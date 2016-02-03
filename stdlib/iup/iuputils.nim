import iup, strutils, tables, macros

when defined(windows):
  when defined(vcc):
    {.link: "../manifest/app.res".}
  else:
    {.link: "../manifest/app.rc.o".}

####################################################################################################
# IUP declarations
when defined(windows):
  const dllname = "iup(|30|27|26|25|24).dll"
elif defined(macosx):
  const dllname = "libiup(|3.0|2.7|2.6|2.5|2.4).dylib"
else:
  const dllname = "libiup(|3.0|2.7|2.6|2.5|2.4).so(|.1)"

proc setInt*(ih: PIhandle, name: cstring, value: cint) {.
  importc: "IupSetInt", cdecl, dynlib: dllname.}

####################################################################################################
# Attributes helpers

type
  IupAttrVal* = object
    h: PIhandle
    n: string

proc `[]`*(h: PIhandle, name: string): IupAttrVal =
  IupAttrVal(h: h, n: name.toUpper)

converter asStr*(v: IupAttrVal): string =
  $v.h.getAttribute(v.n)

converter asInt*(v: IupAttrVal): int =
  v.h.getInt(v.n).int

converter asPtr*(v: IupAttrVal): pointer =
  cast[pointer](v.h.getAttribute(v.n))

converter asHandle*(v: IupAttrVal): PIhandle =
  v.h.getAttributeHandle(v.n)

proc `[]=`*(h: PIhandle, name: string, v: string) =
  h.storeAttribute(name.toUpper, v)

proc `[]=`*(h: PIhandle, name: string, v: int) =
  h.setInt(name.toUpper, v.cint)

proc `[]=`*(h: PIhandle, name: string, v: pointer) =
  h.setAttribute(name.toUpper, cast[cstring](v))

proc `[]=`*(h: PIhandle, name: string, v: PIhandle) =
  h.setAttributeHandle(name.toUpper, v)

macro set*(h: PIhandle, data: expr): stmt =
  expectKind data, nnkTableConstr
  result = newStmtList()
  let lval = genSym(nskLet)
  result.add quote do:
    let `lval` = `h`
  for i in 0..<data.len:
    expectKind data[i], nnkExprColonExpr
    let n = data[i][0]
    let v = data[i][1]
    result.add quote do:
      `lval`[`n`] = `v`

####################################################################################################
# Callback helpers

type IupCb = proc(h: PIhandle): cint {.closure.}

type IupCbs = Table[string,seq[IupCb]]

proc addCb(cbs: var IupCbs, action: string, cb: IupCb) =
  let a = action.toUpper
  if not cbs.hasKey(a):
    cbs.add(a, newSeq[IupCb]())
  cbs[a].add(cb)

type IupBinding = ref object
  cbs: IupCbs

proc intAttr(s: string): string = "vega_IUP_INT_" & s

proc bindingDestructor(h: PIhandle): cint {.cdecl.} =
  result = IUP_DEFAULT
  let b = cast[IupBinding](h.getAttribute(intAttr"binding"))
  assert b != nil
  GC_unref(b)

proc getBinding(h: PIhandle): IupBinding =
  var b = cast[IupBinding](h.getAttribute(intAttr"binding"))
  if b == nil:
    new(b)
    b[].cbs = initTable[string,seq[IupCb]]()
    GC_ref(b)
    h.setAttribute(intAttr"binding", cast[cstring](b))
    h.setCallback("LDESTROY_CB", bindingDestructor)
  b

macro genAction(action: static[string]): stmt =
  let a = action
  let n = ("on" & a.capitalize).newIdentNode
  result = quote do:
    proc `n`*(h: PIhandle, cb: IupCb) =
      var b = h.getBinding
      b.cbs.addCb(`a`, cb)

      proc callbackF(h: PIhandle): cint {.cdecl.} =
        let b = h.getBinding
        var res = IUP_DEFAULT
        if b.cbs.hasKey(`a`.toUpper):
          for cb in b.cbs[`a`.toUpper]:
            res = cb(h)
        return res

      h.setCallback(`a`.toUpper, callbackF)

genAction "Action"
