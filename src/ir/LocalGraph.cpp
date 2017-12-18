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

namespace wasm {

LocalGraph::LocalGraph(Function* func, Module* module) {
  walkFunctionInModule(func, module);

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

void LocalGraph::doWalkFunction(Function* func) {
  numLocals = func->getNumLocals();
  if (numLocals == 0) return; // nothing to do
  // We begin with each param being assigned from the incoming value, and the zero-init for the locals,
  // so the initial state is the identity permutation
  currMapping.resize(numLocals);
  for (auto& set : currMapping) {
    set = { nullptr };
  }
  PostWalker<LocalGraph>::walk(func->body);
}

// control flow

void LocalGraph::visitBlock(Block* curr) {
  if (curr->name.is() && breakMappings.find(curr->name) != breakMappings.end()) {
    auto& infos = breakMappings[curr->name];
    infos.emplace_back(std::move(currMapping));
    currMapping = std::move(merge(infos));
    breakMappings.erase(curr->name);
  }
}

void LocalGraph::finishIf() {
  // that's it for this if, merge
  std::vector<Mapping> breaks;
  breaks.emplace_back(std::move(currMapping));
  breaks.emplace_back(std::move(mappingStack.back()));
  mappingStack.pop_back();
  currMapping = std::move(merge(breaks));
}

void LocalGraph::afterIfCondition(LocalGraph* self, Expression** currp) {
  self->mappingStack.push_back(self->currMapping);
}
void LocalGraph::afterIfTrue(LocalGraph* self, Expression** currp) {
  auto* curr = (*currp)->cast<If>();
  if (curr->ifFalse) {
    auto afterCondition = std::move(self->mappingStack.back());
    self->mappingStack.back() = std::move(self->currMapping);
    self->currMapping = std::move(afterCondition);
  } else {
    self->finishIf();
  }
}
void LocalGraph::afterIfFalse(LocalGraph* self, Expression** currp) {
  self->finishIf();
}
void LocalGraph::beforeLoop(LocalGraph* self, Expression** currp) {
  // save the state before entering the loop, for calculation later of the merge at the loop top
  self->mappingStack.push_back(self->currMapping);
  self->loopGetStack.push_back({});
}
void LocalGraph::visitLoop(Loop* curr) {
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
      if (!std::includes(getSets.begin(), getSets.end(),
                         beforeSets.begin(), beforeSets.end())) {
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
void LocalGraph::visitBreak(Break* curr) {
  if (curr->condition) {
    breakMappings[curr->name].emplace_back(currMapping);
  } else {
    breakMappings[curr->name].emplace_back(std::move(currMapping));
    setUnreachable(currMapping);
  }
}
void LocalGraph::visitSwitch(Switch* curr) {
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
void LocalGraph::visitReturn(Return *curr) {
  setUnreachable(currMapping);
}
void LocalGraph::visitUnreachable(Unreachable *curr) {
  setUnreachable(currMapping);
}

// local usage

void LocalGraph::visitGetLocal(GetLocal* curr) {
  assert(currMapping.size() == numLocals);
  assert(curr->index < numLocals);
  for (auto& loopGets : loopGetStack) {
    loopGets.push_back(curr);
  }
  // current sets are our sets
  getSetses[curr] = currMapping[curr->index];
  locations[curr] = getCurrentPointer();
}
void LocalGraph::visitSetLocal(SetLocal* curr) {
  assert(currMapping.size() == numLocals);
  assert(curr->index < numLocals);
  // current sets are just this set
  currMapping[curr->index] = { curr }; // TODO optimize?
  locations[curr] = getCurrentPointer();
}

// traversal

void LocalGraph::scan(LocalGraph* self, Expression** currp) {
  if (auto* iff = (*currp)->dynCast<If>()) {
    // if needs special handling
    if (iff->ifFalse) {
      self->pushTask(LocalGraph::afterIfFalse, currp);
      self->pushTask(LocalGraph::scan, &iff->ifFalse);
    }
    self->pushTask(LocalGraph::afterIfTrue, currp);
    self->pushTask(LocalGraph::scan, &iff->ifTrue);
    self->pushTask(LocalGraph::afterIfCondition, currp);
    self->pushTask(LocalGraph::scan, &iff->condition);
  } else {
    PostWalker<LocalGraph>::scan(self, currp);
  }

  // loops need pre-order visiting too
  if ((*currp)->is<Loop>()) {
    self->pushTask(LocalGraph::beforeLoop, currp);
  }
}

// helpers

void LocalGraph::setUnreachable(Mapping& mapping) {
  mapping.resize(numLocals); // may have been emptied by a move
  mapping[0].clear();
}

bool LocalGraph::isUnreachable(Mapping& mapping) {
  // we must have some set for each index, if only the zero init, so empty means we emptied it for unreachable code
  return mapping[0].empty();
}

// merges a bunch of infos into one.
// if we need phis, writes them into the provided vector. the caller should
// ensure those are placed in the right location
LocalGraph::Mapping& LocalGraph::merge(std::vector<Mapping>& mappings) {
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

} // namespace wasm

