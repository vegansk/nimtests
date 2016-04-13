type EitherS[T] = distinct T

proc rightS[T](v: T): EitherS[T] = (EitherS[T])v
proc `$`[T](v: EitherS[T]): string = $((T)v)
proc flatMap[T,U](e: EitherS[T], f: proc(v: T): EitherS[U]): EitherS[U] = f((T)e)

proc io1(): EitherS[int] =
  1.rightS
proc io2(i: int): EitherS[string] =
  "1".rightS
proc io3(i: int, s: string): EitherS[string] =
  ("2").rightS

let res = io1().flatMap(proc (i: int): auto =
  ().rightS.flatMap(proc (_: tuple[]): auto =
    io2(i).flatMap(proc (s: string): auto =
      ().rightS.flatMap(proc (_: tuple[]): auto = io3(i, s)))))

echo res
