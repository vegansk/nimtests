import sequtils

type Int* = distinct int

proc `$`*(i: Int): string = $(i.int)

type Ints* = seq[int]

proc mkInts*(v: seq[Int]): Ints = v.Ints

proc `$`*(v: Ints): string =
  v.mapIt($it).foldl(a & ", " & b)

