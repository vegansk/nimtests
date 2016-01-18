proc isEmpty(s: string): bool =
  len(s) == 0

proc main() =
  let s = ""
  case s.isEmpty
  of true: echo "Empty"
  else: echo "Not empty"

when isMainModule:
  main()
    
