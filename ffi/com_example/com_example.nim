when not defined windows:
  {.fatal: "This example work on Windows only!".}

{.compile: "com.c".}
when defined vcc:
  {.passL: "wbemuuid.lib ole32.lib oleaut32.lib".}
else:
  {.passL: "-lole32 -loleaut32 -luuid -lcomctl32 -lwbemuuid".}

proc getSystemDriveSerial(buff: WideCString, sLen: cint): cint {.importc: "get_system_drive_serial", cdecl.}
proc initCom(): cint {.importc: "init_com", cdecl.}

when isMainModule:
  if initCom() != 0:
    quit "Error initializing com"
  var buff: array[0..100, Utf16Char]
  let res = getSystemDriveSerial(cast[WideCString](buff[0].addr), buff.len.cint)
  if res == 0:
    echo "System drive serial is ", cast[WideCString](buff[0].addr)
  else:
    echo "Error getting drive serial: ", res
