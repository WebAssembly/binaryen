/*
 * Copyright 2017 WebAssembly Community Group participants
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
// Local CSE
//
// In each linear area of execution,
//  * track each relevant (big enough) expression
//  * if already seen, write to a local if not already, and reuse
//  * invalidate the list as we see effects
//
// TODO: global, inter-block gvn etc.
//

#include <wasm.h>
#include <wasm-builder.h>
#include <wasm-traversal.h>
#include <pass.h>
#include <ast_utils.h>
#include <ast/hashed.h>

namespace wasm {

const Index UNUSED = -1;

struct LocalCSE : public WalkerPass<LinearExecutionWalker<LocalCSE>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new LocalCSE(); }

  // information for an expression we can reuse
  struct UsableInfo {
    Expression** item;
    Index index; // if not UNUSED, then the local we are assigned to, use that to reuse us
    EffectAnalyzer effects;

    UsableInfo(Expression** item, PassOptions& passOptions) : item(item), index(UNUSED), effects(passOptions, *item) {}
  };

  // a list of usables in a linear execution trace
  typedef HashedExpressionMap<UsableInfo> Usables;

  // locals in current linear execution trace, which we try to sink
  Usables usables;

  static void doNoteNonLinear(LocalCSE* self, Expression** currp) {
    self->usables.clear();
  }

  void checkInvalidations(EffectAnalyzer& effects) {
    // TODO: this is O(bad)
    std::vector<HashedExpression> invalidated;
    for (auto& sinkable : usables) {
      if (effects.invalidates(sinkable.second.effects)) {
        invalidated.push_back(sinkable.first);
      }
    }
    for (auto index : invalidated) {
      usables.erase(index);
    }
  }

  std::vector<Expression*> expressionStack;

  static void visitPre(LocalCSE* self, Expression** currp) {
    // pre operations
    Expression* curr = *currp;

    EffectAnalyzer effects(self->getPassOptions());
    if (effects.checkPre(curr)) {
      self->checkInvalidations(effects);
    }

    self->expressionStack.push_back(curr);
  }

  static void visitPost(LocalCSE* self, Expression** currp) {
    auto* curr = *currp;

    // main operations
    if (self->isRelevant(curr)) {
      self->handle(currp, curr);
    }

    // post operations

    EffectAnalyzer effects(self->getPassOptions());
    if (effects.checkPost(curr)) {
      self->checkInvalidations(effects);
    }

    self->expressionStack.pop_back();
  }

  // override scan to add a pre and a post check task to all nodes
  static void scan(LocalCSE* self, Expression** currp) {
    self->pushTask(visitPost, currp);

    WalkerPass<LinearExecutionWalker<LocalCSE>>::scan(self, currp);

    self->pushTask(visitPre, currp);
  }

  bool isRelevant(Expression* curr) {
    if (curr->is<GetLocal>()) {
      return false; // trivial, this is what we optimize to!
    }
    if (!isConcreteWasmType(curr->type)) {
      return false; // don't bother with unreachable etc.
    }
    if (EffectAnalyzer(getPassOptions(), curr).hasSideEffects()) {
      return false; // we can't combine things with side effects
    }
    // check what we care about TODO: use optimize/shrink levels?
    return Measurer::measure(curr) > 1;
  }

  void handle(Expression** currp, Expression* curr) {
    HashedExpression hashed(curr);
    auto iter = usables.find(hashed);
    if (iter != usables.end()) {
      // already exists in the table, this is good to reuse
      auto& info = iter->second;
      if (info.index == UNUSED) {
        // we need to assign to a local. create a new one
        auto index = info.index = Builder::addVar(getFunction(), curr->type);
        (*info.item) = Builder(*getModule()).makeTeeLocal(index, *info.item);
      }
      replaceCurrent(
        Builder(*getModule()).makeGetLocal(info.index, curr->type)
      );
    } else {
      // not in table, add this, maybe we can help others later
      usables.emplace(std::make_pair(hashed, UsableInfo(currp, getPassOptions())));
    }
  }
};

Pass *createLocalCSEPass() {
  return new LocalCSE();
}

} // namespace wasm
