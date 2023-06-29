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
template<typename Lattice>
class BlockState {
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
  void addPredecessor(BlockState<Lattice>* pred) { predecessors.push_back(pred); }
  void addSuccessor(BlockState<Lattice>* succ) { successors.push_back(succ); }

  // Prints out the beginning and end states.
  void print(std::ostream& os);
};

template<typename Lattice>
class LivenessTransferFunction : public Visitor<LivenessTransferFunction<Lattice>> {
  typename Lattice::Element currState;  

  public:
  LivenessTransferFunction(Lattice& lattice); 
  
  // Transfer function implementation. Modifies the state for a particular
  // expression type.
  void visitLocalSet(LocalSet* curr);
  void visitLocalGet(LocalGet* curr);

  // Executes the transfer function on all the expressions of the corresponding
  // CFG node.
  void transfer(BlockState<Lattice>& currBlock);
  
  void enqueueWorklist(const std::vector<BlockState<Lattice>>& stateBlocks, std::queue<Index>& worklist);

  using iterator = typename std::vector<BlockState<Lattice>*>::const_iterator;
  iterator depsBegin(BlockState<Lattice>& currBlock) { return currBlock.predecessorsBegin(); }
  iterator depsEnd(BlockState<Lattice>& currBlock) { return currBlock.predecessorsEnd(); }

  typename Lattice::Element& getInputState(BlockState<Lattice>* currBlock) { return currBlock->getLastState(); }
  typename Lattice::Element& getOutputState(BlockState<Lattice>* currBlock) { return currBlock->getFirstState(); }

  void print(std::ostream& os, BlockState<Lattice>& currBlock);
};

template<typename Lattice, template<typename> typename TransferFunction>
struct MonotoneCFGAnalyzer {
  static_assert(is_lattice<Lattice>);
  
  MonotoneCFGAnalyzer(Lattice lattice, TransferFunction<Lattice> transferFunction) : lattice(lattice), transferFunction(transferFunction) {}

  // Constructs a graph of BlockState objects which parallels
  // the CFG graph. Each CFG node corresponds to a BlockState node.
  void fromCFG(CFG* cfg);

  // Runs the worklist algorithm to compute the states for the BlockList graph.
  void evaluate();

  // Prints out all BlockStates in this analyzer.
  void print(std::ostream& os);

private:
  Lattice lattice;
  TransferFunction<Lattice> transferFunction;
  std::vector<BlockState<Lattice>> stateBlocks;
};

} // namespace wasm::analysis

#include "monotone-analyzer-impl.h"

#endif // wasm_analysis_monotone_analyzer_h
