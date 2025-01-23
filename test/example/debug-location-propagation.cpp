#include <cassert>
#include <iostream>

#include <binaryen-c.h>
#include <wasm.h>

int main() {
  BinaryenModuleRef module = BinaryenModuleCreate();

  BinaryenType ii[2] = {BinaryenTypeInt32(), BinaryenTypeInt32()};
  BinaryenType params = BinaryenTypeCreate(ii, 2);
  BinaryenType results = BinaryenTypeNone();

  BinaryenExpressionRef x = BinaryenLocalGet(module, 0, BinaryenTypeInt32()),
                        y = BinaryenLocalGet(module, 1, BinaryenTypeInt32());
  BinaryenExpressionRef add = BinaryenBinary(module, BinaryenAddInt32(), x, y);
  BinaryenExpressionRef drop = BinaryenDrop(module, add);
  BinaryenExpressionRef funcBody =
    BinaryenBlock(module, "", &drop, 1, BinaryenTypeNone());

  BinaryenFunctionRef adder =
    BinaryenAddFunction(module, "adder", params, results, NULL, 0, funcBody);

  BinaryenModuleAddDebugInfoFileName(module, "main");

  BinaryenFunctionSetDebugLocation(adder, x, 0, 2, 13);
  BinaryenFunctionSetDebugLocation(adder, drop, 0, 2, 2);

  BinaryenModuleValidate(module);
  BinaryenSetDebugInfo(true);
  const char* runPasses[] = {"propagate-debug-locs"};
  BinaryenModuleRunPasses(module, runPasses, 1);

  auto& debugLocations = module->getFunction("adder")->debugLocations;
  assert(debugLocations.size() == 4);
  assert(debugLocations[x]->columnNumber == 13);
  assert(debugLocations[y]->columnNumber == 13);
  assert(debugLocations[add]->columnNumber == 2);
  assert(debugLocations[drop]->columnNumber == 2);

  BinaryenSetDebugInfo(false);
  BinaryenModuleDispose(module);

  std::cout << "success." << std::endl;

  return 0;
}
