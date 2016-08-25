type
  Vector {.importcpp: "std::vector<'*0>", header: "vector".} [T] = object
  VectorIterator {.importcpp: "std::vector<'*0>::iterator".} [T] = object

proc getIterator[T](v: Vector[T]): VectorIterator[T] {.importcpp: "#.begin()", nodecl.}
proc add[T](v: var Vector[T], item: T) {.importcpp: "#.push_back(@)", nodecl.}
proc isValid[T](it: VectorIterator[T], v: Vector[T]): bool {.importcpp: "(# != #.end())", nodecl.}
proc get[T](it: VectorIterator[T]): T {.importcpp: "(*#)", nodecl.}
proc next[T](it: var VectorIterator[T]) {.importcpp: "(++#)", nodecl.}

iterator items[T](v: Vector[T]): T =
  var iter = v.getIterator()
  while iter.isValid(v):
    yield iter.get()
    iter.next()

proc createVector(): Vector[int] =
  result.add(1)
  result.add(10)
  result.add(20)

let v = createVector()
for num in v: # this works well
  echo num

# for num in createVector(): # this doesn't
#   echo num
