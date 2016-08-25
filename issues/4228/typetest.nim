import macros, typetraits

template seqType(t: typedesc): typedesc =
  when t is int:
    seq[int]
  else:
    seq[string]

proc mkSeq[T](v: T): seqType(T) =
  result = newSeq[T](1)
  result[0] = v

echo mkSeq("a")
# Fails here
echo mkSeq(1)
