#ifndef wasm_analysis_reaching_definitions_transfer_function_h
#define wasm_analysis_reaching_definitions_transfer_function_h

#include "ir/find_all.h"
#include "ir/local-graph.h"
#include "lattice.h"
#include "lattices/powerset.h"
#include "visitor-transfer-function.h"

namespace wasm::analysis {

// A state contains all the "live" LocalSet instances at some particular
// point in a program. The state tracks every LocalSet instance, not just
// ones which influence a particular local index.

// In addition to LocalSet expressions modifying a local index's value, we
// must also account for the fact that the value of a local index could be
// the default value at initialization or its value passed in as a parameter.
// As a result, we use a fictitious LocalSet object held by the transfer
// function to represent the local index obtaining its current value on
// initialization or parameter passing.

// Each local index gets an individual fictitious LocalSet, because the state
// tracks all local indices, and setting one local index should not affect the
// initial value of another.

// When collecting results, the transfer function takes the states and converts
// it into a map of LocalGets to LocalSets which affect it. The fictitious
// inital value LocalSetes will be converted to nullptrs.

class ReachingDefinitionsTransferFunction
  : public VisitorTransferFunc<ReachingDefinitionsTransferFunction,
                               FinitePowersetLattice<LocalSet*>,
                               AnalysisDirection::Forward> {

  // Number of locals in the function.
  size_t numLocals;

  // Maps a local index to a list of LocalSets that modify the index's value.
  // The most common case is to have a single set; after that, to be a phi of 2
  // items, so we use a small set of size 2 to avoid allocations there.
  std::unordered_map<Index, SmallVector<LocalSet*, 2>> indexSetses;

  // LocalGraph members we need to update.
  LocalGraph::GetSetsMap& getSetsMap;

  // Fictitious LocalSet objects to reprsent a local index obtaining its value
  // from its default initial value or parameter value.
  std::vector<LocalSet> fakeInitialValueSets;

  // Pointers to the fictitious LocalSet objects.
  std::unordered_set<LocalSet*> fakeSetPtrs;

  // Helper function which creates fictitious LocalSets for a function,
  // inserts them into fakeInitialValueSets and fakeSetPtrs. It returns a
  // vector of actual LocalSets in the function and fictitious LocalSets for
  // use when instatitating the lattice.
  static std::vector<LocalSet*>
  listLocalSets(Function* func,
                std::vector<LocalSet>& fakeInitialValueSets,
                std::unordered_set<LocalSet*>& fakeSetPtrs) {
    // Create a fictitious LocalSet for each local index.
    for (Index i = 0; i < func->getNumLocals(); ++i) {
      LocalSet currSet;
      currSet.index = i;
      fakeInitialValueSets.push_back(currSet);
    }

    // Find all actual LocalSets.
    FindAll<LocalSet> setFinder(func->body);
    std::vector<LocalSet*> setsList = std::move(setFinder.list);

    // Take a pointer for each fictitious LocalSet.
    for (size_t i = 0; i < fakeInitialValueSets.size(); ++i) {
      setsList.push_back(&fakeInitialValueSets[i]);
      fakeSetPtrs.insert(&fakeInitialValueSets[i]);
    }
    return setsList;
  }

public:
  // Analysis lattice. Public, as the monotone analyzer may need it.
  FinitePowersetLattice<LocalSet*> lattice;

  // We actually don't update LocalGraph::Locations right now since the CFG we
  // are working with doesn't contain the correct Expression**s, but this is
  // left in for future improvements. TODO.
  ReachingDefinitionsTransferFunction(Function* func,
                                      LocalGraph::GetSetsMap& getSetsMap,
                                      LocalGraph::Locations& locations)
    : numLocals(func->getNumLocals()), getSetsMap(getSetsMap),
      lattice(listLocalSets(func, fakeInitialValueSets, fakeSetPtrs)) {

    // Map every local index to a set of all the local sets which affect it.
    for (auto it = lattice.membersBegin(); it != lattice.membersEnd(); ++it) {
      indexSetses[(*it)->index].push_back(*it);
    }
  }

  void visitLocalSet(LocalSet* curr) {
    assert(currState);

    // This is only needed to derive states when solving the analysis, and
    // not for collecting results from the final states.

    // For a LocalSet, we remove all previous sets modifying its index and
    // adds itself.
    auto& currSets = indexSetses[curr->index];
    for (auto setInstance : currSets) {
      lattice.remove(currState, setInstance);
    }

    lattice.add(currState, curr);
  }

  // Only for collecting results. For curr, collects all of the sets to curr's
  // index which are present in the state (i.e. those that set index's current
  // value).
  void visitLocalGet(LocalGet* curr) {
    assert(currState);

    // This is only to be run in the second phase where we iterate over the
    // final (i.e. solved) states. Thus, only done when collectingResults is
    // true.
    if (collectingResults) {
      auto& matchingSets = indexSetses[curr->index];

      for (auto setInstance : matchingSets) {
        if (lattice.exists(currState, setInstance)) {
          // If a pointer to a real LocalSet, add it, otherwise add a nullptr.
          if (fakeSetPtrs.find(setInstance) == fakeSetPtrs.end()) {
            getSetsMap[curr].insert(setInstance);
          } else {
            getSetsMap[curr].insert(nullptr);
          }
        }
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
    for (auto currSet : fakeSetPtrs) {
      lattice.add(&inputState, currSet);
    }
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
