type A[T: int|string] = object
    x: T

proc initA[T](x: T): A[T] =
  result.x = x

let a = initA(1)
