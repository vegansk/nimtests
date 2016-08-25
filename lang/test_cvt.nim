import strutils

type
  NotSeq = concept x
    not (x is seq)

type
  Id = tuple[id: int, arr: seq[string]]

proc cvt[T: NotSeq,U](v: seq[T], t: typedesc[U]): seq[U]
proc cvt[T,U](v: seq[seq[T]], t: typedesc[seq[U]]): seq[seq[U]]
proc cvt(s: string, t = int): int = s.parseInt
proc cvt(s: string, t = string): string = s
proc cvt(s: string, t = bool): bool = s == "true"
proc cvt(s: string, t = Id): Id = (cvt(s, int), cvt(@[s], string))

proc cvt[T: NotSeq,U](v: seq[T], t: typedesc[U]): seq[U] =
  result = newSeq[U](v.len)
  for i in 0..<v.len:
    result[i] = cvt(v[i], U)

proc cvt[T,U](v: seq[seq[T]], t: typedesc[seq[U]]): seq[seq[U]] =
  result = newSeq[seq[U]](v.len)
  for i in 0..<v.len:
    result[i] = cvt(v[i], seq[U])

echo @[1,2,3] is NotSeq
echo 1 is NotSeq
echo "1" is NotSeq

echo cvt(@["true", "false"], bool)
echo cvt(@[@["true", "false"]], seq[bool])
# echo cvt("100", Id)
