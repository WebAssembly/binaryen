#ifndef wasm_analysis_monotone_analyzer_h
#define wasm_analysis_monotone_analyzer_h

#include <iostream>
#include <queue>
#include <vector>

#include "cfg.h"
#include "lattice.h"
#include "wasm-traversal.h"

namespace wasm::analysis {

template<typename Lattice> struct MonotoneCFGAnalyzer;

// A node which contains all the lattice states for a given CFG node.
template<typename Lattice>
struct BlockState : public Visitor<BlockState<Lattice>> {
  static_assert(is_lattice<Lattice>);
  // All states are set to the bottom lattice element in this constructor.
  BlockState(const BasicBlock* underlyingBlock, Lattice& lattice);

  typename Lattice::Element& getFirstState() { return beginningState; }
  typename Lattice::Element& getLastState() { return endState; }

  // Transfer function implementation. Modifies the state for a particular
  // expression type.
  void visitLocalSet(LocalSet* curr);
  void visitLocalGet(LocalGet* curr);

  // Executes the transfer function on all the expressions of the corresponding
  // CFG node.
  void transfer();

  // Prints out all intermediate states in the block.
  void print(std::ostream& os);

private:
  // The index of the block is same as the CFG index.
  Index index;
  const BasicBlock* cfgBlock;
  // State at beginning of CFG node.
  typename Lattice::Element beginningState;
  // State at the end of the CFG node.
  typename Lattice::Element endState;
  // Holds intermediate state values.
  typename Lattice::Element currState;
  std::vector<BlockState<Lattice>*> predecessors;
  std::vector<BlockState<Lattice>*> successors;

  friend MonotoneCFGAnalyzer<Lattice>;
};

template<typename Lattice> struct MonotoneCFGAnalyzer {
  MonotoneCFGAnalyzer(Lattice lattice) : lattice(lattice) {}

  // Constructs a graph of BlockState objects which parallels
  // the CFG graph. Each CFG node corresponds to a BlockState node.
  void fromCFG(CFG* cfg);

  // Runs the worklist algorithm to compute the states for the BlockList graph.
  void evaluate();

  // Prints out all BlockStates in this analyzer.
  void print(std::ostream& os);

private:
  Lattice lattice;
  std::vector<BlockState<Lattice>> stateBlocks;
};

} // namespace wasm::analysis

#include "monotone-analyzer-impl.h"

#endif // wasm_analysis_monotone_analyzer_h
