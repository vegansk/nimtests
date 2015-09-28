import future, fp/option, fp/list

proc memoize[T](f: () -> T): () -> T =
  var hasVal = false
  var value: T
  result = proc(): T =
    if not hasVal:
      value = f()
      hasVal = true
    value

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
  Cons(h.memoize, t.memoize)

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
