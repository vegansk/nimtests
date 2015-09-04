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

proc `$`[T](lst: List[T]): string =
  case lst.t
  of ListNodeType.Nil:
    "Nil"
  of ListNodeType.Cons:
    "Cons(" & $lst.v & ", " & $lst.n & ")"

proc initList[T](xs: varargs[T]): List[T] =
  proc initListImpl(i: int, xs: openarray[T]): List[T] =
    if i > high(xs):
      Nil[T]()
    else:
        Cons(xs[i], initListImpl(i+1, xs))
  initListImpl(0, xs)
  
proc foldRight[T,U](xs: List[T], z: U, f: (T, U) -> U): U =
  case xs.t
  of ListNodeType.Nil: z
  else:
    f(xs.v, xs.n.foldRight(z, f))

proc dup[T](lst: List[T]): List[T] = lst.foldRight(Nil[T](), (x: T, xs: List[T]) => Cons(x, xs))

when isMainModule:
  let lst = initList(1,2,3,4,5)
  echo lst
  echo lst.foldRight(0, (x, y) => x + y)
  echo lst.dup()
