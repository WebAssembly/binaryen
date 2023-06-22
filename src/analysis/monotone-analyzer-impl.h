#ifndef wasm_analysis_monotone_analyzer_impl_h
#define wasm_analysis_monotone_analyzer_impl_h

#include <iostream>
#include <unordered_map>

#include "monotone-analyzer.h"

namespace wasm::analysis {
template<size_t N>
inline BlockState<N>::BlockState(const BasicBlock* underlyingBlock)
  : index(underlyingBlock->getIndex()), cfgBlock(underlyingBlock),
    beginningState(BitsetPowersetLattice<N>::getBottom()),
    endState(BitsetPowersetLattice<N>::getBottom()),
    currState(BitsetPowersetLattice<N>::getBottom()) {}

template<size_t N> inline void BlockState<N>::addPredecessor(BlockState* pred) {
  predecessors.push_back(pred);
}

template<size_t N> inline void BlockState<N>::addSuccessor(BlockState* succ) {
  successors.push_back(succ);
}

template<size_t N>
inline BitsetPowersetLattice<N>& BlockState<N>::getFirstState() {
  return beginningState;
}

template<size_t N>
inline BitsetPowersetLattice<N>& BlockState<N>::getLastState() {
  return endState;
}

// In our current limited implementation, we just update a new live variable
// when it it is used in a get or set.
template<size_t N> inline void BlockState<N>::visitLocalSet(LocalSet* curr) {
  currState.value[curr->index] = false;
}

template<size_t N> inline void BlockState<N>::visitLocalGet(LocalGet* curr) {
  currState.value[curr->index] = true;
}

template<size_t N> inline void BlockState<N>::transfer() {
  // If the block is empty, we propagate the state by endState = currState, then
  // currState = beginningState

  // compute transfer function for all expressions in the CFG block
  auto cfgIter = cfgBlock->rbegin();
  currState = endState;

  while (cfgIter != cfgBlock->rend()) {
    // run transfer function.
    BlockState<N>::visit(*cfgIter);
    ++cfgIter;
  }
  beginningState = currState;
}

template<size_t N> inline void BlockState<N>::print(std::ostream& os) {
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
    BlockState<N>::visit(*cfgIter);
    currState.print(os);
    os << std::endl;
    ++cfgIter;
  }
}

template<size_t N>
MonotoneCFGAnalyzer<N> inline MonotoneCFGAnalyzer<N>::fromCFG(CFG* cfg) {
  MonotoneCFGAnalyzer<N> result;

  // Map BasicBlocks to each BlockState's index
  std::unordered_map<const BasicBlock*, size_t> basicBlockToState;
  size_t index = 0;
  for (auto it = cfg->begin(); it != cfg->end(); it++) {
    result.stateBlocks.emplace_back(&(*it));
    basicBlockToState[&(*it)] = index++;
  }

  // Update predecessors and successors of each BlockState object
  // according to the BasicBlock's predecessors and successors.
  for (index = 0; index < result.stateBlocks.size(); ++index) {
    BlockState<N>& currBlock = result.stateBlocks.at(index);
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

template<size_t N> inline void MonotoneCFGAnalyzer<N>::evaluate() {
  std::queue<Index> worklist;

  for (auto it = stateBlocks.rbegin(); it != stateBlocks.rend(); ++it) {
    worklist.push(it->index);
  }

  while (!worklist.empty()) {
    BlockState<N>& currBlockState = stateBlocks[worklist.front()];
    worklist.pop();
    currBlockState.transfer();

    // Propagate state to dependents
    for (size_t j = 0; j < currBlockState.predecessors.size(); ++j) {
      BitsetPowersetLattice<N>& predLast =
        currBlockState.predecessors[j]->getLastState();

      LatticeComparison cmp = BitsetPowersetLattice<N>::compare(
        predLast, currBlockState.getFirstState());

      if (cmp == LatticeComparison::NO_RELATION ||
          cmp == LatticeComparison::LESS) {
        predLast.getLeastUpperBound(currBlockState.getFirstState());
        worklist.push(currBlockState.predecessors[j]->index);
      }
    }
  }
}

template<size_t N> inline void MonotoneCFGAnalyzer<N>::print(std::ostream& os) {
  os << "CFG Analyzer" << std::endl;
  for (auto state : stateBlocks) {
    state.print(os);
  }
  os << "End" << std::endl;
}

} // namespace wasm::analysis

#endif // wasm_analysis_monotone_analyzer_impl_h
