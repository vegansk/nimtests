import iup, strutils

when defined(windows):
  when defined(vcc):
    {.link: "../manifest/app.res".}
  else:
    {.link: "../manifest/app.rc.o".}

type IupAttr* = distinct PIhandle
type IupHAttr* = distinct PIhandle

proc attr*(r: PIhandle): IupAttr = r.IupAttr
proc hattr*(r: PIhandle): IupHAttr = r.IupHAttr

proc `.`*(a: IupAttr, name: string): string =
  $a.PIhandle.getAttribute(name.toUpper)

proc `.`*(a: IupHAttr, name: string): PIhandle =
  a.PIhandle.getAttributeHandle(name.toUpper)

proc `.=`*(a: IupAttr, name, value: string) =
  a.PIhandle.storeAttribute(name.toUpper, value)

proc `.=`*(a: IupHAttr, name: string, value: PIhandle) =
  a.PIhandle.setAttributeHandle(name.toUpper, value)

proc set*(a: IupAttr, args: varargs[(string, string)]) =
  for v in args:
    a.PIhandle.storeAttribute(v[0].toUpper, v[1])

proc set*(a: IupHAttr, args: varargs[(string, PIhandle)]) =
  for v in args:
    a.PIhandle.setAttributeHandle(v[0].toUpper, v[1])

####################################################################################################
## Dialog helpers
proc dlgStatus*(d: PIhandle): int =
  d.getInt("STATUS").int
