type
  Test = ref object
    x: string

proc `$`(v: Test): string = v[].`$`

proc threadFunc[T](fc: ForeignCell) {.thread.} =
  var v: T
  let s = cast[T](fc.data)
  deepCopy(v, s)
  fc.dispose
  echo v

var thr: Thread[ForeignCell]

let v = Test(x: "a")

thr.createThread(threadFunc[type(v)], cast[pointer](v).protect)
thr.joinThread
