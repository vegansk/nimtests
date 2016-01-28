import iup

{.passL: "-Wl,-rpath=.".}

discard iup.open(nil, nil)

let txt = iup.text(nil)
txt.setAttribute("MULTILINE", "YES")
txt.setAttribute("EXPAND", "YES")

let vbox = iup.vbox(txt, nil)
let dlg = iup.dialog(vbox)
dlg.setAttribute("TITLE", "Simple Notepad")
dlg.setAttribute("SIZE", "QUARTERxQUARTER")

dlg.showXY(IUP_CENTER, IUP_CENTER)
dlg.setAttribute("USERSIZE", nil)

iup.mainLoop()

iup.close()
