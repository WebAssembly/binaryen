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
#include "ir/literal-utils.h"
#include "ir/local-graph.h"

namespace wasm {

// A set we know is impossible / not in the ast
static SetLocal IMPOSSIBLE_SET;

// Tracks assignments to locals, assuming single-assignment form, i.e.,
// each assignment creates a new variable.

struct SSAify : public Pass {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new SSAify; }

  Module* module;
  Function* func;
  std::vector<Expression*> functionPrepends; // things we add to the function prologue

  void runOnFunction(PassRunner* runner, Module* module_, Function* func_) override {
    module = module_;
    func = func_;
    LocalGraph graph(func);
    // create new local indexes, one for each set
    createNewIndexes(graph);
    // we now know the sets for each get, and can compute get indexes and handle phis
    computeGetsAndPhis(graph);
    // add prepends to function
    addPrepends();
  }

  void createNewIndexes(LocalGraph& graph) {
    for (auto& pair : graph.locations) {
      auto* curr = pair.first;
      if (auto* set = curr->dynCast<SetLocal>()) {
        set->index = addLocal(func->getLocalType(set->index));
      }
    }
  }

  void computeGetsAndPhis(LocalGraph& graph) {
    for (auto& iter : graph.getSetses) {
      auto* get = iter.first;
      auto& sets = iter.second;
      if (sets.size() == 0) {
        continue; // unreachable, ignore
      }
      if (sets.size() == 1) {
        // easy, just one set, use its index
        auto* set = *sets.begin();
        if (set) {
          get->index = set->index;
        } else {
          // no set, assign param or zero
          if (func->isParam(get->index)) {
            // leave it, it's fine
          } else {
            // zero it out
            (*graph.locations[get]) = LiteralUtils::makeZero(get->type, *module);
          }
        }
        continue;
      }
      // more than 1 set, need a phi: a new local written to at each of the sets
      auto new_ = addLocal(get->type);
      auto old = get->index;
      get->index = new_;
      Builder builder(*module);
      // write to the local in each of our sets
      for (auto* set : sets) {
        if (set) {
          // a set exists, just add a tee of its value
          auto* value = set->value;
          auto* tee = builder.makeTeeLocal(
            new_,
            value
          );
          set->value = tee;
          // the value may have been something we tracked the location
          // of. if so, update that, since we moved it into the tee
          if (graph.locations.count(value) > 0) {
            assert(graph.locations[value] == &set->value);
            graph.locations[value] = &tee->value;
          }
        } else {
          // this is a param or the zero init value.
          if (func->isParam(old)) {
            // we add a set with the proper
            // param value at the beginning of the function
            auto* set = builder.makeSetLocal(
              new_,
              builder.makeGetLocal(old, func->getLocalType(old))
            );
            functionPrepends.push_back(set);
          } else {
            // this is a zero init, so we don't need to do anything actually
          }
        }
      }
    }
  }

  Index addLocal(Type type) {
    return Builder::addVar(func, type);
  }

  void addPrepends() {
    if (functionPrepends.size() > 0) {
      Builder builder(*module);
      auto* block = builder.makeBlock();
      for (auto* pre : functionPrepends) {
        block->list.push_back(pre);
      }
      block->list.push_back(func->body);
      block->finalize(func->body->type);
      func->body = block;
    }
  }
};

Pass *createSSAifyPass() {
  return new SSAify();
}

} // namespace wasm

