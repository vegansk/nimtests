import future

type
  RNG* = object
    seed: int64
  Rand*[T] = (RNG) -> (T, RNG)
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

when isMainModule:
  let rnd = initRNG(100)
  # Ex. 6.1
  echo rnd.nextNonNegativeInt[0]
  # Ex. 6.2
  echo rnd.nextDouble[0]
  # Ex. 6.3
  echo rnd.nextIntDouble[0]
  echo rnd.nextDoubleInt[0]
  echo rnd.nextDouble3[0]
  
