import unittest

{.passC: "-std=c++11".}

{.emit: """

#include <stdexcept>

void throwEx() {
  throw std::runtime_error("Shit happends!");
}

""".}

proc throwEx() {.importcpp: "throwEx", nodecl.}

# When emit pragma is used in global scope,
# the code will be inserted somewhere near the
# top of the cpp source. Thats why we need to
# create a proc for try/catch block

template cppTry(bl: stmt, catch: stmt) {.immediate.} =
  proc tryBlock() {.inline.} =
    {.emit: "try {".}
    bl
    {.emit: "} catch(...) {".}
    catch
    {.emit: "}".}
  tryBlock()

proc test() =
  {.emit: "try {".}
  throwEx()
  {.emit: "} catch(...) {".}
  echo "Got an exception"
  {.emit: "}".}

when isMainModule:
  cppTry(throwEx(), echo "Got an exception")
