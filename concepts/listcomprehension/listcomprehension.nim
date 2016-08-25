import macros, future

type ListComprehension2 = object
var lc2: ListComprehension2

macro `[]`(lc2: ListComprehension2, comp: expr): expr =
  expectLen(comp, 3)
  expectKind(comp, nnkInfix)
  expectKind(comp[0], nnkIdent)
  assert($comp[0].ident == "|")

  result = newCall(
    newDotExpr(
      newIdentNode("result"),
      newIdentNode("add")),
    comp[1])

  for i in countdown(comp[2].len-1, 0):
    let x = comp[2][i]
    expectMinLen(x, 1)
    if x[0].kind == nnkIdent and $x[0].ident == "<-":
      expectLen(x, 3)
      result = newNimNode(nnkForStmt).add(x[1], x[2], result)
    else:
      result = newIfStmt((x, result))

  result = newNimNode(nnkCall).add(
    newNimNode(nnkPar).add(
      newNimNode(nnkLambda).add(
        newEmptyNode(),
        newEmptyNode(),
        newEmptyNode(),
        newNimNode(nnkFormalParams).add(
          newNimNode(nnkBracketExpr).add(
            newIdentNode("seq"),
            newIdentNode("auto"))),
        newEmptyNode(),
        newEmptyNode(),
        newStmtList(
          newAssignment(
            newIdentNode("result"),
            newNimNode(nnkPrefix).add(
              newIdentNode("@"),
              newNimNode(nnkBracket))),
          result))))

macro test(): stmt {.immediate.} =
  let n = (lc[x+y | (x <- 0..10, y <- 1..2), int]).getAst
  echo n.treeRepr
  result = newEmptyNode()

when isMainModule:
  # let lambda = proc(): seq[int] =
  #   result = 
  let x = lc[x | (x <- 0..10), int]
  test()
