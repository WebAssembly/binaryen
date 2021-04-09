/*
 * Copyright 2015 WebAssembly Community Group participants
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//
// Finds stores that are trampled over by other stores anyhow, before they can
// be read.
//

#include <ir/effects.h>
#include <ir/local-graph.h>
#include <ir/utils.h>
#include <pass.h>
#include <wasm.h>

namespace wasm {

struct DeadStoreElimination
  : public WalkerPass<PostWalker<DeadStoreElimination>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new DeadStoreElimination; }

  void doWalkFunction(Function* curr) {
#if 1
    // First, find 
    struct Analysis : public UseDefAnalysis {
      DeadStoreElimination& parent;

      Analysis(DeadStoreElimination& parent) : parent(parent) {}

      virtual bool isUse(Expression* curr) {
        EffectAnalyzer effects(passOptions, features).visit(curr);
        return effects.readsMemory;
      }

      virtual bool isDef(Expression* curr) {
        EffectAnalyzer effects(passOptions, features).visit(curr);
        return effects.writesMemory;
      }

      virtual Index getLane(Expression* curr) {
        if (auto* store = curr->dynCast<Store>()) {
        }
        // If we cannot recognize this, it is an arbitrary load or store or
        // other memory operation.
        return 0;
      }

      virtual Index getNumLanes() { return func->getNumLocals(); }

      virtual void noteUseDef(Expression* use, Expression* def) {
        useDefs[use->cast<LocalGet>()].insert(def ? def->cast<LocalSet>()
                                               : nullptr);
      }

    private:
      EffectAnalyzer getEffects(Expression* curr) {
        return EffectAnalyzer(parent.getPassOptions(), parent.getModule()->features);
    };

    UseDefAnalysis analyzer;
    analyzer.analyze(curr);
#endif
  }
};

Pass* createDeadStoreEliminationPass() { return new DeadStoreElimination(); }

} // namespace wasm
