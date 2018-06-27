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

namespace LocalGraphInternal {

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
  std::vector<Action> actions; // actions occurring in this block
  std::unordered_map<Index, SetLocal*> lastSets; // for each index, the last set_local for it

  void dump(Function* func) {
    if (actions.empty()) return;
    std::cout << "    actions:\n";
    for (auto& action : actions) {
      std::cout << "      " << (action.isGet() ? "get" : "set") << " " << func->getLocalName(action.index) << "\n";
    }
  }
};

// flow helper class. flows the gets to their sets

struct Flower : public CFGWalker<Flower, Visitor<Flower>, Info> {
  LocalGraph::GetSetses& getSetses;
  LocalGraph::Locations& locations;

  Flower(LocalGraph::GetSetses& getSetses, LocalGraph::Locations& locations, Function* func) : getSetses(getSetses), locations(locations) {
    setFunction(func);
    // create the CFG by walking the IR
    CFGWalker<Flower, Visitor<Flower>, Info>::doWalkFunction(func);
    // flow gets across blocks
    flow(func);
  }

  BasicBlock* makeBasicBlock() {
    return new BasicBlock();
  }

  // cfg traversal work

  static void doVisitGetLocal(Flower* self, Expression** currp) {
    auto* curr = (*currp)->cast<GetLocal>();
     // if in unreachable code, skip
    if (!self->currBasicBlock) return;
    self->currBasicBlock->contents.actions.emplace_back(Action::Get, curr->index, curr);
    self->locations[curr] = currp;
  }

  static void doVisitSetLocal(Flower* self, Expression** currp) {
    auto* curr = (*currp)->cast<SetLocal>();
    // if in unreachable code, skip
    if (!self->currBasicBlock) return;
    self->currBasicBlock->contents.actions.emplace_back(Action::Set, curr->index, curr);
    self->currBasicBlock->contents.lastSets[curr->index] = curr;
    self->locations[curr] = currp;
  }

  void flow(Function* func) {
    // This block struct is optimized for this flow process (Minimal information, iteration index).
    struct FlowBlock {
      // last Traversed Iteration
      // This value help us to find if this block has been seen while traversing blocks.
      // We compare this value to the current iteration index in order to determine if we already process this block in the current iteration.
      // This speed up the processing compared to unordered_set or other struct usage. (No need to reset internal values, lookup into container, ...)
      size_t lastTraversedIteration;
      std::vector<Action> actions; // actions occurring in this block
      std::vector<FlowBlock*> in;
      // for each index, the last set_local for it
      // The unordered_map from BasicBlock is converted ther into a vector
      // This speed up search as there are almost always fewer than 100 items
      std::vector<std::pair<Index, SetLocal*>> lastSets; 
    };

    auto numLocals = func->getNumLocals();
    std::vector<std::vector<GetLocal*>> allGets;
    allGets.resize(numLocals);
    std::vector<FlowBlock*> work;


    // Converts input blocks (basicBlocks) into more efficient blocks to improve memory access.
    std::vector<FlowBlock> flowBlocks;
    flowBlocks.resize(basicBlocks.size());

    // Init mapping between basicblocks and flowBlocks
    std::unordered_map<BasicBlock*, FlowBlock*> basicToFlowMap;
    for (size_t i = 0; i < basicBlocks.size(); ++i) {
      basicToFlowMap.emplace(std::make_pair(basicBlocks[i].get(), &flowBlocks[i]));
    }

    FlowBlock* entryFlowBlock = nullptr;
    for (size_t i = 0; i < flowBlocks.size(); ++i) {
      auto& optBlock = flowBlocks[i];
      auto& inBlock = basicBlocks[i];
      // Get the equivalent block to entry in the flow list
      if (inBlock.get() == entry) entryFlowBlock = &optBlock;
      // Initialize iteration index to max size_t to ensure we don't miss a block from wrong value.
      optBlock.lastTraversedIteration = -1;
      optBlock.actions.swap(inBlock->contents.actions);
      // Map in block to flow blocks
      auto& inBlocks = inBlock->in;
      optBlock.in.resize(inBlocks.size());
      std::transform(inBlocks.begin(), inBlocks.end(), optBlock.in.begin(), [&](BasicBlock* block) { return basicToFlowMap[block]; });

      // Convert unordered_map to vector
      optBlock.lastSets.reserve(inBlock->contents.lastSets.size());
      for (auto set : inBlock->contents.lastSets) {
        optBlock.lastSets.emplace_back(std::make_pair(set.first, set.second));
      }
    }
    assert(entryFlowBlock != nullptr);

    size_t currentIteration = 0;
    for (auto& block : flowBlocks) {
#ifdef LOCAL_GRAPH_DEBUG
      std::cout << "basic block " << block.get() << " :\n";
      for (auto& action : block->contents.actions) {
        std::cout << "  action: " << action.expr << '\n';
      }
      for (auto* lastSet : block->contents.lastSets) {
        std::cout << "  last set " << lastSet << '\n';
      }
#endif
      // go through the block, finding each get and adding it to its index,
      // and seeing how sets affect that
      auto& actions = block.actions;
      // move towards the front, handling things as we go
      for (int i = int(actions.size()) - 1; i >= 0; i--) {
        auto& action = actions[i];
        auto index = action.index;
        if (action.isGet()) {
          allGets[index].push_back(action.expr->cast<GetLocal>());
        } else {
          // this set is the only set for all those gets
          auto* set = action.expr->cast<SetLocal>();
          auto& gets = allGets[index];
          for (auto* get : gets) {
            getSetses[get].insert(set);
          }
          gets.clear();
        }
      }
      // if anything is left, we must flow it back through other blocks. we
      // can do that for all gets as a whole, they will get the same results
      for (Index index = 0; index < numLocals; index++) {
        auto& gets = allGets[index];
        if (gets.empty()) continue;
        work.push_back(&block);

        // note that we may need to revisit the later parts of this initial
        // block, if we are in a loop, so don't mark it as seen
        while (!work.empty()) {
          auto* curr = work.back();
          work.pop_back();
          // we have gone through this block; now we must handle flowing to
          // the inputs
          if (curr->in.empty()) {
            if (curr == entryFlowBlock) {
              // these receive a param or zero init value
              for (auto* get : gets) {
                getSetses[get].insert(nullptr);
              }
            }
          } else {
            for (auto* pred : curr->in) {
              if (pred->lastTraversedIteration == currentIteration) continue;
              pred->lastTraversedIteration = currentIteration;
              auto lastSet = std::find_if(pred->lastSets.begin(), pred->lastSets.end(), [&](std::pair<Index, SetLocal*>& value) { return value.first == index; });
              if (lastSet != pred->lastSets.end()) {
                // there is a set here, apply it, and stop the flow
                for (auto* get : gets) {
                  getSetses[get].insert(lastSet->second);
                }
              } else {
                // keep on flowing
                work.push_back(pred);
              }
            }
          }
        }
        gets.clear();
        currentIteration++;
      }
    }
  }
};

} // namespace LocalGraphInternal

// LocalGraph implementation

LocalGraph::LocalGraph(Function* func) {
  LocalGraphInternal::Flower flower(getSetses, locations, func);

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
  std::cout << "total locations: " << locations.size() << '\n';
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

