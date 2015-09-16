# Generics playing games (C) enamex_

{.warning[TypelessParam]: off.}

import future

type
  List[T] = seq[T]

proc foldRight[T,U](lst: List[T], v: U, f: (T, U) -> U): U = discard

# This line produces error
proc mean[T: SomeNumber](xs: List[T]): T = xs.foldRight(0.T, (x: T, y: T) => x + y) / cast[T](xs.len)
# But this line compiles ok
# proc mean[T: SomeNumber](xs: List[T]): T = xs.foldRight(0.T, (x: T, y: T) => x + y) / cast[T](xs.len)

when isMainModule:
  let x = cast[List[float]](@[1.float, 2, 3]).mean()
  echo x
