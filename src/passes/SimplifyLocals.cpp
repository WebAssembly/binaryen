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
// Locals-related optimizations
//
// This "sinks" set_locals, pushing them to the next get_local where possible,
// and removing the set if there are no gets remaining (the latter is
// particularly useful in ssa mode, but not only).
//
// After this pass, some locals may be completely unused. reorder-locals
// can get rid of those (the operation is trivial there after it sorts by use
// frequency).

#include <wasm.h>
#include <wasm-traversal.h>
#include <pass.h>
#include <ast_utils.h>

namespace wasm {

struct SimplifyLocals : public WalkerPass<LinearExecutionWalker<SimplifyLocals>> {
  bool isFunctionParallel() { return true; }

  struct SinkableInfo {
    Expression** item;
    EffectAnalyzer effects;

    SinkableInfo(Expression** item) : item(item) {
      effects.walk(*item);
    }
  };

  // locals in current linear execution trace, which we try to sink
  std::map<Name, SinkableInfo> sinkables;

  bool sunk;

  // name => # of get_locals for it
  std::map<Name, int> numGetLocals;

  // for each set_local, its origin pointer
  std::map<SetLocal*, Expression**> setLocalOrigins;

  void noteNonLinear() {
    sinkables.clear();
  }

  void visitGetLocal(GetLocal *curr) {
    auto found = sinkables.find(curr->name);
    if (found != sinkables.end()) {
      // sink it, and nop the origin TODO: clean up nops
      replaceCurrent(*found->second.item);
      // reuse the getlocal that is dying
      *found->second.item = curr;
      ExpressionManipulator::nop(curr);
      sinkables.erase(found);
      sunk = true;
    } else {
      numGetLocals[curr->name]++;
    }
  }

  void visitSetLocal(SetLocal *curr) {
    // if we are a potentially-sinkable thing, forget it - this
    // write overrides the last TODO: optimizable
    // TODO: if no get_locals left, can remove the set as well (== expressionizer in emscripten optimizer)
    auto found = sinkables.find(curr->name);
    if (found != sinkables.end()) {
      sinkables.erase(found);
    }
  }

  void checkInvalidations(EffectAnalyzer& effects) {
    // TODO: this is O(bad)
    std::vector<Name> invalidated;
    for (auto& sinkable : sinkables) {
      if (effects.invalidates(sinkable.second.effects)) {
        invalidated.push_back(sinkable.first);
      }
    }
    for (auto name : invalidated) {
      sinkables.erase(name);
    }
  }

  static void visitPre(SimplifyLocals* self, Expression** currp) {
    Expression* curr = *currp;

    EffectAnalyzer effects;
    if (effects.checkPre(curr)) {
      self->checkInvalidations(effects);
    }
  }

  static void visitPost(SimplifyLocals* self, Expression** currp) {
    Expression* curr = *currp;

    EffectAnalyzer effects;
    if (effects.checkPost(curr)) {
      self->checkInvalidations(effects);
    }

    // noting origins in the post means it happens after a
    // get_local was replaced by a set_local in a sinking
    // operation, so we track those movements properly.
    if (curr->is<SetLocal>()) {
      self->setLocalOrigins[curr->cast<SetLocal>()] = currp;
    }
  }

  static void tryMarkSinkable(SimplifyLocals* self, Expression** currp) {
    auto* curr = (*currp)->dynCast<SetLocal>();
    if (curr) {
      Name name = curr->name;
      assert(self->sinkables.count(name) == 0);
      self->sinkables.emplace(std::make_pair(name, SinkableInfo(currp)));
    }
  }

  // override scan to add a pre and a post check task to all nodes
  static void scan(SimplifyLocals* self, Expression** currp) {
    self->pushTask(visitPost, currp);

    auto* curr = *currp;

    if (curr->is<Block>()) {
      // special-case blocks, by marking their children as locals.
      // TODO sink from elsewhere? (need to make sure value is not used)
      self->pushTask(SimplifyLocals::doNoteNonLinear, currp);
      auto& list = curr->cast<Block>()->list;
      int size = list.size();
      // we can't sink the last element, as it might be a return value;
      // and anyhow, control flow is nonlinear at the end of the block so
      // it would be invalidated.
      for (int i = size - 1; i >= 0; i--) {
        if (i < size - 1) {
          self->pushTask(tryMarkSinkable, &list[i]);
        }
        self->pushTask(scan, &list[i]);
      }
    } else {
      WalkerPass<LinearExecutionWalker<SimplifyLocals>>::scan(self, currp);
    }

    self->pushTask(visitPre, currp);
  }

  void walk(Expression*& root) {
    // multiple passes may be required per function, consider this:
    //    x = load
    //    y = store
    //    c(x, y)
    // the load cannot cross the store, but y can be sunk, after which so can x
    do {
      sunk = false;
      // main operation
      WalkerPass<LinearExecutionWalker<SimplifyLocals>>::walk(root);
      // after optimizing a function, we can see if we have set_locals
      // for a local with no remaining gets, in which case, we can
      // remove the set.
      std::vector<SetLocal*> optimizables;
      for (auto pair : setLocalOrigins) {
        SetLocal* curr = pair.first;
        if (numGetLocals[curr->name] == 0) {
          // no gets, can remove the set and leave just the value
          optimizables.push_back(curr);
        }
      }
      for (auto* curr : optimizables) {
        Expression** origin = setLocalOrigins[curr];
        *origin = curr->value;
        // nested set_values need to be handled properly.
        // consider (set_local x (set_local y (..)), where both can be
        // reduced to their values, and we might do it in either
        // order.
        if (curr->value->is<SetLocal>()) {
          setLocalOrigins[curr->value->cast<SetLocal>()] = origin;
        }
      }
      // clean up
      numGetLocals.clear();
      setLocalOrigins.clear();
      sinkables.clear();
    } while (sunk);
  }
};

static RegisterPass<SimplifyLocals> registerPass("simplify-locals", "miscellaneous locals-related optimizations");

} // namespace wasm
