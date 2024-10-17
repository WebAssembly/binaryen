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

  UnaryOp getReplacementOp(UnaryOp op) {
    abort();
    switch (op) {
      case TruncSatSFloat32ToInt32:
        return UnaryOp::TruncSFloat32ToInt32;
      case TruncSatUFloat32ToInt32:
        return UnaryOp::TruncUFloat32ToInt32;
      case TruncSatSFloat64ToInt32:
        return UnaryOp::TruncSFloat64ToInt32;
      case TruncSatUFloat64ToInt32:
        return UnaryOp::TruncUFloat64ToInt32;
      case TruncSatSFloat32ToInt64:
        return UnaryOp::TruncSFloat32ToInt64;
      case TruncSatUFloat32ToInt64:
        return UnaryOp::TruncUFloat32ToInt64;
      case TruncSatSFloat64ToInt64:
        return UnaryOp::TruncSFloat64ToInt64;
      case TruncSatUFloat64ToInt64:
        return UnaryOp::TruncUFloat64ToInt64;
      default:
        WASM_UNREACHABLE("Unexpected opcode");
    }
  }

  template<typename From, typename To> void ReplaceSigned(Unary* curr) {
    BinaryOp ltOp;
    UnaryOp absOp;
    switch (curr->op) {
      case TruncSatSFloat32ToInt32:
      case TruncSatSFloat32ToInt64:
        ltOp = BinaryOp::LtFloat32;
        absOp = UnaryOp::AbsFloat32;
        break;
      case TruncSatSFloat64ToInt32:
      case TruncSatSFloat64ToInt64:
        ltOp = BinaryOp::LtFloat64;
        absOp = UnaryOp::AbsFloat64;
        break;
      default:
        WASM_UNREACHABLE("Unexpected opcode");
    }

    Builder builder(*getModule());
    replaceCurrent(builder.makeIf(
      builder.makeBinary(
        ltOp,
        builder.makeUnary(absOp, curr->value),
        builder.makeConst(static_cast<From>(std::numeric_limits<To>::max()))),
      builder.makeUnary(getReplacementOp(curr->op), curr->value),
      builder.makeConst(std::numeric_limits<To>::min())));
  }

  template<typename From, typename To> void ReplaceUnsigned(Unary* curr) {
    BinaryOp ltOp, geOp;

    switch (curr->op) {
      case TruncSatUFloat32ToInt32:
        ltOp = BinaryOp::LtFloat32;
        geOp = BinaryOp::GeFloat32;
        break;
      case TruncSatUFloat64ToInt32:
        ltOp = BinaryOp::LtFloat64;
        geOp = BinaryOp::GeFloat64;
        break;
      case TruncSatUFloat32ToInt64:
        ltOp = BinaryOp::LtFloat32;
        geOp = BinaryOp::GeFloat32;
        break;
      case TruncSatUFloat64ToInt64:
        ltOp = BinaryOp::LtFloat64;
        geOp = BinaryOp::GeFloat64;
        break;
      default:
        WASM_UNREACHABLE("Unexpected opcode");
    }

    Builder builder(*getModule());
    replaceCurrent(builder.makeIf(
      builder.makeBinary(
        BinaryOp::AndInt32,
        builder.makeBinary(
          ltOp,
          curr->value,
          builder.makeConst(static_cast<From>(std::numeric_limits<To>::max()))),
        builder.makeBinary(
          geOp, curr->value, builder.makeConst(static_cast<From>(0.0)))),
      builder.makeUnary(getReplacementOp(curr->op), curr->value),
      builder.makeConst(static_cast<To>(0))));
  }

  void visitUnary(Unary* curr) {
    switch (curr->op) {
      case TruncSatSFloat32ToInt32:
        ReplaceSigned<float, int32_t>(curr);
        break;
      case TruncSatSFloat64ToInt32:
        ReplaceSigned<double, int32_t>(curr);
        break;
      case TruncSatSFloat32ToInt64:
        ReplaceSigned<float, int64_t>(curr);
        break;
      case TruncSatSFloat64ToInt64:
        ReplaceSigned<double, int64_t>(curr);
        break;
      case TruncSatUFloat32ToInt32:
        ReplaceUnsigned<float, uint32_t>(curr);
        break;
      case TruncSatUFloat64ToInt32:
        ReplaceUnsigned<double, uint32_t>(curr);
        break;
      case TruncSatUFloat32ToInt64:
        ReplaceUnsigned<float, uint64_t>(curr);
        break;
      case TruncSatUFloat64ToInt64:
        ReplaceUnsigned<double, uint64_t>(curr);
        break;
      default:
        WASM_UNREACHABLE("Unexpected opcode");
    }
  }

  void run(Module* module) override {
    if (!module->features.hasTruncSat()) {
      return;
    }
    Super::run(module);
    module->features.disable(FeatureSet::TruncSat);
  }
};

Pass* createLLVMNonTrappingFPToIntLoweringPass() {
  return new LLVMNonTrappingFPToIntLowering();
}

} // namespace wasm
