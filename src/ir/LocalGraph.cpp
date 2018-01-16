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

#include <iterator>

#include <wasm-builder.h>
#include <wasm-printing.h>
#include <ir/find_all.h>
#include <ir/local-graph.h>
#include <cfg/cfg-traversal.h>

namespace wasm {

// A set of live get_locals, for each index
typedef std::unordered_map<Index, std::unordered_set<GetLocal*>> Gets;

// A relevant action. Supports a get, a set, or an
// "other" which can be used for other purposes, to mark
// their position in a block
struct Action {
  enum What {
    Get = 0,
    Set = 1
  };
  What what;
  Index index; // the local index read or written
  Expression* expr; // the expression itself

  Action(What what, Index index, Expression* expr) : what(what), index(index), expr(expr) {
    if (what == Get) assert(expr->is<GetLocal>());
    if (what == Set) assert(expr->is<SetLocal>());
  }

  bool isGet() { return what == Get; }
  bool isSet() { return what == Set; }
};

// information about a basic block
struct Info {
  Gets start, end; // live gets at the start and end
  std::vector<Action> actions; // actions occurring in this block

  void dump(Function* func) {
    if (actions.empty()) return;
    std::cout << "    actions:\n";
    for (auto& action : actions) {
      std::cout << "      " << (action.isGet() ? "get" : "set") << " " << func->getLocalName(action.index) << "\n";
    }
  }
};

// flower helper class. flows the gets to their sets

struct Flower : public CFGWalker<Flower, Visitor<Flower>, Info> {
  // cfg traversal work

  static void doVisitGetLocal(Flower* self, Expression** currp) {
    auto* curr = (*currp)->cast<GetLocal>();
     // if in unreachable code, skip
    if (!self->currBasicBlock) return;
    self->currBasicBlock->contents.actions.emplace_back(Action::Get, curr->index, curr);
  }

  static void doVisitSetLocal(Flower* self, Expression** currp) {
    auto* curr = (*currp)->cast<SetLocal>();
    // if in unreachable code, skip
    if (!self->currBasicBlock) return;
    self->currBasicBlock->contents.actions.emplace_back(Action::Set, curr->index, curr);
  }

  // main entry point

  Index numLocals;

  void compute(Function* func, LocalGraph::GetSetses& getSetses) {
    numLocals = func->getNumLocals();
    // create the CFG by walking the IR
    CFGWalker<Flower, Visitor<Flower>, Info>::doWalkFunction(func);
    // flow gets across blocks
    flow();
    // compute our output data structures
    computeGetSetses(getSetses);
  }

  void flow() {
    // keep working while stuff is flowing
    std::unordered_set<BasicBlock*> queue;
    for (auto& curr : basicBlocks) {
      queue.insert(curr.get());
      // do the first scan through the block, starting with nothing at the end, and updating to the start
      scanThroughActions(curr->contents.actions, curr->contents.start);
    }
    while (queue.size() > 0) {
      auto iter = queue.begin();
      auto* curr = *iter;
      queue.erase(iter);
      Gets gets;
      if (!mergeStartsAndCheckChange(curr->out, curr->contents.end, gets)) continue;
      curr->contents.end = gets;
      scanThroughActions(curr->contents.actions, gets);
      // liveness is now calculated at the start. if something
      // changed, all predecessor blocks need recomputation
      if (curr->contents.start == gets) continue;
      assert(curr->contents.start.size() < gets.size());
      curr->contents.start = gets;
      for (auto* in : curr->in) {
        queue.insert(in);
      }
    }
  }

  void scanThroughActions(std::vector<Action>& actions, Gets& gets) {
    // move towards the front
    for (int i = int(actions.size()) - 1; i >= 0; i--) {
      auto& action = actions[i];
      if (action.isGet()) {
        gets[action.index].insert(action.expr->cast<GetLocal>());
      } else {
        gets.erase(action.index);
      }
    }
  }

  // merge starts of a list of blocks. return
  // whether anything changed vs an old state (which indicates further processing is necessary).
  bool mergeStartsAndCheckChange(std::vector<BasicBlock*>& blocks, Gets& old, Gets& ret) {
    if (blocks.size() == 0) return false;
    ret = blocks[0]->contents.start;
    if (blocks.size() > 1) {
      // more than one, so we must merge
      for (Index i = 1; i < blocks.size(); i++) {
        auto* curr = blocks[i];
        for (Index j = 0; j < numLocals; j++) {
          auto& currStart = curr->contents.start;
          if (!currStart.count(j)) continue; // nothing to add
          if (ret.count(j)) {
            // both, do a merge
            for (auto* get : currStart[j]) {
              ret[j].insert(get);
            }
          } else {
            // copy over
            ret[j] = currStart[j];
          }
        }
      }
    }
    return old != ret;
  }

  void computeGetSetses(LocalGraph::GetSetses& getSetses) {
    for (auto& block : basicBlocks) {
      auto& actions = block->contents.actions;
      Gets gets = block->contents.end;
      for (int i = int(actions.size()) - 1; i >= 0; i--) {
        auto& action = actions[i];
        auto index = action.index;
        if (action.isGet()) {
          gets[action.index].insert(action.expr->cast<GetLocal>());
        } else {
          auto* set = action.expr->cast<SetLocal>();
          for (auto* get : gets[index]) {
            getSetses[get].insert(set);
          }
          gets.erase(action.index);
        }
      }
    }
  }
};

// LocalGraph implementation

LocalGraph::LocalGraph(Function* func) {
  Flower flower;
  flower.compute(func, getSetses);

#ifdef LOCAL_GRAPH_DEBUG
  std::cout << "LocalGraph::dump\n";
  for (auto& pair : getSetses) {
    auto* get = pair.first;
    auto& sets = pair.second;
    std::cout << "GET\n" << get << " is influenced by\n";
    for (auto* set : sets) {
      std::cout << set << '\n';
    }
  }
#endif
}

void LocalGraph::computeInfluences() {
  for (auto& pair : locations) {
    auto* curr = pair.first;
    if (auto* set = curr->dynCast<SetLocal>()) {
      FindAll<GetLocal> findAll(set->value);
      for (auto* get : findAll.list) {
        getInfluences[get].insert(set);
      }
    } else {
      auto* get = curr->cast<GetLocal>();
      for (auto* set : getSetses[get]) {
        setInfluences[set].insert(get);
      }
    }
  }
}

} // namespace wasm

