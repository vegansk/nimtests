#/bin/bash

cd ../lib && nim dl && cd ../c && gcc main.c ../lib/libtest.so -ldl -o dynamic
