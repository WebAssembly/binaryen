#include "pass.h"
#include "passes/passes.h"
#include "ir/module-utils.h"
#include "ir/local-graph.h"
#include "ir/properties.h"
#include "analysis/cfg.h"

namespace wasm {
namespace {

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
    virtual std::unique_ptr<Pass> create() { return std::make_unique<DeadStoreEliminationPass>(); }

    bool isFunctionParallel() override { return true; }

    // void run(Module* module) override {
    //     ModuleUtils::iterDefinedFunctions(*module, [this, module](auto* function) { runOnFunction(module, function); });
    // }

    void runOnFunction(Module* module, Function* function) override {
        std::cout<<"Ran on function " << function->name<< "\n";

        ComparingLocalGraph localGraph(function, getPassOptions(), *module);

        auto cfg = analysis::CFG::fromFunction(function);

        // todo might want to use a map here
        // keyed by the ref expression
        int deadStoreCount = 0;
        for (auto& block : cfg) {
            for (const auto* inst : block) {
                std::vector<const StructSet*> sets;
                if (const StructSet* structSet = inst->dynCast<StructSet>()) {
                    bool found = false;
                    for (auto* otherSet : sets) {
                        if (localGraph.equalValues(structSet->ref, otherSet->ref) && structSet->index == otherSet->index) {
                            deadStoreCount++;
                            found = true;
                            // std::cout<<"Found dead store\n";
                            // structSet->dump();
                        }
                    }
                    if (!found) {
                        sets.push_back(structSet);
                        // std::cout<<"not equal\n";
                    }
                    // localGraph.equalValues(structSet->ref)
                    // structSet->dump();
                    // structSet->ref->dump();
                } else if (const StructGet* structGet = inst->dynCast<StructGet>()) {
                    // structGet->ref->dump();
                }
            }
        }
    }
};

}  // namespace

Pass* createDeadStoreEliminationPass() {
    return new DeadStoreEliminationPass();
}

}  // namespace wasm