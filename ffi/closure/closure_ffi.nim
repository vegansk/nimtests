import future

{.emit: """

typedef int (*CB)(int curr, void* pEnv);

void test(int from, int to, CB cb, void* pEnv) {
  int c;
  for(c = from; c < to; c++) {
    if(((CB)cb)(c, pEnv))
      break;
  }
}

""".}

proc test(`from`, to: cint, cb: pointer, env: pointer) {.importc: "test", nodecl.}

when isMainModule:
  var s = ""
  let p = proc (i: cint): cint {.closure.} = (if s == "": s = $i else: s &= ", " & $i; 0)

  test 0, 10, p.rawProc, p.rawEnv
  echo s
  
