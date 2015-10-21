import math

let a: array[1..5, char]

for i in low(a)..high(a):
  a[i] = ('A'.int + 10.random).char
  echo(a[i])
