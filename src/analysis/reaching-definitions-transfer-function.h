#ifndef wasm_analysis_reaching_definitions_transfer_function_h
#define wasm_analysis_reaching_definitions_transfer_function_h

#include "lattice.h"
#include "monotone-analyzer.h"
#include "wasm-traversal.h"

namespace wasm::analysis {

class ReachingDefinitionsTransferFunction
  : public Visitor<ReachingDefinitionsTransferFunction> {
  FinitePowersetLattice<LocalSet*>::Element* currState = nullptr;
  FinitePowersetLattice<LocalSet*>& lattice;
  std::unordered_map<Index, SmallVector<LocalSet*, 2>> indexSetses;

public:
  ReachingDefinitionsTransferFunction(FinitePowersetLattice<LocalSet*>& lattice)
    : lattice(lattice) {
    for (auto it = lattice.membersBegin(); it != lattice.membersEnd(); ++it) {
      indexSetses[(*it)->index].push_back(*it);
    }
  }

  void visitLocalSet(LocalSet* curr) {
    assert(currState);

    auto& currSetses = indexSetses[curr->index];
    for (auto setPos : currSetses) {
      lattice.remove(currState, setPos);
    }

    lattice.add(currState, curr);
  }

  void transfer(const BasicBlock* cfgBlock,
                FinitePowersetLattice<LocalSet*>::Element& inputState) {
    currState = &inputState;
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
