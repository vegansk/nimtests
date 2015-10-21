var tmp{.compiletime.} = 10

proc foo(): int {.compiletime} =
  tmp = tmp + 10
  tmp

echo foo() # echos 20
echo foo() # echos 20

