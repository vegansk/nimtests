when not defined windows:
  {.fatal: "This example work on Windows only!".}

{.compile: "com.c".}
when defined vcc:
  {.passL: "wbemuuid.lib ole32.lib oleaut32.lib".}
else:
  {.passL: "-lole32 -loleaut32 -luuid -lcomctl32 -lwbemuuid".}

proc getSystemDriveSerial(buff: WideCString, sLen: cint): cint {.importc: "get_system_drive_serial", cdecl.}
proc initCom(): cint {.importc: "init_com", cdecl.}

template ws(x: untyped): WideCString =
  cast[WideCString](x[0].addr)

when isMainModule:
  if initCom() != 0:
    quit "Error initializing com"
  var buff: array[0..100, Utf16Char]
  let res = getSystemDriveSerial(buff.ws, buff.len.cint)
  if res == 0:
    echo "System drive serial is ", buff.ws
  else:
    echo "Error getting drive serial: ", res
