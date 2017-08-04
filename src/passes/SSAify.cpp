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
// single assignment.
//
// Note that "SSA form" usually means SSA + phis. This pass does not
// create phis, we still emit something in our AST, which does not
// have a phi instruction. What we emit when control flow joins
// require more than one input to a value is multiple assignments
// to the same local, with the SSA guarantee that one and only one
// of those assignments will arrive at the uses of that "merge local".
// TODO: consider adding a "proper" phi node to the AST, that passes
//       can utilize
//

#include <iterator>

#include "wasm.h"
#include "pass.h"
#include "wasm-builder.h"
#include "support/permutations.h"
#include "ast/literal-utils.h"

namespace wasm {

// A set we know is impossible / not in the ast
SetLocal IMPOSSIBLE_SET;

// Tracks assignments to locals, assuming single-assignment form, i.e.,
// each assignment creates a new variable.

struct SSAify : public WalkerPass<PostWalker<SSAify>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new SSAify; }

  // the set_locals relevant for an index or a get. we use
  // as set as merges of control flow mean more than 1 may
  // be relevant; we create a phi on demand when necessary for those
  typedef std::set<SetLocal*> Sets;

  // we map (old local index) => the set_locals for that index.
  // a nullptr set means there is a virtual set, from a param
  // initial value or the zero init initial value.
  typedef std::vector<Sets> Mapping;

  Index numLocals;
  Mapping currMapping;
  Index nextIndex;
  std::vector<Mapping> mappingStack; // used in ifs, loops
  std::map<Name, std::vector<Mapping>> breakMappings; // break target => infos that reach it
  std::vector<std::vector<GetLocal*>> loopGetStack; //  stack of loops, all the gets in each, so we can update them for back branches
  std::vector<Expression*> functionPrepends; // things we add to the function prologue
  std::map<GetLocal*, Sets> getSetses; // the sets for each get
  std::map<GetLocal*, Expression**> getLocations;

  void doWalkFunction(Function* func) {
    numLocals = func->getNumLocals();
    if (numLocals == 0) return; // nothing to do
    // We begin with each param being assigned from the incoming value, and the zero-init for the locals,
    // so the initial state is the identity permutation
    currMapping.resize(numLocals);
    for (auto& set : currMapping) {
      set = { nullptr };
    }
    nextIndex = numLocals;
    WalkerPass<PostWalker<SSAify>>::walk(func->body);
    // apply - we now know the sets for each get
    computeGetsAndPhis();
    // add prepends
    if (functionPrepends.size() > 0) {
      Builder builder(*getModule());
      auto* block = builder.makeBlock();
      for (auto* pre : functionPrepends) {
        block->list.push_back(pre);
      }
      block->list.push_back(func->body);
      block->finalize(func->body->type);
      func->body = block;
    }
  }

  // control flow

  void visitBlock(Block* curr) {
    if (curr->name.is() && breakMappings.find(curr->name) != breakMappings.end()) {
      auto& infos = breakMappings[curr->name];
      infos.emplace_back(std::move(currMapping));
      currMapping = std::move(merge(infos));
      breakMappings.erase(curr->name);
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
  void visitLoop(Loop* curr) {
    if (curr->name.is() && breakMappings.find(curr->name) != breakMappings.end()) {
      auto& infos = breakMappings[curr->name];
      infos.emplace_back(std::move(mappingStack.back()));
      auto before = infos.back();
      auto& merged = merge(infos);
      // every local we created a phi for requires us to update get_local operations in
      // the loop - the branch back has means that gets in the loop have potentially
      // more sets reaching them.
      // we can detect this as follows: if a get of oldIndex has the same sets
      // as the sets at the entrance to the loop, then it is affected by the loop
      // header sets, and we can add to there sets that looped back
      auto linkLoopTop = [&](Index i, Sets& getSets) {
        auto& beforeSets = before[i];
        if (getSets.size() < beforeSets.size()) {
          // the get trivially has fewer sets, so it overrode the loop entry sets
          return;
        }
        std::vector<SetLocal*> intersection;
        std::set_intersection(beforeSets.begin(), beforeSets.end(),
                              getSets.begin(), getSets.end(),
                              std::back_inserter(intersection));
        if (intersection.size() < beforeSets.size()) {
          // the get has not the same sets as in the loop entry
          return;
        }
        // the get has the entry sets, so add any new ones
        for (auto* set : merged[i]) {
          getSets.insert(set);
        }
      };
      auto& gets = loopGetStack.back();
      for (auto* get : gets) {
        linkLoopTop(get->index, getSetses[get]);
      }
      // and the same for the loop fallthrough: any local that still has the
      // entry sets should also have the loop-back sets as well
      for (Index i = 0; i < numLocals; i++) {
        linkLoopTop(i, currMapping[i]);
      }
      // finally, breaks still in flight must be updated too
      for (auto& iter : breakMappings) {
        auto name = iter.first;
        if (name == curr->name) continue; // skip our own (which is still in use)
        auto& mappings = iter.second;
        for (auto& mapping : mappings) {
          for (Index i = 0; i < numLocals; i++) {
            linkLoopTop(i, mapping[i]);
          }
        }
      }
      // now that we are done with using the mappings, erase our own
      breakMappings.erase(curr->name);
    }
    mappingStack.pop_back();
    loopGetStack.pop_back();
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

  void visitGetLocal(GetLocal* curr) {
    assert(currMapping.size() == numLocals);
    assert(curr->index < numLocals);
    for (auto& loopGets : loopGetStack) {
      loopGets.push_back(curr);
    }
    // current sets are our sets
    getSetses[curr] = currMapping[curr->index];
    getLocations[curr] = getCurrentPointer();
  }
  void visitSetLocal(SetLocal* curr) {
    assert(currMapping.size() == numLocals);
    assert(curr->index < numLocals);
    // current sets are just this set
    currMapping[curr->index] = { curr }; // TODO optimize?
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
    mapping[0].clear();
  }

  bool isUnreachable(Mapping& mapping) {
    // we must have some set for each index, if only the zero init, so empty means we emptied it for unreachable code
    return mapping[0].empty();
  }

  // merges a bunch of infos into one.
  // if we need phis, writes them into the provided vector. the caller should
  // ensure those are placed in the right location
  Mapping& merge(std::vector<Mapping>& mappings) {
    assert(mappings.size() > 0);
    auto& out = mappings[0];
    if (mappings.size() == 1) {
      return out;
    }
    // merge into the first
    for (Index j = 1; j < mappings.size(); j++) {
      auto& other = mappings[j];
      for (Index i = 0; i < numLocals; i++) {
        auto& outSets = out[i];
        for (auto* set : other[i]) {
          outSets.insert(set);
        }
      }
    }
    return out;
  }

  // After we traversed it all, we can compute gets and phis
  void computeGetsAndPhis() {
    for (auto& iter : getSetses) {
      auto* get = iter.first;
      auto& sets = iter.second;
      if (sets.size() == 0) {
        continue; // unreachable, ignore
      }
      if (sets.size() == 1) {
        // TODO: add tests for this case
        // easy, just one set, use it's index
        auto* set = *sets.begin();
        if (set) {
          get->index = set->index;
        } else {
          // no set, assign param or zero
          if (getFunction()->isParam(get->index)) {
            // leave it, it's fine
          } else {
            // zero it out
            (*getLocations[get]) = LiteralUtils::makeZero(get->type, *getModule());
          }
        }
        continue;
      }
      // more than 1 set, need a phi: a new local written to at each of the sets
      // if there is already a local with that property, reuse it
      auto gatherIndexes = [](SetLocal* set) {
        std::set<Index> ret;
        while (set) {
          ret.insert(set->index);
          set = set->value->dynCast<SetLocal>();
        }
        return ret;
      };
      auto indexes = gatherIndexes(*sets.begin());
      for (auto* set : sets) {
        if (set == *sets.begin()) continue;
        auto currIndexes = gatherIndexes(set);
        std::vector<Index> intersection;
        std::set_intersection(indexes.begin(), indexes.end(),
                              currIndexes.begin(), currIndexes.end(),
                              std::back_inserter(intersection));
        indexes.clear();
        if (intersection.empty()) break;
        // TODO: or keep sorted vectors?
        for (Index i : intersection) {
          indexes.insert(i);
        }
      }
      if (!indexes.empty()) {
        // we found an index, use it
        get->index = *indexes.begin();
      } else {
        // we need to create a local for this phi'ing
        auto new_ = addLocal(get->type);
        auto old = get->index;
        get->index = new_;
        Builder builder(*getModule());
        // write to the local in each of our sets
        for (auto* set : sets) {
          if (set) {
            // a set exists, just add a tee of its value
            set->value = builder.makeTeeLocal(
              new_,
              set->value
            );
          } else {
            // this is a param or the zero init value.
            if (getFunction()->isParam(old)) {
              // we add a set with the proper
              // param value at the beginning of the function
              auto* set = builder.makeSetLocal(
                new_,
                builder.makeGetLocal(old, getFunction()->getLocalType(old))
              );
              functionPrepends.push_back(set);
            } else {
              // this is a zero init, so we don't need to do anything actually
            }
          }
        }
      }
    }
  }

  Index addLocal(WasmType type) {
    return Builder::addVar(getFunction(), type);
  }
};

Pass *createSSAifyPass() {
  return new SSAify();
}

} // namespace wasm

