import jester, asyncdispatch

settings:
  port = Port(5001)

routes:
  post "/":
    writeFile("/tmp/payload", request.formData.getOrDefault("file").body)
    resp "OK"

runForever()
