import macros, future

macro test(): stmt =
  # let n = lc[x+y | (x <- 0..10, x mod 2 == 0, y <- 1..2), int].getAst
  let n = getAst(future.`[]`(lc, x+y | (x <- 0..10, x mod 2 == 0, y <- 1..2), int))
  echo n.treeRepr
  result = newEmptyNode()

test()
        
