type
  Data[U,V] = ref object
    d: U

proc fromInt[U,V](t: typedesc[Data], d: U, v: V): Data[U,V] =
  new(result)
  result.d = d

let x = Data[int,string].fromInt(1, "a")
