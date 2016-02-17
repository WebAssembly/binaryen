
//
// Tiny example, using Binaryen to walk a WebAssembly module in search
// for direct integer divisions by zero. To do so, we inherit from
// WasmWalker, and implement visitBinary, which is called on every
// Binary node in the module's functions.
//

#include <ostream>
#include <wasm.h>
#include <wasm-printing.h>
#include <wasm-s-parser.h>

using namespace wasm;

int main() {
  // A simple WebAssembly module in S-Expression format.
  char input[] =
    "(module"
    "  (func $has_div_zero"
    "    (i32.div_s"
    "      (i32.const 5)"
    "      (i32.const 0)"
    "    )"
    "  )"
    ")";

  // Parse the S-Expression text, and prepare to build a WebAssembly module.
  SExpressionParser parser(input);
  Element& root = *parser.root;
  AllocatingModule module;

  // The parsed code has just one element, the module. Build the module
  // from that (and abort on any errors, but there won't be one here).
  SExpressionWasmBuilder builder(module, *root[0], [&]() { abort(); });

  // Print it out
  printWasm(&module, std::cout);

  // Search it for divisions by zero: Walk the module, looking for
  // that operation.
  struct DivZeroSeeker : public WasmWalker<DivZeroSeeker> {
    void visitBinary(Binary* curr) {
      // In every Binary, look for integer divisions
      if (curr->op == BinaryOp::DivS || curr->op == BinaryOp::DivU) {
        // Check if the right operand is a constant, and if it is 0
        auto right = curr->right->dyn_cast<Const>();
        if (right && right->value.getInteger() == 0) {
          std::cout << "We found that ";
          printWasm(curr->left, std::cout) << " is divided by zero\n";
        }
      }
    }
  };
  DivZeroSeeker seeker;
  seeker.startWalk(&module);
}

