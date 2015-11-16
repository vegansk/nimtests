import db_postgres, marshal, logging

when isMainModule:
  logging.addHandler(newConsoleLogger(lvlAll, verboseFmtStr))
  let conn = open("", "portal", "Porta1", "host=localhost dbname=portal")
  info "Connected to postgresql"

  # for row in conn.fastRows(sql"select * from portal_user"):
  #   info "ROW: ", $row

  for x in 0..100000:
    discard conn.getValue(sql"select login from portal_user where user_id=7")

  defer:
    info "Closing the connection"
    conn.close

  
