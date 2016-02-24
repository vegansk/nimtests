#include <iostream>
extern "C" {
#include "nimcache/lib.h"
};

int main(int argc, char *argv[]) {
  NimMain();

  std::cout << "Hello from C++!" << std::endl;

  test();

  initLib();

  sendMsg("C++ sends the message to Nim's actor");
  sendMsg("C++ sends another message to Nim's actor");

  deinitLib();
  
  return 0;
}