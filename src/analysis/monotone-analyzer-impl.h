#ifndef wasm_analysis_monotone_analyzer_impl_h
#define wasm_analysis_monotone_analyzer_impl_h

#include <iostream>
#include <unordered_map>

#include "monotone-analyzer.h"

namespace wasm::analysis {

// All states are set to the bottom lattice element using the lattice in this
// constructor.
template<typename Lattice>
inline BlockState<Lattice>::BlockState(const BasicBlock* underlyingBlock,
                                       Lattice& lattice)
  : cfgBlock(underlyingBlock),
    beginningState(lattice.getBottom()),
    endState(lattice.getBottom()) {}

// Prints out inforamtion about a CFG node's state, but not intermediate states.
template<typename Lattice> inline void BlockState<Lattice>::print(std::ostream& os) {
  os << "CFG Block: " << cfgBlock->getIndex() << std::endl;
  os << "Beginning State: ";
  beginningState.print(os);
  os << std::endl << "End State: ";
  endState.print(os);
  os << std::endl << "Predecessors:";
  for (auto pred : predecessors) {
    os << " " << pred->cfgBlock->getIndex();
  }
  os << std::endl << "Successors:";
  for (auto succ : successors) {
    os << " " << succ->cfgBlock->getIndex();
  }
  os << std::endl;
}

template<typename Lattice> LivenessTransferFunction<Lattice>::LivenessTransferFunction(Lattice& lattice) : currState(lattice.getBottom()) {}

// In our current limited implementation, we just update state on gets
// and sets of local indices.
template<typename Lattice>
inline void LivenessTransferFunction<Lattice>::visitLocalSet(LocalSet* curr) {
  currState.set(curr->index, false);
}

template<typename Lattice>
inline void LivenessTransferFunction<Lattice>::visitLocalGet(LocalGet* curr) {
  currState.set(curr->index, true);
}

template<typename Lattice> inline void LivenessTransferFunction<Lattice>::transfer(BlockState<Lattice>& currBlock) {
  // If the block is empty, we propagate the state by endState = currState, then
  // currState = beginningState.

  // Compute transfer function for all expressions in the CFG block.
  auto cfgIter = currBlock.getCFGBlock()->rbegin();
  currState = currBlock.getLastState();

  while (cfgIter != currBlock.getCFGBlock()->rend()) {
    // Run transfer function.
    LivenessTransferFunction<Lattice>::visit(*cfgIter);
    ++cfgIter;
  }

  currBlock.getFirstState() = std::move(currState);
}
  
template<typename Lattice> inline void LivenessTransferFunction<Lattice>::enqueueWorklist(const std::vector<BlockState<Lattice>>& stateBlocks, std::queue<Index>& worklist)   {
  for (auto it = stateBlocks.rbegin(); it != stateBlocks.rend(); ++it) {
    worklist.push((*it).getCFGBlock()->getIndex());
  }
}

template<typename Lattice>
inline void LivenessTransferFunction<Lattice>::print(std::ostream& os, BlockState<Lattice>& currBlock) {
  os << "Intermediate States (reverse order): " << std::endl;
  currState = currBlock.getLastState();
  currState.print(os);
  os << std::endl;
  auto cfgIter = currBlock.getCFGBlock()->rbegin();

  // Since we don't store the intermediate states in the BlockState, we need to
  // re-run the transfer function on all the CFG node expressions to reconstruct
  // the intermediate states here.
  while (cfgIter != currBlock.getCFGBlock()->rend()) {
    os << ShallowExpression{*cfgIter} << std::endl;
    LivenessTransferFunction<Lattice>::visit(*cfgIter);
    currState.print(os);
    os << std::endl;
    ++cfgIter;
  }
}

template<typename Lattice, template<typename> typename TransferFunction>
inline void MonotoneCFGAnalyzer<Lattice, TransferFunction>::fromCFG(CFG* cfg) {
  // Construct BlockStates for each BasicBlock and map each BasicBlock to each
  // BlockState's index in stateBlocks.
  std::unordered_map<const BasicBlock*, size_t> basicBlockToState;
  size_t index = 0;
  for (auto it = cfg->begin(); it != cfg->end(); it++) {
    stateBlocks.emplace_back(&(*it), lattice);
    basicBlockToState[&(*it)] = index++;
  }

  // Update predecessors and successors of each BlockState object
  // according to the BasicBlock's predecessors and successors.
  for (index = 0; index < stateBlocks.size(); ++index) {
    BlockState<Lattice>& currBlock = stateBlocks.at(index);
    BasicBlock::Predecessors preds = currBlock.getCFGBlock()->preds();
    BasicBlock::Successors succs = currBlock.getCFGBlock()->succs();
    for (auto& pred : preds) {
      currBlock.addPredecessor(&stateBlocks[basicBlockToState[&pred]]);
    }

    for (auto& succ : succs) {
      currBlock.addSuccessor(&stateBlocks[basicBlockToState[&succ]]);
    }
  }
}

template<typename Lattice, template<typename> typename TransferFunction>
inline void MonotoneCFGAnalyzer<Lattice, TransferFunction>::evaluate() {
  std::queue<Index> worklist;
  transferFunction.enqueueWorklist(stateBlocks, worklist);

  while (!worklist.empty()) {
    BlockState<Lattice>& currBlockState = stateBlocks[worklist.front()];
    worklist.pop();

    // For each expression, applies the transfer function, using the expression,
    // on the state of the expression it depends upon (here the next expression)
    // to arrive at the expression's state. The beginning and end states of the
    // CFG block will be updated.
    transferFunction.transfer(currBlockState);

    // Propagate state to dependents.
    for (auto dep = transferFunction.depsBegin(currBlockState); dep != transferFunction.depsEnd(currBlockState); ++dep) {
      if (transferFunction.getInputState(*dep).makeLeastUpperBound(
            transferFunction.getOutputState(&currBlockState))) {
        worklist.push((*dep)->getCFGBlock()->getIndex());
      }
    }
  }
}

template<typename Lattice, template<typename> typename TransferFunction>
inline void MonotoneCFGAnalyzer<Lattice, TransferFunction>::print(std::ostream& os) {
  os << "CFG Analyzer" << std::endl;
  for (auto state : stateBlocks) {
    state.print(os);
    transferFunction.print(os, state);
  }
  os << "End" << std::endl;
}

} // namespace wasm::analysis

#endif // wasm_analysis_monotone_analyzer_impl_h
