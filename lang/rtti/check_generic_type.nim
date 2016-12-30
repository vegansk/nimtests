type
  BaseObj {.inheritable.} = object
    name: string
  Base = ref BaseObj
  ChildObj[T] = object of BaseObj
    value: T
  Child[T] = ref ChildObj[T]

proc `$`[T](v: ref T): string = v[].`$`

var store: seq[Base] = @[]

store.add(Child[string](name: "strChild", value: "a"))
store.add(Child[int](name: "intChild", value: 1))

echo store
echo store[0] of Child[string]
echo store[0] of Child[int]

proc get[T:Child]: T =
  for v in store:
    if v of T:
      return cast[T](v)

echo get[Child[int]]()[].value
