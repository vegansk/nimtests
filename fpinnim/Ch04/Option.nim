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

proc `==`[T](x, y: Option[T]): bool =
  if (x.kind, y.kind) == (okNone, okNone): true
  elif (x.kind, y.kind) == (okSome, okSome): x.value == y.value
  else: false

proc `$`[T](o: Option[T]): string =
  case o.kind
  of okNone: "None()"
  else: "Some(" & $o.value & ")"

proc isEmpty(o: Option): bool = o.kind == okNone

when isMainModule:
  let s = Some(123)
  let n = None[int]()

  echo s.isEmpty, " ", s
  echo n.isEmpty, " ", n

