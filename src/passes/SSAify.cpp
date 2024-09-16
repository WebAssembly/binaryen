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
// There is also a "no-merge" variant of this pass. That will ignore
// sets leading to merges, that is, it only creates new SSA indexes
// for sets whose gets have just that set, e.g.
//
//  x = ..
//  f(x, x)
//  x = ..
//  g(x, x)
// =>
//  x = ..
//  f(x, x)
//  x' = ..
//  g(x', x')
//
// This "untangles" local indexes in a way that helps other passes,
// while not creating copies with overlapping lifetimes that can
// lead to a code size increase. In particular, the new variables
// added by ssa-nomerge can be easily removed by the coalesce-locals
// pass.
//

#include <iterator>

#include "ir/find_all.h"
#include "ir/literal-utils.h"
#include "ir/local-graph.h"
#include "ir/utils.h"
#include "pass.h"
#include "support/permutations.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

// A set we know is impossible / not in the ast
static LocalSet IMPOSSIBLE_SET;

// Tracks assignments to locals, assuming single-assignment form, i.e.,
// each assignment creates a new variable.

struct SSAify : public Pass {
  bool isFunctionParallel() override { return true; }

  // SSAify maps each original local to a number of new ones.
  // FIXME DWARF updating does not handle local changes yet.
  bool invalidatesDWARF() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<SSAify>(allowMerges);
  }

  SSAify(bool allowMerges) : allowMerges(allowMerges) {}

  bool allowMerges;

  Module* module;
  Function* func;
  // things we add to the function prologue
  std::vector<Expression*> functionPrepends;
  bool refinalize = false;

  void runOnFunction(Module* module_, Function* func_) override {
    module = module_;
    func = func_;
    LocalGraph graph(func, module);
    graph.computeSetInfluences();
    graph.computeSSAIndexes();
    // create new local indexes, one for each set
    createNewIndexes(graph);
    // we now know the sets for each get, and can compute get indexes and handle
    // phis
    computeGetsAndPhis(graph);
    // add prepends to function
    addPrepends();

    if (refinalize) {
      ReFinalize().walkFunctionInModule(func, module);
    }
  }

  void createNewIndexes(LocalGraph& graph) {
    FindAll<LocalSet> sets(func->body);
    for (auto* set : sets.list) {
      // Indexes already in SSA form do not need to be modified - there is
      // already just one set for that index. Otherwise, use a new index, unless
      // merges are disallowed.
      if (!graph.isSSA(set->index) && (allowMerges || !hasMerges(set, graph))) {
        set->index = addLocal(func->getLocalType(set->index));
      }
    }
  }

  bool hasMerges(LocalSet* set, LocalGraph& graph) {
    for (auto* get : graph.getSetInfluences(set)) {
      if (graph.getSets(get).size() > 1) {
        return true;
      }
    }
    return false;
  }

  void computeGetsAndPhis(LocalGraph& graph) {
    FindAll<LocalGet> gets(func->body);
    for (auto* get : gets.list) {
      auto& sets = graph.getSets(get);
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
          } else if (LiteralUtils::canMakeZero(get->type)) {
            // zero it out
            (*graph.locations[get]) =
              LiteralUtils::makeZero(get->type, *module);
            // If we replace a local.get with a null then we are refining the
            // type that the parent receives to a bottom type.
            if (get->type.isRef()) {
              refinalize = true;
            }
          } else {
            // No zero exists here, so this is a nondefaultable type. The
            // default won't be used anyhow, so this value does not really
            // matter and we have nothing to do.
          }
        }
        continue;
      }
      if (!allowMerges) {
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
          auto* tee = builder.makeLocalTee(new_, value, get->type);
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
            auto* set = builder.makeLocalSet(
              new_, builder.makeLocalGet(old, func->getLocalType(old)));
            functionPrepends.push_back(set);
          } else {
            // this is a zero init, so we don't need to do anything actually
          }
        }
      }
    }
  }

  Index addLocal(Type type) { return Builder::addVar(func, type); }

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

Pass* createSSAifyPass() { return new SSAify(true); }

Pass* createSSAifyNoMergePass() { return new SSAify(false); }

} // namespace wasm
