# This is the sample of the for comprehension syntax

import macros

dumpTree:
  let zs = fc[(x, y) | (x <- xs, y <- ys, y < 3)]
