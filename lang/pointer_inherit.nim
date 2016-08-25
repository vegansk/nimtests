type
  jobject = distinct pointer
  BaseObject = distinct pointer
  ChildObject = distinct pointer
  OtherObject = distinct pointer

proc newO[T](): T = nil.T

proc say(o: jobject): string = "jobject"
proc sayObject(o: jobject): string = "jobject"
proc sayBase(o: BaseObject): string = "BaseObject"
proc sayChild(o: ChildObject): string = "ChildObject"
proc sayBase(o: ChildObject): string = "ChildObject"
proc sayBase(o: OtherObject): string = "OtherObject"

converter baseObjectToObject(o: BaseObject): jobject = o.jobject
converter childObjectToBaseObject(o: ChildObject): BaseObject = o.BaseObject

let a = newO[jobject]()
let b = newO[BaseObject]()
let c = newO[ChildObject]()
let o = newO[OtherObject]()

echo a.say
echo b.sayBase
echo c.sayChild
echo c.sayBase
echo c.BaseObject.sayObject
echo o.sayBase
