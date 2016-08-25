type
  Iterator[T] = object
    v: T
  Monad[T] = concept m
    # flatMap i.e. monadic bind
    flatMap[T,R](m, proc(x: T): Monad[R]) is Monad[R]

# somewhere else
proc flatMap[T,R](coll: Iterator[T], f: (proc(item: T): Iterator[R])): Iterator[R] = Iterator(v: R(0))

# and
echo Iterator[int] is Monad[int]
