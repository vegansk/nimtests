import future

type T[A] = ref object
  value: A

proc map[A,B](o: T[A], f: A -> B): T[B] =
  T[B](value: f(o.value))

proc f(o: T[int], f: int -> int): T[int -> int] =
  o.map(v => ((x: int) => x + f(v)))

discard f(T[int](value: 1), v => v * 2)
