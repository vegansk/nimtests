import future, fp/option, fp/list, strutils

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

proc foldRight[T,U](xs: Stream[T], z: () -> U, f: proc(x: T, y: proc(): U): U): U =
  if xs.kind == sntEmpty:
    z()
  else:
    f(xs.h(), xs.t().foldRight(z, f))

# Ex. 5.1
proc toList[T](xs: Stream[T]): List[T] =
  if xs.kind == sntEmpty:
    Nil[T]()
  else:
    xs.h() ^^ xs.t().toList()

proc `$`[T](xs: Stream[T]): string =
  # It's so shitty
  replace($(xs.toList), "List", "Stream")

# Ex. 5.2
proc take[T](xs: Stream[T], n: int): Stream[T] =
  if n == 0 or xs.kind == sntEmpty:
    empty[T]()
  else:
    cons(xs.h, () => xs.t().take(n - 1))

proc drop[T](xs: Stream[T], n: int): Stream[T] =
  if n == 0 or xs.kind == sntEmpty:
    xs
  else:
    xs.t().drop(n - 1)

# Ex. 5.3
proc takeWhile[T](xs: Stream[T], p: T -> bool): Stream[T] =
  if xs.kind == sntEmpty or not p(xs.h()):
    empty[T]()
  else:
    cons(xs.h, () => xs.t().takeWhile(p))

# Ex. 5.4
proc forAll[T](xs: Stream[T], p: T -> bool): bool =
  if xs.kind == sntEmpty:
    true
  else:
    p(xs.h()) and xs.t().forAll(p)

when isMainModule:
  let s = @[1, 2, 3, 4, 5].asStream

  echo: s.toList

  let s2 = cons(() => (echo "2"; 2), () => empty[int]())
  let s3 = cons(() => (echo "1"; 1), () => s2)

  echo: s3
  echo: s3

  echo s.take(3)
  echo s.drop(3)
  echo s.takeWhile(x => x < 5)

  echo s.forAll(x => x < 10)
  echo s.forAll(x => x < 4)
