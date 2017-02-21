import future, sequtils

type
  Validation[A] = object
  Validator[X, A] = X -> Validation[A]

proc mkValidator[A](
  msg: string,
  predicate:  A -> bool
): Validator[A, A] =
  var a: A
  let b = a

block:
  type
    Y = object
      yVal: string
      zObj: Z
    Z = object
      zVal: bool

  let
    valY = mkValidator("yVal is empty", (y: Y) => y.yVal.len > 0)

block:
  type
    Y = object
      yVal: string
      zObj: Z
    Z = object
      zVal: bool

  let
    valY = mkValidator("yVal is empty", (y: Y) => y.yVal.len > 0)
