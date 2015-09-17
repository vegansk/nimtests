# For this topic: http://forum.nim-lang.org/t/1634

var x = 1
var y = 2

proc calc(x: uint64, y: uint64) =
  echo cast[ptr int](x)[] + cast[ptr int](y)[]

calc(cast[uint64](x.addr), cast[uint64](y.addr))
