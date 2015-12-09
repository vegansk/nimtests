#/bin/sh

cd ../lib && nim dl && cd ../c && gcc -static main.c ../lib/libtest.a -ldl -o static
