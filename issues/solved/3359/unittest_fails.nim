import future, unittest

proc runF2[T](x: T, y: T, f: (T, T) -> T): T =
  f(x, y)

suite "Test":

  test "Test":
    check: runF2(1, 2, (x, y) => x + y) == 3
