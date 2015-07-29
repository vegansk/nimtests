type
  HListNodeKind = enum
    hlCons, hlNil
  HList[T, HList[U]] = ref object
    case kind: HListNodeKind
    of hlCons:
      n: HList
      v: T
    of hlNil:
      discard
  


# type
#   HList = ref object {.inheritable.}
#   HNil = ref object of HList
#   HCons[T] = ref object of HList
#     n: HList
#     v*: T

# let hNil = HNil()

# proc newHCons[T](v: T, n: HList): HCons[T] =
#   new result
#   result.n = n
#   result.v = v

# proc newHCons[T](v: T): HCons[T] =
#   new result
#   result.n = hNil
#   result.v = v

# let v = newHCons(10, newHCons("test"))
# let x = v.n
# echo repr(type(x))
