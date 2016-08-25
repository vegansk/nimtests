import future

proc tryE(f: () -> void): string =
  try:
    f()
    result = nil
  except:
    result = getCurrentExceptionMsg()

template io(x: stmt): expr =
  tryE(proc =
    `x`
  )

proc main =
  let s = "Hello, world!"
  let res = io(echo s)
  
main()
