const CC = "g++"

template dep*(task: untyped): stmt =
  exec "nim " & astToStr(task)

task build_lib, "Build the lib":
  --app:staticlib
  --noMain
  --header
  --threads:on
  --tlsEmulation:off

  setCommand "c", "lib.nim"

task build, "Build the app":
  dep build_lib
  if not dirExists("bin"):
    mkdir "bin"
  let addParams = when defined(windows): "lib.lib -pthread" else: "liblib.a -pthread -ldl"
  exec CC & " -Wno-write-strings -o bin/test -I. main.cpp " & addParams
  setCommand "nop"

task run, "Run the app":
  dep build
  exec "bin/test"
