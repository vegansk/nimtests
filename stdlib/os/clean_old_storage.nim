import os, logging, encodings, xmltree, xmlparser, strtabs

proc tr(s: string): string =
  when defined(windows):
    s.convert("CP866", "UTF-8")
  else:
    s

proc fatal(s: string) =
  logging.fatal(s)
  quit(QuitFailure)

when isMainModule:
  try:
    logging.addHandler(newConsoleLogger())
    logging.addHandler(newFileLogger("clean_old_storage.log", fmtStr = verboseFmtStr))
    if paramCount() < 1:
      fatal(tr"Ошибка: отсутствуют параметры. Укажите путь к portal-config.xml")

    let apply = paramCount() > 1 and paramStr(2) == "--apply"

    let conf = paramStr(1).loadXml
    for server in conf.findAll("server"):
      let path = server.attrs["webdavServerPath"]
      logging.info(tr("Путь к хранилищу: " & path))
      break
  except:
    fatal(tr(getCurrentExceptionMsg()))
