import option, future

var x = some(100) 
echo "X=" & $x

echo "None=", none[int]() >>= ((x: int) => none[string]())

echo "Y=" & $(none[int]().getOr(() => 100))

echo "Z=" & some(200).getOr(() => 100).`$`

# Sadly, in 0.11.2 we can't use method call syntax here
eval[int,void](some(100500), (v: int) => echo "I'm at some " & $v, () => echo "Nope")
eval[int,void](none[int](), (v: int) => echo "I'm at some " & $v, () => echo "Nope")
