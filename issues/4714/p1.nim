template ordLimitDecl(typ: typedesc): untyped =
  proc min*(t = typ): typ = low(typ)
  proc max*(t = typ): typ = high(typ)

int64.ordLimitDecl

echo int64.min
