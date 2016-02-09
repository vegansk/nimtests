import xmlparser, xmltree, os, streams

proc `*`(s: string, c: Natural): string =
  result = newStringOfCap(s.len * c)
  for _ in 0..<c:
    result &= s

proc zeroData(root: XmlNode): XmlNode =
  if root.kind == xnElement:
    result = newElement(root.tag)
    result.attrs = root.attrs
    for ch in root:
      if ch.kind == xnElement or ch.kind == xnText:
        result.add(ch.zeroData)
  elif root.kind == xnText:
    result = newText("_" * root.text.len)

when isMainModule:
  let s = if os.paramCount() == 0:
            (newFileStream(stdin), false)
          else:
            (newFileStream(paramStr(1)), true)
  defer:
    if s[1]:
      s[0].close
  echo s[0].parseXml.zeroData
