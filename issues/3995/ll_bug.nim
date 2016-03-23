import future, fp.list

type
  RNG* = tuple[]
  Rand*[A] = (RNG) -> (A, RNG)

{.push overflowChecks: off.}

proc nextInt*(r: RNG): (int, RNG) =
  (1, ())

{.pop.}

proc flatMap[A,B](f: Rand[A], g: A -> Rand[B]): Rand[B] =
  (rng: RNG) => (
    let (a, rng2) = f(rng);
    let g1 = g(a);
    g1(rng2)
  )

proc map[A,B](s: Rand[A], f: A -> B): Rand[B] =
  let g: A -> Rand[B] = (a: A) => ((rng: RNG) => (f(a), rng))
  flatMap(s, g)

let f = nextInt.map(i => i - i mod 2)
