type
  TypeA1 = object of RootObj
    a_impl: int
    b_impl: string
    c_impl: pointer

proc initTypeA1(a: int; b: string; c: pointer = nil): TypeA1 =
  result.a_impl = a
  result.b_impl = b
  result.c_impl = c

let x = initTypeA1(1, "a")
