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

#include <cfg/cfg-traversal.h>
#include <ir/find_all.h>
#include <ir/local-graph.h>
#include <wasm-builder.h>

namespace wasm {

namespace {

// Information about a basic block.
struct Info {
  // actions occurring in this block: local.gets and local.sets
  std::vector<Expression*> actions;
  // for each index, the last local.set for it
  std::unordered_map<Index, LocalSet*> lastSets;

  void dump(Function* func) {
    std::cout << "    info: " << actions.size() << " actions\n";
  }
};

} // anonymous namespace

// flow helper class. flows the gets to their sets

struct LocalGraphFlower
  : public CFGWalker<LocalGraphFlower, Visitor<LocalGraphFlower>, Info> {
  LocalGraph::GetSetsMap& getSetsMap;
  LocalGraph::Locations& locations;
  Function* func;

  LocalGraphFlower(LocalGraph::GetSetsMap& getSetsMap,
                   LocalGraph::Locations& locations,
                   Function* func,
                   Module* module)
    : getSetsMap(getSetsMap), locations(locations), func(func) {
    setFunction(func);
    setModule(module);
    // create the CFG by walking the IR
    CFGWalker<LocalGraphFlower, Visitor<LocalGraphFlower>, Info>::
      doWalkFunction(func);
  }

  BasicBlock* makeBasicBlock() { return new BasicBlock(); }

  // Branches outside of the function can be ignored, as we only look at locals
  // which vanish when we leave.
  bool ignoreBranchesOutsideOfFunc = true;

  // cfg traversal work

  static void doVisitLocalGet(LocalGraphFlower* self, Expression** currp) {
    auto* curr = (*currp)->cast<LocalGet>();
    // if in unreachable code, skip
    if (!self->currBasicBlock) {
      return;
    }
    self->currBasicBlock->contents.actions.emplace_back(curr);
    self->locations[curr] = currp;
  }

  static void doVisitLocalSet(LocalGraphFlower* self, Expression** currp) {
    auto* curr = (*currp)->cast<LocalSet>();
    // if in unreachable code, skip
    if (!self->currBasicBlock) {
      return;
    }
    self->currBasicBlock->contents.actions.emplace_back(curr);
    self->currBasicBlock->contents.lastSets[curr->index] = curr;
    self->locations[curr] = currp;
  }

  // Each time we flow a get (or set of gets) to find its sets, we mark a
  // different iteration number. This lets us memoize the current iteration on
  // blocks as we pass them, allowing us to quickly skip them in that iteration
  // (another option would be a set of blocks we've visited, but storing the
  // iteration number on blocks is faster since we are already processing that
  // FlowBlock already, meaning it is likely in cache, and avoids a set lookup).
  size_t currentIteration = 0;

  // This block struct is optimized for this flow process (Minimal
  // information, iteration index).
  struct FlowBlock {
    // See currentIteration, above.
    size_t lastTraversedIteration;

    static const size_t NULL_ITERATION = -1;

    // TODO: this could be by local index?
    std::vector<Expression*> actions;
    std::vector<FlowBlock*> in;
    // Sor each index, the last local.set for it
    // The unordered_map from BasicBlock.Info is converted into a vector
    // This speeds up search as there are usually few sets in a block, so just
    // scanning them linearly is efficient, avoiding hash computations (while
    // in Info, it's convenient to have a map so we can assign them easily,
    // where the last one seen overwrites the previous; and, we do that O(1)).
    // TODO: If we also stored gets here then we could use the sets for a get
    //       we already computed, for a get that we are computing, and stop that
    //       part of the flow.
    std::vector<std::pair<Index, LocalSet*>> lastSets;
  };

  // All the flow blocks.
  std::vector<FlowBlock> flowBlocks;

  // A mapping of basic blocks to flow blocks.
  std::unordered_map<BasicBlock*, FlowBlock*> basicToFlowMap;

  // The flow block corresponding to the function entry block.
  FlowBlock* entryFlowBlock = nullptr;

  // We note which local indexes have local.sets, as that can help us
  // optimize later (if there are none at all, we do not need to flow).
  std::vector<bool> hasSet;

  // Fill in flowBlocks and basicToFlowMap.
  void prepareFlowBlocks() {
    auto numLocals = func->getNumLocals();

    // Convert input blocks (basicBlocks) into more efficient flow blocks to
    // improve memory access.
    flowBlocks.resize(basicBlocks.size());

    hasSet.resize(numLocals, false);

    // Init mapping between basicblocks and flowBlocks
    for (Index i = 0; i < basicBlocks.size(); ++i) {
      auto* block = basicBlocks[i].get();
      basicToFlowMap[block] = &flowBlocks[i];
    }

    for (Index i = 0; i < flowBlocks.size(); ++i) {
      auto& block = basicBlocks[i];
      auto& flowBlock = flowBlocks[i];
      // Get the equivalent block to entry in the flow list
      if (block.get() == entry) {
        entryFlowBlock = &flowBlock;
      }
      flowBlock.lastTraversedIteration = FlowBlock::NULL_ITERATION;
      flowBlock.actions.swap(block->contents.actions);
      // Map in block to flow blocks
      auto& in = block->in;
      flowBlock.in.resize(in.size());
      std::transform(in.begin(),
                     in.end(),
                     flowBlock.in.begin(),
                     [&](BasicBlock* block) { return basicToFlowMap[block]; });
      // Convert unordered_map to vector.
      flowBlock.lastSets.reserve(block->contents.lastSets.size());
      for (auto set : block->contents.lastSets) {
        flowBlock.lastSets.emplace_back(set);
        hasSet[set.first] = true;
      }
    }
    assert(entryFlowBlock != nullptr);
  }

  // Flow all the data. This is done in eager (i.e., non-lazy) mode.
  void flow() {
    prepareFlowBlocks();

    auto numLocals = func->getNumLocals();

    for (auto& block : flowBlocks) {
#ifdef LOCAL_GRAPH_DEBUG
      std::cout << "basic block " << &block << " :\n";
      for (auto& action : block.actions) {
        std::cout << "  action: " << *action << '\n';
      }
      for (auto& val : block.lastSets) {
        std::cout << "  last set " << val.second << '\n';
      }
#endif

      // Track all gets in this block, by index.
      std::vector<std::vector<LocalGet*>> allGets(numLocals);

      // go through the block, finding each get and adding it to its index,
      // and seeing how sets affect that
      auto& actions = block.actions;

      // move towards the front, handling things as we go
      for (int i = int(actions.size()) - 1; i >= 0; i--) {
        auto* action = actions[i];
        if (auto* get = action->dynCast<LocalGet>()) {
          allGets[get->index].push_back(get);
        } else {
          // This set is the only set for all those gets.
          auto* set = action->cast<LocalSet>();
          auto& gets = allGets[set->index];
          for (auto* get : gets) {
            getSetsMap[get].insert(set);
          }
          gets.clear();
        }
      }
      // If anything is left, we must flow it back through other blocks. we
      // can do that for all gets as a whole, they will get the same results.
      for (Index index = 0; index < numLocals; index++) {
        auto& gets = allGets[index];
        if (gets.empty()) {
          continue;
        }
        if (!hasSet[index]) {
          // This local index has no sets, so we know all gets will end up
          // reaching the entry block. Do that here as an optimization to avoid
          // flowing through the (potentially very many) blocks in the function.
          //
          // Note that we may be in unreachable code, and if so, we might add
          // the entry values when they are not actually relevant. That is, we
          // are not precise in the case of unreachable code. This can be
          // confusing when debugging, but it does not have any downside for
          // optimization (since unreachable code should be removed anyhow).
          for (auto* get : gets) {
            getSetsMap[get].insert(nullptr);
          }
          continue;
        }

        flowBackFromStartOfBlock(&block, index, gets);
      }
    }
  }

  // Given a flow block and a set of gets all of the same index, begin at the
  // start of the block and flow backwards to find the sets affecting them. This
  // does not look into |block| itself (unless we are in a loop, and reach it
  // again), that is, it is a utility that is called when we are ready to do a
  // cross-block flow.
  //
  // All the sets we find are applied to all the gets we are given.
  void flowBackFromStartOfBlock(FlowBlock* block,
                                Index index,
                                const std::vector<LocalGet*>& gets) {
    std::vector<FlowBlock*> work; // TODO: UniqueDeferredQueue
    work.push_back(block);
    // Note that we may need to revisit the later parts of this initial
    // block, if we are in a loop, so don't mark it as seen.
    while (!work.empty()) {
      auto* curr = work.back();
      work.pop_back();
      // We have gone through this block; now we must handle flowing to
      // the inputs.
      if (curr->in.empty()) {
        if (curr == entryFlowBlock) {
          // These receive a param or zero init value.
          for (auto* get : gets) {
            getSetsMap[get].insert(nullptr);
          }
        }
      } else {
        for (auto* pred : curr->in) {
          if (pred->lastTraversedIteration == currentIteration) {
            // We've already seen pred in this iteration.
            continue;
          }
          pred->lastTraversedIteration = currentIteration;
          auto lastSet = std::find_if(pred->lastSets.begin(),
                                      pred->lastSets.end(),
                                      [&](std::pair<Index, LocalSet*>& value) {
                                        return value.first == index;
                                      });
          if (lastSet != pred->lastSets.end()) {
            // There is a set here, apply it, and stop the flow.
            for (auto* get : gets) {
              getSetsMap[get].insert(lastSet->second);
            }
          } else {
            // Keep on flowing.
            work.push_back(pred);
          }
        }
      }
    }

    // Bump the current iteration for the next time we are called.
    currentIteration++;
  }

  // When the LocalGraph is in lazy mode we do not compute all of getSetsMap
  // initially, but instead fill in these data structures that let us do so
  // later for individual gets. Specifically we need to find the location of a
  // local.get in the CFG.
  struct BlockLocation {
    // The basic block an item is in.
    FlowBlock* block = nullptr;
    // The index in that block that the item is at.
    Index index;
  };
  std::unordered_map<LocalGet*, BlockLocation> getLocations;

  // Set up getLocations using the flow blocks, so that we are ready to handle
  // later lazy requests for the sets of particular gets. This is done in lazy
  // mode.
  void prepareLaziness() {
    prepareFlowBlocks();

    for (auto& block : flowBlocks) {
      const auto& actions = block.actions;
      for (Index i = 0; i < actions.size(); i++) {
        if (auto* get = actions[i]->dynCast<LocalGet>()) {
          getLocations[get] = BlockLocation{&block, i};
        }
      }
    }
  }

  // Flow a specific get. This is done in lazy mode.
  void flowGet(LocalGet* get) {
    auto index = get->index;

    // Regardless of what we do below, ensure an entry for this get, so that we
    // know we computed it.
    auto& sets = getSetsMap[get];

    auto [block, blockIndex] = getLocations[get];
    if (!block) {
      // We did not find location info for this get, which means it is
      // unreachable.
      return;
    }

    // We must have the get at that location.
    assert(blockIndex < block->actions.size());
    assert(block->actions[blockIndex] == get);

    if (!hasSet[index]) {
      // As in flow(), when there is no local.set for an index we can just mark
      // the default value as the only writer.
      sets.insert(nullptr);
      return;
    }

    // Go backwards in this flow block, from the get. If we see other gets that
    // have not been computed then we can accumulate them as well, as the
    // results we compute apply to them too.
    std::vector<LocalGet*> gets = {get};
    while (blockIndex > 0) {
      blockIndex--;
      auto* curr = block->actions[blockIndex];
      if (auto* otherGet = curr->dynCast<LocalGet>()) {
        if (otherGet->index == index) {
          // This is another get of the same index. If we've already computed
          // it, then we can just use that, as they must have the same sets.
          auto iter = getSetsMap.find(otherGet);
          if (iter != getSetsMap.end()) {
            auto& otherSets = iter->second;
            for (auto* get : gets) {
              getSetsMap[get] = otherSets;
            }
            return;
          }

          // This is a get of the same index, but which has not been computed.
          // It will have the same sets as us.
          gets.push_back(otherGet);
        }
      } else {
        // This is a set.
        auto* set = curr->cast<LocalSet>();
        if (set->index == index) {
          // This is the only set writing to our gets.
          for (auto* get : gets) {
            getSetsMap[get].insert(set);
          }
          return;
        }
      }
    }

    // We must do an inter-block flow.
    flowBackFromStartOfBlock(block, index, gets);
  }
};

// LocalGraph implementation

LocalGraph::LocalGraph(Function* func, Module* module)
  : LocalGraphBase(func, module) {
  // See comment on the declaration of this field for why we use a raw
  // allocation.
  LocalGraphFlower flower(getSetsMap, locations, func, module);
  flower.flow();

#ifdef LOCAL_GRAPH_DEBUG
  std::cout << "LocalGraph::dump\n";
  for (auto& [get, sets] : getSetsMap) {
    std::cout << "GET\n" << get << " is influenced by\n";
    for (auto* set : sets) {
      std::cout << set << '\n';
    }
  }
  std::cout << "total locations: " << locations.size() << '\n';
#endif
}

bool LocalGraph::equivalent(LocalGet* a, LocalGet* b) {
  auto& aSets = getSets(a);
  auto& bSets = getSets(b);
  // The simple case of one set dominating two gets easily proves that they must
  // have the same value. (Note that we can infer dominance from the fact that
  // there is a single set: if the set did not dominate one of the gets then
  // there would definitely be another set for that get, the zero initialization
  // at the function entry, if nothing else.)
  if (aSets.size() != 1 || bSets.size() != 1) {
    // TODO: use a LinearExecutionWalker to find trivially equal gets in basic
    //       blocks. that plus the above should handle 80% of cases.
    // TODO: handle chains, merges and other situations
    return false;
  }
  auto* aSet = *aSets.begin();
  auto* bSet = *bSets.begin();
  if (aSet != bSet) {
    return false;
  }
  if (!aSet) {
    // They are both nullptr, indicating the implicit value for a parameter
    // or the zero for a local.
    if (func->isParam(a->index)) {
      // For parameters to be equivalent they must have the exact same
      // index.
      return a->index == b->index;
    } else {
      // As locals, they are both of value zero, but must have the right
      // type as well.
      return func->getLocalType(a->index) == func->getLocalType(b->index);
    }
  } else {
    // They are both the same actual set.
    return true;
  }
}

void LocalGraph::computeSetInfluences() {
  for (auto& [curr, _] : locations) {
    if (auto* get = curr->dynCast<LocalGet>()) {
      for (auto* set : getSetsMap[get]) {
        setInfluences[set].insert(get);
      }
    }
  }
}

void LocalGraph::computeGetInfluences() {
  for (auto& [curr, _] : locations) {
    if (auto* set = curr->dynCast<LocalSet>()) {
      FindAll<LocalGet> findAll(set->value);
      for (auto* get : findAll.list) {
        getInfluences[get].insert(set);
      }
    }
  }
}

void LocalGraph::computeSSAIndexes() {
  std::unordered_map<Index, std::set<LocalSet*>> indexSets;
  for (auto& [get, sets] : getSetsMap) {
    for (auto* set : sets) {
      indexSets[get->index].insert(set);
    }
  }
  for (auto& [curr, _] : locations) {
    if (auto* set = curr->dynCast<LocalSet>()) {
      auto& sets = indexSets[set->index];
      if (sets.size() == 1 && *sets.begin() != curr) {
        // While it has just one set, it is not the right one (us),
        // so mark it invalid.
        sets.clear();
      }
    }
  }
  for (auto& [index, sets] : indexSets) {
    if (sets.size() == 1) {
      SSAIndexes.insert(index);
    }
  }
}

bool LocalGraph::isSSA(Index x) { return SSAIndexes.count(x); }

// LazyLocalGraph

LazyLocalGraph::LazyLocalGraph(Function* func, Module* module)
  : LocalGraphBase(func, module) {
  flower =
    std::make_unique<LocalGraphFlower>(getSetsMap, locations, func, module);

  flower->prepareLaziness();

#ifdef LOCAL_GRAPH_DEBUG
  std::cout << "LazyLocalGraph::dump\n";
  for (auto& [get, sets] : getSetsMap) {
    std::cout << "GET\n" << get << " is influenced by\n";
    for (auto* set : sets) {
      std::cout << set << '\n';
    }
  }
  std::cout << "total locations: " << locations.size() << '\n';
#endif
}

LazyLocalGraph::~LazyLocalGraph() {
  // We must declare a destructor here in the cpp file, even though it is empty
  // and pointless, due to some C++ issue with our having a unique_ptr to a
  // forward-declared class (LocalGraphFlower).
  // https://stackoverflow.com/questions/13414652/forward-declaration-with-unique-ptr#comment110005453_13414884
}

void LazyLocalGraph::computeGetSets(LocalGet* get) const {
  flower->flowGet(get);
}

} // namespace wasm
