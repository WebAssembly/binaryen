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
// removed.
//
// After this, the original input has only local.gets as inputs, or other things
// that have no interacting effects, and so those children can be reordered
// and/or removed as needed.
//
// The sets of the locals are emitted on a |sets| property on the class. Those
// must be emitted right before the input.
//
// This stops at the first unreachable child, as there is no code executing
// after that point anyhow.
//
// TODO: use in more places
struct ChildLocalizer {
  std::vector<LocalSet*> sets;

  ChildLocalizer(Expression* input,
                 Function* func,
                 Module* wasm,
                 const PassOptions& options) {
    Builder builder(*wasm);
    ChildIterator iterator(input);
    auto& children = iterator.children;
    auto num = children.size();

    // Compute the effects of all children.
    std::vector<EffectAnalyzer> effects;
    for (Index i = 0; i < num; i++) {
      // The children are in reverse order in ChildIterator, but we want to
      // process them in the normal order.
      auto* child = *children[num - 1 - i];
      effects.emplace_back(options, *wasm, child);
    }

    // Go through the children and move to locals those that we need to.
    for (Index i = 0; i < num; i++) {
      auto** childp = children[num - 1 - i];
      auto* child = *childp;
      if (child->type == Type::unreachable) {
        break;
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
};

} // namespace wasm

#endif // wasm_ir_localizer_h
