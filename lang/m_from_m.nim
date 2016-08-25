import macros

proc jniSig(t: typedesc[string]): string = "Ljava/lang/String;"

# This macro generates JNI signatures
macro genSignature(id, n: expr): stmt =
  result = quote do:
    `id` = `n`.jniSig

# I can get the signature in ordinary code
var sig: string
genSignature sig, string

# I can use it in unit tests
assert sig == "Ljava/lang/String;"

# And this macro must use ``genSignature``
macro jclass(head, body: expr): stmt =
  for procDef in body:
    var sig: string
    # *** I can't use genSignature in the macro code like that
    genSignature sig, procDef
