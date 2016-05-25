type
  Data = object
    data: string

{.experimental.}

proc `=destroy`(d: Data) =
  echo d.data, " destroyed"

proc `=`(dst: var Data, src: Data) =
  echo src.data, " copied"
  dst.data = src.data & " (copy)"

proc initData(s: string): Data =
  result = Data(data: s)
  echo s, " created"

proc main =
  var x = initData"test"

when isMainModule:
  main()
