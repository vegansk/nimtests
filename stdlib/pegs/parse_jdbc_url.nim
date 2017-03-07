import pegs, sequtils

template massert(a, b, body: untyped): untyped =
  if a =~ b:
    `body`
  else:
    assert false, a & " doesn't match the grammar"

proc test =
  let parser = peg"""
url <- ^ prefix ':' dbdesc $
dbdesc <- '//' {\ident} (':' {\d+})? '/' {\ident} / {\ident}
prefix <- 'jdbc:' dbtype
dbtype <- 'postgresql'
"""

  massert "jdbc:postgresql:testdb", parser:
    echo @matches.filterIt(not it.isNil)
  massert "jdbc:postgresql://server/testdb", parser:
    echo @matches.filterIt(not it.isNil)
  massert "jdbc:postgresql://server:5432/testdb", parser:
    echo @matches.filterIt(not it.isNil)
  assert: not("badurl" =~ parser)

when isMainModule:
  test()
