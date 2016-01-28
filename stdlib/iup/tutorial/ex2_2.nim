import iup

{.passL: "-Wl,-rpath=.".}

discard iup.open(nil, nil)

let label = iup.label("Hello world from IUP.")
let dlg = iup.dialog(iup.vbox(label, nil))
dlg.setAttribute("TITLE", "Hello world 2")

dlg.showXY(IUP_CENTER, IUP_CENTER)

iup.mainLoop()

iup.close()
