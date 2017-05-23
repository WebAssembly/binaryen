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

namespace wasm {

// Tracks assignments to locals, assuming single-assignment form, i.e.,
// each assignment creates a new variable.

struct SSAify : public PostWalker<SSAify> {
  // we map (old local index) => the set_local for that index. The new
  // index for the local can be seen in that set local.
  // this can be nullptr if there is no set_local, and instead the value
  // is a parameter, or the zero init.
  typedef std::vector<SetLocal*> Mapping;

  Index numLocals;
  Mapping currMapping;
  Index nextIndex;
  std::vector<Mapping> mappingStack; // used in ifs, loops
  std::map<Name, std::vector<Mapping>> breakInfos; // break target => infos that reach it
  std::vector<std::vector<GetLocal*>> loopGetStack; //  stack of loops, all the gets in each, so we can update them for phis
  std::map<GetLocal*, Index> originalGetIndexes;

  void doWalkFunction(Function* func) {
    numLocals = func->getNumLocals();
    if (numLocals == 0) return; // nothing to do
    // We begin with each param being assigned from the incoming value, and the zero-init for the locals,
    // so the initial state is the identity permutation
    currMapping.resize(numLocals);
    for (auto& set : currMapping) set = nullptr;
    nextIndex = numLocals;
    PostWalker<SSAify>::walk(func->body);
  }

  // control flow

  static void doVisitBlock(SSAify* self, Expression** currp) {
    auto* curr = (*currp)->cast<Block>();
    if (curr->name.is() && self->breakInfos.find(curr->name) != self->breakInfos.end()) {
      auto& infos = self->breakInfos[curr->name];
      infos.emplace_back(std::move(self->currMapping), currp, BreakInfo::Internal);
      self->currMapping = std::move(self->merge(infos), curr->name);
    }
  }

  void finishIf() {
    // that's it for this if, merge
    std::vector<BreakInfo> breaks;
    breaks.emplace_back(std::move(currMapping));
    breaks.emplace_back(std::move(mappingStack.back()));
    mappingStack.pop_back();
    currMapping = std::move(merge(breaks));
  }

  static void afterIfCondition(SSAify* self, Expression** currp) {
    auto* curr = (*currp)->cast<If>();
    self->mappingStack.push_back(self->currMapping);
  }
  static void afterIfTrue(SSAify* self, Expression** currp) {
    auto* curr = (*currp)->cast<If>();
    if (curr->ifFalse) {
      auto afterCondition = std::move(self.mappingStack.back());
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
    if (curr->name.is() && self->breakInfos.find(curr->name) != self->breakInfos.end()) {
      auto& infos = self->breakInfos[curr->name];
      infos.emplace_back(std::move(self->mappingStack.back()));
      auto before = infos.back();
      auto& merged = self->merge(infos);
      // every local we created a phi for requires us to update get_local operations in
      // the loop
      auto& gets = self->loopGetStack.back();
      for (auto* get : gets) {
        auto original = self->originalGetIndexes[get];
        get->index = merged[original];
      }
    }
    self->mappingStack.pop_back();
    self->loopGetStack.pop_back();
  }
  static void visitBreak(SSAify* self, Expression** currp) {
    auto* curr = (*currp)->cast<Break>();
    self->breakInfos[curr->name].emplace_back(std::move(self->currMapping), currp, BreakInfo::Internal);
    if (!(*currp)->cast<Break>()->condition) {
      setUnreachable(self->currMapping);
    }
  }
  static void visitSwitch(SSAify* self, Expression** currp) {
    auto* curr = (*currp)->cast<Switch>();
    std::set<Name> all;
    for (auto target : curr->targets) {
      all.insert(target);
    }
    all.insert(curr->default_);
    for (auto target : all) {
      self->breakInfos[curr->default_].emplace_back(self->currMapping, currp, BreakInfo::Switch);
    }
    setUnreachable(self->currMapping);
  }
  void visitReturn(Return *curr) {
    setUnreachable(currMapping);
  }
  void visitUnreachable(Unreachable *curr) {
    setUnreachable(currMapping);
  }

  // local usage

  void visitGetLocal(GetLocal* curr) {
    for (auto& loopGets : loopGetStack) {
      loopGets.push_back(curr);
    }
    originalGetIndexes[curr] = curr->index;
    curr->index = currMapping[curr->index]->index;
  }
  void visitSetLocal(SetLocal* curr) {
    currMapping[curr->index] = curr;
    curr->index = nextIndex++;
  }

  // traversal

  static void scan(SSAify* self, Expression** currp) {
    if (auto* iff = (*currp)->dynCast<If>()) {
      // if needs special handling
      if (iff->ifFalse) {
        self->pushTask(SSAify::afterIfFalse, currp);
        self->pushTask(SSAify::scan, iff->ifFalse);
      }
      self->pushTask(SSAify::afterIfTrue, currp);
      self->pushTask(SSAify::scan, iff->ifTrue);
      self->pushTask(SSAify::afterIfCondition, currp);
      self->pushTask(SSAify::scan, iff->condition);
    } else {
      PostWalker<SSAify, VisitorType>::scan(self, currp);
    }

    // loops need pre-order visiting too
    if ((*currp)->is<Loop>()) {
      self->pushTask(SSAify::beforeLoop, currp);
    }
  }

  // helpers

  void setUnreachable(Mapping& mapping) {
    mapping.resize(numLocals); // may have been emptied by a move
    mapping[0] = Index(-1);
  }

  bool isUnreachable(Mapping& mapping) {
    return mapping[0] == Index(-1);
  }

  // merges a bunch of infos into one
  Mapping& merge(std::vector<Info>& infos) {
    assert(infos.size() > 0);
    auto& out = infos[0];
    if (infos.size() == 1) {
      return infos[0];
    }
    for (Index i = 0; i < numLocals; i++) {
      SetLocal* merged;
      bool seen = false;
      for (auto& info : infos) {
        if (isUnreachable(info)) continue;
        if (!seen) {
          merged = info[i];
          seen = true;
        } else {
          if (info[i] != merged) {
            // we need a phi for this local
// XXX merge to a single set_local how?
            merged = nextIndex++;
            createPhi(infos, i, merged);
            break;
          }
        }
      }
      if (seen) {
        out[i] = merged;
      }
    }
    return out;
  }

  void createPhi(std::vector<BreakInfo>& infos, Index old, Index new_) {
    // assign the set value to the phi value as well
    Builder builder(*getModule());
    for (auto& info : infos) {
      if (!info[index]) {
        // this is a param or the zero init value. add a set first thing in
        // the function
        auto* block = builder.blockify(getFunction()->body);
        getFunction()->body = block;
        auto* set = builder.makeSetLocal(
          old_,
          builder.makeGetLocal(new_, getFunction()->getLocalType(old))
        );
        info[old] = set;
        ExpressionManipulator::spliceIntoBlock(block, 0, set);
      }
      // now a set exists, just add a tee of its value, so we also set the phi merge var
      info[old]->value = builder.makeTeeLocal(
        new_,
        info[old]->value
      );
    }
  }
};

Pass *createSSAifyPass() {
  return new SSAify();
}

} // namespace wasm

