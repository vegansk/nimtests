# Discussion is here: http://forum.nim-lang.org/t/1725/1#10766
import macros, future, sequtils

proc mkEchoes(xs: seq[string]): NimNode {.compileTime.} =
  result = newStmtList()
  for x in xs:
    let st = quote do:
      echo `x`
    result.add(st)

macro test(xs: static[seq[string]]): stmt =
  result = mkEchoes(xs)

proc getSeq(): seq[string] {.compileTime.} = 
  result = toSeq(0..100).mapIt(string, $it)

when isMainModule:
  test(@["1", "2", "3"])
  test(getSeq())
