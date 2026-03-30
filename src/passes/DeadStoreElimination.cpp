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

  // A struct.get observed this store. It may or may not be dead besides that (check `duplicateStores` for that) but it is definitely not dead because of the get.
  int conflictingGets = 0;


  bool conflictingEffects = 0;
};

enum class Barrier {
  None,
  Branch,
};

using Info = std::variant<StoreInfo, Barrier>;

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
    std::vector<Info> storeInfos;
    for (auto& block : cfg) {
      for (const auto* inst : block) {
        if (const StructSet* structSet = inst->dynCast<StructSet>()) {
          std::vector<Barrier> barriers;
          for (auto it = storeInfos.rbegin(); it != storeInfos.rend(); ++it) {
            if (auto* storeInfo = std::get_if<StoreInfo>(&*it)) {
              if (localGraph.equalValues(structSet->ref, storeInfo->store->ref) &&
                  structSet->index == storeInfo->store->index) {
                storeInfo->duplicateStores++;

                if (!barriers.empty()) {
                  storeInfo->conflictingEffects = true;
                }
                break;
              }
            } else if (auto* barrier = std::get_if<Barrier>(&*it)) {
              barriers.push_back(*barrier);
            }
          }
          storeInfos.push_back(StoreInfo{structSet});
        } else if (const StructGet* structGet = inst->dynCast<StructGet>()) {
          for (auto it = storeInfos.rbegin(); it != storeInfos.rend(); ++it) {
            // Don't care about barriers here.
            if (!std::holds_alternative<StoreInfo>(*it)) {
              continue;
            }

            auto& storeInfo = std::get<StoreInfo>(*it);

            if (localGraph.equalValues(structGet->ref, storeInfo.store->ref) &&
                structGet->index == storeInfo.store->index) {
              storeInfo.conflictingGets++;
              break;
            }
          }
        } else {
          ShallowEffectAnalyzer effects(getPassOptions(), *module, const_cast<Expression*>(inst));
          if (effects.branchesOut) {
            storeInfos.push_back(Barrier::Branch);
          }
        }
      }
    }

    for (const auto& info : storeInfos) {
      if (!std::holds_alternative<StoreInfo>(info)) {
        continue;
      }

      auto& storeInfo = std::get<StoreInfo>(info);

      if (storeInfo.duplicateStores && !storeInfo.conflictingGets && !storeInfo.conflictingEffects) {
        std::lock_guard _(m);
        std::cout<<storeInfo.duplicateStores<<"\n";
      }
    }
  }
};

} // namespace

Pass* createDeadStoreEliminationPass() {
  return new DeadStoreEliminationPass();
}

} // namespace wasm