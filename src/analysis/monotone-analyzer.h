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

  // CFG node corresponding to this state block
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

  // Prints out the beginning and end states.
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
