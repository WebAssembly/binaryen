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

struct StoreInfo {
  const StructSet* store = nullptr;
  int duplicateStores = 0;
  int conflictingGets = 0;
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
    std::vector<StoreInfo> storeInfos;
    for (auto& block : cfg) {
      for (const auto* inst : block) {
        if (const StructSet* structSet = inst->dynCast<StructSet>()) {
          for (auto it = storeInfos.rbegin(); it != storeInfos.rend(); ++it) {
            auto& storeInfo = *it;

            if (localGraph.equalValues(structSet->ref, storeInfo.store->ref) &&
                structSet->index == storeInfo.store->index) {
              storeInfo.duplicateStores++;
              break;
            }
          }
          storeInfos.push_back(StoreInfo{structSet});
        } else if (const StructGet* structGet = inst->dynCast<StructGet>()) {
          for (auto it = storeInfos.rbegin(); it != storeInfos.rend(); ++it) {
            auto& storeInfo = *it;

            if (localGraph.equalValues(structGet->ref, storeInfo.store->ref) &&
                structGet->index == storeInfo.store->index) {
              storeInfo.conflictingGets++;
              break;
            }
          }
        }
      }
    }

    for (const auto& info : storeInfos) {
      if (info.duplicateStores && !info.conflictingGets) {
        std::lock_guard _(m);
        std::cout<<info.duplicateStores<<"\n";
      }
    }
  }
};

} // namespace

Pass* createDeadStoreEliminationPass() {
  return new DeadStoreEliminationPass();
}

} // namespace wasm