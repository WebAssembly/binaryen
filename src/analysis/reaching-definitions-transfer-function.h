#ifndef wasm_analysis_reaching_definitions_transfer_function_h
#define wasm_analysis_reaching_definitions_transfer_function_h

#include "ir/local-graph.h"
#include "lattice.h"
#include "monotone-analyzer.h"
#include "wasm-traversal.h"

namespace wasm::analysis {

class ReachingDefinitionsTransferFunction
  : public Visitor<ReachingDefinitionsTransferFunction> {
  FinitePowersetLattice<LocalSet*>::Element* currState = nullptr;
  FinitePowersetLattice<LocalSet*>& lattice;
  size_t numLocals;
  std::unordered_map<Index, SmallVector<LocalSet*, 2>> indexSetses;

  LocalGraph::GetSetses* getSetses = nullptr;
  LocalGraph::Locations* locations = nullptr;
  bool collectingResults = false;

public:
  ReachingDefinitionsTransferFunction(FinitePowersetLattice<LocalSet*>& lattice,
                                      size_t numLocals)
    : lattice(lattice), numLocals(numLocals) {
    for (auto it = lattice.membersBegin();
         it != lattice.membersEnd() - numLocals;
         ++it) {
      indexSetses[(*it)->index].push_back(*it);
    }
  }

  void beginResultCollection(LocalGraph::GetSetses* getSetses,
                             LocalGraph::Locations* locations) {
    this->getSetses = getSetses;
    this->locations = locations;
    collectingResults = true;
  }

  void endResultCollection() { collectingResults = false; }

  void visitLocalSet(LocalSet* curr) {
    assert(currState);

    auto& currSetses = indexSetses[curr->index];
    for (auto setInstance : currSetses) {
      lattice.remove(currState, setInstance);
    }
    currState->set(lattice.getSetSize() - numLocals + curr->index, false);
    lattice.add(currState, curr);

    if (collectingResults) {
      Expression* currExpr = curr;
      Expression** currp = &currExpr;
      (*locations)[currExpr] = currp;
    }
  }

  void visitLocalGet(LocalGet* curr) {
    if (collectingResults) {
      auto& matchingSetses = indexSetses[curr->index];

      for (auto setInstance : matchingSetses) {
        if (lattice.exists(currState, setInstance)) {
          (*getSetses)[curr].insert(setInstance);
        }
      }

      if (currState->get(lattice.getSetSize() - numLocals + curr->index)) {
        (*getSetses)[curr].insert(nullptr);
      }

      Expression* currExpr = curr;
      Expression** currp = &currExpr;
      (*locations)[currExpr] = currp;
    }
  }

  void transfer(const BasicBlock* cfgBlock,
                FinitePowersetLattice<LocalSet*>::Element& inputState) {
    currState = &inputState;
    auto preds = cfgBlock->preds();
    if (preds.begin() == preds.end()) {
      for (size_t i = 0; i < numLocals; ++i) {
        currState->set(lattice.getSetSize() - i - 1, true);
      }
    }

    for (auto cfgIter = cfgBlock->begin(); cfgIter != cfgBlock->end();
         ++cfgIter) {
      visit(*cfgIter);
    }
    currState = nullptr;
  }

  void enqueueWorklist(CFG& cfg, std::queue<const BasicBlock*>& worklist) {
    for (auto it = cfg.begin(); it != cfg.end(); ++it) {
      worklist.push(&(*it));
    }
  }

  BasicBlock::Successors getDependents(const BasicBlock* currBlock) {
    return currBlock->succs();
  }

  void collectResults(const BasicBlock* cfgBlock,
                      FinitePowersetLattice<LocalSet*>::Element& inputState) {
    currState = &inputState;
    auto preds = cfgBlock->preds();
    if (preds.begin() == preds.end()) {
      for (size_t i = 0; i < numLocals; ++i) {
        currState->set(lattice.getSetSize() - i - 1, true);
      }
    }
    for (auto cfgIter = cfgBlock->begin(); cfgIter != cfgBlock->end();
         ++cfgIter) {
      visit(*cfgIter);
    }
    currState = nullptr;
  }

  void print(std::ostream& os,
             const BasicBlock* cfgBlock,
             FinitePowersetLattice<LocalSet*>::Element& inputState) {
    os << "Intermediate States: " << std::endl;
    currState = &inputState;
    currState->print(os);
    os << std::endl;
    auto cfgIter = cfgBlock->begin();

    // Since we don't store the intermediate states, we need to re-run the
    // transfer function on all the CFG node expressions to reconstruct
    // the intermediate states here.
    while (cfgIter != cfgBlock->end()) {
      os << ShallowExpression{*cfgIter} << std::endl;
      visit(*cfgIter);
      currState->print(os);
      os << std::endl;
      ++cfgIter;
    }
    currState = nullptr;
  }
};

} // namespace wasm::analysis

#endif // wasm_analysis_reaching_definitions_transfer_function_h
