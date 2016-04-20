type
  Map {.importcpp: "std::map", header: "<map>".} [T,U] = object

proc initMap(T: typedesc, U: typedesc): Map[T,U] {.importcpp: "std::map<'*1,'*2>()", nodecl.}

var x = initMap(int, string)
