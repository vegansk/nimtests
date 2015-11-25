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
# QString
proc initQString(): QString {.importcpp: "QString(@)", constructor.}
proc initQString(s: cstring = ""): QString {.importcpp: "QString(@)", constructor.}
proc initQString(ba: QByteArray): QString {.importcpp: "QString(@)", constructor.}
proc toUtf8(this: QString): QByteArray {.importcpp: "toUtf8".}
proc fromUtf8(s: cstring): QString {.importcpp: "QString::fromUtf8(@)".}
proc `$`(s: QString): string = $s.toUtf8.constData

suite "Qt tests":

  test "QString":
    let s = "Hello, world!".initQString
    echo s
    check: $s == "Hello, world!"
