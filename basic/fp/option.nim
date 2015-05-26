import future, typetraits

type Option*[T] = object
  case valid: bool
  of true: value: T
  else: discard

converter toBool*[T](v: Option[T]): bool =
  if v.valid: true else: false
  
proc some*[T](v: T): Option[T] =
  Option[T](valid: true, value: v)
proc none*[T](): Option[T] =
  Option[T](valid: false)

proc map*[T,U](v: Option[T], f: T -> U): Option[U] =
  if v: some f(v.value) else: none[U]()

proc `>>=`*[T,U](v: Option[T], f: T -> Option[U]): Option[U] =
  if v: f(v.value) else: none[U]()

proc `$`*[T](v: Option[T]): string =
  if v: "Some[" & T.name & "](" & $v.value & ")" else: "None[" & T.name & "]()"

proc getOr*[T](v: Option[T], d: T): T =
  if v: v.value else: d

proc getOr*[T](v: Option[T], d: void -> T): T =
  if v: v.value else: d()

proc eval*[T,U](v: Option[T], ifSome: T -> U, ifNone: void -> U): U =
  if v: ifSome(v.value) else: ifNone()
