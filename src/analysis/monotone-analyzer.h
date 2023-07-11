#ifndef wasm_analysis_monotone_analyzer_h
#define wasm_analysis_monotone_analyzer_h

#include <iostream>
#include <queue>
#include <vector>

#include "cfg.h"
#include "lattice.h"
#include "wasm-traversal.h"

namespace wasm::analysis {

// A node which contains all the lattice states for a given CFG node.
template<typename Lattice> struct BlockState {
  static_assert(is_lattice<Lattice>);

  // CFG node corresponding to this state block.
  const BasicBlock* cfgBlock;
  // State at which the analysis flow starts for a CFG. For instance, the ending
  // state for backward analysis, or the beginning state for forward analysis.
  typename Lattice::Element inputState;

  // All states are set to the bottom lattice element in this constructor.
  BlockState(const BasicBlock* underlyingBlock, Lattice& lattice);

  // Prints out BlockState information, but not any intermediate states.
  void print(std::ostream& os);
};

// A transfer function using a lattice <Lattice> is required to have the
// following methods:

// Lattice::Element transfer(const BasicBlock* cfgBlock, Lattice::Element&
// inputState);

// This function takes in a pointer to a CFG BasicBlock and the input state
// associated with it and modifies the input state in-place into the ouptut
// state for the basic block by applying the analysis transfer function to each
// expression in the CFG BasicBlock. Starting with the input state, the transfer
// function is used to change the state to new intermediate states based on each
// expression until we reach the output state. The outuput state will be
// propagated to dependents of the CFG BasicBlock by the worklist algorithm in
// MonotoneCFGAnalyzer.

template<typename TransferFunction, typename Lattice>
constexpr bool has_transfer =
  std::is_invocable_r<void,
                      decltype(&TransferFunction::transfer),
                      TransferFunction,
                      const BasicBlock*,
                      typename Lattice::Element&>::value;

// void enqueueWorklist(CFG&, std::queue<const BasicBlock*>& value);

// Loads CFG BasicBlocks in some order into the worklist. Custom specifying the
// order for each analysis brings performance savings. For example, when doing a
// backward analysis, loading the BasicBlocks in reverse order will lead to less
// state propagations, and therefore better performance. The opposite is true
// for a forward analysis.

template<typename TransferFunction, typename Lattice>
constexpr bool has_enqueueWorklist =
  std::is_invocable_r<void,
                      decltype(&TransferFunction::enqueueWorklist),
                      TransferFunction,
                      CFG&,
                      std::queue<const BasicBlock*>&>::value;

// <iterable> getDependents(const BasicBlock* currBlock);

// Returns an iterable to the CFG BasicBlocks which depend on currBlock for
// information (e.g. predecessors in a backward analysis). Used to select which
// blocks to propagate to after applying the transfer function to a block. At
// present, we allow this function to return any iterable, so we only assert
// that the method exists with the following parameters.

template<typename TransferFunction>
constexpr bool has_getDependents =
  std::is_invocable<decltype(&TransferFunction::getDependents),
                    TransferFunction,
                    const BasicBlock*>::value;

// Combined TransferFunction assertions.
template<typename TransferFunction, typename Lattice>
constexpr bool is_TransferFunction = has_transfer<TransferFunction, Lattice>&&
  has_enqueueWorklist<TransferFunction, Lattice>&&
    has_getDependents<TransferFunction>;

template<typename Lattice, typename TransferFunction>
class MonotoneCFGAnalyzer {
  static_assert(is_lattice<Lattice>);
  static_assert(is_TransferFunction<TransferFunction, Lattice>);

  Lattice& lattice;
  TransferFunction& transferFunction;
  CFG& cfg;
  std::vector<BlockState<Lattice>> stateBlocks;

public:
  // Will constuct BlockState objects corresponding to BasicBlocks from the
  // given CFG.
  MonotoneCFGAnalyzer(Lattice& lattice,
                      TransferFunction& transferFunction,
                      CFG& cfg);

  // Runs the worklist algorithm to compute the states for the BlockList graph.
  void evaluate();

  // Prints out all BlockStates in this analyzer.
  void print(std::ostream& os);
};

} // namespace wasm::analysis

#include "monotone-analyzer-impl.h"

#endif // wasm_analysis_monotone_analyzer_h
