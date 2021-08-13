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

#ifndef wasm_ir_reorderer_h
#define wasm_ir_reorderer_h

#include <ir/effects.h>
#include <wasm-builder.h>

namespace wasm {

//
// Reorder two concrete expressions, using a local if necessary. Given
//
//  (first, second)
//
// we generate something so that it is valid to write
//
//  (Reorderer.second, Reorderer.first)
//
// (note the reversal of the order there). Reorderer.first/second will contain
// either the original two expressions (first in first, second in second), or
// ones with local usage to work around interactions between them.
//

struct Reorderer {
  Expression* first;
  Expression* second;

  Reorderer(Expression* firstInput, Expression* secondInput, Function* func, Module* wasm, const PassOptions& passOptions) {
    assert(firstInput->type.isConcrete());
    assert(secondInput->type.isConcrete());

    if (EffectAnalyzer::canReorder(passOptions,
                                   wasm->features,
                                   firstInput,
                                   secondInput)) {
      first = firstInput;
      second = secondInput;
      return;
    }

    auto type = firstInput->type;
    auto index = Builder::addVar(func, type);
    Builder builder(*wasm);
    second = builder.makeSequence(
      builder.makeLocalSet(index, firstInput),
      secondInput
    );
    first = builder.makeLocalGet(index, type);
  }
};

} // namespace wasm

#endif // wasm_ir_reorderer_h
