import ../iuputils, future, strutils
from iup import nil

when defined(posix):
  {.passL: "-Wl,-rpath=.".}

discard iup.open(nil, nil)

let txtCtrl = iup.text(nil).set({
  "multiLine": true,
  "expand": "yes"
}).set({
  "name": "txtCtrl"
})

let miOpen = menuItem("Open").onAction(proc(h: auto): auto =
  let dlg = iup.fileDlg()
  dlg.set({
    "dialogType": "open",
    "extFilter": "Text Files|*.txt|All Files|*.*|" 
  })

  dlg.popupLocal(IUP_CENTER, IUP_CENTER)

  if dlg.status != -1:
    txtCtrl.value = dlg.value.readFile

  IUP_DEFAULT
)

let miSaveAs = menuItem("Save as...").onAction(proc(h: auto): auto =
  let dlg = iup.fileDlg()
  dlg.set({
    "dialogType": "save",
    "extFilter": "Text Files|*.txt|All Files|*.*|" 
  })

  dlg.popupLocal(IUP_CENTER, IUP_CENTER)

  if dlg.status != -1:
    dlg.value.writeFile(txtCtrl.value)

  IUP_DEFAULT
)

let miExit = menuItem("Exit").onAction(h => IUP_CLOSE)

let miFont = menuItem("Set font...").onAction(proc(h: auto): auto =
  let dlg = iup.fontDlg()
  dlg.value = txtCtrl.font

  dlg.popupLocal(IUP_CENTER, IUP_CENTER)

  if dlg.status != -1:
    txtCtrl.font = dlg.value

  IUP_DEFAULT
)

let miFind = menuItem("Find...")
let miGoTo = menuItem("Go to...").onAction(proc(h: auto): auto =
  let lineCount = txtCtrl["lineCount"].to(int)

  let lbl = iup.label(nil).set({"title": "Line number [1-$#]" % $lineCount})
  let lineTxt = iup.text(nil).set({
    "mask": IUP_MASK_UINT,
    "visibleColumns": 20
  })

  let okBtn = iup.button("OK", nil).setPadding("10x2").onAction(proc(h: auto): auto =
    let c = lineTxt.value
    if c < 1 or c > lineCount:
      iup.message("Error", "Invalid line number")
      IUP_DEFAULT
    else:
      h.getDialog.status = 1
      IUP_CLOSE
  )

  let cancelBtn = button("Cancel").setPadding("10x2").onAction((h) => (h.getDialog.status = 0; IUP_CLOSE))

  let hbox = hbox(iup.fill(), okBtn, cancelBtn)
  hbox["normalSize"] = "horizontal"
  let vbox = vbox(lbl, lineTxt, hbox)
  vbox.set({
    "margin": "10x10",
    "gap": 5
  })

  let dlg = iup.dialog(vbox)
  dlg.set({
    "title": "Go To Line",
    "dialogFrame": true,
    "defaultEnter": okBtn,
    "defaultEsc": cancelBtn,
    "parentDialog": h.getDialog
  })
  dlg.popupLocal(IUP_CENTERPARENT, IUP_CENTERPARENT)

  if dlg["status"] == 1:
    let c = lineTxt["value"].asInt
    var pos: cint
    txtCtrl.textConvertLinColToPos(c.cint, 0, pos)
    txtCtrl["caretPos"] = pos.int
    txtCtrl["scrollToPos"] = pos.int

  IUP_DEFAULT
)

let miAbout = menuItem("About...").onAction(h => (iup.message("About", "Vega was here!"); IUP_DEFAULT))

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

let vbox = vbox(txtCtrl)
let dlg = iup.dialog(vbox).set({
  "menu": menu,
  "title": "Simple Notepad",
  "size": "QUARTERxQUARTER"
})
dlg.showXY(IUP_CENTER, IUP_CENTER)
dlg["userSize"] = nil.pointer
iup.mainLoop()

iup.close()
