import future, typetraits

type X[T] = concept x
  type U = auto
  map(x, T -> U): genericHead(x.type)[U]

type Box[T] = object
  v: T

proc map[T,U](x: Box[T], f: T -> U): Box[U] =
  result.v = f(x.v)

echo Box[int] is X[int]

# type
#   Functor{.explain.}[T] = concept f, type F
#     type U = auto
#     map(f, T -> U) is F[U]

# import options
# echo Option[int] is Functor[int]
