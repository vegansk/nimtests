import future, sequtils

type
  Either[E,A] = ref object
    case err: bool
    of false:
      r: A
    else:
      l: E
  ValidationItem = tuple[path: string, msg: string]
  Validation[A] = distinct Either[seq[ValidationItem], A]
  Validator[X, A] = X -> Validation[A]

proc right[E,A](v: A, t: typedesc[E]): Either[E,A] = Either[E,A](err: false, r: v)

proc left[E,A](v: E, t: typedesc[A]): Either[E,A] = Either[E,A](err: true, l: v)

proc asValidation[A](
  v: Either[seq[ValidationItem], A]
): Validation[A] =
  Validation[A](v)

proc asEither[A](va: Validation[A]): Either[seq[ValidationItem], A] =
  Either[seq[ValidationItem], A](va)

proc success[A](a: A): Validation[A] =
  a.right(seq[ValidationItem]).asValidation

proc failure[A](validationLog: varargs[string]): Validation[A] =
  @(validationLog).mapIt((path: "", msg: it)).left(A).asValidation

proc mkValidator[A](
  msg: string,
  predicate:  A -> bool
): Validator[A, A] =
  (a: A) => (if predicate(a): success(a) else: failure[A](msg))


block:
  type
    X = object
      xVal: int
      yObj: Y
    Y = object
      yVal: string
      zObj: Z
    Z = object
      zVal: bool

  let
    valZ = mkValidator("zVal is false", (z: Z) => z.zVal)
    valY = mkValidator("yVal is empty", (y: Y) => y.yVal.len > 0)
    xObj = X(xVal: 0, yObj: Y(yVal: "", zObj: Z(zVal: false)))

block:
  type
    X = object
      xVal: int
      yObj: Y
    Y = object
      yVal: string
      zObj: Z
    Z = object
      zVal: bool

  let
    valZ = mkValidator("zVal is false", (z: Z) => z.zVal)
    valY = mkValidator("yVal is empty", (y: Y) => y.yVal.len > 0)
    xObj = X(xVal: 0, yObj: Y(yVal: "", zObj: Z(zVal: false)))

