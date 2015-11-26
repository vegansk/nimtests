####################################################################################################
# RAII test for C++ FFI

{.passC: "-std=c++11".}

{.emit: """

#include <memory>
#include <iostream>

class TestObj;

typedef std::shared_ptr<TestObj> TestObjRef;

class TestObj {
private: 
  TestObj(const TestObj&) = delete;
  TestObj() {}
public:
  void sayHello() {
    std::cout << "Hello from cpp" << std::endl;
  }

  static TestObjRef mkRef() {
    return std::shared_ptr<TestObj>(new TestObj);
  }
};

""".}

type
  TestObj {.importcpp: "TestObj".} = object
  TestObjRef {.importcpp: "TestObjRef".} = object

proc mkRef(): TestObjRef {.importcpp: "TestObj::mkRef".}
proc sayHello(o: TestObj) {.importcpp: "sayHello".}

proc get(o: TestObjRef): ptr TestObj =
  {.emit: """
    return `o`.get();
  """.}

{.experimental.}

when isMainModule:
  echo "Hello from nim"
  mkRef().get.sayHello()
