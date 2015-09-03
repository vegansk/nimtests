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
let gNil = List[int](t: ListNodeType.Nil)
proc Nil[T](): List[T] = cast[List[T]](gNil)
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

when isMainModule:
  let lst = 1 ^^ 2 ^^ 3 ^^ 4 ^^ Nil[int]()
  echo lst
  echo lst.tail.tail
  echo lst.setList(100)
  echo lst.drop(3)
  echo lst.dropWhile(x => x < 3)
  echo lst ++ 33 ^^ 44 ^^ Nil[int]()
