import macros

macro getParamType(f: typed, i: static[int]): typed =
  expectKind f, {nnkCall, nnkBracketExpr}
  expectMinLen f, 1
  echo f.getType().treeRepr
  echo f[0].treeRepr
  result = macros.newStmtList()

type
  Array[T] = concept a
    a.len is Ordinal
    a[int] is T

  # Map[K, V, Storage: Array[_,int]] = object
  #   keys: Storage[K]
  #   values: Storage[V]
    
    
var x = @[1,2,3]

echo x is Array[int]
echo seq[int] is Array[int]

getParamType(x.len, 0)
getParamType(x[0], 0)
