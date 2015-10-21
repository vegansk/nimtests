{.nanChecks: on, infChecks: on.}
var a = 1.0
var b = 0.0
# echo b / b # raises FloatInvalidOpError
echo a / b # raises FloatOverflowError
