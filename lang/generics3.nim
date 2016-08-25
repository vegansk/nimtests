# type
#   TGen[T] = object {.inheritable.}
#     field: T

#   TDerived[T] = object of TGen[T]
#     nextField: T

# proc doSomething[T](x: ref TGen[T]) =
#   type
#     Ty = ref TDerived[T]
#   echo Ty(x).nextField

# var
#   x: ref TDerived[string]
# new(x)
# x.nextField = "test"

# doSomething(x)
type
  BaseClass[V] = object of RootObj
    b: V

proc new[V](t: typedesc[BaseClass], v: V): BaseClass[V] =
  BaseClass[V](b: v)

proc baseMethod[V](v: BaseClass[V]): V = v.b

type
  ChildClass[V] = object of BaseClass[V]
    c: V
proc new[V](t: typedesc[ChildClass], v1, v2: V): ChildClass[V] =
  ChildClass[V](b: v1, c: v2)

# proc baseMethod[V](v: ChildClass[V]): V = v.b
proc childMethod[V](v: ChildClass[V]): V = v.c

let b = BaseClass[string].new("Base")
let c = ChildClass[string].new("Base", "Child")

# assert baseMethod(b) == baseMethod[string](c)
discard baseMethod(c)

# # Issue 88

# # {.experimental.}

# type
#   BaseClassObj[V] = object of RootObj
#     b: V
#   BaseClass[V] = ref BaseClassObj[V]

# proc new[V](t: typedesc[BaseClass], v: V): BaseClass[V] =
#   BaseClass[V](b: v)

# proc baseMethod[V](v: BaseClass[V]): V = v.b
# proc overridedMethod[V](v: BaseClass[V]): V = v.baseMethod

# type
#   ChildClassObj[V] = object of BaseClassObj[V]
#     c: V
#   ChildClass[V] = ref ChildClassObj[V]

# proc new[V](t: typedesc[ChildClass], v1, v2: V): ChildClass[V] =
#   ChildClass[V](b: v1, c: v2)

# proc overridedMethod[V](v: ChildClass[V]): V = v.c

# let c = ChildClass[string].new("Base", "Child")

# assert c.baseMethod == "Base"
# assert c.overridedMethod == "Child"
