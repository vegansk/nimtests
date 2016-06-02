var theObjectsCount = 0

type
  Base = ref object of RootObj
    id: int
  Child = ref object of Base
    val: string

proc free(b: Base) =
  echo "Destroying base with id=", b.id

proc destroyBase(b: Base) =
  b.free
  dec theObjectsCount

proc newBase(id: int): Base =
  echo "Creating base with id=", id
  result.new(destroyBase)
  result.id = id
  inc theObjectsCount

proc free(c: Child) =
  echo "Destroying child with id=", c.id
  c.Base.free

proc destroyChild(c: Child) =
  c.free
  dec theObjectsCount

proc newChild(id: int, val: string): Child =
  echo "Creating child with id=", id
  result.new(destroyChild)
  result.id = id
  result.val = val
  inc theObjectsCount
  
proc baseOps =
  discard newBase(1)

proc childOps =
  discard newChild(2, "s")

proc main =
  baseOps()
  childOps()
  GC_fullCollect()
  var ch: Child

main()
