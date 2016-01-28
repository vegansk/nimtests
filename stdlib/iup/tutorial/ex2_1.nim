import iup

{.passL: "-Wl,-rpath=.".}

discard iup.open(nil, nil)
iup.message("Hello, world 1", "Hello from IUP")
iup.close()
