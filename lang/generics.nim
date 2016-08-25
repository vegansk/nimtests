type
  Data[V] = ref object
    v: V

proc newObj[V](t: typedesc[Data], v: V): Data[V] =
  Data[V](v: v)
  # new(result)
  # result.v = v

let d = Data.newObj(100)
