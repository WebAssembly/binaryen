#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"
#include <limits>
#include <memory>

// By default LLVM emits nontrapping float-to-int instructions to implement its
// fptoui/fptosi conversion instructions. This pass replaces these instructions
// with code sequences which also implement LLVM's fptoui/fptosi, but which are
// not semantically equivalent in wasm. This is because out-of-range inputs to
// these instructions produce poison values. So we need only ensure that there
// is no trap, but need not ensure any particular result. The transformation
// in this pass is the same as the one used by LLVM to lower fptoui/fptosi
// to wasm trapping instructions.

// For example, if a conversion is guarded by a range check in the source, LLVM
// can move the conversion before the check (and instead guard the use of the
// result, which may be poison). This is valid in LLVM and for the nontrapping
// wasm fptoint instructions but not for the trapping conversions. The
// transformation in this pass is valid only if the nontrapping conversions
// in the wasm were generated from LLVM and implement LLVM's conversion
// semantics.

namespace wasm {
struct LLVMNonTrappingFPToIntLoweringImpl
  : public WalkerPass<PostWalker<LLVMNonTrappingFPToIntLoweringImpl>> {
  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<LLVMNonTrappingFPToIntLoweringImpl>();
  }

  UnaryOp getReplacementOp(UnaryOp op) {
    switch (op) {
      case TruncSatSFloat32ToInt32:
        return TruncSFloat32ToInt32;
      case TruncSatUFloat32ToInt32:
        return TruncUFloat32ToInt32;
      case TruncSatSFloat64ToInt32:
        return TruncSFloat64ToInt32;
      case TruncSatUFloat64ToInt32:
        return TruncUFloat64ToInt32;
      case TruncSatSFloat32ToInt64:
        return TruncSFloat32ToInt64;
      case TruncSatUFloat32ToInt64:
        return TruncUFloat32ToInt64;
      case TruncSatSFloat64ToInt64:
        return TruncSFloat64ToInt64;
      case TruncSatUFloat64ToInt64:
        return TruncUFloat64ToInt64;
      default:
        WASM_UNREACHABLE("Unexpected opcode");
    }
  }

  template<typename From, typename To> void replaceSigned(Unary* curr) {
    BinaryOp ltOp;
    UnaryOp absOp;
    switch (curr->op) {
      case TruncSatSFloat32ToInt32:
      case TruncSatSFloat32ToInt64:
        ltOp = LtFloat32;
        absOp = AbsFloat32;
        break;
      case TruncSatSFloat64ToInt32:
      case TruncSatSFloat64ToInt64:
        ltOp = LtFloat64;
        absOp = AbsFloat64;
        break;
      default:
        WASM_UNREACHABLE("Unexpected opcode");
    }

    Builder builder(*getModule());
    Index v = Builder::addVar(getFunction(), curr->value->type);
    // if fabs(operand) < INT_MAX then use the trapping operation, else return
    // INT_MIN. The altnernate value is correct for the case where the input is
    // INT_MIN itself; otherwise it's UB so any value will do.
    replaceCurrent(builder.makeIf(
      builder.makeBinary(
        ltOp,
        builder.makeUnary(
          absOp, builder.makeLocalTee(v, curr->value, curr->value->type)),
        builder.makeConst(static_cast<From>(std::numeric_limits<To>::max()))),
      builder.makeUnary(getReplacementOp(curr->op),
                        builder.makeLocalGet(v, curr->value->type)),
      builder.makeConst(std::numeric_limits<To>::min())));
  }

  template<typename From, typename To> void replaceUnsigned(Unary* curr) {
    BinaryOp ltOp, geOp;

    switch (curr->op) {
      case TruncSatUFloat32ToInt32:
      case TruncSatUFloat32ToInt64:
        ltOp = LtFloat32;
        geOp = GeFloat32;
        break;
      case TruncSatUFloat64ToInt32:
      case TruncSatUFloat64ToInt64:
        ltOp = LtFloat64;
        geOp = GeFloat64;
        break;
      default:
        WASM_UNREACHABLE("Unexpected opcode");
    }

    Builder builder(*getModule());
    Index v = Builder::addVar(getFunction(), curr->value->type);
    // if op < INT_MAX and op >= 0 then use the trapping operation, else return
    // 0
    replaceCurrent(builder.makeIf(
      builder.makeBinary(
        AndInt32,
        builder.makeBinary(
          ltOp,
          builder.makeLocalTee(v, curr->value, curr->value->type),
          builder.makeConst(static_cast<From>(std::numeric_limits<To>::max()))),
        builder.makeBinary(geOp,
                           builder.makeLocalGet(v, curr->value->type),
                           builder.makeConst(static_cast<From>(0.0)))),
      builder.makeUnary(getReplacementOp(curr->op),
                        builder.makeLocalGet(v, curr->value->type)),
      builder.makeConst(static_cast<To>(0))));
  }

  void visitUnary(Unary* curr) {
    switch (curr->op) {
      case TruncSatSFloat32ToInt32:
        replaceSigned<float, int32_t>(curr);
        break;
      case TruncSatSFloat64ToInt32:
        replaceSigned<double, int32_t>(curr);
        break;
      case TruncSatSFloat32ToInt64:
        replaceSigned<float, int64_t>(curr);
        break;
      case TruncSatSFloat64ToInt64:
        replaceSigned<double, int64_t>(curr);
        break;
      case TruncSatUFloat32ToInt32:
        replaceUnsigned<float, uint32_t>(curr);
        break;
      case TruncSatUFloat64ToInt32:
        replaceUnsigned<double, uint32_t>(curr);
        break;
      case TruncSatUFloat32ToInt64:
        replaceUnsigned<float, uint64_t>(curr);
        break;
      case TruncSatUFloat64ToInt64:
        replaceUnsigned<double, uint64_t>(curr);
        break;
      default:
        break;
    }
  }

  void doWalkFunction(Function* func) { Super::doWalkFunction(func); }
};

struct LLVMNonTrappingFPToIntLowering : public Pass {
  void run(Module* module) override {
    if (!module->features.hasTruncSat()) {
      return;
    }
    PassRunner runner(module);
    // Run the Impl pass as an inner pass in parallel. This pass updates the
    // module features, so it can't be parallel.
    runner.add(std::make_unique<LLVMNonTrappingFPToIntLoweringImpl>());
    runner.setIsNested(true);
    runner.run();
    module->features.disable(FeatureSet::TruncSat);
  }
};

Pass* createLLVMNonTrappingFPToIntLoweringPass() {
  return new LLVMNonTrappingFPToIntLowering();
}

} // namespace wasm
