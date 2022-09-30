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
// Given two expressions that appear in a specific order - first and then
// second - this helper can create a sequence in which we return the value of
// the first. If the two expressions can be reordered, this simply returns
//
//   (second, first)
//
// If side effects prevent that, it will use a local to save the value of the
// first, and return it at the end,
//
//   (temp = first, second, temp)
//
// The first expression is assumed to not be unreachable (otherwise, there is no
// value to get the result of). If the second is unreachable, this returns
// something with type unreachable (that avoids returning something with a
// concrete type, which might replace something with unreachable type - we want
// to keep the type the same, in most cases).
inline Expression* getResultOfFirst(Expression* first,
                                    Expression* second,
                                    Function* func,
                                    Module* wasm,
                                    const PassOptions& passOptions) {
  assert(first->type.isConcrete());

  Builder builder(*wasm);

  if (second->type == Type::unreachable) {
    // No value is actually consumed here. Emit something with unreachable type.
    // (Note that if we continued to the canReorder code after us, and emitted
    // second followed by first, then the block would have a concrete type due
    // to the last element having such a type - which would not have unreachable
    // type.)
    return builder.makeSequence(builder.makeDrop(first), second);
  }

  if (EffectAnalyzer::canReorder(passOptions, *wasm, first, second)) {
    return builder.makeSequence(second, first);
  }

  auto type = first->type;
  auto index = Builder::addVar(func, type);
  return builder.makeBlock({builder.makeLocalSet(index, first),
                            second,
                            builder.makeLocalGet(index, type)});
}

} // namespace wasm

#endif // wasm_ir_reorderer_h
