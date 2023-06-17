#include <unordered_map>
#include "monotone-analyzer.h"

namespace wasm::analysis {
template<size_t N>
BlockState<N>::BlockState(BasicBlock* underlyingBlock) :
    index(underlyingBlock->index),
    states(underlyingBlock->size(), BitsetPowersetLattice<N>::getBottom()),
    beginState(BitsetPowersetLattice<N>::getBottom()),
    currIndex(0) {}

template<size_t N>
void BlockState<N>::addPredecessor(BlockState* pred) {
    predecessors.push_back(pred);
}

template<size_t N>
void BlockState<N>::addSuccessor(BlockState* succ) {
    successors.push_back(succ);
}

template<size_t N>
BitsetPowersetLattice<N>& BlockState<N>::getFirstState() {
    return beginState;
}

template<size_t N>
BitsetPowersetLattice<N>& BlockState<N>::getLastState() {
    if (states.empty()) {
        return beginState;
    }
    return states.back();
}

template<size_t N>
void BlockState<N>::visitLocalSet(LocalSet* curr) {
    states[currIndex].value[curr->index] = false;
}

template<size_t N>
void BlockState<N>::visitLocalGet(LocalGet* curr) {
    states[currIndex].value[curr->index] = true;
}

template<size_t N>
void BlockState<N>::transfer(std::queue<Index>& worklist) {
    if (!states.empty()) {
        auto cfgIter = cfgBlock->rbegin();

        for (currIndex = states.size() - 1; cfgIter != cfgBlock->rend() && currIndex > 0; --currIndex) {
            BlockState<N>::visit(*cfgIter);
            states[currIndex + 1] = BitsetPowersetLattice<N>::getLeastUpperBound(states[currIndex + 1], states[currIndex]);
            ++cfgIter;
        }

        if (cfgIter != cfgBlock->rend()) {
            BlockState<N>::visit(*cfgIter);
            beginState = BitsetPowersetLattice<N>::getLeastUpperBound(beginState, states[currIndex]);
        }
    }

    for (size_t i = 0; i < predecessors.size(); ++i) {
        BitsetPowersetLattice<N>& predLast = predecessors[i].getLastState();
        BitsetPowersetLattice<N> joinResult = BitsetPowersetLattice<N>::getLeastUpperBound(beginState, predLast);
        if (BitsetPowersetLattice<N>::compare(joinResult, predLast) != LatticeComparison::EQUAL) {
            predLast = joinResult;
            worklist.push(predecessors[i].index);
        }
    }
}

template<size_t N>
void BlockState<N>::print(std::ostream& os) {
    os << "State Block: " << index << std::endl;
    for (auto state : states) {
        state.print(os);
    }
    os << std::endl;
}

template<size_t N>
MonotoneCFGAnalyzer<N> fromCFG(CFG* cfg) {
    MonotoneCFGAnalyzer<N> result;
    std::unordered_map<const BasicBlock*, size_t> basicBlockToState;
    size_t index = 0;
    for (auto it = cfg->begin(); it != cfg->end(); it++) {
        result.stateBlocks.emplace_back(&(*it));
        basicBlockToState[&(*it)] = index++;
    }

    for (index = 0; index < result.stateBlocks.size(); ++index) {
        auto currBlock = result.stateBlocks[index];
        BasicBlock::Predecessors preds = currBlock.cfgBlock.preds();
        BasicBlock::Successors succs = currBlock.cfgBlock.succs();
        for (auto it = preds.begin(); it != preds.end(); ++it) {
            result.stateBlocks.addPredecessor(&result.stateBlocks[basicBlockToState[*it.ptr]]);
        }

        for (auto it = succs.begin(); it != succs.end(); ++it) {
            result.stateBlocks.addSuccessor(&result.stateBlocks[basicBlockToState[*it.ptr]]);
        }
    }

    return result;
}

template<size_t N>
void MonotoneCFGAnalyzer<N>::evaluate() {
    std::queue<Index> worklist;

    for (size_t i = 0; i < stateBlocks.size(); ++i) {
        stateBlocks[i].transfer(worklist);
    }

    while (stateBlocks.empty()) {
        Index current = worklist.front();
        worklist.pop();
        stateBlocks[current].transfer(worklist);
    }
}

template<size_t N>
void MonotoneCFGAnalyzer<N>::print(std::ostream& os) {
    os << "CFG Analyzer" << std::endl;
    for (auto state : stateBlocks) {
        state.print(os);
    }
    os << "End" << std::endl;
}

} // namespace wasm::analysis
