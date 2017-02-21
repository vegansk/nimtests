import macros

macro genBody: untyped =
  let s = genSym(nskLabel, "test")
  result = quote do:
    block `s`:
      break `s`

proc test() =
  genBody()
