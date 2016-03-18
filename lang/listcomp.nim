import future

let x = lc[x | (x <- 0..10), int]
# This wont work
# let x = lc[x | (x <- 0..10), auto]

echo x

