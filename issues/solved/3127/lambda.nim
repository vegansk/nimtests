import future

type Holder[T] = object
  value*: T

proc newHolder[T](v: T): Holder[T] = Holder[T](value: v)

proc `$`[T](h: Holder[T]): string = "Holder(" & $h.value & ")"

proc map[T,U](h: Holder[T], f: T -> U): Holder[U] = newHolder[U](f(h.value))

echo(newHolder(100).map(x => x * 2))
