import bigints, threadpool

proc segment(x:int, y:int): ref BigInt =
  new(result)
  var sum = 1.initBigInt
  for i in x.initBigInt..y.initBigInt:
    sum *= i

  result[] = sum

{.experimental.}
proc f(n:int):BigInt =
  parallel:
    let a = spawn segment(1, (n div 3))
    let b = spawn segment((n div 3+1), (n  div 3)*2)
    let c = spawn segment((n div 3)*2+1, n)

  (^a)[] * (^b)[] * (^c)[]


echo f 10000
