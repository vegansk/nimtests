#? braces

const useObj = true

when useObj {
  type X = object {
    a: int
  }
} else {
  type X = string
}

proc test: X {
  when useObj {
    result.a = 1
  } else {
    result = "test"
  }
}

macro testM: X {
  test()
}

const x = testM()
echo x
