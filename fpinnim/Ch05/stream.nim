import future, fp/option, fp/list

type
  StreamNodeType = enum
    sntEmpty, sntCons
  Stream[T] = ref object
    case kind: StreamNodeType
    of sntEmpty:
      discard
    else:
      h: () -> T
      t: () -> Stream[T]

proc Cons[T](h: () -> T, t: () -> Stream[T]): Stream[T] =
  Stream[T](kind: sntCons, h: h, t: t)

proc Empty[T](): Stream[T] = Stream[T](kind: sntEmpty)

proc cons[T](h: () -> T, t: () -> Stream[T]): Stream[T] =
  var hv = T.none
  let getH = proc(): T =
    if hv.isEmpty:
      hv = h().some
    hv.getOrElse(low(T))
  var tv = Stream[T].none
  let getT = proc(): Stream[T] =
    if tv.isEmpty:
      tv = t().some
    tv.getOrElse(nil)
  
  Cons(getH, getT)

proc empty[T](): Stream[T] = Empty[T]()

proc asStream[T](xs: seq[T]): Stream[T] =
  if len(xs) == 0:
    empty[T]()
  else:
    cons(() => xs[0], () => xs[1..high(xs)].asStream)

proc toList[T](xs: Stream[T]): List[T] =
  if xs.kind == sntEmpty:
    Nil[T]()
  else:
    xs.h() ^^ xs.t().toList()

when isMainModule:
  let s = @[1, 2, 3, 4, 5].asStream

  echo: s.toList

  let s2 = cons(() => (echo "2"; 2), () => empty[int]())
  let s3 = cons(() => (echo "1"; 1), () => s2)

  echo: s3.toList
  echo: s3.toList
