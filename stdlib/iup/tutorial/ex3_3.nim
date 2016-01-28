import iup

{.passL: "-Wl,-rpath=.".}

discard iup.open(nil, nil)

let txt = iup.text(nil)
txt.setAttribute("MULTILINE", "YES")
txt.setAttribute("EXPAND", "YES")

let miOpen = iup.item("Open", nil)
let miSaveAs = iup.item("Save As...", nil)
let miExit = iup.item("Exit", nil)

let miFont = iup.item("Set font...", nil)

let miAbout = iup.item("About...", nil)

miOpen.setCallback("ACTION") do (self: PIhandle) -> auto {.cdecl.}:
  let dlg = iup.fileDlg()
  dlg.setAttribute("DIALOGTYPE", "OPEN")
  dlg.setAttribute("EXTFILTER", "Text Files|*.txt|All Files|*.*|")

  dlg.popup(IUP_CENTER, IUP_CENTER)

  if dlg.getInt("STATUS") != -1:
    let fname = $dlg.getAttribute("VALUE")
    let data = fname.readFile
    txt.setAttribute("VALUE", data)

  dlg.destroy
  IUP_DEFAULT

miSaveAs.setCallback("ACTION") do (self: PIhandle) -> auto {.cdecl.}:
  let dlg = iup.fileDlg()
  dlg.setAttribute("DIALOGTYPE", "SAVE")
  dlg.setAttribute("EXTFILTER", "Text Files|*.txt|All Files|*.*|")

  dlg.popup(IUP_CENTER, IUP_CENTER)

  if dlg.getInt("STATUS") != -1:
    let fname = $dlg.getAttribute("VALUE")
    let data = $txt.getAttribute("VALUE")
    fname.writeFile(data)

  dlg.destroy
  IUP_DEFAULT

miExit.setCallback("ACTION") do (self: PIhandle) -> auto {.cdecl.}:
  IUP_CLOSE

miFont.setCallback("ACTION") do (self: PIhandle) -> auto {.cdecl.}:
  let dlg = iup.fontDlg()
  dlg.setAttribute("VALUE", txt.getAttribute("FONT"))

  dlg.popup(IUP_CENTER, IUP_CENTER)

  if dlg.getInt("STATUS") != -1:
    let font = dlg.getAttribute("VALUE")
    txt.setAttribute("FONT", font)

  dlg.destroy
  IUP_DEFAULT

let fileMenu = iup.menu(miOpen,
                        miSaveAs,
                        iup.separator(),
                        miExit,
                        nil)
let fileSubMenu = iup.submenu("File", fileMenu)

let fmtMenu = iup.menu(miFont, nil)
let fmtSubMenu = iup.submenu("Format", fmtMenu)

let menu = iup.menu(fileSubMenu, fmtSubMenu, nil)

let vbox = iup.vbox(txt, nil)
let dlg = iup.dialog(vbox)
dlg.setAttributeHandle("MENU", menu)
dlg.setAttribute("TITLE", "Simple Notepad")
dlg.setAttribute("SIZE", "QUARTERxQUARTER")

dlg.showXY(IUP_CENTER, IUP_CENTER)
dlg.setAttribute("USERSIZE", nil)

iup.mainLoop()

iup.close()
