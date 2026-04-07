/*
 * Copyright 2026 WebAssembly Community Group participants
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

#ifndef wasm_ir_js_utils_h
#define wasm_ir_js_utils_h

#include "ir/intrinsics.h"
#include "wasm-type.h"
#include "wasm.h"

namespace wasm::JSUtils {

// Whether this is a descriptor struct type whose first field is immutable and a
// subtype of externref.
inline bool hasPossibleJSPrototypeField(HeapType type) {
  if (!type.getDescribedType()) {
    return false;
  }
  assert(type.isStruct());
  const auto& fields = type.getStruct().fields;
  if (fields.empty()) {
    return false;
  }
  if (fields[0].mutable_ == Mutable) {
    return false;
  }
  if (!fields[0].type.isRef()) {
    return false;
  }
  return fields[0].type.getHeapType().isMaybeShared(HeapType::ext);
}

// Calls flowIn and flowOut on all types that may flow in from or out to JS.
template<typename In, typename Out>
void iterJSInterface(const Module& wasm, In flowIn, Out flowOut) {
  // @binaryen.js.called functions are called from JS. Their parameters flow
  // in from JS and their results flow back out.
  for (auto f : Intrinsics(wasm).getJSCalledFunctions()) {
    auto* func = wasm.getFunction(f);
    for (auto type : func->getParams()) {
      flowIn(type);
    }
    for (auto type : func->getResults()) {
      flowOut(type);
    }
  }

  for (auto& ex : wasm.exports) {
    switch (ex->kind) {
      case ExternalKindImpl::Function: {
        // Exported functions are also called from JS. Their parameters flow
        // in from JS and their result flow back out.
        auto* func = wasm.getFunction(*ex->getInternalName());
        for (auto type : func->getParams()) {
          flowIn(type);
        }
        for (auto type : func->getResults()) {
          flowOut(type);
        }
        break;
      }
      case ExternalKindImpl::Table: {
        // Exported tables let values flow in and out.
        auto* table = wasm.getTable(*ex->getInternalName());
        flowOut(table->type);
        flowIn(table->type);
        break;
      }
      case ExternalKindImpl::Global: {
        // Exported globals let values flow out. Iff they are mutable, they
        // also let values flow back in.
        auto* global = wasm.getGlobal(*ex->getInternalName());
        flowOut(global->type);
        if (global->mutable_) {
          flowIn(global->type);
        }
        break;
      }
      case ExternalKindImpl::Memory:
      case ExternalKindImpl::Tag:
      case ExternalKindImpl::Invalid:
        break;
    }
  }
  for (auto& func : wasm.functions) {
    // Imported functions are the opposite of exported functions. Their
    // parameters flow out and their results flow in.
    if (func->imported()) {
      for (auto type : func->getParams()) {
        flowOut(type);
      }
      for (auto type : func->getResults()) {
        flowIn(type);
      }
    }
  }
  for (auto& table : wasm.tables) {
    // Imported tables, like exported tables, let values flow in and out.
    if (table->imported()) {
      flowOut(table->type);
      flowIn(table->type);
    }
  }
  for (auto& global : wasm.globals) {
    // Imported mutable globals let values flow in and out. Imported immutable
    // globals imply that values will flow in.
    if (global->imported()) {
      flowIn(global->type);
      if (global->mutable_) {
        flowOut(global->type);
      }
    }
  }
}

} // namespace wasm::JSUtils

#endif // wasm_ir_js_utils_h
