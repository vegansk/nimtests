import future

##################################################
# List immitation

type
  List[T] = seq[T] not nil

proc isEmpty(lst: List): bool = lst.len == 0

proc head[T](lst: List[T]): T = lst[0]

proc tail[T](lst: List[T]): List[T] =
  result = @[]
  result.add(lst[1..lst.high])

proc `^^`[T](v: T, lst: List[T]): List[T] =
  result = @[v]
  result.add(lst)

proc Nil[T](): List[T] = @[]

##################################################
# Functional random generator

type
  RNG* = object
    seed: int64
  Rand*[A] = (RNG) -> (A, RNG)

{.push overflowChecks: off.}

proc initRNG*(seed: int64): RNG = RNG(seed: seed)

proc nextInt*(r: RNG): (int, RNG) =
  let newSeed = (r.seed * 0x5DEECE66D.int64 + 0xB.int64) and 0xFFFFFFFFFFFF
  # Scala's int is 32 bits long, Nim's int depends on machine word
  # So, the constants up above will work as they should only with int32 type
  ((cast[int32](newSeed shr 16)).int, initRNG(newSeed))

{.pop.}

proc sequence[A](fs: List[Rand[A]]): Rand[List[A]] =
  result = proc (rng: RNG): auto =
    if fs.isEmpty:
      (Nil[A](), rng)
    else:
      let xr: (A, RNG) = fs.head()(rng)
      let xsr: (List[A], RNG) = sequence(fs.tail)(xr[1])
      (xr[0] ^^ xsr[0], xsr[1])

proc randInt: Rand[int] =
  (rng: RNG) => nextInt(rng)

proc map2[A,B,C](ra: Rand[A],  rb: Rand[B], f: (A,B) -> C): Rand[C] =
  (rng: RNG) => (
    let (a, rng2) = ra(rng);
    let (b, rng3) = rb(rng2);
    (f(a, b), rng3)
  )

proc both[A,B](ra: Rand[A], rb: Rand[B]): Rand[(A,B)] =
  map2(ra, rb, (a, b) => (a, b))

proc randIntInt: Rand[(int, int)] =
  both[int, int](nextInt, nextInt)

when isMainModule:
  let rng = initRNG(100)
  let lst: List[Rand[(int, int)]] = randIntInt() ^^ randIntInt() ^^ Nil[Rand[(int, int)]]()
  echo sequence(lst)(rng)[0]
