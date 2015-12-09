#/bin/sh

cd ../lib && nim sl && cd ../haskell && ghc  -optl-static main.hs ../lib/libtest.a -ldl -threaded -o static
