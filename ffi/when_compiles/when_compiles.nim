####################################################################################################
# This is a test for c ffi and `when compiles` communications
#
# Too bad, but it's not working :-(

import macros

let badFfi{.compileTime.} = (parseExpr """
{.emit: "#include <header_not_found.h>".}
""").compiles

let goodFfi{.compileTime.} = (parseExpr """
{.emit: "#include <stdio.h>".}
""").compiles

when badFfi:
  echo "Bad ffi compiles"
else:
  echo "Bad ffi not compiles"

when goodFfi:
  echo "Good ffi compiles"
else:
  echo "Good ffi not compiles"
