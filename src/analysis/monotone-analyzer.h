#ifndef wasm_analysis_monotone_analyzer_h
#define wasm_analysis_monotone_analyzer_h

#include <iostream>
#include <queue>
#include <vector>

#include "cfg.h"
#include "lattice.h"
#include "wasm-traversal.h"

namespace wasm::analysis {

struct MonotoneCFGAnalyzer;

// A node which contains all the lattice states for a given CFG node.
struct BlockState : public Visitor<BlockState> {
  BlockState(const BasicBlock* underlyingBlock,
             FinitePowersetLattice::Element begin,
             FinitePowersetLattice::Element end);

  void addPredecessor(BlockState* pred);
  void addSuccessor(BlockState* succ);

  FinitePowersetLattice::Element& getFirstState();
  FinitePowersetLattice::Element& getLastState();

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
  FinitePowersetLattice::Element beginningState;
  // State at the end of the CFG node.
  FinitePowersetLattice::Element endState;
  // Holds intermediate state values.
  FinitePowersetLattice::Element currState;
  std::vector<BlockState*> predecessors;
  std::vector<BlockState*> successors;

  friend MonotoneCFGAnalyzer;
};

struct MonotoneCFGAnalyzer {
  // Constructs a graph of BlockState objects which parallels
  // the CFG graph. Each CFG node corresponds to a BlockState node.
  static MonotoneCFGAnalyzer fromCFG(CFG* cfg, size_t size);

  // Runs the worklist algorithm to compute the states for the BlockList graph.
  void evaluate();

  void print(std::ostream& os);

private:
  MonotoneCFGAnalyzer(size_t size);
  FinitePowersetLattice lattice;
  std::vector<BlockState> stateBlocks;
};

} // namespace wasm::analysis

#include "monotone-analyzer-impl.h"

#endif // wasm_analysis_monotone_analyzer_h
