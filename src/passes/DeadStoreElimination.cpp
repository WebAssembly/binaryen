#include "analysis/cfg.h"
#include "ir/local-graph.h"
#include "ir/module-utils.h"
#include "ir/properties.h"
#include "pass.h"
#include "passes/passes.h"

namespace wasm {
namespace {

std::mutex m;

struct ComparingLocalGraph : public LocalGraph {
  PassOptions& passOptions;
  Module& wasm;

  ComparingLocalGraph(Function* func, PassOptions& passOptions, Module& wasm)
    : LocalGraph(func), passOptions(passOptions), wasm(wasm) {}

  // Check whether the values of two expressions will definitely be equal at
  // runtime.
  // TODO: move to LocalGraph if we find more users?
  bool equalValues(Expression* a, Expression* b) {
    a = Properties::getFallthrough(a, passOptions, wasm);
    b = Properties::getFallthrough(b, passOptions, wasm);
    if (auto* aGet = a->dynCast<LocalGet>()) {
      if (auto* bGet = b->dynCast<LocalGet>()) {
        if (LocalGraph::equivalent(aGet, bGet)) {
          return true;
        }
      }
    }

    // not relevant
    // if (auto* aConst = a->dynCast<Const>()) {
    //   if (auto* bConst = b->dynCast<Const>()) {
    //     return aConst->value == bConst->value;
    //   }
    // }
    return false;
  }
};

class DeadStoreEliminationPass : public Pass {
  virtual std::unique_ptr<Pass> create() {
    return std::make_unique<DeadStoreEliminationPass>();
  }

  bool isFunctionParallel() override { return true; }

  void runOnFunction(Module* module, Function* function) override {

    ComparingLocalGraph localGraph(function, getPassOptions(), *module);

    auto cfg = analysis::CFG::fromFunction(function);

    // todo might want to use a map here
    // keyed by the ref expression
    int deadStoreCount = 0;
    std::vector<const StructSet*> potentiallyDeadSets;
    for (auto& block : cfg) {
      for (const auto* inst : block) {
        if (const StructSet* structSet = inst->dynCast<StructSet>()) {
          bool found = false;
          for (auto* otherSet : potentiallyDeadSets) {
            if (localGraph.equalValues(structSet->ref, otherSet->ref) &&
                structSet->index == otherSet->index) {
              // We don't remove the dead store from potentiallyDeadSets, and we might increment multiple times on the same store, but that's fine.
              // If we have e.g. 3 stores in a row, we'll only record the first and increment deadStoreCount twice on the first
              deadStoreCount++;
              found = true;
            }
          }
          if (!found) {
            potentiallyDeadSets.push_back(structSet);
          }
        }
      }
    }

    if (deadStoreCount == 0) {
      return;
    }

    std::lock_guard _(m);
    std::cout<<deadStoreCount<<"\n";
  }
};

} // namespace

Pass* createDeadStoreEliminationPass() {
  return new DeadStoreEliminationPass();
}

} // namespace wasm