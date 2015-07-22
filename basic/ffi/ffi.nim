{.compile: "ffi_c.c".}

proc getCString: cstring {.importc: "get_c_string", cdecl.}

echo getCString()
