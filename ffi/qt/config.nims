#!/usr/bin/env nim

mode = ScriptMode.Verbose

task build, "Build the app":
  let cflags = staticExec"pkg-config --cflags Qt5Core" & "-fPIC"
  let libs = staticExec"pkg-config --libs Qt5Core"
  switch "passC", cflags
  switch "passL", libs
  setCommand "cpp", "qtapp"
