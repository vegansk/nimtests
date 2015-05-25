import option, future

var x = some(100) 
echo "X=" & $x

echo "None=", none[int]() >>= ((x: int) => none[string]())

echo "Y=" & $(none[int]().getOr(() => 100))

echo "Z=" & some(200).getOr(() => 100).`$`
