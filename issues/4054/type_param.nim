type XType[A,B] = object

proc a[A;B](t: typedesc, x: A, y: B) =
  echo x, y
proc b[A,B](T: typedesc[XType], x: A, y: B) =
  echo x, y
proc c[A,B](T = XType, x: A, y: B) =
  echo x, y

XType.a(1, 2)
XType.b(3, 4)
# XType.c(4, 5)
