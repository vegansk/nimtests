import parseopt2, os, strutils

let cmdLine = """nim c -d:release --noBabelPath --path:"C:\Documents and Settings\vega.ELDISSOFT\.nimble\pkgs\nimshell-0.0.1" --path:"C:\Documents and Settings\vega.ELDISSOFT\.nimble\pkgs\monad-0.1""""

echo repr(parseCmdLine(cmdLine))

var p = initOptParser(parseCmdLine(cmdLine))
p.next
while p.kind != cmdEnd:
  p.next
  echo repr(p.kind) & ": " & p.key & " = " & p.val
