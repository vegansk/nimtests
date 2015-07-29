type
  List[T] = ref object
    value: T
    next: List[T]

proc Nil[T](): List[T] = nil

proc `^::`[T](v: T, lst: List[T]): List[T] =
  result.new
  result.value = v
  result.next = lst

echo repr(1 ^:: 2 ^:: 3 ^:: Nil[int]())
