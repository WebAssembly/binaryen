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

class LivenessTransferFunction : public Visitor<LivenessTransferFunction> {
  FinitePowersetLattice::Element currState;

public:
  LivenessTransferFunction(FinitePowersetLattice& lattice);

  // Transfer function implementation. Modifies the state for a particular
  // expression type.
  void visitLocalSet(LocalSet* curr);
  void visitLocalGet(LocalGet* curr);

  // Executes the transfer function on all the expressions of the corresponding
  // CFG node.
  void transfer(BlockState<FinitePowersetLattice>& currBlock);

  void enqueueWorklist(
    const std::vector<BlockState<FinitePowersetLattice>>& stateBlocks,
    std::queue<Index>& worklist);

  using iterator =
    std::vector<BlockState<FinitePowersetLattice>*>::const_iterator;
  iterator depsBegin(BlockState<FinitePowersetLattice>& currBlock) {
    return currBlock.predecessorsBegin();
  }
  iterator depsEnd(BlockState<FinitePowersetLattice>& currBlock) {
    return currBlock.predecessorsEnd();
  }

  FinitePowersetLattice::Element&
  getInputState(BlockState<FinitePowersetLattice>* currBlock) {
    return currBlock->getLastState();
  }
  FinitePowersetLattice::Element&
  getOutputState(BlockState<FinitePowersetLattice>* currBlock) {
    return currBlock->getFirstState();
  }

  void print(std::ostream& os, BlockState<FinitePowersetLattice>& currBlock);
};

template<typename Lattice, typename TransferFunction>
struct MonotoneCFGAnalyzer {
  static_assert(is_lattice<Lattice>);

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
