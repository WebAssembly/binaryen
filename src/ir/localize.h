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

#ifndef wasm_ir_localizer_h
#define wasm_ir_localizer_h

#include "ir/iteration.h"
#include "wasm-builder.h"

namespace wasm {

// Make an expression available in a local. If already in one, just
// use that local, otherwise use a new local.
//
// Note that if the local is reused, this assumes it is not modified in between
// the set and the get, which the caller must ensure.
struct Localizer {
  Index index;
  Expression* expr;

  Localizer(Expression* input, Function* func, Module* wasm) {
    expr = input;
    if (auto* get = expr->dynCast<LocalGet>()) {
      index = get->index;
    } else if (auto* set = expr->dynCast<LocalSet>()) {
      index = set->index;
    } else {
      index = Builder::addVar(func, expr->type);
      expr = Builder(*wasm).makeLocalTee(index, expr, expr->type);
    }
  }
};

// Replaces all children with gets of locals, if they have any effects that
// interact with any of the others, or if they have side effects which cannot be
// removed. Also replace unreachable things with an unreachable, leaving in
// place only things without interacting effects. For example:
//
//  (parent
//    (call $foo)
//    (br $out)
//    (i32.const)
//  )
//
// =>
//
//  (local.set $temp.foo
//    (call $foo)            ;; moved out
//  )
//  (br $out)                ;; moved out
//  (parent
//    (local.get $temp.foo)  ;; value saved to a local
//    (unreachable)          ;; complex effect replaced by unreachable
//    (i32.const)
//  )
//
// After this it is safe to reorder and remove things from the parent: all
// interesting interactions happen before the parent.
//
// Typical usage is to call getReplacement() will produces the entire output
// just shown (i.e., possible initial local.sets and other stuff that was pulled
// out, followed by the parent, as relevant). Note that getReplacement() may
// omit the parent, if it had an unreachable child. That is useful behavior in
// that it removes unneeded code (& otherwise some users of this code would need
// to write their own removal logic). However, that does imply that it is valid
// to remove the parent in such cases, which is not so for e.g. br when it is
// the last thing keeping a block reachable. Calling this with something like a
// struct.new or a call (the current intended users) is valid; if we want to
// generalize this fully then we need to make changes here.
//
// TODO: use in more places
struct ChildLocalizer {
  ChildLocalizer(Expression* parent,
                 Function* func,
                 Module& wasm,
                 const PassOptions& options)
    : parent(parent), wasm(wasm) {
    Builder builder(wasm);
    ChildIterator iterator(parent);
    auto& children = iterator.children;
    auto num = children.size();

    // Compute the effects of all children.
    std::vector<EffectAnalyzer> effects;
    for (Index i = 0; i < num; i++) {
      // The children are in reverse order in ChildIterator, but we want to
      // process them in the normal order.
      auto* child = *children[num - 1 - i];
      effects.emplace_back(options, wasm, child);
    }

    // Go through the children and move to locals those that we need to.
    for (Index i = 0; i < num; i++) {
      auto** childp = children[num - 1 - i];
      auto* child = *childp;
      if (child->type == Type::unreachable) {
        // Move the child out, and put an unreachable in its place (note that we
        // don't need an actual set here, as there is no value to set to a
        // local).
        sets.push_back(child);
        *childp = builder.makeUnreachable();
        hasUnreachableChild = true;
        continue;
      }

      if (hasUnreachableChild) {
        // Once we pass one unreachable, we only need to copy the children over.
        // (The only reason we still need them is that they may be needed for
        // validation, e.g. if one contains a break to a block that is the only
        // reason the block has type none.)
        sets.push_back(builder.makeDrop(child));
        *childp = builder.makeUnreachable();
        continue;
      }

      // Use a local if we need to. That is the case either if this has side
      // effects we can't remove, or if it interacts with other children.
      bool needLocal = effects[i].hasUnremovableSideEffects();
      if (!needLocal) {
        for (Index j = 0; j < num; j++) {
          if (j != i && effects[i].invalidates(effects[j])) {
            needLocal = true;
            break;
          }
        }
      }
      if (needLocal) {
        auto local = builder.addVar(func, child->type);
        sets.push_back(builder.makeLocalSet(local, child));
        *childp = builder.makeLocalGet(local, child->type);
      }
    }
  }

  // Helper that gets a replacement for the parent: a block containing the
  // sets + the parent. This will not contain the parent if we don't need it
  // (if it was never reached).
  Expression* getReplacement() {
    if (sets.empty()) {
      // Nothing to add.
      return parent;
    }
    auto* block = getChildrenReplacement();
    if (!hasUnreachableChild) {
      block->list.push_back(parent);
      block->finalize();
    }
    return block;
  }

  // Like `getReplacement`, but the result never contains the parent.
  Block* getChildrenReplacement() {
    auto* block = Builder(wasm).makeBlock();
    block->list.set(sets);
    if (hasUnreachableChild) {
      block->type = Type::unreachable;
    }
    return block;
  }

private:
  Expression* parent;
  Module& wasm;

  std::vector<Expression*> sets;
  bool hasUnreachableChild = false;
};

} // namespace wasm

#endif // wasm_ir_localizer_h
