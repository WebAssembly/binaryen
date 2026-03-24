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
    if (auto* aConst = a->dynCast<Const>()) {
      if (auto* bConst = b->dynCast<Const>()) {
        return aConst->value == bConst->value;
      }
    }
    return false;
  }
};

class DeadStoreEliminationPass : public Pass {
  virtual std::unique_ptr<Pass> create() {
    return std::make_unique<DeadStoreEliminationPass>();
  }

  bool isFunctionParallel() override { return true; }

  // void run(Module* module) override {
  //     ModuleUtils::iterDefinedFunctions(*module, [this, module](auto*
  //     function) { runOnFunction(module, function); });
  // }

  int totalDeadStores{0};

  // struct DeadStoreInfo {
  //   const StructSet* store;
  //   std::vector<const StructGet*> conflictingGets;
  // };

  void runOnFunction(Module* module, Function* function) override {
    // std::cout<<"Ran on function " << function->name<< "\n";

    ComparingLocalGraph localGraph(function, getPassOptions(), *module);

    auto cfg = analysis::CFG::fromFunction(function);

    // todo might want to use a map here
    // keyed by the ref expression
    int deadStoreCount = 0;
    for (auto& block : cfg) {
      std::vector<const StructSet*> potentiallyDeadSets;
      // std::vector<DeadStoreInfo> potentiallyDeadSets;
      for (const auto* inst : block) {
        if (const StructSet* structSet = inst->dynCast<StructSet>()) {
          bool found = false;
          // for (auto* otherSet : potentiallyDeadSets) {
          for (auto* otherSet : potentiallyDeadSets) {
            if (localGraph.equalValues(structSet->ref, otherSet->ref) &&
                structSet->index == otherSet->index) {
              deadStoreCount++;
              found = true;
            }
          }
          if (!found) {
            potentiallyDeadSets.push_back(structSet);
          }
        // } else if (const StructGet* structGet = inst->dynCast<StructGet>())
          // { structGet->ref->dump();
        // } else if (const StructGet* structGet = inst->dynCast<StructGet>()) {
        //   for (const auto* set : potentiallyDeadSets) {
        //     if (localGraph.equalValues(set->ref, structGet->ref)) {

        //     }
        //   }
        }
      }
    }

    std::lock_guard _(m);
    totalDeadStores += deadStoreCount;

    std::cout<<totalDeadStores<<"\n";
  }
};

} // namespace

Pass* createDeadStoreEliminationPass() {
  return new DeadStoreEliminationPass();
}

} // namespace wasm