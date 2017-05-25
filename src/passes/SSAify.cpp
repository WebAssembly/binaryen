/*
 * Copyright 2016 WebAssembly Community Group participants
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
// Transforms code into SSA form. That ensures each variable has a
// single assignment. For phis, we do not add a new node to the AST,
// so the result is multiple assignments but with the guarantee that
// they all travel directly to the same basic block, i.e., they are
// a way to represent a phi in our AST.
// TODO: consider adding a "proper" phi node to the AST, that passes
//       can utilize
//

#include "wasm.h"
#include "pass.h"
#include "wasm-builder.h"
#include "support/permutations.h"
#include "ast/manipulation.h"
#include "ast/literal-utils.h"

namespace wasm {

// A set we know is impossible / not in the ast
SetLocal IMPOSSIBLE_SET;

// Tracks assignments to locals, assuming single-assignment form, i.e.,
// each assignment creates a new variable.

struct SSAify : public WalkerPass<PostWalker<SSAify>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new SSAify; }

  // we map (old local index) => the set_local for that index. The new
  // index for the local can be seen in that set local.
  // this can be nullptr if there is no set_local, and instead the value
  // is a parameter, or the zero init.
  typedef std::vector<SetLocal*> Mapping;

  Index numLocals;
  Mapping currMapping;
  Index nextIndex;
  std::vector<Mapping> mappingStack; // used in ifs, loops
  std::map<Name, std::vector<Mapping>> breakMappings; // break target => infos that reach it
  std::vector<std::vector<GetLocal*>> loopGetStack; //  stack of loops, all the gets in each, so we can update them for phis
  std::map<GetLocal*, Index> originalGetIndexes;
  std::vector<Expression*> functionPrepends; // things we add to the function prologue

  void doWalkFunction(Function* func) {
    numLocals = func->getNumLocals();
    if (numLocals == 0) return; // nothing to do
    // We begin with each param being assigned from the incoming value, and the zero-init for the locals,
    // so the initial state is the identity permutation
    currMapping.resize(numLocals);
    for (auto& set : currMapping) set = nullptr;
    nextIndex = numLocals;
    WalkerPass<PostWalker<SSAify>>::walk(func->body);
    if (functionPrepends.size() > 0) {
      Builder builder(*getModule());
      auto* block = builder.blockify(func->body);
      func->body = block;
      // TODO: this is O(toplevel block size^2)
      for (auto* pre : functionPrepends) {
        ExpressionManipulator::spliceIntoBlock(block, 0, pre);
      }
    }
  }

  // control flow

  void visitBlock(Block* curr) {
    if (curr->name.is() && breakMappings.find(curr->name) != breakMappings.end()) {
      auto& infos = breakMappings[curr->name];
      infos.emplace_back(std::move(currMapping));
      currMapping = std::move(merge(infos));
    }
  }

  void finishIf() {
    // that's it for this if, merge
    std::vector<Mapping> breaks;
    breaks.emplace_back(std::move(currMapping));
    breaks.emplace_back(std::move(mappingStack.back()));
    mappingStack.pop_back();
    currMapping = std::move(merge(breaks));
  }

  static void afterIfCondition(SSAify* self, Expression** currp) {
    self->mappingStack.push_back(self->currMapping);
  }
  static void afterIfTrue(SSAify* self, Expression** currp) {
    auto* curr = (*currp)->cast<If>();
    if (curr->ifFalse) {
      auto afterCondition = std::move(self->mappingStack.back());
      self->mappingStack.back() = std::move(self->currMapping);
      self->currMapping = std::move(afterCondition);
    } else {
      self->finishIf();
    }
  }
  static void afterIfFalse(SSAify* self, Expression** currp) {
    self->finishIf();
  }
  static void beforeLoop(SSAify* self, Expression** currp) {
    // save the state before entering the loop, for calculation later of the merge at the loop top
    self->mappingStack.push_back(self->currMapping);
    self->loopGetStack.push_back({});
  }
  static void doVisitLoop(SSAify* self, Expression** currp) {
    auto* curr = (*currp)->cast<Loop>();
    if (curr->name.is() && self->breakMappings.find(curr->name) != self->breakMappings.end()) {
      auto& infos = self->breakMappings[curr->name];
      infos.emplace_back(std::move(self->mappingStack.back()));
      auto before = infos.back();
      auto& merged = self->merge(infos);
      // every local we created a phi for requires us to update get_local operations in
      // the loop
      auto& gets = self->loopGetStack.back();
      for (auto* get : gets) {
        self->updateGetLocalIndex(get, merged);
      }
    }
    self->mappingStack.pop_back();
    self->loopGetStack.pop_back();
  }
  void visitBreak(Break* curr) {
    if (curr->condition) {
      breakMappings[curr->name].emplace_back(currMapping);
    } else {
      breakMappings[curr->name].emplace_back(std::move(currMapping));
      setUnreachable(currMapping);
    }
  }
  void visitSwitch(Switch* curr) {
    std::set<Name> all;
    for (auto target : curr->targets) {
      all.insert(target);
    }
    all.insert(curr->default_);
    for (auto target : all) {
      breakMappings[target].emplace_back(currMapping);
    }
    setUnreachable(currMapping);
  }
  void visitReturn(Return *curr) {
    setUnreachable(currMapping);
  }
  void visitUnreachable(Unreachable *curr) {
    setUnreachable(currMapping);
  }

  // local usage

  void updateGetLocalIndex(GetLocal* curr, Mapping& mapping) {
    auto* set = mapping[curr->index];
    if (set) {
      curr->index = set->index;
    } else {
      // no set, this is either a param or a zero init
      if (curr->index < getFunction()->getNumParams()) {
        // nothing to do, keep getting that param
      } else {
        // just replace with zero
        replaceCurrent(LiteralUtils::makeZero(curr->type, *getModule()));
      }
    }
  }

  void visitGetLocal(GetLocal* curr) {
    assert(currMapping.size() == numLocals);
    assert(curr->index < numLocals);
    for (auto& loopGets : loopGetStack) {
      loopGets.push_back(curr);
    }
    originalGetIndexes[curr] = curr->index;
    updateGetLocalIndex(curr, currMapping);
  }
  void visitSetLocal(SetLocal* curr) {
    assert(currMapping.size() == numLocals);
    assert(curr->index < numLocals);
    currMapping[curr->index] = curr;
    curr->index = addLocal(getFunction()->getLocalType(curr->index));
  }

  // traversal

  static void scan(SSAify* self, Expression** currp) {
    if (auto* iff = (*currp)->dynCast<If>()) {
      // if needs special handling
      if (iff->ifFalse) {
        self->pushTask(SSAify::afterIfFalse, currp);
        self->pushTask(SSAify::scan, &iff->ifFalse);
      }
      self->pushTask(SSAify::afterIfTrue, currp);
      self->pushTask(SSAify::scan, &iff->ifTrue);
      self->pushTask(SSAify::afterIfCondition, currp);
      self->pushTask(SSAify::scan, &iff->condition);
    } else {
      WalkerPass<PostWalker<SSAify>>::scan(self, currp);
    }

    // loops need pre-order visiting too
    if ((*currp)->is<Loop>()) {
      self->pushTask(SSAify::beforeLoop, currp);
    }
  }

  // helpers

  void setUnreachable(Mapping& mapping) {
    mapping.resize(numLocals); // may have been emptied by a move
    mapping[0] = &IMPOSSIBLE_SET;
  }

  bool isUnreachable(Mapping& mapping) {
    return mapping[0] == &IMPOSSIBLE_SET;
  }

  // merges a bunch of infos into one.
  // if we need phis, writes them into the provided vector. the caller should
  // ensure those are placed in the right location
  Mapping& merge(std::vector<Mapping>& mappings) {
    assert(mappings.size() > 0);
    auto& out = mappings[0];
    if (mappings.size() == 1) {
      return mappings[0];
    }
    for (Index i = 0; i < numLocals; i++) {
      SetLocal* merged = &IMPOSSIBLE_SET;
      for (auto& mapping : mappings) {
        if (isUnreachable(mapping)) continue;
        if (merged == &IMPOSSIBLE_SET) {
          merged = mapping[i];
        } else {
          if (mapping[i] != merged) {
            // we need a phi for this local, e.g., imagine
            // if (..) { x = 1 } else { x = 2 } ..use x here..
            // create a new local, and also write to it at the old write locations
            // if (..) { x = y = 1 } else { x = y = 2 } ..use y here..
            // (not that y seems as "single-assignment" as x here, but the point is
            // that x may be merged multiple times, so we need a different phi merge
            // local for each)
            auto phiLocal = addLocal(getFunction()->getLocalType(i));
;           merged = addWritesToLocal(mappings, i, phiLocal);
            break;
          }
        }
      }
      if (merged != &IMPOSSIBLE_SET) {
        out[i] = merged;
      }
    }
    return out;
  }

  // adds phi-style writes to sets of a local
  // returns one of those writes
  SetLocal* addWritesToLocal(std::vector<Mapping>& mappings, Index old, Index new_) {
    SetLocal* ret = nullptr;
    Builder builder(*getModule());
    // the same set may appear in multiple mappings; we just need one for each
    std::set<SetLocal*> seen;
    for (auto& mapping : mappings) {
      auto* set = mapping[old];
      if (!seen.insert(set).second) {
        // seen it already
        continue;
      }
      if (!set) {
        // this is a param or the zero init value. add a set first thing in
        // the function
        set = builder.makeSetLocal(
          old,
          getFunction()->isParam(old) ? builder.makeGetLocal(old, getFunction()->getLocalType(old))
                                      : LiteralUtils::makeZero(getFunction()->getLocalType(old), *getModule())
        );
        mapping[old] = set;
        functionPrepends.push_back(set);
      }
      // now a set exists, just add a tee of its value, so we also set the phi merge var
      set->value = ret = builder.makeTeeLocal(
        new_,
        set->value
      );
    }
    return ret;
  }

  Index addLocal(WasmType type) {
    return Builder::addVar(getFunction(), type);
  }
};

Pass *createSSAifyPass() {
  return new SSAify();
}

} // namespace wasm

