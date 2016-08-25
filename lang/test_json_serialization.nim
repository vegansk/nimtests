import macros, json, fp.option, boost.parsers, fp.list, unittest

type
  Child = object
    id: int
    data: Option[string]
  Data = object
    id: int
    str: string

proc simpleToJson(n: NimNode, typ: NimNode): NimNode =
  if typ.sameType(int.getType):
    result = newCall("newJInt", n)
  elif typ.sameType(string.getType):
    result = newCall("newJString", n)
  else:
    error("Don't know how ``toJson`` " & $typ.toStrLit)

proc seqToJson(n: NimNode, typ: NimNode): NimNode =
  result = newNimNode(nnkStmtListExpr)
  let arr = ident"arr"
  let v = ident"v"
  result.add quote do:
    let `arr` = newJArray()
  result.add quote do:
    for `v` in `n`:
      `arr`.add(toJson(`v`))
  result.add quote do:
    `arr`

proc toJsonImpl = discard

proc getCustomSerializer(typ: NimNode): Option[NimNode] {.compileTime.} =
  result = NimNode.none
  let s = bindSym("toJsonImpl", brForceOpen)
  echo s.treeRepr
  for f in s:
    let ftyp = f.getType
    if $ftyp[0] != "proc": continue
    if ftyp.len != 3: continue
    if ftyp[1].kind != nnkBracketExpr or $ftyp[1][1] != "JsonNodeObj": continue
    if ftyp[2].sameType(typ):
      echo "Got it"
      return f.some

# proc getCustomSerializer(typ: NimNode): Option[NimNode] =
#   result = NimNode.none
#   let s = bindSym("toJsonImpl", brForceOpen)
#   echo s.treeRepr
#   for f in s:
#     echo "ITER with ", typ.treeRepr
#     let ftyp = f.getType
#     if $ftyp[0] != "proc": continue
#     if ftyp.len != 3: continue
#     if ftyp[1].kind != nnkBracketExpr or $ftyp[1][1] != "JsonNodeObj": continue
#     if ftyp[2].kind != nnkBracketExpr: continue
#     if ftyp[2].sameType(typ):
#       return f.some
#     echo "TEMP with ", typ.treeRepr
#     let t1 = ftyp[2][0][1]
#     # echo typ.treeRepr
#     let t2 = typ.getType[1]
#     if ftyp[2][0].kind == nnkBracketExpr and $t1 == $t2:
#       result = f.some
#       break

proc toJsonInternal(o: NimNode): NimNode =
  let typ = o.getType
  if typ.kind == nnkSym:
    # Simple type
    result = simpleToJson(o, typ)
  elif typ.kind == nnkBracketExpr and $typ[0] == "seq":
    result = seqToJson(o, typ[1])
  else:
    error("Don't know how ``toJson`` " & $typ.toStrLit)

macro toJsonExpr(o: typed): expr =
  let cs = getCustomSerializer(o.getType)
  if cs.isDefined:
    let f = cs.get
    result = quote do:
      `f`(`o`)
  else:
    result = toJsonInternal(o)

proc mkToJsonExpr(o: NimNode): NimNode =
  result = newCall(bindSym"toJsonExpr", o)

macro toJson(o: typed): expr =
  result = mkToJsonExpr(o)

####################################################################################################
# Tests
   
type
  MyInt = distinct int

proc toJsonImpl(v: MyInt): JsonNode =
  v.int.newJInt

# template toJsonImpl(v: Option[string]): JsonNode =
#   v.get.toJson

proc toJsonImpl[T](v: Option[T]): JsonNode =
  v.get.toJson

suite "JSON marshal":
  # test "Simple types":
  #   check: 1.newJInt == toJson(1)
  #   check: "1".newJString == toJson("1")

  # test "Sequence":
  #   check: %*[1,2,3] == toJson(@[1,2,3])
  #   check: %*["1", "2", "3"] == toJson(@["1", "2", "3"])

  test "Custom serializers":
    check: 1.newJInt = toJson(1.MyInt)

  # test "Option":
  #   let x = toJson("test".some)
  #   check: "test".newJString == toJson("test".some)
  #   check: newJNull == toJson(string.none)

# when isMainModule:
#   # API
#   var o: Data
#   # let j = toJson(o)
#   # let j2 = toJson(@[o])
#   # let j3 = toJson(Nil[Data]())
#   echo toJson(1)
#   # o = j.jsonAs[]
