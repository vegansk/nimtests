#/bin/sh

cd ../lib && nim dl && cd ../haskell && ghc  -optl-static main.hs ../lib/libtest.a -ldl -threaded -o static
