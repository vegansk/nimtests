type
  A[T] = ref object
    v: T

template templ(o: A, op: untyped): untyped =
  type T = type(o.v)

  var res: A[T]

  block:
    var it {.inject.}: t
    it = o.v
    res = A(v: op)
  res

let a = A[int](v: 1)
echo templ(a, $s)
