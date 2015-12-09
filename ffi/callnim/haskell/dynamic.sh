#/bin/bash

cd ../lib && nim dl && cd ../haskell && ghc main.hs ../lib/libtest.so -ldl -o dynamic
