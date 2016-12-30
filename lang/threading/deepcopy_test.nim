import threadpool

type
  Test = ref object
    x: int

proc `$`(v: Test): string = v[].`$`

let x = Test(x: 1)

proc test[T](p: pointer) {.thread.} =
  var v: T
  # let pv = cast[T](p)
  # deepCopy(v, pv)
  deepCopy(v, cast[T](p))
  echo "THREAD: ", v

spawn test[type(x)](cast[pointer](x))

sync()

echo "Done"
