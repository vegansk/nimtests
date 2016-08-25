import fp.either

# This doesn't work
# proc test(good: bool): EitherS[void] =
#   if good:
#     ().rightS
#   else:
#     "Bad value".left(void)

proc test(good: bool): EitherS[tuple[]] =
  if good:
    ().rightS
  else:
    "Bad value".left(())

when isMainModule:
  echo test(true)
  echo test(false)
