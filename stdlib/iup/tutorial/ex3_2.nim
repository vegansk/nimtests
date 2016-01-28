import iup

{.passL: "-Wl,-rpath=.".}

discard iup.open(nil, nil)

let txt = iup.text(nil)
txt.setAttribute("MULTILINE", "YES")
txt.setAttribute("EXPAND", "YES")

let miOpen = iup.item("Open", nil)
let miSaveAs = iup.item("Save As...", nil)
let miExit = iup.item("Exit", nil)
miExit.setCallback("ACTION", proc(self: PIhandle): auto {.cdecl.} = IUP_CLOSE)

let fileMenu = iup.menu(miOpen,
                           miSaveAs,
                           iup.separator(),
                           miExit,
                           nil)
let fileSubMenu = iup.submenu("File", fileMenu)
let menu = iup.menu(fileSubMenu, nil)

let vbox = iup.vbox(txt, nil)
let dlg = iup.dialog(vbox)
dlg.setAttributeHandle("MENU", menu)
dlg.setAttribute("TITLE", "Simple Notepad")
dlg.setAttribute("SIZE", "QUARTERxQUARTER")

dlg.showXY(IUP_CENTER, IUP_CENTER)
dlg.setAttribute("USERSIZE", nil)

iup.mainLoop()

iup.close()
