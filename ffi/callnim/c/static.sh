#/bin/sh

cd ../lib && nim sl && cd ../c && gcc -static main.c ../lib/libtest.a -ldl -o static
