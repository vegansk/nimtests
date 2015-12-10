#!/usr/bin/env nim

mode = ScriptMode.Verbose

task vc, "Build using vc compiler":
  --cc:vcc
  --define:vcc
  setCommand "c", "com_example"

task gcc, "Build using gcc compiler":
  --cc:gcc
  setCommand "c", "com_example"
