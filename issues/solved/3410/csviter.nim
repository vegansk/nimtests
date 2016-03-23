import future, encodings

iterator csvLines(f: File|string, encoding: string): string =

  let enc = if encoding != "UTF-8": (s: string) => convert(s, srcEncoding = encoding) else: (s: string) => s

  # let enc = if encoding == "UTF-8": proc(s: string): auto {.closure.} = s else: proc(s: string): auto = convert(s, srcEncoding = encoding)

  # let enc = if encoding == "UTF-8": (s: string) => s else: (s: string) => convert(s, srcEncoding = encoding)

  for line in f.lines():
    yield enc(line)

when isMainModule:
  for row in "test.csv".csvLines("CP1251"):
    echo row
