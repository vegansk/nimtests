#include <stdio.h>

extern char* test_func(char* say);
extern void NimMain(void);

int main(int argc, char* argv[]) {

  NimMain();

  char* from_nim = test_func("Hello from C!");

  printf("Nim says: %s\n", from_nim);

  return 0;
}
