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

template<typename TransferFunction, typename Lattice>
constexpr bool has_transfer =
  std::is_invocable_r<void,
                      decltype(&TransferFunction::transfer),
                      TransferFunction,
                      const BasicBlock*,
                      typename Lattice::Element&>::value;

template<typename TransferFunction, typename Lattice>
constexpr bool has_enqueueWorklist =
  std::is_invocable_r<void,
                      decltype(&TransferFunction::enqueueWorklist),
                      TransferFunction,
                      CFG*,
                      std::queue<Index>&>::value;

template<typename TransferFunction>
constexpr bool has_getDependents =
  std::is_invocable_r<_indirect_ptr_vec<BasicBlock>,
                      decltype(&TransferFunction::getDependents),
                      TransferFunction,
                      const BasicBlock*>::value;

template<typename TransferFunction, typename Lattice>
constexpr bool is_TransferFunction = has_transfer<TransferFunction, Lattice>&&
  has_enqueueWorklist<TransferFunction, Lattice>&&
    has_getDependents<TransferFunction>;

// A transfer function using a lattice <Lattice> is required to have the
// following methods:

// Lattice::Element transfer(BasicBlock* cfgBlock, Lattice::Element&
// inputState);

// This function takes in a pointer to a CFG BasicBlock and the input state
// associated with it and modifies the input state in-place into the ouptut
// state for the basic block by applying the analysis transfer function to each
// expression in the CFG BasicBlock. Starting with the input state, the transfer
// function is used to change the state to new intermediate states based on each
// expression until we reach the output state. The outuput state will be
// propagated to dependents of the CFG BasicBlock by the worklist algorithm in
// MonotoneCFGAnalyzer.

// void enqueueWorklist(const std::vector<BlockState<Lattice>>& stateBlocks,
// std::queue<index>& value);

// Loads the indices of CFG BasicBlocks in some order into the worklist. Custom
// specifying the order in which worklist nodes are loaded for each analysis
// brings performance savings. For example, when doing a backward analysis,
// loading the CFG BasicBlocks in reverse order will lead to less state
// propagations, and therefore better performance. The opposite is true for a
// forward analysis.

// std::vector<BlockState<Lattice>*>::const_iterator
// depsBegin(BlockState<Lattice>& currBlock);

// Returns an iterable to the CFG BasicBlocks which depend on currBlock for
// information (e.g. predecessors in a backward analysis). Used to select
// which blocks to propagate to after applying the transfer function to
// a block.

template<typename Lattice, typename TransferFunction>
struct MonotoneCFGAnalyzer {
  static_assert(is_lattice<Lattice>);
  static_assert(is_TransferFunction<TransferFunction, Lattice>);

  MonotoneCFGAnalyzer(Lattice lattice, TransferFunction transferFunction)
    : lattice(lattice), transferFunction(transferFunction) {}

  // Constructs a graph of BlockState objects which parallels
  // the CFG graph. Each CFG node corresponds to a BlockState node.
  void fromCFG(CFG* cfg);

  // Runs the worklist algorithm to compute the states for the BlockList graph.
  void evaluate();

  // Prints out all BlockStates in this analyzer.
  void print(std::ostream& os);

private:
  Lattice lattice;
  TransferFunction transferFunction;
  std::vector<BlockState<Lattice>> stateBlocks;
  CFG* cfg = nullptr;
};

} // namespace wasm::analysis

#include "monotone-analyzer-impl.h"

#endif // wasm_analysis_monotone_analyzer_h
