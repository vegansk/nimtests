#
# Exercises from "Functional programming in scala" transated to Nim
#

import future

{.experimental.}
{.warning[TypelessParam]: off.}

type
  OptionKind = enum
    okNone, okSome
  Option[T] = object
    case kind: OptionKind
    of okNone:
      discard
    else:
      value: T

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

when isMainModule:
  let s = Some(123)
  let n = None[int]()

  echo s.isEmpty, " ", s
  echo n.isEmpty, " ", n
  echo "Hello, world".some
  echo "Hello, world".none
  echo string.none
  echo 12345.some.map((x: int) => "Value is " & $x)
  echo 12.some.flatMap((x: int) => (x * 3).some)
  echo "".none.getOrElse(() => "Lalala")
  echo "".none.orElse(() => "Lalala".some)
  echo 12.some.filter(x => x < 5)
