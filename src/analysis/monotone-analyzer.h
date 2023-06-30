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
template<typename Lattice> class BlockState {
  static_assert(is_lattice<Lattice>);

  // CFG node corresponding to this state block.
  const BasicBlock* cfgBlock;
  // State at beginning of CFG node.
  typename Lattice::Element beginningState;
  // State at the end of the CFG node.
  typename Lattice::Element endState;

  std::vector<BlockState<Lattice>*> predecessors;
  std::vector<BlockState<Lattice>*> successors;

public:
  // All states are set to the bottom lattice element in this constructor.
  BlockState(const BasicBlock* underlyingBlock, Lattice& lattice);

  // Accessors.
  typename Lattice::Element& getFirstState() { return beginningState; }
  typename Lattice::Element& getLastState() { return endState; }
  const BasicBlock* getCFGBlock() const { return cfgBlock; }

  // Methods to manipulate predecessors and successors.
  using iterator = typename std::vector<BlockState<Lattice>*>::const_iterator;
  iterator predecessorsBegin() { return predecessors.cbegin(); };
  iterator successorsBegin() { return successors.cbegin(); }
  iterator predecessorsEnd() { return predecessors.cend(); }
  iterator successorsEnd() { return successors.cend(); }
  void addPredecessor(BlockState<Lattice>* pred) {
    predecessors.push_back(pred);
  }
  void addSuccessor(BlockState<Lattice>* succ) { successors.push_back(succ); }

  // Prints out BlockState information, but not any intermediate states.
  void print(std::ostream& os);
};

template<typename TransferFunction, typename Lattice>
constexpr bool has_transfer =
  std::is_invocable_r<void,
                      decltype(&TransferFunction::transfer),
                      TransferFunction,
                      BlockState<Lattice>&>::value;

template<typename TransferFunction, typename Lattice>
constexpr bool has_enqueueWorklist =
  std::is_invocable_r<void,
                      decltype(&TransferFunction::enqueueWorklist),
                      TransferFunction,
                      const std::vector<BlockState<Lattice>>&,
                      std::queue<Index>&>::value;

template<typename TransferFunction, typename Lattice>
constexpr bool has_depsBegin = std::is_invocable_r<
  typename std::vector<BlockState<Lattice>*>::const_iterator,
  decltype(&TransferFunction::depsBegin),
  TransferFunction,
  BlockState<Lattice>&>::value;

template<typename TransferFunction, typename Lattice>
constexpr bool has_depsEnd = std::is_invocable_r<
  typename std::vector<BlockState<Lattice>*>::const_iterator,
  decltype(&TransferFunction::depsEnd),
  TransferFunction,
  BlockState<Lattice>&>::value;

template<typename TransferFunction, typename Lattice>
constexpr bool has_getInputState =
  std::is_invocable_r<typename Lattice::Element&,
                      decltype(&TransferFunction::getInputState),
                      TransferFunction,
                      BlockState<Lattice>*>::value;

template<typename TransferFunction, typename Lattice>
constexpr bool has_getOutputState =
  std::is_invocable_r<typename Lattice::Element&,
                      decltype(&TransferFunction::getOutputState),
                      TransferFunction,
                      BlockState<Lattice>*>::value;

template<typename TransferFunction, typename Lattice>
constexpr bool is_TransferFunction = has_transfer<TransferFunction, Lattice>&&
  has_enqueueWorklist<TransferFunction, Lattice>&&
    has_depsBegin<TransferFunction, Lattice>&&
      has_depsEnd<TransferFunction, Lattice>&&
        has_getInputState<TransferFunction, Lattice>&&
          has_getOutputState<TransferFunction, Lattice>;

// A transfer function using a lattice <Lattice> is required to have the
// following methods:

// void transfer(BlockState<Lattice>& currBlock);

// This function updates the output state of currBlock in-place. To do this, it
// starts at the input state of currBlock and applies the analysis transfer
// function to each expression in the CFG block associated with currBlock to
// derive the intermediate states associated with each expression until we
// produce the output state.

// void enqueueWorklist(const std::vector<BlockState<Lattice>>& stateBlocks,
// std::queue<index>& value);

// Loads CFG nodes in some order into the worklist. Custom specifying the order
// in which worklist nodes are loaded for each analysis brings performance
// savings. For example, when doing a backward analysis, loading the CFG blocks
// in reverse order will lead to less state propagations, and therefore better
// performance. The opposite is true for a forward analysis.

// std::vector<BlockState<Lattice>*>::const_iterator
// depsBegin(BlockState<Lattice>& currBlock);

// Returns a begin iterator to the blocks which depend on currBlock for
// information (e.g. predecessors in a backward analysis). Used for propagating
// states.

// std::vector<BlockState<Lattice>*>::const_iterator
// depsEnd(BlockState<Lattice>& currBlock);

// Returns an end iterator to the blocks which depend on currBlock for
// information. Used for propagating states.

// Lattice::Element& getInputState(BlockState<Lattice>* currBlock);

// Returns a reference to the state at which the static analysis flow for
// currBlock starts. For instance for backward analysis, we start at the end
// state of currBlock. States from other blocks are propagated to currBlock via
// this input state.

// Lattice::Element& getOutputState(BlockState<Lattice>* currBlock);

// Returns a reference to the state at which the static analysis flow for
// currBlock (e.g. the start state in a backward analysis). This state may be
// propagated to other blocks.

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
};

} // namespace wasm::analysis

#include "monotone-analyzer-impl.h"

#endif // wasm_analysis_monotone_analyzer_h
