# Discussion is here: http://forum.nim-lang.org/t/1725/1#10766
import macros, future, sequtils

macro test(xs: static[seq[string]]): stmt =
  result = newStmtList()
  for x in xs:
    let st = quote do:
      echo `x`
    result.add(st)

when isMainModule:
  test(@["1", "2", "3"])
  test(toSeq(0..100).mapIt(string, $it))
