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

// Replaces all children with gets of locals, if they have any effects. After
// this, the original input has only local.gets as inputs, or other things that
// have no interacting effects, and so those children can be reordered.
// The sets of the locals are emitted on a |sets| property on the class. Those
// must be emitted right before the input.
// This stops at the first unreachable child, as there is no code executing
// after that point anyhow.
struct ChildLocalizer {
  std::vector<LocalSet*> sets;

  ChildLocalizer(Expression* input,
                 Function* func,
                 Module* wasm,
                 const PassOptions& options) {
    Builder builder(*wasm);
    ChildIterator iterator(input);
    auto& children = iterator.children;
    // The children are in reverse order, so allocate the output first and
    // apply items as we go.
    auto num = children.size();
    for (Index i = 0; i < num; i++) {
      auto** childp = children[num - 1 - i];
      auto* child = *childp;
      if (child->type == Type::unreachable) {
        break;
      }
      // If there are effects, use a local for this.
      // TODO: Compare interactions between their side effects.
      if (EffectAnalyzer(options, *wasm, child).hasAnything()) {
        auto local = builder.addVar(func, child->type);
        sets.push_back(builder.makeLocalSet(local, child));
        *childp = builder.makeLocalGet(local, child->type);
      }
    }
  }
};

} // namespace wasm

#endif // wasm_ir_localizer_h
