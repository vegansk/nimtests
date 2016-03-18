#include <iostream>
#include <thread>
extern "C" {
#include "nimcache/lib.h"
};

int main(int argc, char *argv[]) {
  NimMain();

  std::cout << "Hello from C++!" << std::endl;

  test();

  initLib();

  auto threadFunc = []() {
    sendMsg("C++ sends the message to Nim's actor");
    sendMsg("C++ sends another message to Nim's actor");

    char* s = "abcdef";
    char rs[100];
    doSomeAction(s, rs, 100);

    std::cout << "Reverted \"" << s << "\" is \"" << rs << "\"" << std::endl;
  };

  std::thread thr(threadFunc);
  thr.join();

  deinitLib();
  
  return 0;
}
