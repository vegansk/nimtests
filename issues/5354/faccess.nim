import macros

type
  Test = object
    case p: bool
    of true:
      a: int
    else:
      discard
  Test2 = object
    a: int

proc f[T](t: typedesc[T]): int =
  1

when isMainModule:
  let x = Test(p: false)
  doAssert Test.f == 1
