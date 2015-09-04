import future, sequtils

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
  
proc `$`[T](lst: List[T]): string =
  case lst.t
  of ListNodeType.Nil:
    "Nil"
  of ListNodeType.Cons:
    "Cons(" & $lst.v & ", " & $lst.n & ")"

proc `^^`[T](v: T, lst: List[T]): List[T] = Cons(v, lst)

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
proc tail[T](lst: List[T]): List[T] =
  case lst.t
  of ListNodeType.Cons:
    lst.n
  else:
    Nil[T]()

# Ex. 3.3
proc setList[T](lst: List[T], v: T): List[T] = Cons(v, lst.tail)

# Ex. 3.4
proc drop[T](lst: List[T], n: int): List[T] =
  case lst.t
  of ListNodeType.Nil: lst
  else:
    if n == 0: lst else: lst.tail.drop(n - 1)

# Ex. 3.5
proc dropWhile[T](lst: List[T], p: T -> bool): List[T] =
  case lst.t
  of ListNodeType.Nil: lst
  else:
    if not lst.v.p(): lst else: lst.tail.dropWhile(p)

# Ex. 3.6
proc init[T](lst: List[T]): List[T] =
  case lst.t
  of ListNodeType.Nil:
    lst
  else:
    if lst.n.t == ListNodeType.Nil:
      lst.n
    else:
      lst.v ^^ lst.tail.init

# Ex. 3.8
proc dup[T](lst: List[T]): List[T] = lst.foldRight(Nil[T](), (x: T, xs: List[T]) => Cons(x, xs))

# Ex. 3.9
proc length[T](lst: List[T]): int = lst.foldRight(0, (_: T, x: int) => x+1)

# Ex. 3.10
proc foldLeft[T,U](lst: List[T], z: U, f: (U, T) -> U): U =
  case lst.t
  of ListNodeType.Nil: z
  else:
    foldLeft(lst.n, f(z, lst.v), f)

# Ex. 3.11
type
  Number = concept x, y
    x + y is type(x)
    x * y is type(x)
proc sumViaFoldLeft[T: Number](lst: List[T]): T = lst.foldLeft(0.T, (x: T, y: T) => x + y)
proc productViaFoldLeft[T: Number](lst: List[T]): T = lst.foldLeft(1.T, (x: T, y: T) => x * y)
proc lengthViaFoldLeft[T](lst: List[T]): int = lst.foldLeft(0.T, (x: int, _: T) => x + 1)

# Ex. 3.12
proc reverse[T](lst: List[T]): List[T] = lst.foldLeft(Nil[T](), (xs: List[T], x: T) => Cons(x, xs))

when isMainModule:
  let lst = [1,2,3,4,5,6,7].initList
  echo lst
  echo lst.tail.tail
  echo lst.setList(100)
  echo lst.drop(3)
  echo lst.dropWhile(x => x < 3)
  echo lst ++ 33 ^^ 44 ^^ Nil[int]() ++ initList(100, 200, 300) ++ @[32,32,32].initList
  echo lst.init
  echo lst.foldRight(0, (x, y) => x + y)
  echo lst.dup
  echo lst.length
  echo lst.sumViaFoldLeft
  echo lst.productViaFoldLeft
  echo lst.lengthViaFoldLeft
  echo lst.reverse
