
//
// Tiny example, using Binaryen to walk a WebAssembly module in search
// for direct integer divisions by zero. To do so, we inherit from
// PostWalker, and implement visitBinary, which is called on every
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
  Module module;

  // The parsed code has just one element, the module. Build the module
  // from that (and abort on any errors, but there won't be one here).
  SExpressionWasmBuilder builder(module, *root[0]);

  // Print it out
  WasmPrinter::printModule(&module, std::cout);

  // Search it for divisions by zero: Walk the module, looking for
  // that operation.
  struct DivZeroSeeker : public PostWalker<DivZeroSeeker, Visitor<DivZeroSeeker>> {
    void visitBinary(Binary* curr) {
      // In every Binary, look for integer divisions
      if (curr->op == BinaryOp::DivSInt32 || curr->op == BinaryOp::DivUInt32) {
        // Check if the right operand is a constant, and if it is 0
        auto right = curr->right->dynCast<Const>();
        if (right && right->value.getInteger() == 0) {
          std::cout << "We found that " << curr->left << " is divided by zero\n";
        }
      }
    }
  };
  DivZeroSeeker seeker;
  seeker.walkModule(&module);
}

