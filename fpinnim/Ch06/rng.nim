import future, fp.list

type
  RNG* = object
    seed: int64
  double = float64
  
proc initRNG*(seed: int64): RNG = RNG(seed: seed)

{.push overflowChecks: off.}

proc nextInt*(r: RNG): (int, RNG) =
  let newSeed = (r.seed * 0x5DEECE66D.int64 + 0xB.int64) and 0xFFFFFFFFFFFF
  # Scala's int is 32 bits long, Nim's int depends on machine word
  # So, the constants up above will work as they should only with int32 type
  ((cast[int32](newSeed shr 16)).int, initRNG(newSeed))

{.pop.}

# Ex. 6.1
proc nextNonNegativeInt(r: RNG): (int, RNG) =
  let res = r.nextInt
  if res[0] < 0:
    result = if res[0] == int.low: res[1].nextNonNegativeInt else: (res[0] * -1, res[1])
  else:
    result = res

# Ex. 6.2
proc nextDouble(r: RNG): (double, RNG) =
  let nni = r.nextNonNegativeInt
  # See comments about int32 in the ``nextInt`` proc body
  (nni[0].double / int32.high.double, nni[1])

# Ex. 6.3
proc nextIntDouble(r: RNG): ((int, double), RNG) =
  let ir = r.nextInt
  let dr = ir[1].nextDouble
  ((ir[0], dr[0]), dr[1])

proc nextDoubleInt(r: RNG): ((double, int), RNG) =
  let dr = r.nextDouble
  let ir = dr[1].nextInt
  ((dr[0], ir[0]), ir[1])

proc nextDouble3(r: RNG): ((double, double, double), RNG) =
  let d1 = r.nextDouble
  let d2 = d1[1].nextDouble
  let d3 = d2[1].nextDouble
  ((d1[0], d2[0], d3[0]), d3[1])

# Ex. 6.4
proc nextInts(r: RNG, c: int): (List[int], RNG) =
  if c <= 0:
    (Nil[int](), r)
  else:
    let ir = r.nextInt
    let nr = ir[1].nextInts(c - 1)
    (ir[0] ^^ nr[0], nr[1])

# Chapter 6.4
type
  Rand*[A] = (RNG) -> (A, RNG)

proc unit*[A](a: A): Rand[A] =
  rng => (a, rng)

proc map[A,B](s: Rand[A], f: A -> B): Rand[B] =
  (rng: RNG) => (
    let (a, rng2) = s(rng);
    (f(a), rng2)
  )

proc randInt: Rand[int] =
  (rng: RNG) => rng.nextInt

proc randNonNegativeEven: Rand[int] =
  nextNonNegativeInt.map(i => i - i mod 2)

# Ex. 6.5
proc randDouble: Rand[double] =
  nextInt.map(i => i.double / int32.high.double)

# Ex. 6.6
proc map2[A,B,C](ra: Rand[A],  rb: Rand[B], f: (A,B) -> C): Rand[C] =
  (rng: RNG) => (
    let (a, rng2) = ra(rng);
    let (b, rng3) = rb(rng2);
    (f(a, b), rng3)
  )

proc both[A,B](ra: Rand[A], rb: Rand[B]): Rand[(A,B)] =
  map2(ra, rb, (a, b) => (a, b))

proc randIntDouble: Rand[(int, double)] =
  both[int, double](nextInt, nextDouble)

proc randDoubleInt: Rand[(double, int)] =
  both[double, int](nextDouble, nextInt)

# Ex. 6.7
proc sequence[A](fs: List[Rand[A]]): Rand[List[A]] =
  result = proc (rng: RNG): auto =
    if fs.isEmpty:
      (Nil[A](), rng)
    else:
      let (a, xr) = fs.head()(rng)
      let xsr: (List[A], RNG) = sequence(fs.tail())(xr)
      (a ^^ xsr[0], xsr[1])

proc randInts(c: int): Rand[List[int]] =
  let lst = lc[randInt() | (x <- 1..c), Rand[int]].asList
  lst.sequence

when isMainModule:
  let rng = initRNG(100)
  # Ex. 6.1
  echo rng.nextNonNegativeInt[0]
  # Ex. 6.2
  echo rng.nextDouble[0]
  # Ex. 6.3
  echo rng.nextIntDouble[0]
  echo rng.nextDoubleInt[0]
  echo rng.nextDouble3[0]
  # Ex. 6.4
  echo rng.nextInts(10)[0]
  # Chapter 6.4
  echo randNonNegativeEven()(rng)[0]
  # Ex. 6.5
  echo randDouble()(rng)[0]
  # Ex. 6.6
  echo randIntDouble()(rng)[0]
  echo randDoubleInt()(rng)[0]
  # Ex. 6.7
  let lst: List[Rand[(int, double)]] = [randIntDouble(), randIntDouble(), randIntDouble()].asList
  echo sequence(lst)(rng)[0]
  echo randInts(10)(rng)[0]
