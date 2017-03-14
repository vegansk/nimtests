import macros, future

proc tryS(f: () -> void): void =
  (try: f() except: discard)

template trySTImpl(body: untyped): untyped =
  tryS do() -> auto:
    `body`

macro tryST*(body: untyped): untyped =
  var b = if body.kind == nnkDo: body[^1] else: body
  result = quote do:
    trySTImpl((block:
      `b`
    ))

iterator testIt(): int {.closure.} =
  for x in 0..10:
    yield x

proc test = tryST do:
  for x in testIt():
    echo x

test()
