import macros

dumpTree:
  proc head*[T](xs: List[T]): T =
    ## Returns list's head
    assert xs.kind == lnkCons
    xs.value
