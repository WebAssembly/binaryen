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
#include "ir/properties.h"
#include "ir/replacer.h"
#include "ir/utils.h"
#include "pass.h"
#include "support/unique_deferring_queue.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

struct Heap2LocalOptimizer {
  Function* func;
  Module* module;

  // To find allocations that do not escape, we must track locals so that we
  // can see which gets refer to the same allocation.
  // TODO: only scan reference types
  LocalGraph localGraph;

  // To find what escapes, we need to follow where values flow, both up to
  // parents, and via branches.
  Parents parents;
  BranchUtils::BranchTargets branchTargets;

  // All the allocations in the function.
  // TODO: Arrays (of constant size) as well.
  FindAll<StructNew> allocations;

  bool optimized = false;

  Heap2LocalOptimizer(Function* func, Module* module) : localGraph(func),
      parents(func->body), branchTargets(func->body), allocations(func->body) {
    // We need to track what each set influences, to see where its value can
    // flow to.
    localGraph.computeSetInfluences();

    Replacer replacer;

    for (auto* allocation : allocations.list) {
      // The point of this optimization is to replace heap allocations with
      // locals, so we must be able to place the data in locals.
      if (!canHandleAsLocal(type)) {
        continue;
      }

      if (canConvertToLocals(allocation)) {
        replacer.replacements[..] = ..

        optimized = true;
      }
    }

    // Perform the replacements all at the end in a safe way, avoiding possible
    // issues with the ordering.
    if (!replacer.replacements.empty()) {
      replacer.walk(func->body);
      TypeUpdating::handleNonDefaultableLocals(func, *module);
    }
  }

  bool canHandleAsLocal(Type type) {
    auto& fields = type.getHeapType().getStruct().fields;
    for (auto field : fields) {
      if (!TypeUpdating::canHandleAsLocal(field)) {
        return false;
      }
    }
    return true;
  }

  // All the expressions that may escape from the function. We lazily compute
  // what escapes as we go, and memoize it here, so that we do not repeat work.
  std::unordered_map<Expression*> escapes;

  // Analyze an allocation to see if we can convert it from a heap allocation to
  // locals. Doing so requires two properties:
  //
  //  * It must not escape from the function. If it escapes, we must pass out a
  //    reference anyhow. (In theory we could do a whole-program transformation
  //    to replace the reference with parameters in some cases, but inlining can
  //    hopefully let us optimize common cases.)
  //  * It must be used "exclusively" in locals, without overlap. That is, we
  //    cannot handle the case where a local.get might return our allocation,
  //    but might also get some other value.
  bool canConvertToLocals(StructNew* allocation) {
    auto fail = [&]() {
      escapes.insert(child);
      return false;
    }

    // All the gets we are written to, that we have confirmed are used
    // exclusively by us. Adding them to this set lets us avoid duplicate work,
    // as a get may read from more than one set.
    std::unordered_set<LocalSet*> exclusiveGets;

    // A queue of expressions that have already been checked themselves, and we
    // need to check if by flowing to their parents they may escape.
    UniqueNonrepeatingDeferredQueue<Expression*> flows;

    // Start the flow from the expression itself.
    flows.push(allocation);

    // Keep flowing while we can.
    while (!flows.empty()) {
      auto* child = flows.pop();
      auto* parent = parents.getParent(child);

      // If the parent may let us escape, then we are done.
      if (escapesViaParent(child, parent)) {
        return fail();
      }

      // If the value flows through the parent, we need to look further at
      // the grandparent.
      if (flowsThroughParent(child, parent)) {
        flows.push(parent);
      }

      if (auto* set = parent->dynCast<LocalSet>()) {
        // This is one of the sets we are written to, and so we must check for
        // exclusive use of our allocation there. The first part of that is to
        // see that only we are written by the set and no other value.
        if (!flowsSingleValue(child)) {
          return fail();
        }

        // The second part of exclusivity is to see that any gets reading this
        // set are exclusive to our allocation.
        if (auto* getsReached = getGetsReached(set)) {
          for (auto* get : *getsReached) {
            if (!exclusiveGets.count(get)) {
              // We do not know if this get is exclusive yet, so check it.
              // no we need the sets tath ten enddd
              exclusiveGets.insert(get);
            }

            // We must also look at all the places that read the reference that the set
            // writes.
            flows.push(get);
          }
        }
      }

      // If the parent may send us on a branch, we will need to look at the
      // branch target(s).
      for (auto name : branchesSentByParent(child, parent)) {
        flows.push(targets.getTarget(name));
      }
    }

    return true;
  }

  // Checks if a parent's use of a child may cause it to escape.
  bool escapesViaParent(Expression* child, Expression* parent) {
    // If there is no parent then we are the body of the function, and that
    // means we escape by flowing to the caller.
    if (!parent) {
      return true;
    }

    struct EscapeChecker : public Visitor<EscapeChecker> {
      Expression* child;

      // Assume escaping unless we are certain otherwise.
      bool escapes = true;

      // Local operations. Locals by themselves do not escape; the analysis
      // tracks where locals are used.
      void visitLocalGet(RefIs* curr) { escapes = false; }
      void visitLocalSet(RefIs* curr) { escapes = false; }

      // Reference operations
      void visitRefIs(RefIs* curr) { escapes = false; }
      void visitRefEq(RefEq* curr) { escapes = false; }
      void visitI31Get(I31Get* curr) { escapes = false; }
      void visitRefTest(RefTest* curr) { escapes = false; }
      void visitRefCast(RefCast* curr) { escapes = false; }
      void visitBrOn(BrOn* curr) { escapes = false; }
      void visitRefAs(RefAs* curr) { escapes = false; }
      void visitStructSet(StructSet* curr) {
        // The reference does not escape (but the value is stored to memory and
        // therefore might).
        if (curr->ref == child) {
          escapes = false;
        }
      }
      void visitStructGet(StructGet* curr) { escapes = false; }
      // TODO: Array operations
    } checker;

    checker.child = child;
    checker.visit(parent);
    return checker.escapes;
  }

  bool flowsThroughParent(Expression* child, Expression* parent) {
    return child == Properties::getImmediateFallthrough(
                      parent, getPassOptions(), getModule()->features);
  }

  // Checks whether a single value flows here. That is, we need to avoid things
  // like
  //
  //  (if ..
  //    (value1)
  //    (value2)
  //  )
  //
  // (It is ok if zero values flow out, or if some paths end in a trap or
  // exception; we just cannot tolerate multiple values, if a value does in fact
  // flow out.)
  //
  // This is not a general-purpose analysis, rather it is only valid in the
  // context we use it, which is to follow the uses of an allocation via flowing
  // out and via locals.
  bool flowsSingleValue(Expression* value) {
    auto* fallthrough = Properties::getFallthrough(value, getPassOptions(), getModule()->features);
    if (fallthrough->is<StructNew>()) {
      // This is our allocation (one allocation cannot fall through another, so
      // it must be ours).
      return true;
    }
    if (fallthrough->is<LocalGet>()) {
      // This is a local.get of our allocation.
      return true;
    }
    // TODO: branches
    return false;
  }


  std::unordered_set<LocalGet*>* getGetsReached(LocalSet* parent) {
    auto iter = localGraph.setInfluences.find(set);
    if (iter != localGraph.setInfluences.end()) {
      return &iter->second;
    }
    return nullptr;
  }

  BranchUtils::NameSet branchesSentByParent(Expression* child,
                                            Expression* parent) {
    BranchUtils::NameSet names;
    BranchUtils::operateOnScopeNameUsesAndSentValues(
      Expression * parent, [&](Name name, Expression* value) {
        if (value == child) {
          names.insert(name);
        }
      });
    return names;
  }
};

struct Heap2Local : public WalkerPass<PostWalker<Heap2Local>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new Heap2Local(); }

  void doWalkFunction(Function* func) {
    // Multiple rounds of optimization may work, as once we turn one allocation
    // into locals, references written to its fields become references written
    // to locals, which we may see do not escape;
    while (Heap2LocalOptimizer(func->body, getModule()).optimized) {
    }
  }
};

} // anonymous namespace

Pass* createHeap2LocalPass() { return new Heap2Local(); }

} // namespace wasm
