# Discussion is here: http://forum.nim-lang.org/t/1725/1#10766
import macros, future, sequtils, strutils

macro test(xs: static[seq[string]]): stmt =
  result = newStmtList()
  for x in xs:
    let st = quote do:
      echo "Here is ", `x`
    result.add(st)
    result.add(parseStmt("echo \"And more $1\"" % [x]))

when isMainModule:
  test(@["1", "2", "3"])
  test(toSeq(0..100).mapIt(string, $it))
