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

#include "ir/flat.h"
#include "ir/local-graph.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "wasm.h"
#include <unordered_map>
#include <unordered_set>
#ifdef POST_ASSEMBLYSCRIPT_DEBUG
#include "wasm-printing.h"
#include <iostream>
#endif

namespace wasm {

namespace PostAssemblyScript {

static Name RETAIN = Name("~lib/rt/pure/__retain");
static Name RELEASE = Name("~lib/rt/pure/__release");
static Name ALLOC = Name("~lib/rt/tlsf/__alloc");
static Name ALLOCARRAY = Name("~lib/rt/__allocArray");

template<typename K, typename V> using Map = std::unordered_map<K, V>;
template<typename T> using Set = std::unordered_set<T>;

// A variant of LocalGraph that considers only assignments when computing
// influences.
//
// This allows us to find locals aliasing a retain, while ignoring other
// influences.
//
// For example, we are interested in
//
//   var a = __retain(X)
//   var b = a;
//   __release(b); // releases X
//
// but not in
//
//  var a = __retain(X);
//  var b = someFunction(a);
//  __release(b);
//  return a;
//
// since the latter releases not 'X' but the reference returned by the call,
// which is usually something else.
struct AliasGraph : LocalGraph {
  AliasGraph(Function* func) : LocalGraph(func) {}
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

// Tests if the given call calls retain. Note that this differs from what we
// consider a full retain pattern, which must also set a local.
static bool isRetainCall(Call* expr) {
  // __retain(...)
  return expr->target == RETAIN && expr->type == i32 &&
         expr->operands.size() == 1 && expr->operands[0]->type == i32;
}

// Tests if a local.set is considered to be a full retain pattern.
static bool isRetain(LocalSet* expr) {
  // local.set(X, __retain(...))
  if (auto* call = expr->value->dynCast<Call>()) {
    return isRetainCall(call);
  }
  return false;
}

#ifndef NDEBUG
// Tests if the given location is that of a full retain pattern.
static bool isRetainLocation(Expression** expr) {
  if (expr != nullptr) {
    if (auto localSet = (*expr)->dynCast<LocalSet>()) {
      return isRetain(localSet);
    }
  }
  return false;
}
#endif

// Tests if the given call calls release. Note that this differs from what we
// consider a full release pattern, which must also get a local.
static bool isReleaseCall(Call* expr) {
  // __release(...)
  return expr->target == RELEASE && expr->type == none &&
         expr->operands.size() == 1 && expr->operands[0]->type == i32;
}

// Tests if the given location is that of a full release pattern. Note that
// the local.get is our key when checking for releases to align with
// AliasGraph, and not the outer call, which is also the reason why there is
// no `isRelease` as we can't tell from the local.get alone.
static bool isReleaseLocation(Expression** expr) {
  // __release(local.get(X, ...))
  if (expr != nullptr) {
    if (auto* call = (*expr)->dynCast<Call>()) {
      return isReleaseCall(call) && call->operands[0]->is<LocalGet>();
    }
  }
  return false;
}

// Tests if the given call calls any allocation function.
static bool isAllocCall(Call* expr) {
  return (expr->target == ALLOC || expr->target == ALLOCARRAY) &&
         expr->type == i32;
}

// A pass that eliminates redundant retain and release calls.
//
// Does a cheap traversal first, remembering ARC-style patterns, and goes all-in
// only if it finds any.
//
// This is based on the assumption that the compiler is not allowed to emit
// unbalanced retains or releases, except if
//
// * a value is returned or otherwise escapes in one branch or
// * a branch is being internally unified by the compiler
//
// which we detect below. In turn, we do not have to deal with control
// structures but can instead look for escapes reached (by any alias) using
// AliasGraph.
//
// For example, in code like
//
//   var a = __retain(X);
//   if (cond) {
//     return a;
//   }
//   __release(a);
//  return null;
//
// we cannot eliminate the retain/release pair because the implementation
// dictates that returned references must remain retained for the caller since
// dropping to RC=0 on the boundary would prematurely free the object.
//
// Typical patterns this recognizes are simple pairs of the form
//
//   var a = __retain(X);
//   __release(a);
//
// retains with balanced releases of the form
//
//   var a = __retain(X);
//   if (cond) {
//     __release(a);
//   } else {
//     __release(a);
//   }
//
// releases with balanced retains of the form
//
//   var a;
//   if (cond) {
//     a = __retain(X);
//   } else {
//     a = __retain(Y);
//   }
//   __release(a);
//
// including technically invalid patterns assumed to be not present in compiler
// output, like:
//
//   var b = __retain(a);
//   if (cond) {
//     __release(b); // unbalanced release
//   }
//
// To detect the latter, we'd have to follow control structures around, which
// we don't do since it isn't neccessary / to keep the amount of work minimal.
struct OptimizeARC : public WalkerPass<PostWalker<OptimizeARC>> {

  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new OptimizeARC; }

  // Sets that are retains, to location
  Map<LocalSet*, Expression**> retains;

  // Gets that are releases, to location
  Map<LocalGet*, Expression**> releases;

  // Gets that are escapes, i.e. being returned or thrown
  Set<LocalGet*> escapes;

  void visitLocalSet(LocalSet* curr) {
    if (isRetain(curr)) {
      retains[curr] = getCurrentPointer();
    }
  }

  void visitCall(Call* curr) {
    auto** currp = getCurrentPointer();
    if (isReleaseLocation(currp)) {
      releases[curr->operands[0]->cast<LocalGet>()] = currp;
    }
  }

  void visitReturn(Return* curr) {
    // return(local.get(X, ...)) ?
    // indicates that an object is returned from one function and given to
    // another, so releasing it would be invalid.
    auto* value = curr->value;
    if (value) {
      if (auto* localGet = value->dynCast<LocalGet>()) {
        escapes.insert(localGet);
      }
    }
  }

  void visitThrow(Throw* curr) {
    // throw(..., local.get(X, ...), ...) ?
    // indicates that an object is thrown in one function and can be caught
    // anywhere, like in another function, so releasing it would be invalid.
    for (auto* operand : curr->operands) {
      if (auto* localGet = operand->dynCast<LocalGet>()) {
        escapes.insert(localGet);
        break;
      }
    }
  }

  void eliminateRetain(Expression** location) {
    assert(isRetainLocation(location));
    auto* localSet = (*location)->cast<LocalSet>();
    localSet->value = localSet->value->cast<Call>()->operands[0];
  }

  void eliminateRelease(Expression** location) {
    assert(isReleaseLocation(location));
    Builder builder(*getModule());
    *location = builder.makeNop();
  }

  // Tests if a retain reaches an escape and thus is considered necessary.
  bool
  testReachesEscape(LocalSet* retain, AliasGraph& graph, Set<LocalSet*>& seen) {
    for (auto* localGet : graph.setInfluences[retain]) {
      if (releases.find(localGet) != releases.end()) {
        continue;
      }
      if (escapes.find(localGet) != escapes.end()) {
        return true;
      }
      for (auto* localSet : graph.getInfluences[localGet]) {
        if (seen.find(localSet) == seen.end()) {
          seen.insert(localSet);
          if (testReachesEscape(localSet, graph, seen)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  bool testReachesEscape(LocalSet* retain, AliasGraph& graph) {
    Set<LocalSet*> seen;
    return testReachesEscape(retain, graph, seen);
  }

  // Collects all reachable releases of a retain.
  void collectReleases(LocalSet* retain,
                       AliasGraph& graph,
                       Set<Expression**>& found,
                       Set<LocalSet*>& seen) {
    for (auto* localGet : graph.setInfluences[retain]) {
      auto foundRelease = releases.find(localGet);
      if (foundRelease != releases.end()) {
        found.insert(foundRelease->second);
      } else {
        for (auto* localSet : graph.getInfluences[localGet]) {
          if (seen.find(localSet) == seen.end()) {
            seen.insert(localSet);
            collectReleases(localSet, graph, found, seen);
          }
        }
      }
    }
  }

  void collectReleases(LocalSet* retain,
                       AliasGraph& graph,
                       Set<Expression**>& found) {
    Set<LocalSet*> seen;
    collectReleases(retain, graph, found, seen);
  }

  // Given a retain, gets the retained expression
  static Expression* getRetainedExpression(LocalSet* retain) {
    assert(isRetain(retain));
    return retain->value->cast<Call>()->operands[0];
  }

  // Tests if a retained value originates at an allocation and thus is
  // considered necessary.
  bool testRetainsAllocation(Expression* retained,
                             AliasGraph& graph,
                             Set<LocalSet*>& seen) {
    if (auto* call = retained->dynCast<Call>()) {
      if (call->target == ALLOC || call->target == ALLOCARRAY) {
        return true;
      }
    } else {
      if (auto* localGet = retained->dynCast<LocalGet>()) {
        for (auto* localSet : graph.getSetses[localGet]) {
          if (localSet != nullptr) {
            if (seen.find(localSet) == seen.end()) {
              seen.insert(localSet);
              if (testRetainsAllocation(localSet->value, graph, seen)) {
                return true;
              }
            }
          }
        }
      }
    }
    return false;
  }

  bool testRetainsAllocation(Expression* retained, AliasGraph& graph) {
    Set<LocalSet*> seen;
    return testRetainsAllocation(retained, graph, seen);
  }

  // Given a release location, gets the local.get that is our release indicator
  static LocalGet* getReleaseByLocation(Expression** releaseLocation) {
    assert(isReleaseLocation(releaseLocation));
    return (*releaseLocation)->cast<Call>()->operands[0]->cast<LocalGet>();
  }

  // Tests if a release has balanced retains, that is it is being retained in
  // any path leading to the release. For example
  //
  //   var c = somethingElse() || a;
  //   ...
  //
  // which compiles to
  //
  //   if (!(b = somethingElse())) {
  //     b = __retain(a);
  //   }
  //   var c = b;
  //   ...
  //   __release(c);
  //
  // is unbalanced since it reaches a retain and something else. Here, the
  // compiler inserts the retain call because it must unify the two branches
  // since the result of `somethingElse()` is known to be retained for the
  // caller and the other branch must yield a retained value as well.
  bool testBalancedRetains(LocalGet* release,
                           AliasGraph& graph,
                           Map<LocalGet*, bool>& cache,
                           Set<LocalGet*>& seen) {
    auto cached = cache.find(release);
    if (cached != cache.end()) {
      return cached->second;
    }
    for (auto* localSet : graph.getSetses[release]) {
      if (localSet == nullptr) {
        return cache[release] = false;
      }
      if (retains.find(localSet) == retains.end()) {
        if (auto* localGet = localSet->value->dynCast<LocalGet>()) {
          if (seen.find(localGet) == seen.end()) {
            seen.insert(localGet);
            if (!testBalancedRetains(localGet, graph, cache, seen)) {
              return cache[release] = false;
            }
          } else {
            return cache[release] = false;
          }
        } else {
          return cache[release] = false;
        }
      }
    }
    return cache[release] = true;
  }

  bool testBalancedRetains(LocalGet* release,
                           AliasGraph& graph,
                           Map<LocalGet*, bool>& cache) {
    Set<LocalGet*> seen;
    return testBalancedRetains(release, graph, cache, seen);
  }

  void doWalkFunction(Function* func) {
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

    AliasGraph graph(func);
    graph.computeInfluences();

    Set<Expression**> redundantRetains;
    Set<Expression**> redundantReleases;
    Map<LocalGet*, bool> balancedRetainsCache;

    // For each retain, check that it
    //
    // * doesn't reach an escape
    // * doesn't retain an allocation
    // * reaches at least one release
    // * reaches only releases with balanced retains
    //
    for (auto& pair : retains) {
      auto* retain = pair.first;
      auto** retainLocation = pair.second;
      if (!testReachesEscape(retain, graph)) {
        if (!testRetainsAllocation(getRetainedExpression(retain), graph)) {
          Set<Expression**> releaseLocations;
          collectReleases(retain, graph, releaseLocations);
          if (!releaseLocations.empty()) {
            bool allBalanced = true;
            for (auto** releaseLocation : releaseLocations) {
              if (!testBalancedRetains(getReleaseByLocation(releaseLocation),
                                       graph,
                                       balancedRetainsCache)) {
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
              for (auto** getLocation : releaseLocations) {
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

// Eliminating retains and releases makes it more likely that other passes lead
// to collapsed release/retain pairs that are not full retain or release
// patterns, and this pass finalizes such pairs. Typical patterns are entire
// unnecessary allocations of the form
//
//   __release(__retain(__alloc(...));
//
// otherwise unnecessary pairs of the form
//
//   __release(__retain(...));
//
// or retains/releases of constants which indicate data in static memory which
// are unnecessary to refcount:
//
//  __retain("staticString");
//
//  __release("staticString");
//
struct FinalizeARC : public WalkerPass<PostWalker<FinalizeARC>> {

  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new FinalizeARC; }

  uint32_t eliminatedAllocations = 0;
  uint32_t eliminatedRetains = 0;
  uint32_t eliminatedReleases = 0;

  void visitCall(Call* curr) {
    if (isReleaseCall(curr)) {
      if (auto* releasedCall = curr->operands[0]->dynCast<Call>()) {
        if (isRetainCall(releasedCall)) {
          if (auto* retainedCall = releasedCall->operands[0]->dynCast<Call>()) {
            if (isAllocCall(retainedCall)) {
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
    } else if (isRetainCall(curr)) {
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
