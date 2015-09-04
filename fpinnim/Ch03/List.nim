import future

{.experimental.}

type
  ListNodeType {.pure.} = enum 
    Nil, Cons
  List[T] = ref object
    case t: ListNodeType
    of ListNodeType.Nil:
      discard
    of ListNodeType.Cons:
      v: T
      n: List[T] not nil

proc Cons[T](head: T, tail: List[T]): List[T] = List[T](t: ListNodeType.Cons, v: head, n: tail)

proc Nil[T](): List[T] = List[T](t: ListNodeType.Nil)

proc initList[T](xs: varargs[T]): List[T] =
  proc initListImpl(i: int, xs: openarray[T]): List[T] =
    if i > high(xs):
      Nil[T]()
    else:
        Cons(xs[i], initListImpl(i+1, xs))
  initListImpl(0, xs)
  
proc `$`[T](xs: List[T]): string =
  case xs.t
  of ListNodeType.Nil:
    "Nil"
  of ListNodeType.Cons:
    "Cons(" & $xs.v & ", " & $xs.n & ")"

proc `^^`[T](v: T, xs: List[T]): List[T] = Cons(v, xs)

proc `++`[T](x, y: List[T]): List[T] =
  case x.t
  of ListNodeType.Nil: y
  else: Cons(x.v, x.n ++ y)

proc foldRight[T,U](xs: List[T], z: U, f: (T, U) -> U): U =
  case xs.t
  of ListNodeType.Nil: z
  else:
    f(xs.v, xs.n.foldRight(z, f))

# Ex. 3.2
proc tail[T](xs: List[T]): List[T] =
  case xs.t
  of ListNodeType.Cons:
    xs.n
  else:
    Nil[T]()

# Ex. 3.3
proc setList[T](xs: List[T], v: T): List[T] = Cons(v, xs.tail)

# Ex. 3.4
proc drop[T](xs: List[T], n: int): List[T] =
  case xs.t
  of ListNodeType.Nil: xs
  else:
    if n == 0: xs else: xs.tail.drop(n - 1)

# Ex. 3.5
proc dropWhile[T](xs: List[T], p: T -> bool): List[T] =
  case xs.t
  of ListNodeType.Nil: xs
  else:
    if not xs.v.p(): xs else: xs.tail.dropWhile(p)

# Ex. 3.6
proc init[T](xs: List[T]): List[T] =
  case xs.t
  of ListNodeType.Nil:
    xs
  else:
    if xs.n.t == ListNodeType.Nil:
      xs.n
    else:
      xs.v ^^ xs.tail.init

# Ex. 3.8
proc dup[T](xs: List[T]): List[T] = xs.foldRight(Nil[T](), (x: T, xs: List[T]) => Cons(x, xs))

# Ex. 3.9
proc length[T](xs: List[T]): int = xs.foldRight(0, (_: T, x: int) => x+1)

# Ex. 3.10
proc foldLeft[T,U](xs: List[T], z: U, f: (U, T) -> U): U =
  case xs.t
  of ListNodeType.Nil: z
  else:
    foldLeft(xs.n, f(z, xs.v), f)

# Ex. 3.11
type
  Number = concept x, y
    x + y is type(x)
    x * y is type(x)
proc sumViaFoldLeft[T: Number](xs: List[T]): T = xs.foldLeft(0.T, (x: T, y: T) => x + y)
proc productViaFoldLeft[T: Number](xs: List[T]): T = xs.foldLeft(1.T, (x: T, y: T) => x * y)
proc lengthViaFoldLeft[T](xs: List[T]): int = xs.foldLeft(0.T, (x: int, _: T) => x + 1)

# Ex. 3.12
proc reverse[T](xs: List[T]): List[T] = xs.foldLeft(Nil[T](), (xs: List[T], x: T) => Cons(x, xs))

# Ex. 3.13
proc foldLeftViaRight[T,U](xs: List[T], z: U, f: (U, T) -> U): U =
  foldRight[T, U -> U](xs, (b: U) => b, (x: T, g: U -> U) => ((b: U) => g(f(b, x))))(z)
  
proc foldRightViaLeft[T,U](xs: List[T], z: U, f: (T, U) -> U): U =
  foldLeft[T, U -> U](xs, (b: U) => b, (g: U -> U, x: T) => ((b: U) => g(f(x, b))))(z)

# Ex. 3.14
proc append[T](xs: List[T], ys: List[T]): List[T] = xs.foldRight(ys, (x: T, xs: List[T]) => Cons(x, xs))

# Ex. 3.15
proc join[T](xs: List[List[T]]): List[T] = xs.foldRight(Nil[T](), append)

# Ex. 3.18
proc map[T, U](xs: List[T], f: T -> U): List[U] =
  case xs.t
  of ListNodeType.Nil: Nil[U]()
  else: Cons(f(xs.v), map(xs.n, f))

# Ex. 3.19
proc filter[T](xs: List[T], p: T -> bool): List[T] =
  case xs.t
  of ListNodeType.Nil: xs
  else:
    if p(xs.v): Cons(xs.v, filter(xs.n, p)) else: filter(xs.n, p)

# Ex. 3.20
proc flatMap[T,U](xs: List[T], f: T -> List[U]): List[U] = xs.map(f).join

# Ex. 3.21
proc filterViaFlatMap[T](xs: List[T], p: T -> bool): List[T] = xs.flatMap((x: T) => (if p(x): Cons(x, Nil[T]()) else: Nil[T]()))

# Ex. 3.23
proc zipWith[T,U,V](xs: List[T], ys: List[U], f: (T,U) -> V): List[V] =
  if xs.t == ListNodeType.Nil or ys.t == ListNodeType.Nil:
    Nil[V]()
  else:
    Cons(f(xs.v, ys.v), zipWith(xs.n, ys.n, f))

when isMainModule:
  let xs = [1,2,3,4,5,6,7].initList
  echo xs
  echo xs.tail.tail
  echo xs.setList(100)
  echo xs.drop(3)
  echo xs.dropWhile(x => x < 3)
  echo xs ++ 33 ^^ 44 ^^ Nil[int]() ++ initList(100, 200, 300) ++ @[32,32,32].initList
  echo xs.init
  echo xs.foldRight(0, (x, y) => x + y)
  echo xs.dup
  echo xs.length
  echo xs.sumViaFoldLeft
  echo xs.productViaFoldLeft
  echo xs.lengthViaFoldLeft
  echo xs.reverse
  echo xs.foldLeftViaRight(0, (x, _) => x + 1)
  echo(initList("a", "b", "c").foldLeftViaRight(0, (x, _) => x + 1))
  echo xs.foldRightViaLeft(0, (_, x) => x + 1)
  echo(initList("a", "b", "c").foldRightViaLeft(0, (_, x) => x + 1))
  echo([1, 2, 3].initList.append([4, 5, 6].initList))
  echo([[1, 2, 3].initList, [4, 5, 6].initList].initList.join)
  echo([1, 2, 3].initList.map((x: int) => "Value" & $x))
  echo([1, 2, 3, 4].initList.filter(x => x mod 2 != 0))
  echo([1, 2, 3].initList.flatMap((x: int) => [x, x].initList))
  echo([1, 2, 3, 4].initList.filterViaFlatMap(x => x mod 2 != 0))
  echo(zipWith([1, 2, 3].initList, [4, 5, 6, 7].initList, (x: int, y: int) => x + y))
