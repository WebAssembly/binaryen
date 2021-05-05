/*
 * Copyright 2021 WebAssembly Community Group participants
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
// Find heap allocations that never escape the current function, and lower the
// object into locals.
//

#include "ir/branch-utils.h"
#include "ir/find_all.h"
#include "ir/local-graph.h"
#include "ir/parents.h"
#include "ir/utils.h"
#include "pass.h"
#include "support/unique_deferring_queue.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

struct Heap2Local : public WalkerPass<PostWalker<Heap2Local>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new Heap2Local(); }

  void doWalkFunction(Function* func) {
    // All the allocations in the function.
    // TODO: Arrays (of constant size) as well.
    FindAll<StructNew> structNews(func->body);

    // To find what escapes, we need to follow where values flow, both up to
    // parents, and via branches.
    Parents parents(func->body);
    BranchUtils::BranchTargets targets(func->body);

    for (auto* structNew : structNews.list) {
      UniqueNonrepeatingDeferredQueue<Expression*> flowToParent;
      UniqueNonrepeatingDeferredQueue<Name> flowOnBranch;

      flowToParent.push(
      // Keep flowing
      while (1) {
      }
    }
  }
};

} // anonymous namespace

Pass* createHeap2LocalPass() { return new Heap2Local(); }

} // namespace wasm
