import macros, json, typetraits, sequtils

# This is a default implementation for int
proc toJson*(v: int): JsonNode =
  v.newJInt

proc toJson*(v: string): JsonNode =
  v.newJString

proc fromJson(t = int, v: JsonNode): int =
  v.getNum.int 

proc fromJson(t = string, v: JsonNode): string =
  v.getStr

type
  Fields = seq[tuple[n: string, t: string]]

macro fields[T](x: T, fields: Fields): stmt =
  iterator objfields(t: NimNode): NimNode =
    let reclist = t.getType[1]
    for i in 0..len(reclist)-1:
      yield reclist[i]

  result = newStmtList()
  for n in x.getType.objfields:
    let i = $n
    let s = quote do:
      `fields`.add((`i`, type(x.`n`).name))
    result.add(s)

proc getFields[T](): Fields {.compileTime.} =
  var x: T
  var f: Fields = @[]
  fields(x, f)
  f

macro toJsonObj(v: expr, fields: static[Fields]): expr =
  result = newNimNode(nnkStmtListExpr)
  let res = ident"res"
  result.add quote do:
    let `res` = newJObject()
  for f in fields:
    let nameS = f.n
    let nameN = f.n.ident
    result.add quote do:
      `res`[`nameS`] = `v`.`nameN`.toJson
  result.add(res)

macro fromJsonObj[T](t: typedesc, v: var T, n: JsonNode, fields: static[Fields]): stmt =
  result = newStmtList()
  for f in fields:
    let nameS = f.n
    let nameN = f.n.ident
    let typeN = f.t.ident
    result.add quote do:
      `v`.`nameN` = fromJson(`typeN`, `n`[`nameS`])

# Default implementation for objects
proc toJson*[T: object](v: T): JsonNode =
  const f = getFields[T]()
  toJsonObj(v, f)

proc fromJson*[T: object](t: typedesc[T], v: JsonNode): T =
  const f = getFields[T]()
  fromJsonObj(t, result, v, f) 
