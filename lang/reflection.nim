import macros, typetraits

type Data = object
  value: int
  fvalue: float

iterator objfields(t: typedesc): (NimNode, NimNode) =
  # t.getType[1] gets the underlying type of the typedesc parameter.
  # getType[1] of that value gets the object items.
  let reclist = t.getType[1].getType[1]
  for i in 0..len(reclist)-1:
    yield (reclist[i], reclist[i].getType)

macro genObjCons(T: typedesc): stmt =
  expectKind T.getType[1].getType, nnkObjectTy
  let name = ident("init" & $T.getType[1])
  var params = @[T.getType[1]]
  var body = newNimNode nnkObjConstr
  body.add(T.getType[1])
  for fName, fType in T.objfields:
    let parName = ident($fName & "Param")
    params.add(newIdentDefs(parName, fType))
    body.add(newColonExpr(fName, parName))
  let procDef = newProc(name, params, body)
  result = newStmtList procDef

Data.genObjCons

echo initData(1, 2)
