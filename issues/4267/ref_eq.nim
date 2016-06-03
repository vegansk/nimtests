type
  DataObj = ref object of RootObj
    id: int
  ChildObj = ref object of DataObj
    str: string

proc new(id: int, str: string): ChildObj =
  result.new
  result.id = id
  result.str = str

method `==`(o1, o2: DataObj): bool =
  o1.id == o2.id

let o1 = new(1, "a")
let o2 = new(1, "b")

assert o1 == o2
