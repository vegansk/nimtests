import iup, ../iuputils, future, strutils

when defined(posix):
  {.passL: "-Wl,-rpath=.".}

discard iup.open(nil, nil)

let txt = iup.text(nil)
txt.set({
  "multiLine": "yes",
  "expand": "yes",
  "name": "txtCtrl"
})

let miOpen = iup.item("Open", nil)
let miSaveAs = iup.item("Save as...", nil)
let miExit = iup.item("Exit", nil)

let miFont = iup.item("Set font...", nil)

let miFind = iup.item("Find...", nil)
let miGoTo = iup.item("Go to...", nil)

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

miGoTo.onAction proc(h: auto): auto =
  let txtCtrl = h.getDialogChild("txtCtrl")
  let lineCount = txtCtrl["lineCount"].asInt

  let lbl = iup.label(nil)
  lbl["title"] = ("Line number [1-$#]" % $lineCount)
  let lineTxt = iup.text(nil)
  lineTxt.set({
    "mask": IUP_MASK_UINT,
    "visibleColumns": "20"
  })

  let okBtn = iup.button("OK", nil)
  okBtn["padding"] = "10x2"
  okBtn.onAction proc(h: auto): auto =
    let c = lineTxt["value"]
    if c < 1 or c > lineCount:
      iup.message("Error", "Invalid line number")
      IUP_DEFAULT
    else:
      h.getDialog()["status"] = 1
      IUP_CLOSE

  let cancelBtn = iup.button("Cancel", nil)
  cancelBtn["padding"] = "10x2"
  cancelBtn.onAction proc(h: auto): auto =
    h.getDialog()["status"] = 0
    IUP_CLOSE

  let hbox = iup.hbox(iup.fill(), okBtn, cancelBtn, nil)
  hbox["normalSize"] = "horizontal"
  let vbox = iup.vbox(lbl, lineTxt, hbox, nil)
  vbox.set({
    "margin": "10x10",
    "gap": 5
  })

  let dlg = iup.dialog(vbox)
  dlg.set({
    "title": "Go To Line",
    "dialogFrame": "yes",
    "defaultEnter": okBtn,
    "defaultEsc": cancelBtn,
    "parentDialog": miGoTo.getDialog
  })
  dlg.popup(IUP_CENTERPARENT, IUP_CENTERPARENT)
  defer: dlg.destroy

  if dlg["status"] == 1:
    let c = lineTxt["value"].asInt
    var pos: cint
    txtCtrl.textConvertLinColToPos(c.cint, 0, pos)
    txtCtrl["caretPos"] = pos.int
    txtCtrl["scrollToPos"] = pos.int

  IUP_DEFAULT

miFont.onAction proc(h: auto): auto =
  let dlg = iup.fontDlg()
  dlg["value"] = txt["font"].asStr

  dlg.popup(IUP_CENTER, IUP_CENTER)
  defer: dlg.destroy

  if dlg["status"] != -1:
    txt["font"] = dlg["value"].asStr
  IUP_DEFAULT

miAbout.onAction(h => (iup.message("About", "Vega was here!"); IUP_DEFAULT))

let fileMenu = iup.menu(miOpen,
                        miSaveAs,
                        iup.separator(),
                        miExit,
                        nil)
let fileSubMenu = iup.submenu("File", fileMenu)

let editMenu = iup.menu(miFind, miGoTo, nil)
let editSubMenu = iup.submenu("Edit", editMenu)

let fmtMenu = iup.menu(miFont, nil)
let fmtSubMenu = iup.submenu("Format", fmtMenu)

let helpMenu = iup.menu(miAbout, nil)
let helpSubMenu = iup.submenu("Help", helpMenu)

let menu = iup.menu(fileSubMenu, editSubMenu, fmtSubMenu, helpSubMenu, nil)

let vbox = iup.vbox(txt, nil)
let dlg = iup.dialog(vbox)
dlg["menu"] = menu
dlg.set({
  "title": "Simple Notepad",
  "size": "QUARTERxQUARTER"
})

dlg.showXY(IUP_CENTER, IUP_CENTER)
dlg["userSize"] = nil.cstring

iup.mainLoop()

iup.close()
