#ifndef wasm_analysis_reaching_definitions_transfer_function_h
#define wasm_analysis_reaching_definitions_transfer_function_h

#include "ir/local-graph.h"
#include "visitor-transfer-function.h"

namespace wasm::analysis {

class ReachingDefinitionsTransferFunction
  : public VisitorTransferFunc<ReachingDefinitionsTransferFunction, FinitePowersetLattice<LocalSet*>, false> {
  // In addition to LocalSet expressions modifying a local index's value, we
  // must also account for the fact that the local index's default value at
  // initialization is used, or that it already has a value at the beginning.
  // Therefore, when creating the powerset lattice from the list of all
  // LocalSetses, we also append a list of nullptrs  numLocals long, one for
  // each local index, at the end of the list of all LocalSetses. These nullptrs
  // represent the use of a default/param value.

  // FinitePowersetLattice<LocalSet*>::Element* currState = nullptr;
  FinitePowersetLattice<LocalSet*>& lattice;

  // Number of locals in a function.
  size_t numLocals;

  // Maps a local index to a list of LocalSets that modify the index's value.
  std::unordered_map<Index, SmallVector<LocalSet*, 2>> indexSetses;

  // LocalGraph members we need to update.
  LocalGraph::GetSetses& getSetses;

  // We actually don't update locations right now since the CFG we are working
  // with doesn't contain the correct Expression**s, but this is left in for
  // future improvements. TODO.
  LocalGraph::Locations& locations;

  // Signals to the visit functions whether we are solving the analysis, or
  // collecting results from the solved analysis.
  bool collectingResults = false;

public:
  ReachingDefinitionsTransferFunction(FinitePowersetLattice<LocalSet*>& lattice,
                                      size_t numLocals, LocalGraph::GetSetses& getSetses, LocalGraph::Locations& locations)
    : lattice(lattice), numLocals(numLocals), getSetses(getSetses), locations(locations) {

    // Populate indexSetses.
    for (auto it = lattice.membersBegin();
         it != lattice.membersEnd() - numLocals;
         ++it) {
      indexSetses[(*it)->index].push_back(*it);
    }
  }

  // Sets the LocalGraph members we want to update, and signals that result
  // collection is about to begin.
  void beginResultCollection() {
    collectingResults = true;
  }

  // Signals that we have stopped result collection.
  void endResultCollection() { collectingResults = false; }

  void visitLocalSet(LocalSet* curr) {
    assert(currState);

    // For a LocalSet, we remove all previous setses modifying its index and
    // adds itself.
    auto& currSetses = indexSetses[curr->index];
    for (auto setInstance : currSetses) {
      lattice.remove(currState, setInstance);
    }

    // Removing all previous setses means that the default initial/parameter
    // value is overwritten, so we need to remove this possibility from the
    // state too.
    currState->set(lattice.getSetSize() - numLocals + curr->index, false);
    lattice.add(currState, curr);
  }

  // Only for collecting results. For curr, collects all of the sets to curr's
  // index which are present in the state (i.e. those that set index's current
  // value).
  void visitLocalGet(LocalGet* curr) {
    assert(currState);
    if (collectingResults) {
      auto& matchingSetses = indexSetses[curr->index];

      for (auto setInstance : matchingSetses) {
        if (lattice.exists(currState, setInstance)) {
          getSetses[curr].insert(setInstance);
        }
      }

      // LocalGraph uses a nullptr to signify that the value obtained by Curr
      // could be a default initial value or a parameter value.
      if (currState->get(lattice.getSetSize() - numLocals + curr->index)) {
        getSetses[curr].insert(nullptr);
      }
    }
  }

  // At the entry point of the function, we must set the state to signify that
  // the values in each local index are from either a parameter value or their
  // default initialized value. This cannot be done normally, because the
  // initial state of the entry block is initialized as the bottom element, but
  // no one can modify it because this block doesn't depend on any other. Hence
  // the need for this function.
  void
  evaluateFunctionEntry(Function* func,
                        FinitePowersetLattice<LocalSet*>::Element& inputState) {
    for (size_t i = 0; i < numLocals; ++i) {
      inputState.set(lattice.getSetSize() - numLocals + i, true);
    }
  }
/*
  void transfer(const BasicBlock* cfgBlock,
                FinitePowersetLattice<LocalSet*>::Element& inputState) {
    currState = &inputState;

    for (auto cfgIter = cfgBlock->begin(); cfgIter != cfgBlock->end();
         ++cfgIter) {
      visit(*cfgIter);
    }
    currState = nullptr;
  }

  // This is a forward analysis, so we push all the block in forward order to
  // reduce calculation in the worklist algorithm.
  void enqueueWorklist(CFG& cfg, std::queue<const BasicBlock*>& worklist) {
    for (auto it = cfg.begin(); it != cfg.end(); ++it) {
      worklist.push(&(*it));
    }
  }

  // All of a block's successors rely on it for information.
  BasicBlock::Successors getDependents(const BasicBlock* currBlock) {
    return currBlock->succs();
  }

  void collectResults(const BasicBlock* cfgBlock,
                      FinitePowersetLattice<LocalSet*>::Element& inputState) {
    // There is currently no difference between the two functions, because the
    // difference is in the visit functions.
    transfer(cfgBlock, inputState);
  }
*/
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
