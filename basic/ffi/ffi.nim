import macros

macro cc(f: string): stmt =
  result = quote do:
    {.compile: `f`.}

cc"ffi_c.c"

proc getCString: cstring {.importc: "get_c_string", cdecl.}

echo getCString()
