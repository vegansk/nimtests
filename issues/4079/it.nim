iterator it(args: varargs[string, `$`]): string {.closure.} =
  for s in args:
    yield s

for s in it("one", "two", "three"):
  echo s
