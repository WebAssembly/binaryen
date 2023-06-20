#ifndef wasm_analysis_monotone_analyzer_h
#define wasm_analysis_monotone_analyzer_h

#include <iostream>
#include <vector>
#include <queue>

#include "wasm-traversal.h"
#include "cfg.h"
#include "lattice.h"

namespace wasm::analysis {

template<size_t N>
struct MonotoneCFGAnalyzer;

template<size_t N>
struct BlockState : public UnifiedExpressionVisitor<BlockState<N>> {
    BlockState(const BasicBlock* underlyingBlock);

    void addPredecessor(BlockState* pred);
    void addSuccessor(BlockState* succ);

    BitsetPowersetLattice<N>& getFirstState();
    BitsetPowersetLattice<N>& getLastState();

    void visitLocalSet(LocalSet* curr);
    void visitLocalGet(LocalGet* curr);

    void transfer(std::queue<Index>& worklist);

    void print(std::ostream& os);

    private:
    Index index;
    const BasicBlock* cfgBlock;
    BitsetPowersetLattice<N> beginState;
    std::vector<BitsetPowersetLattice<N>> states;
    std::vector<BlockState*> predecessors;
    std::vector<BlockState*> successors;
    size_t currIndex;
    friend MonotoneCFGAnalyzer<N>;
};

template<size_t N>
struct MonotoneCFGAnalyzer {
    static MonotoneCFGAnalyzer<N> fromCFG(CFG* cfg);

    void evaluate();

    void print(std::ostream& os);

    private:
    std::vector<BlockState<N>> stateBlocks;
    friend BlockState<N>;
};

} // namespace wasm::analysis

#include "monotone-analyzer-impl.h"

#endif // wasm_analysis_monotone_analyzer_h
