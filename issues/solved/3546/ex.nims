#!/usr/bin/env nim
mode = ScriptMode.Verbose

try:
  echo "Try block"
  raise newException(Exception, "Test")
except:
  echo "Except block"
  
