import strutils, tables, macros, iup

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

converter asBool*(v: IupAttrVal): bool =
  v.asInt == 1

converter asPtr*(v: IupAttrVal): pointer =
  cast[pointer](v.h.getAttribute(v.n))

converter asHandle*(v: IupAttrVal): PIhandle =
  v.h.getAttributeHandle(v.n)

proc to*(v: IupAttrVal, t = string): string =  v.asStr
proc to*(v: IupAttrVal, t = int): int =  v.asInt
proc to*(v: IupAttrVal, t = bool): bool =  v.asBool
proc to*(v: IupAttrVal, t = pointer): pointer =  v.asPtr
proc to*(v: IupAttrVal, t = PIhandle): PIhandle =  v.asHandle

proc `[]=`*(h: PIhandle, name: string, v: string): PIhandle {.discardable.} =
  h.storeAttribute(name.toUpper, v)
  h

proc `[]=`*(h: PIhandle, name: string, v: int): PIhandle {.discardable.}=
  h.setInt(name.toUpper, v.cint)
  h

proc `[]=`*(h: PIhandle, name: string, v: bool): PIhandle {.discardable.}=
  h.setInt(name.toUpper, if v: 1.cint else: 0.cint)
  h

proc `[]=`*(h: PIhandle, name: string, v: pointer): PIhandle {.discardable.} =
  h.setAttribute(name.toUpper, cast[cstring](v))
  h

proc `[]=`*(h: PIhandle, name: string, v: PIhandle): PIhandle {.discardable.} =
  h.setAttributeHandle(name.toUpper, v)
  h
macro set*(h: PIhandle, data: expr): expr =
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
# Common properties

macro genCommonProperty(name: static[string]): stmt =
  let prop = ident(name)
  let propEq = ident(name & "=")
  quote do:
    proc `prop`*(h: PIhandle): IupAttrVal = h[`name`]
    proc `propEq`*(h: PIhandle, v: string) = h[`name`] = v
    proc `propEq`*(h: PIhandle, v: int) = h[`name`] = v
    proc `propEq`*(h: PIhandle, v: bool) = h[`name`] = v
    proc `propEq`*(h: PIhandle, v: pointer) = h[`name`] = v
    proc `propEq`*(h: PIhandle, v: PIhandle) = h[`name`] = v

macro genTypedProperty(name: static[string], t: typedesc): stmt =
  let prop = ident(name)
  let propEq = ident(name & "=")
  let setter = ident("set" & name.capitalize)
  quote do:
    proc `prop`*(h: PIhandle): `t` = h[`name`].to(`t`)
    proc `propEq`*(h: PIhandle, v: `t`) = h[`name`] = v
    proc `setter`*(h: PIhandle, v: `t`): PIhandle = h[`name`] = v

genCommonProperty "value"
genTypedProperty "status", int
genTypedProperty "name", string
genTypedProperty "expand", string
genTypedProperty "font", string
genTypedProperty "padding", string

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
    proc `n`*(h: PIhandle, cb: IupCb): PIhandle {.discardable.} =
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
      h

genAction "Action"

####################################################################################################
# IUP C API wrappers

proc vcall(funcName: NimNode, args: NimNode): expr =
  expectKind args, nnkBracket
  result = newCall(funcName)
  for x in 0..<args.len:
    result.add(args[x])
  result.add(newNilLit())

proc menuItem*(title: string, action = ""): PIhandle =
  iup.item(title, if action == "": nil else: action.cstring)

proc button*(title: string, action = ""): PIhandle =
  iup.button(title, if action == "": nil else: action.cstring)

macro hbox*(args: varargs[untyped]): expr =
  vcall(newDotExpr(ident"iup", ident"hbox"), args)

macro vbox*(args: varargs[untyped]): expr =
  vcall(newDotExpr(ident"iup", ident"vbox"), args)

template popupLocal*(h: PIhandle, x, y: cint) =
  iup.popup(h, x, y)
  defer:
    h.destroy

export iup.popup,
     iup.destroy,
     iup.getDialog,
     iup.textConvertLinColToPos, # TODO: Rewrite to remove var patameter
     iup.showXY

export IUP_CENTER,
     IUP_DEFAULT,
     IUP_CLOSE,
     IUP_MASK_UINT,
     IUP_CENTERPARENT
