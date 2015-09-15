import future, unittest
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

proc isEmpty(l: List): bool = l.t == ListNodeType.Nil

proc `==`[T](x, y: List[T]): bool =
  # if (x.t, y.t) == (ListNodeType.Nil, ListNodeType.Nil): true
  # elif (x.t, y.t) == (ListNodeType.Cons, ListNodeType.Cons): x.v == y.v and x.n == y.n
  # else: false
  if (x.isEmpty, y.isEmpty) == (true, true): true
  elif (x.isEmpty, y.isEmpty) == (false, false): x.v == y.v and x.n == y.n
  else: false

proc `^^`[T](v: T, xs: List[T]): List[T] = Cons(v, xs)

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

suite "Test":
  test "Test":

    check: "1"^^"2"^^Nil[string]() == ["1", "2"].initList
