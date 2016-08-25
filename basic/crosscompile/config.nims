#!/usr/bin/env nim

mode = ScriptMode.Verbose

task build, "Build windows executable":
  --cpu: i386
  --os: windows
  setCommand "c", "hw_win"
