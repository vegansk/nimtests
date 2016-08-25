# type
#   String = object
#     data: ptr char

# proc freeString(s: String) =
#   s.data.pointer.deallocShared

# proc newString(s: string): String =
#   new(result, freeString)
#   let len = s.len + 1
#   result.data = cast[ptr char]

type
  DataObj = object
    data: string
  Data = ref DataObj

proc `=`(dst: var DataObj, src: DataObj)
proc freeData(d: Data) =
  echo d.data, " destroyed"

proc newData(s: string): Data =
  result.new(freeData)
  result.data = s
  echo s, " created"

proc main =
  let x = newData"test"
  # let y = x[]

when isMainModule:
  main()
  GC_fullCollect()
