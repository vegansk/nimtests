import macros

var x{.compiletime.} = 1 

macro foo() : untyped =
  inc(x)
  echo $x
  result = newStmtList()

foo()
foo()
echo $x
