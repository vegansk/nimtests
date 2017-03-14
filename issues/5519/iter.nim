import os, algorithm

iterator filesItImpl(path: string): auto =
  var files = newSeq[string]()
  var dirs = newSeq[string]()
  for k, p in os.walkDir(path):
    let (_, n, e) = p.splitFile
    if e != "":
      continue
    case k
    of pcFile, pcLinkToFile:
      files.add(n)
    else:
      dirs.add(n)
  files.sort(system.cmp)
  dirs.sort(system.cmp)
  for f in files:
    yield f

  # for d in dirs:
  #   files = newSeq[string]()
  #   for k, p in os.walkDir(path / d):
  #     let (_, n, e) = p.splitFile
  #     if e != "":
  #       continue
  #     case k
  #     of pcFile, pcLinkToFile:
  #       files.add(n)
  #     else:
  #       discard
  #   files.sort(system.cmp)
  #   let prefix = path.splitPath[1]
  #   for f in files:
  #     yield prefix / f

iterator filesIt(path: string): string {.closure.} =
  for f in filesItImpl(path):
    yield f

for f in filesIt("/tmp"):
  echo f
