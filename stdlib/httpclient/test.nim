import asynchttpserver,
       httpclient,
       asyncdispatch,
       net,
       os,
       osproc,
       times

type
  TestType = enum SyncClient, DeprecatedAPI, ApacheBenchmark

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

proc runSyncTest(requests: int) =
  when testType == SyncClient:
    let c = newHttpClient()
  when testType != ApacheBenchmark:
    for _ in 1..requests:
      when testType == SyncClient:
        discard c.postContent("http://localhost:" & $port, postBody)
      else:
        discard postContent("http://localhost:" & $port, postBody)
    when testType == SyncClient:
      c.close
  else:
    let file = getTempDir() / "httpclient.test"
    defer:
      removeFile file
    writeFile file, postBody
    let cmd = "ab -n " & $requests & " -p " & file & " http://localhost:" & $port & "/"
    echo "AB command: ", cmd
    discard execCmd(cmd)

proc main() =
  var server: Thread[void]
  createThread(server, serverThread)
  let t = getTime()
  runSyncTest(requestsTotal)

  echo "TEST[", testType, "]: Processed ", requestsTotal, " requests in ", getTime() - t, " seconds!"

when isMainModule:
  main()
