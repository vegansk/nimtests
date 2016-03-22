type
  List[T] = seq[T] not nil

proc `^^`[T](v: T, lst: List[T]): List[T] =
  result = @[v]
  result.add(lst)

proc Nil[T](): List[T] = @[]

when isMainModule:
  let lst = 1 ^^ 2 ^^ Nil[int]()
