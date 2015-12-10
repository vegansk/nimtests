cd ..\lib && nim sl && cd ..\c && gcc -static main.c ..\lib\test.lib -o static
