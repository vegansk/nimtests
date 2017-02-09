import asynchttpserver,
       httpclient,
       asyncdispatch,
       net,
       os,
       osproc,
       times

type
  TestType = enum AsyncClient, SyncClient, DeprecatedAPI, ApacheBenchmark

const port = Port(8888)
const testType = SyncClient
const requestsTotal = 1000
const maxAsyncRequests = 10
const postBody = "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"

proc serverThread {.thread.} =
  var server = newAsyncHttpServer()
  proc cb(req: Request) {.async.} =
    await respond(req, Http200, "OK")

  waitFor serve(server, port, cb)

template clientTestBody: untyped =
  when testType notin {DeprecatedAPI, ApacheBenchmark}:
    let c = when testType == AsyncClient: newAsyncHttpClient() else: newHttpClient()
  when testType != ApacheBenchmark:
    for _ in 1..requests:
      when testType == AsyncClient:
        asyncCheck c.postContent("http://localhost:" & $port, postBody)
      elif testType == SyncClient:
        discard c.postContent("http://localhost:" & $port, postBody)
      else:
        discard postContent("http://localhost:" & $port, postBody)
    when testType in{AsyncClient, SyncClient}:
      c.close
  else:
    let file = getTempDir() / "httpclient.test"
    defer:
      removeFile file
    writeFile file, postBody
    let cmd = "ab -n " & $requests & " -p " & file & " http://localhost:" & $port & "/"
    echo "AB command: ", cmd
    discard execCmd(cmd)

when testType == AsyncClient:
  proc runClientTest(requests: int): Future[void] {.async.} =
    clientTestBody
else:
  proc runClientTest(requests: int): void =
    clientTestBody

proc main() =
  var server: Thread[void]
  createThread(server, serverThread)
  let t = getTime()
  when testType == AsyncClient:
    for i in 1..(requestsTotal div maxAsyncRequests):
      waitFor runClientTest(maxAsyncRequests)
  else:
    runClientTest(requestsTotal)

  echo "TEST[", testType, "]: Processed ", requestsTotal, " requests in ", getTime() - t, " seconds!"

when isMainModule:
  main()
