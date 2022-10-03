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
// Sorts locals by access frequency.
//
// Secondarily, sort by first appearance. This canonicalizes the order.
//
// While sorting, we remove locals that have no uses at all.
//

#include <memory>

#include <pass.h>
#include <wasm.h>

namespace wasm {

struct ReorderLocals : public WalkerPass<PostWalker<ReorderLocals>> {
  bool isFunctionParallel() override { return true; }

  // Sorting and removing unused locals cannot affect validation.
  bool requiresNonNullableLocalFixups() override { return false; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<ReorderLocals>();
  }

  // local index => times it is used
  std::vector<Index> counts;
  // local index => how many locals we saw before this one, before a use of
  // this one appeared. that is, one local has 1, another has 2, and so forth,
  // in the order in which we saw the first uses of them (we use "0" to mark
  // locals we have not yet seen).
  std::vector<Index> firstUses;
  Index firstUseIndex = 1;

  enum { Unseen = 0 };

  void doWalkFunction(Function* curr) {
    if (curr->getNumVars() == 0) {
      return; // nothing to do. All locals are parameters
    }
    Index num = curr->getNumLocals();
    counts.clear();
    counts.resize(num);
    firstUses.clear();
    firstUses.resize(num, Unseen);
    // Gather information about local usages.
    walk(curr->body);
    // Use the information about local usages.
    std::vector<Index> newToOld(num);
    for (size_t i = 0; i < num; i++) {
      newToOld[i] = i;
    }
    // sort, keeping params in front (where they will not be moved)
    sort(
      newToOld.begin(), newToOld.end(), [this, curr](Index a, Index b) -> bool {
        if (curr->isParam(a) && !curr->isParam(b)) {
          return true;
        }
        if (curr->isParam(b) && !curr->isParam(a)) {
          return false;
        }
        if (curr->isParam(b) && curr->isParam(a)) {
          return a < b;
        }
        if (counts[a] == counts[b]) {
          if (counts[a] == 0) {
            return a < b;
          }
          return firstUses[a] < firstUses[b];
        }
        return counts[a] > counts[b];
      });
    // sorting left params in front, perhaps slightly reordered. verify and fix.
    size_t numParams = curr->getParams().size();
    for (size_t i = 0; i < numParams; i++) {
      assert(newToOld[i] < numParams);
      newToOld[i] = i;
    }
    // sort vars, and drop unused ones
    std::vector<Type> oldVars;
    std::swap(oldVars, curr->vars);
    for (size_t i = curr->getVarIndexBase(); i < newToOld.size(); i++) {
      Index index = newToOld[i];
      if (counts[index] > 0) {
        curr->vars.push_back(oldVars[index - curr->getVarIndexBase()]);
      } else {
        newToOld.resize(i);
        break;
      }
    }
    counts.clear();
    std::vector<Index> oldToNew;
    oldToNew.resize(num);
    for (size_t i = 0; i < newToOld.size(); i++) {
      if (curr->isParam(i)) {
        oldToNew[i] = i;
      } else {
        oldToNew[newToOld[i]] = i;
      }
    }
    // apply the renaming to AST nodes
    struct ReIndexer : public PostWalker<ReIndexer> {
      Function* func;
      std::vector<Index>& oldToNew;

      ReIndexer(Function* func, std::vector<Index>& oldToNew)
        : func(func), oldToNew(oldToNew) {}

      void visitLocalGet(LocalGet* curr) {
        curr->index = oldToNew[curr->index];
      }

      void visitLocalSet(LocalSet* curr) {
        curr->index = oldToNew[curr->index];
      }
    };
    ReIndexer reIndexer(curr, oldToNew);
    reIndexer.walk(curr->body);
    // apply to the names
    auto oldLocalNames = curr->localNames;
    auto oldLocalIndices = curr->localIndices;
    curr->localNames.clear();
    curr->localIndices.clear();
    for (size_t i = 0; i < newToOld.size(); i++) {
      auto iter = oldLocalNames.find(newToOld[i]);
      if (iter != oldLocalNames.end()) {
        auto old = iter->second;
        curr->localNames[i] = old;
        curr->localIndices[old] = i;
      }
    }
  }

  void visitLocalGet(LocalGet* curr) {
    counts[curr->index]++;
    if (firstUses[curr->index] == Unseen) {
      firstUses[curr->index] = firstUseIndex++;
    }
  }

  void visitLocalSet(LocalSet* curr) {
    counts[curr->index]++;
    if (firstUses[curr->index] == Unseen) {
      firstUses[curr->index] = firstUseIndex++;
    }
  }
};

Pass* createReorderLocalsPass() { return new ReorderLocals(); }

} // namespace wasm
