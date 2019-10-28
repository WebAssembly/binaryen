/*
 * Copyright 2019 WebAssembly Community Group participants
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
// Misc optimizations that are useful for and/or are only valid for
// AssemblyScript output.
//

// #define POST_ASSEMBLYSCRIPT_DEBUG

#include <list>

#include <cfg/cfg-traversal.h>
#include <ir/flat.h>
#include <ir/local-graph.h>
#include <pass.h>
#include <wasm-builder.h>
#include <wasm-printing.h>
#include <wasm-traversal.h>
#include <wasm.h>

namespace wasm {

namespace PostAssemblyScript {

static Name RETAIN = Name("~lib/rt/pure/__retain");
static Name RELEASE = Name("~lib/rt/pure/__release");
static Name ALLOC = Name("~lib/rt/tlsf/__alloc");
static Name ALLOCARRAY = Name("~lib/rt/__allocArray");

// A variant of LocalGraph that considers only assignments
// when computing influences.
struct AssignmentGraph : LocalGraph {
  AssignmentGraph(Function* func) : LocalGraph(func) {}
  void computeInfluences() {
    for (auto& pair : locations) {
      auto* curr = pair.first;
      if (auto* set = curr->dynCast<LocalSet>()) {
        if (auto* get = set->value->dynCast<LocalGet>()) {
          getInfluences[get].insert(set);
        }
      } else {
        auto* get = curr->cast<LocalGet>();
        for (auto* set : getSetses[get]) {
          setInfluences[set].insert(get);
        }
      }
    }
  }
};

// A pass that eliminates redundant retain and release calls.
// Does a cheap traversal first, remembering ARC-style patterns,
// and goes all-in only if it finds any.
struct OptimizeARC : public WalkerPass<PostWalker<OptimizeARC>> {

#ifndef POST_ASSEMBLYSCRIPT_DEBUG
  bool isFunctionParallel() override { return true; }
#endif

  Pass* create() override { return new OptimizeARC; }

  // Sets that are retains, to location
  std::unordered_map<LocalSet*, Expression**> retains;

  // Gets that are releases, to location
  std::unordered_map<LocalGet*, Expression**> releases;

  // Gets that are returns
  std::unordered_set<LocalGet*> returns;

  void visitLocalSet(LocalSet* curr) {
    // local.set(X, __retain(...)) ?
    if (auto* call = curr->value->dynCast<Call>()) {
      if (call->target == RETAIN) {
        retains[curr] = getCurrentPointer();
      }
    }
  }

  void visitCall(Call* curr) {
    // __release(local.get(X, ...)) ?
    if (curr->target == RELEASE && curr->operands.size() == 1) {
      auto* operand = curr->operands[0];
      if (auto* localGet = operand->dynCast<LocalGet>()) {
        releases[localGet] = getCurrentPointer();
      }
    }
  }

  void visitReturn(Return* curr) {
    // return(local.get(X, ...)) ?
    auto* value = curr->value;
    if (value) {
      if (auto* localGet = value->dynCast<LocalGet>()) {
        returns.insert(localGet);
      }
    }
  }

  void eliminateRetain(Expression** location) {
    // assumes local.set(X, __retain(...))
    auto* localSet = (*location)->cast<LocalSet>();
    auto* call = localSet->value->cast<Call>();
    assert(call->target == RETAIN);
    assert(call->operands.size() == 1);
    localSet->value = call->operands[0];
  }

  void eliminateRelease(Expression** location) {
    // assumes __release(local.get(X, ...))
    if (auto* call = (*location)->dynCast<Call>()) {
      assert(call->target == RELEASE);
      assert(call->operands.size() == 1);
      assert(call->operands[0]->is<LocalGet>());
      Builder builder(*getModule());
      *location = builder.makeNop();
    } else {
      assert((*location)->is<Nop>()); // already replaced
    }
  }

  // Tests if a retain reaches a return
  bool testReachesReturn(LocalSet* retain, AssignmentGraph& graph) {
    for (auto* localGet : graph.setInfluences[retain]) {
      auto foundReturn = returns.find(localGet);
      if (foundReturn != returns.end()) {
        return true;
      }
      for (auto* localSet : graph.getInfluences[localGet]) {
        if (testReachesReturn(localSet, graph)) {
          return true;
        }
      }
    }
    return false;
  }

  // Collects all reachable releases of a retain
  void collectReleases(LocalSet* retain,
                       AssignmentGraph& graph,
                       std::unordered_set<Expression**>& found) {
    for (auto* localGet : graph.setInfluences[retain]) {
      auto foundRelease = releases.find(localGet);
      if (foundRelease != releases.end()) {
        found.insert(foundRelease->second);
      } else {
        for (auto* localSet : graph.getInfluences[localGet]) {
          collectReleases(localSet, graph, found);
        }
      }
    }
  }

  // Given a retain, gets the retained expression
  static Expression* getRetainedExpression(LocalSet* retain) {
    // assumes local.set(X, __retain(...))
    auto* retainCall = retain->value->cast<Call>();
    assert(retainCall->operands.size() == 1);
    return retainCall->operands[0];
  }

  // Tests if a retained value originates at an allocation
  bool testRetainsAllocation(Expression* retained, AssignmentGraph& graph) {
    if (auto* call = retained->dynCast<Call>()) {
      if (call->target == ALLOC || call->target == ALLOCARRAY) {
        return true;
      }
    } else {
      if (auto* localGet = retained->dynCast<LocalGet>()) {
        for (auto* localSet : graph.getSetses[localGet]) {
          if (localSet != nullptr &&
              testRetainsAllocation(localSet->value, graph)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  // Given a release location, gets the release
  static LocalGet* getReleaseByLocation(Expression** releaseLocation) {
    // assumes __release(local.get(X, ...))
    auto* releaseCall = (*releaseLocation)->cast<Call>();
    assert(releaseCall->operands.size() == 1);
    return releaseCall->operands[0]->cast<LocalGet>();
  }

  // Tests if a release has balanced retains
  bool testBalancedRetains(LocalGet* release, AssignmentGraph& graph) {
    for (auto* localSet : graph.getSetses[release]) {
      if (localSet == nullptr) {
        return false;
      }
      if (retains.find(localSet) == retains.end()) {
        if (auto* localGet = localSet->value->dynCast<LocalGet>()) {
          if (!testBalancedRetains(localGet, graph)) {
            return false;
          }
        } else {
          return false;
        }
      }
    }
    return true;
  }

  void doWalkFunction(Function* func) {
    retains.clear();
    releases.clear();
    returns.clear();
    Flat::verifyFlatness(func);
#ifdef POST_ASSEMBLYSCRIPT_DEBUG
    std::cerr << "[PostAssemblyScript::OptimizeARC] walking " << func->name
              << "\n";
#endif
    super::doWalkFunction(func);
    if (retains.empty()) {
#ifdef POST_ASSEMBLYSCRIPT_DEBUG
      std::cerr << "  no ARC code\n";
#endif
      return;
    }
    AssignmentGraph graph(func);
    graph.computeInfluences();

    std::unordered_set<Expression**> redundantRetains;
    std::unordered_set<Expression**> redundantReleases;

    // For each retain, check that it
    //
    // * doesn't reach a return (otherwise unbalanced)
    // * doesn't retain an allocation (otherwise necessary)
    // * reaches at least one release
    // * reaches only releases with balanced retains
    //
    for (auto& pair : retains) {
      auto* retain = pair.first;
      auto** retainLocation = pair.second;
      if (!testReachesReturn(retain, graph)) {
        if (!testRetainsAllocation(getRetainedExpression(retain), graph)) {
          std::unordered_set<Expression**> found;
          collectReleases(retain, graph, found);
          if (!found.empty()) {
            bool allBalanced = true;
            for (auto** getLocation : found) {
              if (!testBalancedRetains(getReleaseByLocation(getLocation),
                                       graph)) {
                allBalanced = false;
                break;
              }
            }
            if (allBalanced) {
#ifdef POST_ASSEMBLYSCRIPT_DEBUG
              std::cerr << "  eliminating ";
              WasmPrinter::printExpression(retain, std::cerr, true);
              std::cerr << " reaching\n";
#endif
              redundantRetains.insert(retainLocation);
              for (auto** getLocation : found) {
#ifdef POST_ASSEMBLYSCRIPT_DEBUG
                std::cerr << "    ";
                WasmPrinter::printExpression(*getLocation, std::cerr, true);
                std::cerr << "\n";
#endif
                redundantReleases.insert(getLocation);
              }
#ifdef POST_ASSEMBLYSCRIPT_DEBUG
            } else {
              std::cerr << "  cannot eliminate ";
              WasmPrinter::printExpression(retain, std::cerr, true);
              std::cerr << " - unbalanced\n";
#endif
            }
#ifdef POST_ASSEMBLYSCRIPT_DEBUG
          } else {
            std::cerr << "  cannot eliminate ";
            WasmPrinter::printExpression(retain, std::cerr, true);
            std::cerr << " - zero releases\n";
#endif
          }
#ifdef POST_ASSEMBLYSCRIPT_DEBUG
        } else {
          std::cerr << "  cannot eliminate ";
          WasmPrinter::printExpression(retain, std::cerr, true);
          std::cerr << " - retains allocation\n";
#endif
        }
#ifdef POST_ASSEMBLYSCRIPT_DEBUG
      } else {
        std::cerr << "  cannot eliminate ";
        WasmPrinter::printExpression(retain, std::cerr, true);
        std::cerr << " - reaches return\n";
#endif
      }
    }
    for (auto** location : redundantRetains) {
      eliminateRetain(location);
    }
    for (auto** location : redundantReleases) {
      eliminateRelease(location);
    }
#ifdef POST_ASSEMBLYSCRIPT_DEBUG
    std::cerr << "  eliminated " << redundantRetains.size() << "/"
              << retains.size() << " retains and " << redundantReleases.size()
              << "/" << releases.size() << " releases\n";
#endif
  }
};

// Eliminating retains and releases makes it more likely
// that other passes lead to collapsed release/retain pairs,
// and this pass finalizes such output.
struct FinalizeARC : public WalkerPass<PostWalker<FinalizeARC>> {

#ifndef POST_ASSEMBLYSCRIPT_DEBUG
  bool isFunctionParallel() override { return true; }
#endif

  Pass* create() override { return new FinalizeARC; }

  uint32_t eliminatedAllocations = 0;
  uint32_t eliminatedRetains = 0;
  uint32_t eliminatedReleases = 0;

  void visitCall(Call* curr) {
    if (curr->target == RELEASE && curr->operands.size() == 1) {
      if (auto* releasedCall = curr->operands[0]->dynCast<Call>()) {
        if (releasedCall->target == RETAIN &&
            releasedCall->operands.size() == 1) {
          if (auto* retainedCall = releasedCall->operands[0]->dynCast<Call>()) {
            if (retainedCall->target == ALLOC ||
                retainedCall->target == ALLOCARRAY) {
              // __release(__retain(__alloc(...))) - unnecessary allocation
#ifdef POST_ASSEMBLYSCRIPT_DEBUG
              std::cerr << "  finalizing ";
              WasmPrinter::printExpression(curr, std::cerr, true);
              std::cerr << " - unnecessary allocation\n";
#endif
              Builder builder(*getModule());
              replaceCurrent(builder.makeNop());
              ++eliminatedAllocations;
              ++eliminatedRetains;
              ++eliminatedReleases;
              return;
            }
          }
          // __release(__retain(...)) - unnecessary pair
#ifdef POST_ASSEMBLYSCRIPT_DEBUG
          std::cerr << "  finalizing ";
          WasmPrinter::printExpression(curr, std::cerr, true);
          std::cerr << " - unnecessary pair\n";
#endif
          Builder builder(*getModule());
          replaceCurrent(builder.makeDrop(releasedCall->operands[0]));
          ++eliminatedRetains;
          ++eliminatedReleases;
        }
      } else if (curr->operands[0]->is<Const>()) {
        // __release(42) - unnecessary static release
#ifdef POST_ASSEMBLYSCRIPT_DEBUG
        std::cerr << "  finalizing ";
        WasmPrinter::printExpression(curr, std::cerr, true);
        std::cerr << " - static release\n";
#endif
        Builder builder(*getModule());
        replaceCurrent(builder.makeNop());
        ++eliminatedReleases;
      }
    } else if (curr->target == RETAIN && curr->operands.size() == 1) {
      if (auto* retainedConst = curr->operands[0]->dynCast<Const>()) {
        // __retain(42) - unnecessary static retain
#ifdef POST_ASSEMBLYSCRIPT_DEBUG
        std::cerr << "  finalizing ";
        WasmPrinter::printExpression(curr, std::cerr, true);
        std::cerr << " - static retain\n";
#endif
        replaceCurrent(retainedConst);
        ++eliminatedRetains;
      }
    }
  }

  void doWalkFunction(Function* func) {
    eliminatedAllocations = 0;
    eliminatedRetains = 0;
    eliminatedReleases = 0;
#ifdef POST_ASSEMBLYSCRIPT_DEBUG
    std::cerr << "[PostAssemblyScript::FinalizeARC] walking " << func->name
              << "\n";
#endif
    super::doWalkFunction(func);
#ifdef POST_ASSEMBLYSCRIPT_DEBUG
    if (eliminatedAllocations > 0 || eliminatedRetains > 0 ||
        eliminatedReleases > 0) {
      std::cerr << "  finalized " << eliminatedAllocations << " allocations, "
                << eliminatedRetains << " retains and" << eliminatedReleases
                << " releases\n";
    } else {
      std::cerr << "  nothing to do\n";
    }
#endif
  }
};

} // namespace PostAssemblyScript

// declare passes

Pass* createPostAssemblyScriptPass() {
  return new PostAssemblyScript::OptimizeARC();
}

Pass* createPostAssemblyScriptFinalizePass() {
  return new PostAssemblyScript::FinalizeARC();
}

} // namespace wasm
