import os, threadpool

proc main =

  proc test() =
    echo "test"

  var t1, t2: Thread[void]

  createThread(t1, test)
  joinThread(t1)
  createThread(t2, test)
  joinThread(t2)

  # joinThreads(t1, t2)

  # spawn test()
  # spawn test()

  # sync()

main()
