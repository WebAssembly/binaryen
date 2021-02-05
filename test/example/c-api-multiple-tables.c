#include <assert.h>
#include <string.h>
#include <binaryen-c.h>

// "hello world" type example: create a function that adds two i32s and returns
// the result

int main() {
  BinaryenModuleRef module = BinaryenModuleCreate();
  BinaryenModuleSetFeatures(module, BinaryenFeatureReferenceTypes());

  // Create a function type for  i32 (i32, i32)
  BinaryenType ii[2] = {BinaryenTypeInt32(), BinaryenTypeInt32()};
  BinaryenType params = BinaryenTypeCreate(ii, 2);
  BinaryenType results = BinaryenTypeInt32();

  assert(BinaryenGetNumTables(module) == 0);

  {
    // Get the 0 and 1 arguments, and add them
    BinaryenExpressionRef x = BinaryenLocalGet(module, 0, BinaryenTypeInt32()),
                          y = BinaryenLocalGet(module, 1, BinaryenTypeInt32());
    BinaryenExpressionRef add =
      BinaryenBinary(module, BinaryenAddInt32(), x, y);

    // Create the add function
    // Note: no additional local variables
    // Note: no basic blocks here, we are an AST. The function body is just an
    // expression node.
    BinaryenFunctionRef adder =
      BinaryenAddFunction(module, "adder", params, results, NULL, 0, add);

    const char* funcNames[] = {"adder"};
    BinaryenAddTable(module,
                     "tab",
                     1,
                     1,
                     funcNames,
                     1,
                     BinaryenConst(module, BinaryenLiteralInt32(0)));
    assert(BinaryenGetTable(module, "tab") != NULL);

    BinaryenAddTable(module,
                     "t2",
                     1,
                     1,
                     funcNames,
                     1,
                     BinaryenConst(module, BinaryenLiteralInt32(0)));
    BinaryenTableRef t2 = BinaryenGetTableByIndex(module, 1);
    assert(t2 != NULL);

    assert(strcmp(BinaryenTableGetName(t2), "t2") == 0);
    assert(BinaryenTableGetInitial(t2) == 1);
    assert(BinaryenTableHasMax(t2) == 1);
    assert(BinaryenTableGetMax(t2) == 1);
    assert(strcmp(BinaryenTableImportGetModule(t2), "") == 0);
    assert(strcmp(BinaryenTableImportGetBase(t2), "") == 0);

    assert(BinaryenGetNumTables(module) == 2);
  }

  {
    // Get the 0 and 1 arguments, and add them
    BinaryenExpressionRef operands[] = {
      BinaryenLocalGet(module, 0, BinaryenTypeInt32()),
      BinaryenLocalGet(module, 1, BinaryenTypeInt32())};

    BinaryenExpressionRef add_indirect =
      BinaryenCallIndirect(module,
                           "tab",
                           BinaryenConst(module, BinaryenLiteralInt32(0)),
                           operands,
                           2,
                           params,
                           results);
    BinaryenCallIndirectSetTable(add_indirect, "t2");

    BinaryenFunctionRef call_adder_indirectly = BinaryenAddFunction(
      module, "call_adder_indirect", params, results, NULL, 0, add_indirect);
  }

  // Print it out
  BinaryenModulePrint(module);

  // Clean up the module, which owns all the objects we created above
  BinaryenModuleDispose(module);

  return 0;
}
