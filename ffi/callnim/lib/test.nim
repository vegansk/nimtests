when appType == "lib":
  {.pragma: lib, cdecl, exportc, dynlib.}
elif appType == "staticlib":
  {.pragma: lib, cdecl, exportc.}
else:
  {.error: "Wrong appType for the library: " & appType.} 

proc test_func(say: cstring): cstring {.lib.} =
  echo "External code says: ", $say
  result = "Hello from Nim!"
