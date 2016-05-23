import typetraits, macros
type EitherS[T] = distinct T

proc rightS[T](v: T): EitherS[T] = (EitherS[T])v
proc `$`[T](v: EitherS[T]): string = $((T)v)
proc flatMap[T,U](e: EitherS[T], f: proc(v: T): EitherS[U]): EitherS[U] = f((T)e)

proc io1(): EitherS[int] =
  1.rightS
proc io2(i: int): EitherS[int] =
  2.rightS
proc io3(i1, i2: int): EitherS[int] =
  3.rightS


let res = io1().flatMap(proc (i: int): auto =
  ().rightS.flatMap(proc (_: tuple[]): auto =
    io2(i).flatMap(proc (i1: int): auto =
      ().rightS.flatMap(proc (_: tuple[]): auto =
                            io3(i, i1)))))

# let res = io1().flatMap(proc (i: int): auto {.closure.} =
#   ().rightS.flatMap(proc (_: tuple[]): auto {.closure.} =
#     io2(i).flatMap(proc (i1: int): auto {.closure.} =
#       ().rightS.flatMap(proc (_: tuple[]): auto {.closure.} =
#                             io3(i, i1)))))

echo res


dumpTree:
  proc f(x: int): auto {.closure.} = discard
