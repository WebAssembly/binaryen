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
  : index(underlyingBlock->getIndex()), cfgBlock(underlyingBlock),
    beginningState(lattice.getBottom()), endState(lattice.getBottom()),
    currState(lattice.getBottom()) {}

// In our current limited implementation, we just update state on gets
// and sets of local indices.
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
  // currState = beginningState.

  // Compute transfer function for all expressions in the CFG block.
  auto cfgIter = cfgBlock->rbegin();
  currState = endState;

  while (cfgIter != cfgBlock->rend()) {
    // Run transfer function.
    BlockState::visit(*cfgIter);
    ++cfgIter;
  }
  beginningState = std::move(currState);
}

template<typename Lattice>
inline void BlockState<Lattice>::print(std::ostream& os) {
  os << "State Block: " << index << std::endl;
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
  os << std::endl << "Intermediate States (reverse order): " << std::endl;

  currState = endState;
  currState.print(os);
  os << std::endl;
  auto cfgIter = cfgBlock->rbegin();

  // Since we don't store the intermediate states in the BlockState, we need to
  // re-run the transfer function on all the CFG node expressions to reconstruct
  // the intermediate states here.
  while (cfgIter != cfgBlock->rend()) {
    os << ShallowExpression{*cfgIter} << std::endl;
    BlockState::visit(*cfgIter);
    currState.print(os);
    os << std::endl;
    ++cfgIter;
  }
}

template<typename Lattice>
inline void MonotoneCFGAnalyzer<Lattice>::fromCFG(CFG* cfg) {
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
    BasicBlock::Predecessors preds = currBlock.cfgBlock->preds();
    BasicBlock::Successors succs = currBlock.cfgBlock->succs();
    for (auto& pred : preds) {
      currBlock.predecessors.push_back(&stateBlocks[basicBlockToState[&pred]]);
    }

    for (auto& succ : succs) {
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

    // For each expression, applies the transfer function, using the expression,
    // on the state of the expression it depends upon (here the next expression)
    // to arrive at the expression's state. The beginning and end states of the
    // CFG block will be updated.
    currBlockState.transfer();

    // Propagate state to dependents
    for (size_t j = 0; j < currBlockState.predecessors.size(); ++j) {
      if (currBlockState.predecessors[j]->getLastState().makeLeastUpperBound(
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
