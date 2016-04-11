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
// This "sinks" set_locals, pushing them to the next get_local where possible

#include <wasm.h>
#include <wasm-traversal.h>
#include <pass.h>
#include <ast_utils.h>

namespace wasm {

struct SimplifyLocals : public WalkerPass<LinearExecutionWalker<SimplifyLocals>> {
  struct SinkableInfo {
    Expression** item;
    EffectAnalyzer effects;

    SinkableInfo(Expression** item) : item(item) {
      effects.walk(*item);
    }
  };

  // locals in current linear execution trace, which we try to sink
  std::map<Name, SinkableInfo> sinkables;

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
    EffectAnalyzer effects;
    if (effects.checkPre(*currp)) {
      self->checkInvalidations(effects);
    }
  }

  static void visitPost(SimplifyLocals* self, Expression** currp) {
    EffectAnalyzer effects;
    if (effects.checkPost(*currp)) {
      self->checkInvalidations(effects);
    }
  }

  static void tryMarkSinkable(SimplifyLocals* self, Expression** currp) {
    auto* curr = (*currp)->dyn_cast<SetLocal>();
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
};

static RegisterPass<SimplifyLocals> registerPass("simplify-locals", "miscellaneous locals-related optimizations");

} // namespace wasm
