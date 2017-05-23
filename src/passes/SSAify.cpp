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
//

#include "wasm.h"
#include "pass.h"
#include "support/permutations.h"

namespace wasm {

// Tracks assignments to locals, assuming single-assignment form, i.e.,
// each assignment creates a new variable.

template<typename SubType, typename VisitorType>
struct SetTrackingWalker : public PostWalker<SubType, VisitorType> {
  typedef std::vector<Index> NameMapping; // old index (in original code) => new index (in SSA form, new variables)

  struct BreakInfo {
    NameMapping mapping;
    Expression** origin; // the origin of a node where a phi would go. note that *origin can be nullptr, in which case we can just fill it
    enum PhiType {
      Before = 0,  // a phi should go right before the origin (e.g., origin is a loop and this is the entrance)
      After = 1,   // a phi should go right after the origin (e.g. this is an if body)
      Internal = 2 // origin is the breaking instruction itself, we must add the phi internally (depending on if the break is condition or has a value, etc.,
                   //                                                                            or for a block as the last instruction)
    } type;
    // TODO: move semantics?
    BreakInfo(NameMapping mapping, Expression** origin, PhiType type) : mapping(mapping), origin(origin), type(type) {}
  };

  Index numLocals;
  NameMapping currMapping;
  Index nextIndex;
  std::vector<NameMapping> mappingStack; // used in ifs, loops
  std::map<Name, std::vector<BreakInfo>> breakInfos; // break target => infos that reach it

  SetTrackingWalker(Function* func) {
    numLocals = func->getNumLocals();
    if (numLocals == 0) return; // nothing to do
    // We begin with each param being assigned from the incoming value, and the zero-init for the locals,
    // so the initial state is the identity permutation
    currMapping.resize(numLocals);
    setIdentity(currMapping);
    nextIndex = numLocals;
    PostWalker<SubType, VisitorType>::walk(func->body);
  }

  // control flow

  static void doVisitBlock(SubType* self, Expression** currp) {
    auto* curr = (*currp)->cast<Block>();
    if (curr->name.is() && self->breakInfos.find(curr->name) != self->breakInfos.end()) {
      auto& infos = self->breakInfos[curr->name];
      infos.emplace_back(std::move(self->currMapping), currp, BreakInfo::Internal);
      self->currMapping = std::move(self->merge(infos), curr->name);
    }
  }
  static void doIfCondition(SubType* self, Expression** currp) {
    auto* curr = (*currp)->cast<If>();
    if (!curr->ifFalse) {
      self->mappingStack.push_back(self->currMapping);
    }
  }
  static void doIfTrue(SubType* self, Expression** currp) {
    auto* curr = (*currp)->cast<If>();
    if (curr->ifFalse) {
      self->mappingStack.push_back(self->currMapping);
    } else {
      // that's it for this if, merge
      std::vector<BreakInfo> breaks;
      breaks.emplace_back(std::move(self->currMapping), &curr->ifFalse, BreakInfo::After);
      breaks.emplace_back(self->mappingStack.back(), &curr->condition, BreakInfo::After);
      self->mappingStack.pop_back();
      self->currMapping = std::move(merge(breaks));
    }
  }
  static void doIfFalse(SubType* self, Expression** currp) {
    auto* curr = (*currp)->cast<If>();
    std::vector<BreakInfo> breaks;
    breaks.emplace_back(std::move(self->currMapping), &curr->ifFalse, BreakInfo::After);
    breaks.emplace_back(self->mappingStack.back(), &curr->ifTrue, BreakInfo::After);
    self->mappingStack.pop_back();
    self->currMapping = std::move(merge(breaks));
  }
  static void doPreLoop(SubType* self, Expression** currp) {
    // save the state before entering the loop, for calculation later of the merge at the loop top
    self->mappingStack.push_back(self->currMapping);
  }
  static void doVisitLoop(SubType* self, Expression** currp) {
    auto* curr = (*currp)->cast<Loop>();
    if (curr->name.is() && self->breakInfos.find(curr->name) != self->breakInfos.end()) {
      auto& infos = self->breakInfos[curr->name];
      infos.emplace_back(self->mappingStack.back(), currp, BreakInfo::Before);
      self->merge(infos, curr->name); // output is not assigned anywhere, this is an interesting code path
    }
    self->mappingStack.pop_back();
  }
  static void visitBreak(SubType* self, Expression** currp) {
    auto* curr = (*currp)->cast<Break>();
    self->breakInfos[curr->name].emplace_back(std::move(self->currMapping), currp, BreakInfo::Internal);
    if (!(*currp)->cast<Break>()->condition) {
      setUnreachable(self->currMapping);
    }
  }
  static void visitSwitch(SubType* self, Expression** currp) {
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

  // assignments

  void visitSetLocal(SetLocal *curr) {
    currMapping[curr->index] = nextIndex++; // a new assignment, trample the old
  }

  // traversal

  static void scan(SubType* self, Expression** currp) {
    if (auto* iff = (*currp)->dynCast<If>()) {
      // if needs special handling
      if (iff->ifFalse) {
        self->pushTask(SubType::doIfFalse, currp);
        self->pushTask(SubType::scan, iff->ifFalse);
      }
      self->pushTask(SubType::doIfTrue, currp);
      self->pushTask(SubType::scan, iff->ifTrue);
      self->pushTask(SubType::doIfCondition, currp);
      self->pushTask(SubType::scan, iff->condition);
    } else {
      PostWalker<SubType, VisitorType>::scan(self, currp);
    }

    // loops need pre-order visiting too
    if ((*currp)->is<Loop>()) {
      self->pushTask(SubType::doPreLoop, currp);
    }
  }

  // helpers

  void setUnreachable(NameMapping& mapping) {
    mapping.resize(numLocals); // may have been emptied by a move
    mapping[0] = Index(-1);
  }

  bool isUnreachable(NameMapping& mapping) {
    return mapping[0] == Index(-1);
  }

  // merges a bunch of infos into one. where necessary calls a phi hook.
  NameMapping& merge(std::vector<BreakInfo>& infos, Name name = Name()) {
    auto& out = infos[0];
    for (Index i = 0; i < numLocals; i++) {
      Index seen = -1;
      for (auto& info : infos) {
        if (isUnreachable(info.mapping)) continue;
        if (seen == -1) {
          seen = info.mapping[i];
        } else {
          if (info.mapping[i] != seen) {
            // we need a phi here
            seen = nextIndex++;
            createPhi(infos, i, seen, name);
            break;
          }
        }
      }
      out.mapping[i] = seen;
    }
    return out.mapping;
  }

  void createPhi(std::vector<BreakInfo>& infos, Index old, Index new_, Name name) {
    abort(); // override this in child classes
  }
};

struct LoopPhiFinder : public SetTrackingWalker<LoopPhiFinder, Visitor<LoopPhiFinder>> {
  std::map<Name, std::vector<Index>> loopPhis; // loop name => list of source indexes that need a phi

  LoopPhiFinder(Function* func) : SetTrackingWalker(func) {}

  void createPhi(std::vector<BreakInfo>& infos, Index old, Index new_, Name name) {
    for (auto& info : infos) {
      if (info.type == BreakInfo::Before) {
        auto* loop = (*info.origin)->cast<Loop>();
        loopPhis[loop->name].push_back(old);
      }
    }
  }
};

struct SSAify : public Pass {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new SSAify; }

  void runFunction(PassRunner* runner, Module* module, Function* function) override {
    // count how many set_locals each local has. if it already has just 1, we can ignore it.
    LoopPhiFinder finder(&numSetLocals, func);
  }
};

Pass *createSSAifyPass() {
  return new SSAify();
}

} // namespace wasm

