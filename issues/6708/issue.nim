import asyncdispatch
type
  TheSyncType = distinct int
  TheAsyncType = distinct int

proc testImpl(i: TheSyncType) = discard
proc testImpl(i: TheAsyncType): Future[void] {.async.} = discard

proc test*(i: TheAsyncType|TheSyncType, j: int): Future[bool] {.multisync.} =
  await testImpl(i)
  result = i.int == j

echo test(1.TheSyncType, 1)
echo waitFor test(1.TheAsyncType, 2)
