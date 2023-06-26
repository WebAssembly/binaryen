#ifndef wasm_analysis_monotone_analyzer_impl_h
#define wasm_analysis_monotone_analyzer_impl_h

#include <iostream>
#include <unordered_map>

#include "monotone-analyzer.h"

namespace wasm::analysis {
inline BlockState::BlockState(const BasicBlock* underlyingBlock, size_t size)
  : index(underlyingBlock->getIndex()), cfgBlock(underlyingBlock),
    beginningState(FinitePowersetLattice::getBottom(size)),
    endState(FinitePowersetLattice::getBottom(size)),
    currState(FinitePowersetLattice::getBottom(size)) {}

inline void BlockState::addPredecessor(BlockState* pred) {
  predecessors.push_back(pred);
}

inline void BlockState::addSuccessor(BlockState* succ) {
  successors.push_back(succ);
}

inline FinitePowersetLattice& BlockState::getFirstState() {
  return beginningState;
}

inline FinitePowersetLattice& BlockState::getLastState() { return endState; }

// In our current limited implementation, we just update a new live variable
// when it it is used in a get or set.
inline void BlockState::visitLocalSet(LocalSet* curr) {
  currState.set(curr->index, false);
}

inline void BlockState::visitLocalGet(LocalGet* curr) {
  currState.set(curr->index, true);
}

inline void BlockState::transfer() {
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

inline void BlockState::print(std::ostream& os) {
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

MonotoneCFGAnalyzer inline MonotoneCFGAnalyzer::fromCFG(CFG* cfg, size_t size) {
  MonotoneCFGAnalyzer result;

  // Map BasicBlocks to each BlockState's index
  std::unordered_map<const BasicBlock*, size_t> basicBlockToState;
  size_t index = 0;
  for (auto it = cfg->begin(); it != cfg->end(); it++) {
    result.stateBlocks.emplace_back(&(*it), size);
    basicBlockToState[&(*it)] = index++;
  }

  // Update predecessors and successors of each BlockState object
  // according to the BasicBlock's predecessors and successors.
  for (index = 0; index < result.stateBlocks.size(); ++index) {
    BlockState& currBlock = result.stateBlocks.at(index);
    BasicBlock::Predecessors preds = currBlock.cfgBlock->preds();
    BasicBlock::Successors succs = currBlock.cfgBlock->succs();
    for (auto pred : preds) {
      currBlock.addPredecessor(&result.stateBlocks[basicBlockToState[&pred]]);
    }

    for (auto succ : succs) {
      currBlock.addSuccessor(&result.stateBlocks[basicBlockToState[&succ]]);
    }
  }

  return result;
}

inline void MonotoneCFGAnalyzer::evaluate() {
  std::queue<Index> worklist;

  for (auto it = stateBlocks.rbegin(); it != stateBlocks.rend(); ++it) {
    worklist.push(it->index);
  }

  while (!worklist.empty()) {
    BlockState& currBlockState = stateBlocks[worklist.front()];
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

inline void MonotoneCFGAnalyzer::print(std::ostream& os) {
  os << "CFG Analyzer" << std::endl;
  for (auto state : stateBlocks) {
    state.print(os);
  }
  os << "End" << std::endl;
}

} // namespace wasm::analysis

#endif // wasm_analysis_monotone_analyzer_impl_h
