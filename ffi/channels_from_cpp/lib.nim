import threadpool 

{.experimental.}

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

proc doSomeActionImpl(cs: cstring, buff: cstring, buffLen: cint) =
  let s = $cs
  var res = newStringOfCap(s.len)
  for i in 0..high(s):
    res.add(s[^(i + 1)])
  let length = min(buffLen.int - 1, res.len + 1)
  copyMem(buff, res.cstring, length)
  cast[ptr char](cast[ByteAddress](buff) +% length -% 1)[] = 0.char

proc doSomeAction(s: cstring, buff: cstring, buffLen: cint) {.exportc.} =
  parallel:
    spawn doSomeActionImpl(s, buff, buffLen)
