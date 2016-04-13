import marshal

type
  Test = object of RootObj
    id: int
    str: string
    
let testObj = Test(id: 1, str: "lalala")

let jsObj = $$testObj

echo jsObj

let unmarshalled = to[Test](jsObj)

echo unmarshalled
