// test multiple uses of the threadPool

#include <cassert>
#include <iostream>
#include <thread>
#include <vector>

#include <binaryen-c.h>

int NUM_THREADS = 33;

void worker() {
  BinaryenModuleRef module = BinaryenModuleCreate();

  // Create a function type for  i32 (i32, i32)
  BinaryenType ii_[2] = {BinaryenTypeInt32(), BinaryenTypeInt32()};
  BinaryenType ii = BinaryenTypeCreate(ii_, 2);

  // Get the 0 and 1 arguments, and add them
  BinaryenExpressionRef x = BinaryenLocalGet(module, 0, BinaryenTypeInt32()),
                        y = BinaryenLocalGet(module, 1, BinaryenTypeInt32());
  BinaryenExpressionRef add = BinaryenBinary(module, BinaryenAddInt32(), x, y);
  BinaryenExpressionRef ret = BinaryenReturn(module, add);

  // Create the add function
  // Note: no additional local variables
  // Note: no basic blocks here, we are an AST. The function body is just an expression node.
  BinaryenFunctionRef adder =
    BinaryenAddFunction(module, "adder", ii, BinaryenTypeInt32(), NULL, 0, ret);

  // validate it
  assert(BinaryenModuleValidate(module));

  // optimize it
  BinaryenModuleOptimize(module);
  assert(BinaryenModuleValidate(module));

  // Clean up the module, which owns all the objects we created above
  BinaryenModuleDispose(module);
}

int main() {
  std::vector<std::thread> threads;

  std::cout << "create threads...\n";
  for (int i = 0; i < NUM_THREADS; i++) {
    threads.emplace_back(worker);
  }
  std::cout << "threads running in parallel...\n";

  std::cout << "waiting for threads to join...\n";
  for (auto& thread : threads) {
    thread.join();
  }

  std::cout << "all done.\n";

  return 0;
}
