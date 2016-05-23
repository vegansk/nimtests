type
  Data = ref object
    case h: bool
    of true:
      d: string
    else:
      discard

proc init(v: string): Data = Data(h: true, d: v)

proc get(d: Data): string =
  case d.h
  of true:
    d.d
  else:
    ""

const data = get(init("a"))
