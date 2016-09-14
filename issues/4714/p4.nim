import parseutils

var x: int64
discard parseBiggestInt($int64.high, x)
echo x
