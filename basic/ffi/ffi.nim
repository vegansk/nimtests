{.compile: "ffi_c.c".}

proc getCString: cstring {.importc: "get_c_string".}

echo getCString()
