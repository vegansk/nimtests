proc ii(): tuple[filename: string, line: int] {.compileTime.} =
  instantiationInfo(-1, true)

const i = ii()
const i2 = instantiationInfo()

echo i
echo i2
