/*
 * Copyright 2020 WebAssembly Community Group participants
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

// TODO: documentation

#include "ir/effects.h"
#include "ir/stack-utils.h"
#include "pass.h"

namespace wasm {

struct StackifyDropsPass : public WalkerPass<PostWalker<StackifyDropsPass>> {
  bool isFunctionParallel() override { return true; }
  Pass* create() override { return new StackifyDropsPass; }

  void visitBlock(Block* curr) {
    StackUtils::StackFlow flow(curr);
    for (auto* expr : curr->list) {
      auto& dests = flow.dests[expr];
      bool unused = std::all_of(
        dests.begin(), dests.end(), [](StackUtils::StackFlow::Location& loc) {
          assert(loc.expr != nullptr);
          return loc.unreachable || loc.expr->is<Drop>();
        });
      if (!unused) {
        continue;
      }
      // Downgrade tees to sets when their stack value isn't used
      // TODO: leave this to coalesce-locals?
      if (auto* set = expr->dynCast<LocalSet>()) {
        if (set->isTee()) {
          set->makeSet();
          if (auto* drop = dests.begin()->expr->dynCast<Drop>()) {
            ExpressionManipulator::nop(drop);
          }
        }
        continue;
      }
      if (EffectAnalyzer(getPassOptions(), getModule()->features, expr)
            .hasSideEffects()) {
        continue;
      }
      // Remove the expression and its drops
      ExpressionManipulator::nop(expr);
      for (auto& loc : dests) {
        if (auto* drop = loc.expr->dynCast<Drop>()) {
          ExpressionManipulator::nop(drop);
        }
      }
    }
    StackUtils::compact(curr);
  }
};

Pass* createStackifyDropsPass() { return new StackifyDropsPass(); }

} // namespace wasm
