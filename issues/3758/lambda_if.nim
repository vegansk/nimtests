import future

proc test(v: int, f: int -> string): string = f(v)

# This works
# echo 1.test(v => (if v mod 2 == 0: "even" else: "odd"))

# echo 1.test(v => (
#   if v mod 2 == 0:
#     "even"
#   else:
#     "odd"
# ))

var (x, y) = (false, true)

# This works
# case x
# of true:
#   let z = if y: "a" else: "b"
#   echo z
# else:
#   echo "no"

case x
of true:
  let z = if y:
    "a"
  else:
    "b"
  echo z
else:
  echo "no"
