#ifndef wasm_analysis_monotone_analyzer_impl_h
#define wasm_analysis_monotone_analyzer_impl_h

#include <iostream>
#include <unordered_map>

#include "monotone-analyzer.h"

namespace wasm::analysis {

template<typename Lattice>
inline BlockState<Lattice>::BlockState(const BasicBlock* underlyingBlock,
                                       Lattice& lattice)
  : index(underlyingBlock->getIndex()), cfgBlock(underlyingBlock),
    beginningState(lattice.getBottom()), endState(lattice.getBottom()),
    currState(lattice.getBottom()) {}

// In our current limited implementation, we just update a new live variable
// when it it is used in a get or set.
template<typename Lattice>
inline void BlockState<Lattice>::visitLocalSet(LocalSet* curr) {
  currState.set(curr->index, false);
}

template<typename Lattice>
inline void BlockState<Lattice>::visitLocalGet(LocalGet* curr) {
  currState.set(curr->index, true);
}

template<typename Lattice> inline void BlockState<Lattice>::transfer() {
  // If the block is empty, we propagate the state by endState = currState, then
  // currState = beginningState

  // compute transfer function for all expressions in the CFG block
  auto cfgIter = cfgBlock->rbegin();
  currState = endState;

  while (cfgIter != cfgBlock->rend()) {
    // run transfer function.
    BlockState::visit(*cfgIter);
    ++cfgIter;
  }
  beginningState = currState;
}

template<typename Lattice>
inline void BlockState<Lattice>::print(std::ostream& os) {
  os << "State Block: " << index << std::endl;
  os << "State at beginning: ";
  beginningState.print(os);
  os << std::endl << "State at end: ";
  endState.print(os);
  os << std::endl << "Intermediate States (reverse order): " << std::endl;

  currState = endState;
  currState.print(os);
  os << std::endl;
  auto cfgIter = cfgBlock->rbegin();

  while (cfgIter != cfgBlock->rend()) {
    // run transfer function.
    os << ShallowExpression{*cfgIter} << std::endl;
    BlockState::visit(*cfgIter);
    currState.print(os);
    os << std::endl;
    ++cfgIter;
  }
}

template<typename Lattice>
inline void MonotoneCFGAnalyzer<Lattice>::fromCFG(CFG* cfg) {
  // Map BasicBlocks to each BlockState's index
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
    BasicBlock::Predecessors preds = currBlock.cfgBlock->preds();
    BasicBlock::Successors succs = currBlock.cfgBlock->succs();
    for (auto pred : preds) {
      currBlock.predecessors.push_back(&stateBlocks[basicBlockToState[&pred]]);
    }

    for (auto succ : succs) {
      currBlock.successors.push_back(&stateBlocks[basicBlockToState[&succ]]);
    }
  }
}

template<typename Lattice>
inline void MonotoneCFGAnalyzer<Lattice>::evaluate() {
  std::queue<Index> worklist;

  for (auto it = stateBlocks.rbegin(); it != stateBlocks.rend(); ++it) {
    worklist.push(it->index);
  }

  while (!worklist.empty()) {
    BlockState<Lattice>& currBlockState = stateBlocks[worklist.front()];
    worklist.pop();
    currBlockState.transfer();

    // Propagate state to dependents
    for (size_t j = 0; j < currBlockState.predecessors.size(); ++j) {
      if (currBlockState.predecessors[j]->getLastState().getLeastUpperBound(
            currBlockState.getFirstState())) {
        worklist.push(currBlockState.predecessors[j]->index);
      }
    }
  }
}

template<typename Lattice>
inline void MonotoneCFGAnalyzer<Lattice>::print(std::ostream& os) {
  os << "CFG Analyzer" << std::endl;
  for (auto state : stateBlocks) {
    state.print(os);
  }
  os << "End" << std::endl;
}

} // namespace wasm::analysis

#endif // wasm_analysis_monotone_analyzer_impl_h
