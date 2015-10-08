import macros, times, strutils, typetraits

type
  SubData* = object
    value*: string
  Data* = object
    value*: int
    fValue*: float
    tValue*: Time
    sValue*: SubData

iterator objfields(t: NimNode): NimNode =
  let reclist = t.getType[1]
  for i in 0..len(reclist)-1:
    yield reclist[i]

macro fields[T](x: T, fields: seq[tuple[name: string, `type`: string]]): stmt =
  result = newStmtList()
  for n in x.getType.objfields:
    let i = $n
    let s = quote do:
      `fields`.add((`i`, type(x.`n`).name))
    result.add(s)

proc getFields[T](): seq[tuple[name: string, `type`: string]] =
  var x: T
  var f: seq[tuple[name: string, `type`: string]] = @[]
  fields(x, f)
  f

echo getFields[Data]()
echo getFields[SubData]()
