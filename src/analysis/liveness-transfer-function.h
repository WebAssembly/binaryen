#ifndef wasm_analysis_liveness_transfer_function_h
#define wasm_analysis_liveness_transfer_function_h

#include "lattice.h"
#include "monotone-analyzer.h"

namespace wasm::analysis {

class LivenessTransferFunction : public Visitor<LivenessTransferFunction> {
  FiniteIntPowersetLattice::Element* currState = nullptr;

public:
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

  // Executes the transfer function on all the expressions of the corresponding
  // CFG node, starting with the node's input state, and changes the input state
  // to the final output state of the node in place.
  void transfer(const BasicBlock* cfgBlock,
                FiniteIntPowersetLattice::Element& inputState) {
    // If the block is empty, we propagate the state by inputState =
    // outputState.

    currState = &inputState;

    // This is a backward analysis, so we start from the end of the CFG
    // and evaluate every expression until the beginning.
    for (auto cfgIter = cfgBlock->rbegin(); cfgIter != cfgBlock->rend();
         ++cfgIter) {
      // Run transfer function.
      visit(*cfgIter);
    }
    currState = nullptr;
  }

  // Enqueues the worklist before the worklist algorithm is run. For
  // liveness analysis, we are doing a backward analysis, so we want
  // to enqueue the worklist backward so that later CFG blocks are
  // run before earlier CFG blocks. This improves performance by
  // reducing the number of state propagations needed, since we are
  // naturally following the backward flow at the beginning.
  void enqueueWorklist(CFG& cfg, std::queue<const BasicBlock*>& worklist) {
    for (auto it = cfg.rbegin(); it != cfg.rend(); ++it) {
      worklist.push(&(*it));
    }
  }

  // Predecessors depend on current basic block for information.
  BasicBlock::Predecessors getDependents(const BasicBlock* currBlock) {
    return currBlock->preds();
  }

  // Prints the intermediate states of each BlockState currBlock by applying
  // the transfer function on each expression of the CFG block. This data is
  // not stored in the BlockState itself. Requires the cfgBlock, and a temp
  // copy of the input state to be passed in, where the temp copy is modified
  // in place to produce the intermediate states.
  void print(std::ostream& os,
             const BasicBlock* cfgBlock,
             FiniteIntPowersetLattice::Element& inputState) {
    os << "Intermediate States (reverse order): " << std::endl;
    currState = &inputState;
    currState->print(os);
    os << std::endl;
    auto cfgIter = cfgBlock->rbegin();

    // Since we don't store the intermediate states in the BlockState, we need
    // to re-run the transfer function on all the CFG node expressions to
    // reconstruct the intermediate states here.
    while (cfgIter != cfgBlock->rend()) {
      os << ShallowExpression{*cfgIter} << std::endl;
      LivenessTransferFunction::visit(*cfgIter);
      currState->print(os);
      os << std::endl;
      ++cfgIter;
    }
    currState = nullptr;
  }
};

} // namespace wasm::analysis

#endif // wasm_analysis_liveness_transfer_function_h
