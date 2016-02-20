#include <iostream>
extern "C" {
#include "nimcache/lib.h"
};

int main(int argc, char *argv[]) {
  NimMain();

  std::cout << "Hello, world!" << std::endl;

  test();
  
  return 0;
}
