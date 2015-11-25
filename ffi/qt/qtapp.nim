import unittest

type
  QByteArray {.importcpp: "QByteArray", header: "QByteArray".} = object
  QString {.importcpp: "QString", header: "QString".} = object

####################################################################################################
# QByteArray
proc initQByteArray(): QByteArray {.importcpp: "QByteArray(@)", constructor.}
proc initQByteArray(data: cstring, size: cint = -1): QByteArray {.importcpp: "QByteArray(@)", constructor.}
proc constData(this: QByteArray): cstring {.importcpp: "constData".}

####################################################################################################
# QByteArray
proc initQString(): QString {.importcpp: "QString(@)", constructor.}
proc initQString(s: cstring = ""): QString {.importcpp: "QString(@)", constructor.}
proc initQString(ba: QByteArray): QString {.importcpp: "QString(@)", constructor.}
proc toUtf8(this: QString): QByteArray {.importcpp: "toUtf8".}
    
suite "Qt tests":

  test "QString":
    let s = initQString("Hello, world!")
    echo s.toUtf8.constData
    check: $s.toUtf8.constData == "Hello, world!"
