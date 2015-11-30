const CFLAGS = staticExec"pkg-config --cflags Qt5Core" & "-fPIE"
const LIBS   = staticExec"pkg-config --libs Qt5Core"

{.passC: CFLAGS.}
{.passL: LIBS.}

type
  QStringList {.importcpp: "QStringList", header: "QStringList".} = object

proc initQStringList(): QStringList {.importcpp: "QStringList(@)", constructor, header: "QStringList".}
proc len(o: QStringList): cint {.importcpp: "#.length(@)", header: "QStringList".}

let x = initQStringList()
assert x.len == 0
