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

struct SimplifyLocals : public WalkerPass<FastExecutionWalker<SimplifyLocals>> {
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

  void visitBlock(Block *curr) {
    // note locals, we can sink them from here TODO sink from elsewhere?
    derecurseBlocks(curr, [&](Block* block) {
      // curr was already checked by walk()
      if (block != curr) checkPre(block);
    }, [&](Block* block, Expression*& child) {
      walk(child);
      if (child->is<SetLocal>()) {
        Name name = child->cast<SetLocal>()->name;
        assert(sinkables.count(name) == 0);
        sinkables.emplace(std::make_pair(name, SinkableInfo(&child)));
      }
    }, [&](Block* block) {
      if (block != curr) checkPost(block);
    });
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
    walk(curr->value);
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

  void checkPre(Expression* curr) {
    EffectAnalyzer effects;
    if (effects.checkPre(curr)) {
      checkInvalidations(effects);
    }
  }

  void checkPost(Expression* curr) {
    EffectAnalyzer effects;
    if (effects.checkPost(curr)) {
      checkInvalidations(effects);
    }
  }

  void walk(Expression*& curr) override {
    if (!curr) return;

    checkPre(curr);

    FastExecutionWalker::walk(curr);

    checkPost(curr);
  }
};

static RegisterPass<SimplifyLocals> registerPass("simplify-locals", "miscellaneous locals-related optimizations");

} // namespace wasm
