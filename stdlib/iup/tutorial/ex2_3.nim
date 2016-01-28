import iup

{.passL: "-Wl,-rpath=.".}

discard iup.open(nil, nil)

let btn = iup.button("OK", nil)
let dlg = iup.dialog(iup.vbox(btn, nil))
dlg.setAttribute("TITLE", "Hello world 3")

btn.setCallback("ACTION", proc(b: PIhandle): cint {.cdecl.} = IUP_CLOSE)

dlg.showXY(IUP_CENTER, IUP_CENTER)

iup.mainLoop()

iup.close()
