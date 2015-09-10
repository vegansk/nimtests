#
# Exercises from "Functional programming in scala" transated to Nim
#

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
proc maximum[T: SomeNumber](t: Tree[T]): T =
  case t.kind
  of tnkLeaf: t.value
  else: t.left.maximum.max(t.right.maximum)

# Ex. 3.27
proc depth(t: Tree): int =
  case t.kind
  of tnkLeaf: 1
  else: 1 + max(t.left.depth, t.right.depth)

# Ex. 3.28
proc map[T,U](t: Tree[T], f: T -> U): Tree[U] =
  case t.kind
  of tnkLeaf: Leaf(t.value.f)
  else: Branch(t.left.map(f), t.right.map(f))

# Ex. 3.29
proc fold[T,U](t: Tree[T], f: T -> U, g: (U, U) -> U): U =
  case t.kind
  of tnkLeaf: f(t.value)
  else: g(t.left.fold(f, g), t.right.fold(f, g))

# With current nim version, we can't use type class Tree here
proc sizeViaFold[T](t: Tree[T]): int = t.fold((_: T) => 1, (x: int, y: int) => 1 + x + y)
proc maximumViaFold[T: SomeNumber](t: Tree[T]): T = t.fold((_: T) => _, (x: T, y: T) => x.max(y))
proc depthViaFold[T](t: Tree[T]): int = t.fold((_: T) => 1, (x: int, y: int) => 1 + x.max(y))
proc mapViaFold[T,U](t: Tree[T], f: T -> U): Tree[U] = t.fold((_: T) => Leaf(f(_)), (x: Tree[U], y: Tree[U]) => Branch(x, y))

when isMainModule:
  let tree = Branch(Branch(Leaf(1), Leaf(2)), Branch(Leaf(3), Branch(Leaf(4), Leaf(5))))

  echo "Here is the tree: ", tree
  echo "It's size is ", tree.size, " or ", tree.sizeViaFold
  echo "It's maximum is ", tree.maximum, " or ", tree.maximumViaFold
  echo "It's depth is ", tree.depth, " or ", tree.depthViaFold
  echo "Map can be like this:\n  ", tree.map((x: int) => "Value" & $x)
  echo "Or this:\n  ", tree.mapViaFold((x: int) => "Value" & $x)
