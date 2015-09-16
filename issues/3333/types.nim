import List

type
  OptionKind = enum
    okNone, okSome
  Option[T] = ref object
    case kind: OptionKind
    of okNone:
      discard
    else:
      value: T

# This line compiles
proc test1[T: SomeNumber](xs: List[T]): List[T] = discard
# And this line fails
proc test2[T: SomeNumber](xs: List[T]): Option[List[T]] = discard
