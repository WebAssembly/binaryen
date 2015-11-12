
#include <ostream>
#include <wasm.h>

using namespace wasm;

int main() {
  // A module with a function with a division by zero in the body
  Module module;
  Function func;
  func.name = "func";
  Binary div;
  div.op = BinaryOp::DivS;
  Const left;
  left.value = 5;
  Const right;
  right.value = 0;
  div.left = &left;
  div.right = &right;
  div.finalize();
  func.body = &div;
  module.addFunction(&func);

  // Print it out
  std::cout << module;

  // Search it for divisions by zero: Walk the module, looking for
  // that operation.
  struct DivZeroSeeker : public WasmWalker {
    void visitBinary(Binary* curr) {
      // In every Binary, look for integer divisions
      if (curr->op == BinaryOp::DivS || curr->op == BinaryOp::DivU) {
        // Check if the right operand is a constant, and if it is 0
        auto right = curr->right->dyn_cast<Const>();
        if (right && right->value.getInteger() == 0) {
          std::cout << "We found that " << curr->left << " is divided by zero\n";
        }
      }
    }
  };
  DivZeroSeeker seeker;
  seeker.startWalk(&module);
}

