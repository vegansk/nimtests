import macros

macro def(name: untyped, params: untyped, retType: typedesc, body: untyped): stmt =
  echo params.treeRepr
  result = quote do:
    proc `name`*(`params`): `rettype` = `body`

macro def_test: stmt =
  result = newStmtList()
  let t = def(ident"testFunc", (i: int, s: string), string):
    result = "(" & $i & ", " & s & ")"
  echo t.toStrLit

# def(testFunc, (i: int, s: string), string):
#   result = "(" & $i & ", " & s & ")"

# echo testFunc(1, "a")

def_test()
