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

#include <wasm.h>
#include <pass.h>

namespace wasm {

struct ReorderLocals : public WalkerPass<PostWalker<ReorderLocals>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new ReorderLocals; }

  std::map<Index, Index> counts; // local => times it is used
  std::map<Index, Index> firstUses; // local => index in the list of which local is first seen

  void visitFunction(Function *curr) {
    Index num = curr->getNumLocals();
    std::vector<Index> newToOld;
    for (size_t i = 0; i < num; i++) {
      newToOld.push_back(i);
    }
    // sort, keeping params in front (where they will not be moved)
    sort(newToOld.begin(), newToOld.end(), [this, curr](Index a, Index b) -> bool {
      if (curr->isParam(a) && !curr->isParam(b)) return true;
      if (curr->isParam(b) && !curr->isParam(a)) return false;
      if (curr->isParam(b) && curr->isParam(a)) {
        return a < b;
      }
      if (counts[a] == counts[b]) {
        if (counts[a] == 0) return a < b;
        return firstUses[a] < firstUses[b];
      }
      return counts[a] > counts[b];
    });
    // sorting left params in front, perhaps slightly reordered. verify and fix.
    for (size_t i = 0; i < curr->params.size(); i++) {
      assert(newToOld[i] < curr->params.size());
    }
    for (size_t i = 0; i < curr->params.size(); i++) {
      newToOld[i] = i;
    }
    // sort vars, and drop unused ones
    auto oldVars = curr->vars;
    curr->vars.clear();
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

      ReIndexer(Function* func, std::vector<Index>& oldToNew) : func(func), oldToNew(oldToNew) {}

      void visitGetLocal(GetLocal *curr) {
        if (func->isVar(curr->index)) {
          curr->index = oldToNew[curr->index];
        }
      }

      void visitSetLocal(SetLocal *curr) {
        if (func->isVar(curr->index)) {
          curr->index = oldToNew[curr->index];
        }
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
      if (newToOld[i] < oldLocalNames.size()) {
        auto old = oldLocalNames[newToOld[i]];
        curr->localNames[i] = old;
        curr->localIndices[old] = i;
      }
    }
  }

  void visitGetLocal(GetLocal *curr) {
    counts[curr->index]++;
    if (firstUses.count(curr->index) == 0) {
      firstUses[curr->index] = firstUses.size();
    }
  }

  void visitSetLocal(SetLocal *curr) {
    counts[curr->index]++;
    if (firstUses.count(curr->index) == 0) {
      firstUses[curr->index] = firstUses.size();
    }
  }
};

Pass *createReorderLocalsPass() {
  return new ReorderLocals();
}

} // namespace wasm
