#ifndef wasm_analysis_monotone_analyzer_impl_h
#define wasm_analysis_monotone_analyzer_impl_h

#include <iostream>
#include <unordered_map>

#include "monotone-analyzer.h"
#include "support/unique_deferring_queue.h"

namespace wasm::analysis {

template<Lattice L, TransferFunction TxFn>
inline MonotoneCFGAnalyzer<L, TxFn>::MonotoneCFGAnalyzer(L& lattice,
                                                         TxFn& txfn,
                                                         CFG& cfg)
  : lattice(lattice), txfn(txfn), cfg(cfg),
    states(cfg.size(), lattice.getBottom()) {}

template<Lattice L, TransferFunction TxFn>
inline void
MonotoneCFGAnalyzer<L, TxFn>::evaluateFunctionEntry(Function* func) {
  txfn.evaluateFunctionEntry(func, states[0]);
}

template<Lattice L, TransferFunction TxFn>
inline void MonotoneCFGAnalyzer<L, TxFn>::evaluate() {
  UniqueDeferredQueue<Index> worklist;

  // Start with all blocks on the work list. TODO: optimize the iteration order
  // using e.g. strongly-connected components.
  for (Index i = 0; i < cfg.size(); ++i) {
    worklist.push(i);
  }

  while (!worklist.empty()) {
    // The index of the block we will analyze.
    Index i = worklist.pop();

    // Apply the transfer function to the input state to compute the output
    // state, then propagate the output state to the dependent blocks.
    auto state = states[i];
    for (const auto* dep : txfn.transfer(cfg[i], state)) {
      // If the input state for the dependent block changes, we need to
      // re-analyze it.
      if (lattice.join(states[dep->getIndex()], state)) {
        worklist.push(dep->getIndex());
      }
    }
  }
}

template<Lattice L, TransferFunction TxFn>
inline void MonotoneCFGAnalyzer<L, TxFn>::collectResults() {
  for (Index i = 0, size = cfg.size(); i < size; ++i) {
    // The transfer function generates the final set of states and uses it to
    // produce useful information. For example, in reaching definitions
    // analysis, these final states are used to populate a mapping of
    // local.get's to a set of local.set's that affect its value.
    txfn.collectResults(cfg[i], states[i]);
  }
}

// Currently prints both the basic information and intermediate states of each
// BlockState.
template<Lattice L, TransferFunction TxFn>
inline void MonotoneCFGAnalyzer<L, TxFn>::print(std::ostream& os) {
  os << "CFG Analyzer" << std::endl;
  for (Index i = 0, size = cfg.size(); i < size; ++i) {
    os << "CFG Block: " << cfg[i].getIndex() << std::endl;
    os << "Input State: ";
    states[i].print(os);
    for (auto& pred : cfg[i].preds()) {
      os << " " << pred->getIndex();
    }
    os << std::endl << "Successors:";
    for (auto& succ : cfg[i].succs()) {
      os << " " << succ->getIndex();
    }
    os << "\n";
    txfn.print(os, cfg[i], states[i]);
  }
  os << "End\n";
}

} // namespace wasm::analysis

#endif // wasm_analysis_monotone_analyzer_impl_h
