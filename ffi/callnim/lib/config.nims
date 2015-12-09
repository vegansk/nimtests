#!/usr/bin/env nim

mode = ScriptMode.Verbose

task sl, "Build static library":
  echo "Building static version"
  --app:staticlib
  --noMain
  setCommand "c", "test"

task dl, "Build dynamic library":
  echo "Building dynamic version"
  --app:lib
  --noMain
  setCommand "c", "test"
