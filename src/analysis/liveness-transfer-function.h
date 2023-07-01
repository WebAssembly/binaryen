#ifndef wasm_analysis_liveness_transfer_function_h
#define wasm_analysis_liveness_transfer_function_h

#include "lattice.h"
#include "monotone-analyzer.h"

namespace wasm::analysis {

class LivenessTransferFunction : public Visitor<LivenessTransferFunction> {
  FinitePowersetLattice::Element* currState;

public:
  LivenessTransferFunction() : currState(nullptr) {}

  // Transfer function implementation. Modifies the state for a particular
  // expression type. In our current limited implementation, we just update
  // state on gets and sets of local indices.
  void visitLocalSet(LocalSet* curr) {
    if (currState) {
      currState->set(curr->index, false);
    }
  }
  void visitLocalGet(LocalGet* curr) {
    if (currState) {
      currState->set(curr->index, true);
    }
  }

  // Executes the transfer function on all the expressions of the corresponding
  // CFG node, starting with the node's input state. Returns the final output
  // state of the node.
  FinitePowersetLattice::Element
  transfer(const BasicBlock* cfgBlock,
           FinitePowersetLattice::Element& inputState) {
    // If the block is empty, we propagate the state by inputState =
    // outputState.

    FinitePowersetLattice::Element outputState = inputState;
    currState = &outputState;

    // Compute transfer function for all expressions in the CFG block.
    for (auto cfgIter = cfgBlock->rbegin(); cfgIter != cfgBlock->rend();
         ++cfgIter) {
      // Run transfer function.
      LivenessTransferFunction::visit(*cfgIter);
    }
    currState = nullptr;
    return outputState;
  }

  // Enqueues the worklist before the worklist algorithm is run. For
  // liveness analysis, we are doing a backward analysis, so we want
  // to enqueue the worklist backward so that later CFG blocks are
  // run before earlier CFG blocks. This improves performance by
  // reducing the number of state propagations needed, since we are
  // naturally following the backward flow at the beginning.
  void enqueueWorklist(
    const std::vector<BlockState<FinitePowersetLattice>>& stateBlocks,
    std::queue<Index>& worklist) {
    for (auto it = stateBlocks.rbegin(); it != stateBlocks.rend(); ++it) {
      worklist.push((*it).getCFGBlock()->getIndex());
    }
  }

  // Predecessors depend on use for information.
  using iterator =
    std::vector<BlockState<FinitePowersetLattice>*>::const_iterator;
  iterator depsBegin(BlockState<FinitePowersetLattice>& currBlock) {
    return currBlock.predecessorsBegin();
  }
  iterator depsEnd(BlockState<FinitePowersetLattice>& currBlock) {
    return currBlock.predecessorsEnd();
  }

  // Prints the intermediate states of each BlockState currBlock by applying
  // the transfer function on each expression of the CFG block. This data is
  // not stored in the BlockState itself.
  void print(std::ostream& os, BlockState<FinitePowersetLattice>& currBlock) {
    os << "Intermediate States (reverse order): " << std::endl;
    currState = &currBlock.getInputState();
    currState->print(os);
    os << std::endl;
    auto cfgIter = currBlock.getCFGBlock()->rbegin();

    // Since we don't store the intermediate states in the BlockState, we need
    // to re-run the transfer function on all the CFG node expressions to
    // reconstruct the intermediate states here.
    while (cfgIter != currBlock.getCFGBlock()->rend()) {
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
