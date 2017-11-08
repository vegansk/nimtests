import future

proc withX(x: int): (y: int) -> int =
  discard

withX(1)((y: int) => y + 1)
