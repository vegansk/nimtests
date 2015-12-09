static:
  echo appType
when appType == "lib":
  {.pragma: lib, cdecl, exportc, dynlib.}
else:
  {.pragma: lib, cdecl, exportc.}


proc test_func(say: cstring): cstring {.lib.} =
  echo "External code says: ", $say
  result = "Hello from Nim!"
