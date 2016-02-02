import iup, ../iuputils, future

when defined(posix):
  {.passL: "-Wl,-rpath=.".}

discard iup.open(nil, nil)

let txt = iup.text(nil)
txt.set({
  "multiLine": "yes",
  "expand": "yes"
})

let miOpen = iup.item("Open", nil)
let miSaveAs = iup.item("Save As...", nil)
let miExit = iup.item("Exit", nil)

let miFont = iup.item("Set font...", nil)

let miAbout = iup.item("About...", nil)

miOpen.onAction proc(h: auto): auto =
  let dlg = iup.fileDlg()
  dlg.set({
    "dialogType": "open",
    "extFilter": "Text Files|*.txt|All Files|*.*|" 
  })

  dlg.popup(IUP_CENTER, IUP_CENTER)
  defer: dlg.destroy

  if dlg["status"] != -1:
    let fname = dlg["value"]
    let data = fname.readFile
    txt["value"] = data

  IUP_DEFAULT

miSaveAs.onAction proc(h: auto): auto =
  let dlg = iup.fileDlg()
  dlg.set({
    "dialogType": "save",
    "extFilter": "Text Files|*.txt|All Files|*.*|" 
  })

  dlg.popup(IUP_CENTER, IUP_CENTER)
  defer: dlg.destroy

  if dlg.getInt("STATUS") != -1:
    let fname = dlg["value"]
    let data = txt["value"]
    fname.writeFile(data)

  IUP_DEFAULT

miExit.onAction(h => IUP_CLOSE)

miFont.onAction proc(h: auto): auto =
  let dlg = iup.fontDlg()
  dlg["value"] = txt["font"].asStr
  
  dlg.popup(IUP_CENTER, IUP_CENTER)
  defer: dlg.destroy
 
  if dlg["status"] != -1:
    let font = dlg["value"].asStr
    txt["font"] = font

  IUP_DEFAULT

miAbout.onAction(h => (iup.message("About", "Vega was here!"); IUP_DEFAULT))

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
dlg["menu"] = menu
dlg.set({
  "title": "Simple Notepad",
  "size": "QUARTERxQUARTER"
})

dlg.showXY(IUP_CENTER, IUP_CENTER)
dlg["userSize"] = nil.pointer

iup.mainLoop()

iup.close()
