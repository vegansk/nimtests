import iup, ../iuputils, future, strutils

when defined(posix):
  {.passL: "-Wl,-rpath=.".}

discard iup.open(nil, nil)

let txtCtrl = iup.text(nil).set({
  "multiLine": "yes",
  "expand": "yes",
  "name": "txtCtrl"
})

let miOpen = iup.item("Open", nil).onAction(proc(h: auto): auto =
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
    txtCtrl["value"] = data

  IUP_DEFAULT
)

let miSaveAs = iup.item("Save as...", nil).onAction(proc(h: auto): auto =
  let dlg = iup.fileDlg()
  dlg.set({
    "dialogType": "save",
    "extFilter": "Text Files|*.txt|All Files|*.*|" 
  })

  dlg.popup(IUP_CENTER, IUP_CENTER)
  defer: dlg.destroy

  if dlg.getInt("STATUS") != -1:
    let fname = dlg["value"]
    let data = txtCtrl["value"]
    fname.writeFile(data)

  IUP_DEFAULT
)

let miExit = iup.item("Exit", nil).onAction(h => IUP_CLOSE)

let miFont = iup.item("Set font...", nil).onAction(proc(h: auto): auto =
  let dlg = iup.fontDlg()
  dlg["value"] = txtCtrl["font"].asStr

  dlg.popup(IUP_CENTER, IUP_CENTER)
  defer: dlg.destroy

  if dlg["status"] != -1:
    txtCtrl["font"] = dlg["value"].asStr
  IUP_DEFAULT
)

let miFind = iup.item("Find...", nil)
let miGoTo = iup.item("Go to...", nil).onAction(proc(h: auto): auto =
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
    "parentDialog": h.getDialog
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
)

let miAbout = iup.item("About...", nil).onAction(h => (iup.message("About", "Vega was here!"); IUP_DEFAULT))

let menu = iup.menu(
  iup.submenu("File", iup.menu(miOpen,
                               miSaveAs,
                               iup.separator(),
                               miExit,
                               nil)),
  iup.submenu("Edit", iup.menu(miFind, miGoTo, nil)),
  iup.submenu("Format", iup.menu(miFont, nil)),
  iup.submenu("Help", iup.menu(miAbout, nil)) ,
  nil
)

let vbox = iup.vbox(txtCtrl, nil)
let dlg = iup.dialog(vbox).set({
  "menu": menu,
  "title": "Simple Notepad",
  "size": "QUARTERxQUARTER"
})
dlg.showXY(IUP_CENTER, IUP_CENTER)
dlg["userSize"] = nil.pointer
iup.mainLoop()

iup.close()
