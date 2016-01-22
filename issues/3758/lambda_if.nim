import future

proc test(v: int, f: int -> string): string = f(v)

# This works
# echo 1.test(v => (if v mod 2 == 0: "even" else: "odd"))

echo 1.test(v => (
  if v mod 2 == 0:
    "even"
  else:
    "odd"
))
