type
  Data = object
    data: string

{.experimental.}

proc `=destroy`(d: Data) =
  echo d.data, " destroyed"

# proc `=`(dst: var Data, src: Data) =
#   echo src.data, " copied"
#   dst.data = src.data & " (copy)"

proc initData(d: var Data, s: string) =
  d.data = s
  echo s, " created"

proc initData(s: string): Data =
  result.initData(s)

proc main =
  # var y: Data
  # y.initData("test2")
  # let x = initData"test"
  echo initData("test 1").data & initData("test 2").data


when isMainModule:
  main()
