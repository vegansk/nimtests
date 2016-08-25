import macros, typetraits

macro test(e: expr): stmt =
  echo treeRepr(e)
  result = quote do:
    echo `e`

test 1
test "asd"
