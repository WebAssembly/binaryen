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
// This requires --flatten to be run before, and preserves flatness.
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

  // We track copied locals and canonicalize them, e.g.
  //  y = x
  //  z = y
  //  f(z) => turns into f(x)
  // This lets expression comparison work well without teaching it about
  // which locals are equal.
  // localEquivalences[an index] = the set of indexes the index is equal to
  struct EquivalentSet {
    std::unordered_set<Index> set; // the set of indexes that are equivalent
    Index preferred; // the preferred one - copy all to this
    EquivalentSet(Index preferred) : preferred(preferred) {}
  };
  std::unordered_map<Index, std::shared_ptr<EquivalentSet>> localEquivalences;

  bool anotherPass;

  void doWalkFunction(Function* func) {
    anotherPass = true;
    // we may need multiple rounds
    while (anotherPass) {
      anotherPass = false;
      super::doWalkFunction(func);
    }
  }

  static void doNoteNonLinear(LocalCSE* self, Expression** currp) {
    self->usables.clear();
    self->localEquivalences.clear();
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
      // we are assigning to a local, so existing equivalences are moot
      resetLocal(set->index);
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
      } else if (auto* get = value->dynCast<GetLocal>()) {
        // this is a copy of one local to another
        addEquivalence(set->index, get->index);
      }
    } else if (auto* get = curr->dynCast<GetLocal>()) {
      // Perhaps we can canonicalize this get, if it is a copy of another.
      get->index = getCanonical(get->index);
    }
  }

  void resetLocal(Index index) {
    auto iter = localEquivalences.find(index);
    if (iter != localEquivalences.end()) {
      auto& eqSet = iter->second;
      assert(!eqSet->set.empty()); // can't be empty - we are equal to ourselves!
      if (eqSet->set.size() > 1) {
        // We are not the last item, fix things up
        eqSet->set.erase(index);
        if (!eqSet->set.empty()) {
          if (eqSet->preferred == index) {
            // We need to pick a new preferred index. Pick the lowest.
            eqSet->preferred = *std::min_element(eqSet->set.begin(), eqSet->set.end());
          }
        }
      } else {
        // We are the last item, just let it all go away.
        assert(*(eqSet->set.begin()) == eqSet->preferred); // if one item, it is us
      }
      localEquivalences.erase(iter);
    }
  }

  void addEquivalence(Index justReset, Index copied) {
    auto iter = localEquivalences.find(copied);
    if (iter != localEquivalences.end()) {
      auto& eqSet = iter->second;
      if (eqSet->set.empty()) {
        eqSet->preferred = justReset;
      }
      eqSet->set.insert(justReset);
      localEquivalences[justReset] = eqSet;
    } else {
      // Note how we set the preferred index to the copied one.
      auto eqSet = std::make_shared<EquivalentSet>(copied);
      eqSet->set.insert(justReset);
      eqSet->set.insert(copied);
      localEquivalences[justReset] = eqSet;
      localEquivalences[copied] = eqSet;
    }
  }

  Index getCanonical(Index index) {
    auto iter = localEquivalences.find(index);
    if (iter != localEquivalences.end()) {
      auto& eqSet = iter->second;
      assert(!eqSet->set.empty()); // can't be empty - we are equal to ourselves!
      assert(eqSet->set.size() == 1 ? *(eqSet->set.begin()) == eqSet->preferred : true); // if one item, it is us
      return eqSet->preferred;
    }
    return index;
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
