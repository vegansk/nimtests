type
  Data = ref object
    v: string

proc newData(v: string): Data = Data(v: v)

proc `==`(v1, v2: Data): bool =
  v1.v != v2.v

echo newData("a") == newData("b")
