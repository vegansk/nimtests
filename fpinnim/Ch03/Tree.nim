import future

{.experimental.}

type
  TreeNodeKind = enum
    tnkLeaf, tnkBranch
  Tree[T] = ref object
    case kind: TreeNodeKind
    of tnkLeaf:
      value: T
    of tnkBranch:
      left, right: Tree[T]

proc Leaf[T](value: T): Tree[T] = Tree[T](kind: tnkLeaf, value: value)
      
proc Branch[T](left, right: Tree[T]): Tree[T] = Tree[T](kind: tnkBranch, left: left, right: right)

proc `$`(t: Tree): string =
  case t.kind
  of tnkLeaf: "Leaf(" & $t.value & ")"
  else: "Branch(" & $t.left & ", " & $t.right & ")"

# Ex. 3.25
proc size(t: Tree): int =
  case t.kind
  of tnkLeaf: 1
  else: 1 + size(t.left) + size(t.right)

# Ex. 3.26
type
  Number = concept x, y
    x.max(y) is Number

proc maximum[T: Number](t: Tree[T]): T =
  case t.kind
  of tnkLeaf: t.value
  else: t.left.maximum.max(t.right.maximum)

when isMainModule:
  let tree = Branch(Branch(Leaf(1), Leaf(2)), Branch(Leaf(3), Branch(Leaf(4), Leaf(5))))

  echo tree
  echo tree.size()
  echo tree.maximum()
