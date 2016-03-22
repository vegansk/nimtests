import future

# let x = lc[x | (x <- 0..10), int]
# This wont work
# let x = lc[x | (x <- 0..10), auto]
let x = lc[x | (x <- 0..10), type(x)]

echo x

