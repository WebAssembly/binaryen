#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"
#include <limits>

// By default LLVM emits nontrapping float-to-int instructions to implement its
// fptoui/fptosi conversion instructions. This pass replaces these instructions
// with code sequences which also implement LLVM's fptoui/fptosi, but which are
// not semantically equivalent in wasm. This is because out-of-range inputs to
// these instructions produce poison values. So we need only ensure that there
// is no trap, but need not ensure any particular result.

namespace wasm {
struct LLVMNonTrappingFPToIntLowering
  : public WalkerPass<PostWalker<LLVMNonTrappingFPToIntLowering>> {
  void visitUnary(Unary* curr) {
    switch (curr->op) {
      case TruncSatSFloat32ToInt32: {
        Builder builder(*getModule());
        replaceCurrent(builder.makeIf(
          builder.makeBinary(
            BinaryOp::LtFloat32,
            builder.makeUnary(UnaryOp::AbsFloat32, curr->value),
            builder.makeConst(
              static_cast<float>(std::numeric_limits<int32_t>::max()))),
          builder.makeUnary(UnaryOp::TruncSFloat32ToInt32, curr->value),
          builder.makeConst(std::numeric_limits<int32_t>::min())));
      } break;
      case TruncSatUFloat32ToInt32: {
        Builder builder(*getModule());
        replaceCurrent(builder.makeIf(
          builder.makeBinary(
            BinaryOp::AndInt32,
            builder.makeBinary(BinaryOp::LtFloat32,
                               curr->value,
                               builder.makeConst(static_cast<float>(
                                 std::numeric_limits<uint32_t>::max()))),
            builder.makeBinary(
              BinaryOp::GeFloat32, curr->value, builder.makeConst(0.0f))),
          builder.makeUnary(UnaryOp::TruncUFloat32ToInt32, curr->value),
          builder.makeConst(0)));
      } break;
      default: {
      }
    }
  }
  void run(Module* module) override {
    if (!module->features.hasTruncSat()) {
      return;
    }
    super::run(module);
    module->features.disable(FeatureSet::TruncSat);
  }
};

Pass* createLLVMNonTrappingFPToIntLoweringPass() {
  return new LLVMNonTrappingFPToIntLowering();
}

} // namespace wasm