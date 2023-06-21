#ifndef wasm_analysis_monotone_analyzer_impl_h
#define wasm_analysis_monotone_analyzer_impl_h

#include <iostream>
#include <unordered_map>

#include "monotone-analyzer.h"

namespace wasm::analysis {
template<size_t N>
BlockState<N>::BlockState(const BasicBlock* underlyingBlock)
  : index(underlyingBlock->getIndex()), cfgBlock(underlyingBlock),
    states(underlyingBlock->size() + 1, BitsetPowersetLattice<N>::getBottom()),
    currIndex(0) {}

template<size_t N> void BlockState<N>::addPredecessor(BlockState* pred) {
  predecessors.push_back(pred);
}

template<size_t N> void BlockState<N>::addSuccessor(BlockState* succ) {
  successors.push_back(succ);
}

template<size_t N> BitsetPowersetLattice<N>& BlockState<N>::getFirstState() {
  return states.front();
}

template<size_t N> BitsetPowersetLattice<N>& BlockState<N>::getLastState() {
  return states.back();
}

// In our current limited implementation, we just update a new live variable
// when it it is used in a get or set.
template<size_t N> void BlockState<N>::visitLocalSet(LocalSet* curr) {
  states[currIndex].value[curr->index] = true;
}

template<size_t N> void BlockState<N>::visitLocalGet(LocalGet* curr) {
  states[currIndex].value[curr->index] = true;
}

template<size_t N> void BlockState<N>::transfer(std::queue<Index>& worklist) {
  // compute transfer function for all expressions in the CFG block
  if (states.size() > 1) {
    auto cfgIter = cfgBlock->rbegin();
    currIndex = states.size() - 2;

    for (currIndex = states.size() - 2; cfgIter != cfgBlock->rend();
         --currIndex) {
      // propagate state from previous state (i. e. join).
      states[currIndex] = BitsetPowersetLattice<N>::getLeastUpperBound(
        states[currIndex + 1], states[currIndex]);

      // run transfer function.
      BlockState<N>::visit(*cfgIter);
      ++cfgIter;
    }
  }

  // Propagate state to all predecessors (since this is a backward analysis).
  for (size_t i = 0; i < predecessors.size(); ++i) {
    BitsetPowersetLattice<N>& predLast = predecessors[i]->getLastState();
    BitsetPowersetLattice<N> joinResult =
      BitsetPowersetLattice<N>::getLeastUpperBound(states[0], predLast);
    if (BitsetPowersetLattice<N>::compare(joinResult, predLast) !=
        LatticeComparison::EQUAL) {
      predLast = joinResult;
      worklist.push(predecessors[i]->index);
    }
  }
}

template<size_t N> void BlockState<N>::print(std::ostream& os) {
  os << "State Block: " << index << std::endl;
  os << "State at beginning: ";
  for (auto state : states) {
    state.print(os);
  }
  os << std::endl;
}

template<size_t N>
MonotoneCFGAnalyzer<N> MonotoneCFGAnalyzer<N>::fromCFG(CFG* cfg) {
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
    for (auto it = preds.begin(); it != preds.end(); ++it) {
      currBlock.addPredecessor(&result.stateBlocks[basicBlockToState[*it.ptr]]);
    }

    for (auto it = succs.begin(); it != succs.end(); ++it) {
      currBlock.addSuccessor(&result.stateBlocks[basicBlockToState[*it.ptr]]);
    }
  }

  return result;
}

template<size_t N> void MonotoneCFGAnalyzer<N>::evaluate() {
  std::queue<Index> worklist;

  for (size_t i = 0; i < stateBlocks.size(); ++i) {
    stateBlocks[i].transfer(worklist);
  }

  while (!worklist.empty()) {
    Index current = worklist.front();
    worklist.pop();
    stateBlocks[current].transfer(worklist);
  }
}

template<size_t N> void MonotoneCFGAnalyzer<N>::print(std::ostream& os) {
  os << "CFG Analyzer" << std::endl;
  for (auto state : stateBlocks) {
    state.print(os);
  }
  os << "End" << std::endl;
}

} // namespace wasm::analysis

#endif // wasm_analysis_monotone_analyzer_impl_h
