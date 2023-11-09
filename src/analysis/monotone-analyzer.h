#ifndef wasm_analysis_monotone_analyzer_h
#define wasm_analysis_monotone_analyzer_h

#include <iostream>
#include <queue>
#include <vector>

#include "cfg.h"
#include "lattice.h"
#include "transfer-function.h"

namespace wasm::analysis {

template<Lattice L, TransferFunction TxFn> class MonotoneCFGAnalyzer {
  using Element = typename L::Element;

  L& lattice;
  TxFn& txfn;
  CFG& cfg;

  // The lattice element representing the program state before each block.
  std::vector<Element> states;

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

// Deduction guide.
template<typename L, typename TxFn>
MonotoneCFGAnalyzer(L&, TxFn&, CFG&) -> MonotoneCFGAnalyzer<L, TxFn>;

} // namespace wasm::analysis

#include "monotone-analyzer-impl.h"

#endif // wasm_analysis_monotone_analyzer_h
