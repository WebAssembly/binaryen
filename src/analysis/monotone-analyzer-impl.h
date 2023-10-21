#ifndef wasm_analysis_monotone_analyzer_impl_h
#define wasm_analysis_monotone_analyzer_impl_h

#include <iostream>
#include <unordered_map>

#include "monotone-analyzer.h"

namespace wasm::analysis {

// All states are set to the bottom lattice element using the lattice in this
// constructor.
template<Lattice L>
inline BlockState<L>::BlockState(const BasicBlock* underlyingBlock, L& lattice)
  : cfgBlock(underlyingBlock), inputState(lattice.getBottom()) {}

// Prints out inforamtion about a CFG node's state, but not intermediate states.
template<Lattice L> inline void BlockState<L>::print(std::ostream& os) {
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

template<Lattice L, TransferFunction TxFn>
inline MonotoneCFGAnalyzer<L, TxFn>::MonotoneCFGAnalyzer(L& lattice,
                                                         TxFn& txfn,
                                                         CFG& cfg)
  : lattice(lattice), txfn(txfn), cfg(cfg) {

  // Construct BlockStates for each BasicBlock.
  for (auto it = cfg.begin(); it != cfg.end(); it++) {
    stateBlocks.emplace_back(&(*it), lattice);
  }
}

template<Lattice L, TransferFunction TxFn>
inline void
MonotoneCFGAnalyzer<L, TxFn>::evaluateFunctionEntry(Function* func) {
  txfn.evaluateFunctionEntry(func, stateBlocks[0].inputState);
}

template<Lattice L, TransferFunction TxFn>
inline void MonotoneCFGAnalyzer<L, TxFn>::evaluate() {
  std::queue<const BasicBlock*> worklist;

  // Transfer function enqueues the work in some order which is efficient.
  txfn.enqueueWorklist(cfg, worklist);

  while (!worklist.empty()) {
    BlockState<L>& currBlockState = stateBlocks[worklist.front()->getIndex()];
    worklist.pop();

    // For each expression, applies the transfer function, using the expression,
    // on the state of the expression it depends upon (here the next expression)
    // to arrive at the expression's state. The beginning and end states of the
    // CFG block will be updated.
    typename L::Element outputState = currBlockState.inputState;
    txfn.transfer(currBlockState.cfgBlock, outputState);

    // Propagate state to dependents of currBlockState.
    for (auto& dep : txfn.getDependents(currBlockState.cfgBlock)) {
      // If we need to change the input state of a dependent, we need
      // to enqueue the dependent to recalculate it.
      if (stateBlocks[dep.getIndex()].inputState.makeLeastUpperBound(
            outputState)) {
        worklist.push(&dep);
      }
    }
  }
}

template<Lattice L, TransferFunction TxFn>
inline void MonotoneCFGAnalyzer<L, TxFn>::collectResults() {
  for (BlockState currBlockState : stateBlocks) {
    typename L::Element inputStateCopy = currBlockState.inputState;

    // The transfer function generates the final set of states and uses it to
    // produce useful information. For example, in reaching definitions
    // analysis, these final states are used to populate a mapping of
    // local.get's to a set of local.set's that affect its value.
    txfn.collectResults(currBlockState.cfgBlock, inputStateCopy);
  }
}

// Currently prints both the basic information and intermediate states of each
// BlockState.
template<Lattice L, TransferFunction TxFn>
inline void MonotoneCFGAnalyzer<L, TxFn>::print(std::ostream& os) {
  os << "CFG Analyzer" << std::endl;
  for (auto state : stateBlocks) {
    state.print(os);
    typename L::Element temp = state.inputState;
    txfn.print(os, state.cfgBlock, temp);
  }
  os << "End" << std::endl;
}

} // namespace wasm::analysis

#endif // wasm_analysis_monotone_analyzer_impl_h
