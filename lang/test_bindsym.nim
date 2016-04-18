import macros

macro mtest: expr =
  result = bindSym("test").len.newIntLitNode

proc test(s: string): string = s

assert mtest() == 1
