
#include <binaryen-c.h>

// "hello world" type example: create a function that adds two i32s and returns the result

int main() {
  BinaryenModuleRef module = BinaryenModuleCreate();

  // Create a function type for  i32 (i32, i32)
  BinaryenType params[2] = { BinaryenInt32(), BinaryenInt32() };
  BinaryenFunctionTypeRef iii = BinaryenAddFunctionType(module, "iii", BinaryenInt32(), params, 2);

  // Get the 0 and 1 arguments, and add them
  BinaryenExpressionRef x = BinaryenGetLocal(module, 0, BinaryenInt32()),
                        y = BinaryenGetLocal(module, 1, BinaryenInt32());
  BinaryenExpressionRef add = BinaryenBinary(module, BinaryenAddInt32(), x, y);

  // Create the add function
  // Note: no additional local variables
  // Note: no basic blocks here, we are an AST. The function body is just an expression node.
  BinaryenFunctionRef adder = BinaryenAddFunction(module, "adder", iii, NULL, 0, add);

  // Print it out
  BinaryenModulePrint(module);

  // Clean up the module, which owns all the objects we created above
  BinaryenModuleDispose(module);

  return 0;
}

