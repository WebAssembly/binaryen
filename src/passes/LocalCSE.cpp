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
// This requires --flatten to be run before in order to be effective,
// and preserves flatness. The reason flatness is required is that
// this pass assumes everything is stored in a local, and all it does
// is alter set_locals to do get_locals of an existing value when
// possible, replacing a recomputing of that value. That design means that
// if there are block and if return values, nested expressions not stored
// to a local, etc., then it can't operate on them (and will just not
// do anything for them).
//
// In each linear area of execution,
//  * track each relevant (big enough) expression
//  * if already seen, write to a local if not already, and reuse
//  * invalidate the list as we see effects
//
// TODO: global, inter-block gvn etc.
//

#include <algorithm>
#include <memory>

#include <wasm.h>
#include <wasm-builder.h>
#include <wasm-traversal.h>
#include <pass.h>
#include <ir/effects.h>
#include <ir/equivalent_sets.h>
#include <ir/hashed.h>

namespace wasm {

struct LocalCSE : public WalkerPass<LinearExecutionWalker<LocalCSE>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new LocalCSE(); }

  // information for an expression we can reuse
  struct UsableInfo {
    Expression* value; // the value we can reuse
    Index index; // the local we are assigned to, get_local that to reuse us
    EffectAnalyzer effects;

    UsableInfo(Expression* value, Index index, PassOptions& passOptions) : value(value), index(index), effects(passOptions, value) {}
  };

  // a list of usables in a linear execution trace
  typedef HashedExpressionMap<UsableInfo> Usables;

  // locals in current linear execution trace, which we try to sink
  Usables usables;

  // We track locals containing the same value - the value is what matters, not
  // the index.
  EquivalentSets equivalences;

  bool anotherPass;

  void doWalkFunction(Function* func) {
    anotherPass = true;
    // we may need multiple rounds
    while (anotherPass) {
      anotherPass = false;
      clear();
      super::doWalkFunction(func);
    }
  }

  static void doNoteNonLinear(LocalCSE* self, Expression** currp) {
    self->clear();
  }

  void clear() {
    usables.clear();
    equivalences.clear();
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
    self->handle(curr);

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

    super::scan(self, currp);

    self->pushTask(visitPre, currp);
  }

  void handle(Expression* curr) {
    if (auto* set = curr->dynCast<SetLocal>()) {
      // Calculate equivalences
      equivalences.reset(set->index);
      if (auto* get = set->value->dynCast<GetLocal>()) {
        equivalences.add(set->index, get->index);
      }
      // consider the value
      auto* value = set->value;
      if (isRelevant(value)) {
        HashedExpression hashed(value);
        auto iter = usables.find(hashed);
        if (iter != usables.end()) {
          // already exists in the table, this is good to reuse
          auto& info = iter->second;
          set->value = Builder(*getModule()).makeGetLocal(info.index, value->type);
          anotherPass = true;
        } else {
          // not in table, add this, maybe we can help others later
          usables.emplace(std::make_pair(hashed, UsableInfo(value, set->index, getPassOptions())));
        }
      }
    } else if (auto* get = curr->dynCast<GetLocal>()) {
      if (auto* set = equivalences.getEquivalents(get->index)) {
        // Canonicalize to the lowest index. This lets hashing and comparisons
        // "just work".
        get->index = *std::min_element(set->begin(), set->end());
      }
    }
  }

  // A relevant value is a non-trivial one, something we may want to reuse
  // and are able to.
  bool isRelevant(Expression* value) {
    if (value->is<GetLocal>()) {
      return false; // trivial, this is what we optimize to!
    }
    if (!isConcreteType(value->type)) {
      return false; // don't bother with unreachable etc.
    }
    if (EffectAnalyzer(getPassOptions(), value).hasSideEffects()) {
      return false; // we can't combine things with side effects
    }
    // check what we care about TODO: use optimize/shrink levels?
    return Measurer::measure(value) > 1;
  }
};

Pass *createLocalCSEPass() {
  return new LocalCSE();
}

} // namespace wasm
