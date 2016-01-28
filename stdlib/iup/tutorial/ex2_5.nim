import iup

{.passL: "-Wl,-rpath=.".}

discard iup.open(nil, nil)

let label = iup.label("Hello world from IUP.")
let btn = iup.button("OK", nil)
let vbox = iup.vbox(label, btn, nil)
let dlg = iup.dialog(vbox)
dlg.setAttribute("TITLE", "Hello world 4")

btn.setCallback("ACTION", proc(b: PIhandle): cint {.cdecl.} = IUP_CLOSE)

vbox.setAttribute("ALIGNMENT", "ACENTER")
vbox.setAttribute("GAP", "10")
vbox.setAttribute("MARGIN", "10x10")

dlg.showXY(IUP_CENTER, IUP_CENTER)

iup.mainLoop()

iup.close()
