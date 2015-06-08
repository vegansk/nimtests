when not defined(useLibzipSrc):
  # We want to test internal realization of libzip
  {.fatal: "Tragedy!".}

import libzip

let z = zip_open("test.zip", 0'i32, nil)
if z == nil:
  quit "Can't open test.zip"
block:
  defer: zip_close(z)
  echo "Success"
