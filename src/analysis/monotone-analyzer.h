#ifndef wasm_analysis_monotone_analyzer_h
#define wasm_analysis_monotone_analyzer_h

#include <iostream>
#include <queue>
#include <vector>

#include "cfg.h"
#include "lattice.h"
#include "wasm-traversal.h"

namespace wasm::analysis {

template<size_t N> struct MonotoneCFGAnalyzer;

// A node which contains all the lattice states for a given CFG node.
template<size_t N> struct BlockState : public Visitor<BlockState<N>> {
  static_assert(is_lattice<BitsetPowersetLattice<N>>);
  BlockState(const BasicBlock* underlyingBlock);

  void addPredecessor(BlockState* pred);
  void addSuccessor(BlockState* succ);

  BitsetPowersetLattice<N>& getFirstState();
  BitsetPowersetLattice<N>& getLastState();

  // Transfer function implementation. Modifies the state for a particular
  // expression type.
  void visitLocalSet(LocalSet* curr);
  void visitLocalGet(LocalGet* curr);

  // Executes the transfer function on all the expressions of the corresponding
  // CFG and then propagates the state to all predecessors (which depend on the
  // current node).
  void transfer();

  // prints out all states.
  void print(std::ostream& os);

private:
  // The index of the block is same as the CFG index.
  Index index;
  const BasicBlock* cfgBlock;
  // State at beginning of CFG node.
  BitsetPowersetLattice<N> beginningState;
  // State at the end of the CFG node.
  BitsetPowersetLattice<N> endState;
  // Holds intermediate state values.
  BitsetPowersetLattice<N> currState;
  std::vector<BlockState*> predecessors;
  std::vector<BlockState*> successors;

  friend MonotoneCFGAnalyzer<N>;
};

template<size_t N> struct MonotoneCFGAnalyzer {
  static_assert(is_lattice<BitsetPowersetLattice<N>>);

  // Constructs a graph of BlockState objects which parallels
  // the CFG graph. Each CFG node corresponds to a BlockState node.
  static MonotoneCFGAnalyzer<N> fromCFG(CFG* cfg);

  // Runs the worklist algorithm to compute the states for the BlockList graph.
  void evaluate();

  void print(std::ostream& os);

private:
  std::vector<BlockState<N>> stateBlocks;
  friend BlockState<N>;
};

} // namespace wasm::analysis

#include "monotone-analyzer-impl.h"

#endif // wasm_analysis_monotone_analyzer_h
