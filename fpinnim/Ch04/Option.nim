#
# Exercises from "Functional programming in scala" transated to Nim
#

import future, fp/list, math

{.experimental.}
{.warning[TypelessParam]: off.}

type
  OptionKind = enum
    okNone, okSome
  OptionObj[T] = object
    case kind: OptionKind
    of okNone:
      discard
    else:
      value: T
  Option[T] = ref OptionObj[T] not nil

proc Some[T](value: T): Option[T] = Option[T](kind: okSome, value: value)
proc None[T](): Option[T] = Option[T](kind: okNone)

proc some[T](value: T): Option[T] = Some(value)
proc none[T](value: T): Option[T] = None[T]()
proc none(T: typedesc): Option[T] = None[T]()


proc `==`[T](x, y: Option[T]): bool =
  if (x.kind, y.kind) == (okNone, okNone): true
  elif (x.kind, y.kind) == (okSome, okSome): x.value == y.value
  else: false

proc `$`[T](o: Option[T]): string =
  case o.kind
  of okNone: "None()"
  else: "Some(" & $o.value & ")"

proc isEmpty(o: Option): bool = o.kind == okNone

proc liftO[T,U](f: proc(x: T): U): proc(o: Option[T]): Option[U] =
  (o: Option[T]) => (if o.isEmpty: U.none else: some(f(o.value)))

# Ex. 4.1
proc map[T,U](o: Option[T], f: T -> U): Option[U] =
  case o.kind
  of okNone: None[U]()
  else: Some(f(o.value))

proc flatMap[T,U](o: Option[T], f: T -> Option[U]): Option[U] =
  case o.kind
  of okNone: None[U]()
  else: f(o.value)

proc getOrElse[T](o: Option[T], f: void -> T): T =
  case o.kind
  of okNone: f()
  else: o.value

proc orElse[T](o: Option[T], f: void -> Option[T]): Option[T] =
  case o.kind
  of okNone: f()
  else: o

proc filter[T](o: Option[T], p: T -> bool): Option[T] =
  if o.kind == okSome and p(o.value):
      o
  else:
    None[T]()

# Ex. 4.2
proc mean[T: SomeNumber](xs: List[T]): Option[T] =
  if xs.isEmpty: 
    T.none
  else:
    Some(xs.foldRight(0.T, (x: T, y: T) => x + y) / xs.length.T)

proc variance[T: SomeNumber](xs: List[T]): Option[T] =
  xs.mean.flatMap((m: T) => xs.map((x: T) => pow(x - m, 2)).mean)

# Ex. 4.3
proc map2[T,U,V](x: Option[T], y: Option[U], f: (T, U) -> V): Option[V] =
  if x.isEmpty or y.isEmpty:
    V.none
  else:
    f(x.value, y.value).some

# Ex. 4.4
proc sequence[T](xs: List[Option[T]]): Option[List[T]] =
  proc f(x: Option[T], v: Option[List[T]]): Option[List[T]] =
    if v.isEmpty:
      v
    elif x.isEmpty:
      Nil[T]().some
    else: Some(Cons(x.value, v.value))
  xs.foldRight(Nil[T]().some, f)

when isMainModule:
  let s = Some(123)
  let n = None[int]()

  echo s.isEmpty, " ", s
  echo n.isEmpty, " ", n
  echo "Hello, world".some
  echo "Hello, world".none
  echo string.none
  echo 12345.some.map(x => "Value is " & $x)
  echo 12.some.flatMap((x: int) => (x * 3).some)
  echo "".none.getOrElse(() => "Lalala")
  echo "".none.orElse(() => "Lalala".some)
  echo 12.some.filter(x => x < 5)
  let lst = @[1.float, 2, 3, 4, 5].asList
  echo "Mean of ", lst, " is ", lst.mean()
  echo "Variance of ", lst, " is ", lst.variance()
  echo liftO((x:float) => sqrt(x))(4.float.some)
  echo liftO((x:float) => sqrt(x))(4.float.none)
  echo map2(1.some, 2.some, (x, y) => x + y)
  echo: @[1.some, 2.some, 3.some].asList.sequence()
