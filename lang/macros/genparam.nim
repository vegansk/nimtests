import macros

type A[T] = object
  x: T
type B[T] = ref object
  x: T

macro genConstructor(typ: typed): untyped =
  echo typ.getTypeInst[1].symbol.getImpl[1].treeRepr

genConstructor A
genConstructor B
