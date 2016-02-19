import il

try:
  ilInit()
  let image = ilGenImage()
  ilBindImage(image)
finally:
  discard
  
