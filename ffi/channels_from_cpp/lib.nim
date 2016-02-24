proc test {.exportc.} =
  echo "Hello from Nim!"

var ch: Channel[string]
var thr: Thread[void]

proc actorThread {.thread.} =
  while true:
    let msg = ch.recv
    if msg == "quit":
      break
    echo "ACTOR: ", msg

proc initLib {.exportc.} =
  ch.open
  createThread(thr, actorThread)

proc deinitLib {.exportc.} =
  ch.send("quit")
  joinThread(thr)
  ch.close

proc sendMsg(msg: cstring) {.exportc.} =
  ch.send($msg)
