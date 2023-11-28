#ifndef wasm_analysis_liveness_transfer_function_h
#define wasm_analysis_liveness_transfer_function_h

#include "lattice.h"
#include "lattices/powerset.h"
#include "visitor-transfer-function.h"

namespace wasm::analysis {

struct LivenessTransferFunction
  : public VisitorTransferFunc<LivenessTransferFunction,
                               FiniteIntPowersetLattice,
                               AnalysisDirection::Backward> {
  // Transfer function implementation. A local becomes live before a get
  // and becomes dead before a set.
  void visitLocalSet(LocalSet* curr) {
    assert(currState);
    currState->set(curr->index, false);
  }
  void visitLocalGet(LocalGet* curr) {
    assert(currState);
    currState->set(curr->index, true);
  }

  // Prints the intermediate states of each basic block cfgBlock by applying
  // the transfer function on each expression of the CFG block. This data is
  // not stored. Requires the cfgBlock, and a temp copy of the input state
  // to be passed in, where the temp copy is modified in place to produce the
  // intermediate states.
  void print(std::ostream& os,
             const BasicBlock& bb,
             FiniteIntPowersetLattice::Element& inputState) {
    os << "Intermediate States (reverse order): " << std::endl;
    currState = &inputState;
    currState->print(os);
    os << std::endl;

    // Since we don't store the intermediate states, we need to re-run the
    // transfer function on all the CFG node expressions to reconstruct
    // the intermediate states here.
    for (auto it = bb.rbegin(); it != bb.rend(); ++it) {
      os << ShallowExpression{*it} << "\n";
      visit(*it);
      currState->print(os);
      os << "\n";
    }
    currState = nullptr;
  }
};

} // namespace wasm::analysis

#endif // wasm_analysis_liveness_transfer_function_h
