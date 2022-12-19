/*
 * Copyright 2022 WebAssembly Community Group participants
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

#ifndef wasm_ir_closed_world_h
#define wasm_ir_closed_world_h

#include "ir/closed-world.h"
#include "wasm.h"

namespace wasm {

namespace {

void ensurePrivateType(HeapType& type) {
  // When a type is public, we assume all the types it refers to are public as
  // well, which means all supertypes are. There is therefore a chance that if
  // we use a supertype instead of a subtype then we will be using a private
  // type instead of a public one. In closed world that is fine to do, so long
  // as the types are structurally equal, which is the case for now until we get
  // function subtyping. Note that even so it may not be enough, however, so we
  // may need to add a method here that creates a fresh type in some cases.
  while (1) {
    if (auto super = type.getSuperType()) {
      if (super->getSignature() == type.getSignature()) {
        // These are structurally similar, so use the super.
        type = *super;
        continue;
      }
    }
    break;
  }
}

} // anonymous namespace

void ensureClosedWorld(Module& module) {
  for (auto& exp : module.exports) {
    if (exp->kind == ExternalKind::Function) {
      ensurePrivateType(module.getFunction(exp->value)->type);
    }
  }
}

} // namespace wasm

#endif // wasm_ir_closed_world_h
