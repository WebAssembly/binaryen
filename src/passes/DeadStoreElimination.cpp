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

  // A struct.get observed this store. It may or may not be dead besides that
  // (check `duplicateStores` for that) but it is definitely not dead because of
  // the get.
  int conflictingGets = 0;

  // This is counted differently. If this is set, then there is definitely a
  // duplicate store, and this would definitely be dead if it weren't for these
  // effects (AND it's possible that there are conflicting gets as well).
  std::optional<EffectAnalyzer> conflictingEffects = std::nullopt;

  friend std::ostream& operator<<(std::ostream& os, const StoreInfo& info) {
    os << "StoreInfo { ";

    // Handle the pointer to StructSet
    os << "store: ";
    if (info.store) {
      os << *info.store;
    } else {
      os << "nullptr";
    }

    os << ", duplicateStores: " << info.duplicateStores;
    os << ", conflictingGets: " << info.conflictingGets;

    // Handle the std::optional EffectAnalyzer
    os << ", conflictingEffects: ";
    if (info.conflictingEffects.has_value()) {
      os << *info.conflictingEffects;
    } else {
      os << "none";
    }

    os << " }";
    return os;
  }

  // }
};

using Info = std::variant<StoreInfo, EffectAnalyzer>;

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
          // std::vector<Barrier> barriers;
          EffectAnalyzer barriers(getPassOptions(), *module);
          assert(!barriers.hasAnything());

          for (auto it = storeInfos.rbegin(); it != storeInfos.rend(); ++it) {
            if (auto* storeInfo = std::get_if<StoreInfo>(&*it)) {
              if (localGraph.equalValues(structSet->ref,
                                         storeInfo->store->ref) &&
                  structSet->index == storeInfo->store->index) {
                storeInfo->duplicateStores++;

                if (barriers.hasAnything()) {
                  storeInfo->conflictingEffects.emplace(barriers);
                }
                break;
              }
            } else if (auto* barrier = std::get_if<EffectAnalyzer>(&*it)) {
              barriers.mergeIn(*barrier);
            }
          }
          std::cout << "Should have got here twice\n";
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
          ShallowEffectAnalyzer effects(
            getPassOptions(), *module, const_cast<Expression*>(inst));
          // Add all the possible effects here
          // Maybe prune the ones that matter from effects
          if (effects.branchesOut || effects.calls || effects.throws() ||
              (!getPassOptions().trapsNeverHappen && effects.trap)) {
            ShallowEffectAnalyzer prunedEffects(getPassOptions(), *module);
            prunedEffects.branchesOut = effects.branchesOut;
            prunedEffects.calls = effects.calls;
            prunedEffects.throws_ = effects.throws_;
            prunedEffects.delegateTargets = effects.delegateTargets;
            // trap left out because we're using TNH in practice for now
            storeInfos.push_back(prunedEffects);
          }
        }
      }
    }

    for (const auto& info : storeInfos) {
      if (!std::holds_alternative<StoreInfo>(info)) {
        continue;
      }

      auto& storeInfo = std::get<StoreInfo>(info);

      std::cout << storeInfo << "\n";

      // When running on the small binary and adding a throw, we can tell that
      // the store is not dead but the effects don't print out for some reason.
      if (storeInfo.conflictingEffects) {
        std::lock_guard _(m);
        std::cout << "??\n";
        // std::cout<<*const_cast<EffectAnalyzer*>(&*storeInfo.conflictingEffects);
        std::cout << *storeInfo.conflictingEffects;
      }
      // if (storeInfo.duplicateStores && !storeInfo.conflictingGets &&
      //   !storeInfo.conflictingEffects) {
      //   std::lock_guard _(m);
      //   std::cout << storeInfo.duplicateStores << "\n";
      // }
    }
  }
};

} // namespace

Pass* createDeadStoreEliminationPass() {
  return new DeadStoreEliminationPass();
}

} // namespace wasm