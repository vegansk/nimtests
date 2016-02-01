import iup, ../iuputils, future

when defined(posix):
  {.passL: "-Wl,-rpath=.".}

discard iup.open(nil, nil)

let txt = iup.text(nil)
txt.attr.set({
  "multiLine": "yes",
  "expand": "yes"
})

let miOpen = iup.item("Open", nil)
let miSaveAs = iup.item("Save As...", nil)
let miExit = iup.item("Exit", nil)

let miFont = iup.item("Set font...", nil)

let miAbout = iup.item("About...", nil)

miOpen.onAction do (self: PIhandle) -> auto:
  let dlg = iup.fileDlg()
  dlg.attr.set({
    "dialogType": "open",
    "extFilter": "Text Files|*.txt|All Files|*.*|" 
  })

  dlg.popup(IUP_CENTER, IUP_CENTER)
  defer: dlg.destroy

  if dlg.dlgStatus != -1:
    let fname = dlg.attr.value
    let data = fname.readFile
    txt.attr.value = data

  IUP_DEFAULT

miSaveAs.onAction do (self: PIhandle) -> auto:
  let dlg = iup.fileDlg()
  dlg.attr.set({
    "dialogType": "save",
    "extFilter": "Text Files|*.txt|All Files|*.*|" 
  })

  dlg.popup(IUP_CENTER, IUP_CENTER)
  defer: dlg.destroy

  if dlg.getInt("STATUS") != -1:
    let fname = dlg.attr.value
    let data = txt.attr.value
    fname.writeFile(data)

  IUP_DEFAULT

# miExit.setCallback("ACTION") do (self: PIhandle) -> auto {.cdecl.}:
#   IUP_CLOSE

miExit.onAction(h => IUP_CLOSE)

miFont.setCallback("ACTION") do (self: PIhandle) -> auto {.cdecl.}:
  let dlg = iup.fontDlg()
  dlg.attr.value = txt.attr.font
  
  dlg.popup(IUP_CENTER, IUP_CENTER)
  defer: dlg.destroy
 
  if dlg.dlgStatus != -1:
    let font = dlg.attr.value
    txt.attr.font = font

  IUP_DEFAULT

miAbout.setCallback("ACTION") do (self: PIhandle) -> auto {.cdecl.}:
  iup.message("About", "Vega was here!")
  IUP_DEFAULT

let fileMenu = iup.menu(miOpen,
                        miSaveAs,
                        iup.separator(),
                        miExit,
                        nil)
let fileSubMenu = iup.submenu("File", fileMenu)

let fmtMenu = iup.menu(miFont, nil)
let fmtSubMenu = iup.submenu("Format", fmtMenu)

let helpMenu = iup.menu(miAbout, nil)
let helpSubMenu = iup.submenu("Help", helpMenu)

let menu = iup.menu(fileSubMenu, fmtSubMenu, helpSubMenu, nil)

let vbox = iup.vbox(txt, nil)
let dlg = iup.dialog(vbox)
dlg.hattr.menu = menu
dlg.attr.set({
  "title": "Simple Notepad",
  "size": "QUARTERxQUARTER"
})

dlg.showXY(IUP_CENTER, IUP_CENTER)
dlg.hattr.userSize = nil

iup.mainLoop()

iup.close()
