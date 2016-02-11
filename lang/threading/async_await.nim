import asyncdispatch, future

proc getInt(): Future[int] {.async.} =
  echo "  Getting the result"
  result = 42

proc mainAsync() {.async.} =
  echo "Async version:"
  echo "  ", await getInt()

proc mainSync() =
  echo "Sync version:"
  getInt().callback = (f: Future[int]) => echo("  ", f.read)

asyncCheck mainAsync()
mainSync()
