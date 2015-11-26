####################################################################################################
# RAII test for C++ FFI

{.passC: "-std=c++11".}

{.emit: """

#include <memory>
#include <iostream>

class TestObj;

typedef std::shared_ptr<TestObj> TestObjRef;

class TestObj {
public:
  void sayHello() {
    std::cout << "Hello from cpp" << std::endl;
  }

  static TestObjRef mkRef() {
    return std::make_shared<TestObj>();
  }
};

""".}

type
  TestObj {.importcpp: "TestObj".} = object
  TestObjRef {.importcpp: "TestObjRef".} = ptr TestObj

proc mkRef(): TestObjRef {.importcpp: "TestObj::mkRef".}
proc sayHello(o: TestObj) {.importcpp: "sayHello".}

when isMainModule:
  echo "Hello from nim"
  mkRef()[].sayHello()
