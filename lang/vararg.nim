proc f1(args: varargs[string, `$`]) =
  for x in args:
    echo x

proc f2(args: varargs[string, `$`]) =
  f1(args)

when isMainModule:
  f2(1, 2, 3, 4, 5)
