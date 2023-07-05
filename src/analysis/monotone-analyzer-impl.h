#ifndef wasm_analysis_monotone_analyzer_impl_h
#define wasm_analysis_monotone_analyzer_impl_h

#include <iostream>
#include <unordered_map>

#include "monotone-analyzer.h"

namespace wasm::analysis {

// All states are set to the bottom lattice element using the lattice in this
// constructor.
template<typename Lattice>
inline BlockState<Lattice>::BlockState(const BasicBlock* underlyingBlock,
                                       Lattice& lattice)
  : cfgBlock(underlyingBlock), inputState(lattice.getBottom()) {}

// Prints out inforamtion about a CFG node's state, but not intermediate states.
template<typename Lattice>
inline void BlockState<Lattice>::print(std::ostream& os) {
  os << "CFG Block: " << cfgBlock->getIndex() << std::endl;
  os << "Input State: ";
  inputState.print(os);
  os << std::endl << "Predecessors:";
  for (auto pred : cfgBlock->preds()) {
    os << " " << pred.getIndex();
  }
  os << std::endl << "Successors:";
  for (auto succ : cfgBlock->succs()) {
    os << " " << succ.getIndex();
  }
  os << std::endl;
}

template<typename Lattice, typename TransferFunction>
inline void MonotoneCFGAnalyzer<Lattice, TransferFunction>::fromCFG(CFG* cfg) {
  this->cfg = cfg;

  // Construct BlockStates for each BasicBlock and map each BasicBlock to each
  // BlockState's index in stateBlocks.
  std::unordered_map<const BasicBlock*, size_t> basicBlockToState;
  size_t index = 0;
  for (auto it = cfg->begin(); it != cfg->end(); it++) {
    stateBlocks.emplace_back(&(*it), lattice);
    basicBlockToState[&(*it)] = index++;
  }
}

template<typename Lattice, typename TransferFunction>
inline void MonotoneCFGAnalyzer<Lattice, TransferFunction>::evaluate() {
  assert(cfg);

  std::queue<Index> worklist;

  // Transfer function enqueues the work in some order which is efficient.
  transferFunction.enqueueWorklist(cfg, worklist);

  while (!worklist.empty()) {
    BlockState<Lattice>& currBlockState = stateBlocks[worklist.front()];
    worklist.pop();

    // For each expression, applies the transfer function, using the expression,
    // on the state of the expression it depends upon (here the next expression)
    // to arrive at the expression's state. The beginning and end states of the
    // CFG block will be updated.
    typename Lattice::Element outputState = currBlockState.inputState;
    transferFunction.transfer(currBlockState.cfgBlock, outputState);

    // Propagate state to dependents of currBlockState.
    for (auto& dep : transferFunction.getDependents(currBlockState.cfgBlock)) {
      Index depIndex = dep.getIndex();

      // If we need to change the input state of a dependent, we need
      // to enqueue the dependent to recalculate it.
      if (stateBlocks[depIndex].inputState.makeLeastUpperBound(outputState)) {
        worklist.push(depIndex);
      }
    }
  }
}

// Currently prints both the basic information and intermediate states of each
// BlockState.
template<typename Lattice, typename TransferFunction>
inline void
MonotoneCFGAnalyzer<Lattice, TransferFunction>::print(std::ostream& os) {
  os << "CFG Analyzer" << std::endl;
  for (auto state : stateBlocks) {
    state.print(os);
    typename Lattice::Element temp = state.inputState;
    transferFunction.print(os, state.cfgBlock, temp);
  }
  os << "End" << std::endl;
}

} // namespace wasm::analysis

#endif // wasm_analysis_monotone_analyzer_impl_h
