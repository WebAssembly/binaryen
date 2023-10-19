#ifndef wasm_analysis_monotone_analyzer_h
#define wasm_analysis_monotone_analyzer_h

#include <iostream>
#include <queue>
#include <vector>

#include "cfg.h"
#include "lattice.h"
#include "transfer-function.h"

namespace wasm::analysis {

// A node which contains all the lattice states for a given CFG node.
template<Lattice L> struct BlockState {

  // CFG node corresponding to this state block.
  const BasicBlock* cfgBlock;
  // State at which the analysis flow starts for a CFG. For instance, the ending
  // state for backward analysis, or the beginning state for forward analysis.
  typename L::Element inputState;

  // All states are set to the bottom lattice element in this constructor.
  BlockState(const BasicBlock* underlyingBlock, L& lattice);

  // Prints out BlockState information, but not any intermediate states.
  void print(std::ostream& os);
};

template<Lattice L, TransferFunction TxFn> class MonotoneCFGAnalyzer {
  L& lattice;
  TxFn& txfn;
  CFG& cfg;
  std::vector<BlockState<L>> stateBlocks;

public:
  // Will constuct BlockState objects corresponding to BasicBlocks from the
  // given CFG.
  MonotoneCFGAnalyzer(L& lattice, TxFn& txfn, CFG& cfg);

  // Runs the worklist algorithm to compute the states for the BlockState graph.
  void evaluate();

  // This modifies the state of the CFG's entry block, with function
  // information. This cannot be done otherwise in a forward analysis, as the
  // entry block depends on no other blocks, and hence cannot be changed by
  // them.
  void evaluateFunctionEntry(Function* func);

  // Iterates over all of the BlockStates after evaluate() is completed for the
  // transfer function to collect the finalized intermediate states from each
  // block. For instance, the reaching definitions analysis transfer functions
  // will take the final states and use it to populate a map of local.get's to
  // sets of local.set's which affect it.
  void collectResults();

  // The analyzer is run in two distinct phases. First evaluate() runs the
  // worklist algorithm to obtain a solution. Then collectResults() iterates
  // over the vector of BlockState's, allowing the transfer function to access
  // the final states to and turn them into some result.
  void evaluateAndCollectResults() {
    evaluate();
    collectResults();
  }

  // Prints out all BlockStates in this analyzer.
  void print(std::ostream& os);
};

} // namespace wasm::analysis

#include "monotone-analyzer-impl.h"

#endif // wasm_analysis_monotone_analyzer_h
