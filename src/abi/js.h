/*
 * Copyright 2018 WebAssembly Community Group participants
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

#ifndef wasm_abi_abi_h
#define wasm_abi_abi_h

#include "asmjs/shared-constants.h"
#include "wasm.h"

namespace wasm {

namespace ABI {

enum class LegalizationLevel { Full = 0, Minimal = 1 };

inline std::string getLegalizationPass(LegalizationLevel level) {
  if (level == LegalizationLevel::Full) {
    return "legalize-js-interface";
  } else {
    return "legalize-js-interface-minimally";
  }
}

namespace wasm2js {

extern cashew::IString SCRATCH_LOAD_I32;
extern cashew::IString SCRATCH_STORE_I32;
extern cashew::IString SCRATCH_LOAD_I64;
extern cashew::IString SCRATCH_STORE_I64;
extern cashew::IString SCRATCH_LOAD_F32;
extern cashew::IString SCRATCH_STORE_F32;
extern cashew::IString SCRATCH_LOAD_F64;
extern cashew::IString SCRATCH_STORE_F64;
extern cashew::IString ATOMIC_WAIT_I32;

// The wasm2js helpers let us do things that can't be done without special help,
// like read and write to scratch memory for purposes of implementing things
// like reinterpret, etc.
// The optional "specific" parameter is a specific function we want. If not
// provided, we create them all.
inline void
ensureHelpers(Module* wasm,
                           cashew::IString specific = cashew::IString()) {
  auto ensureImport = [&](Name name, Type params, Type results) {
    if (wasm->getFunctionOrNull(name)) {
      return;
    }
    if (specific.is() && name != specific) {
      return;
    }
    auto func = make_unique<Function>();
    func->name = name;
    func->sig = Signature(params, results);
    func->module = ENV;
    func->base = name;
    wasm->addFunction(std::move(func));
  };

  ensureImport(SCRATCH_LOAD_I32, {Type::i32}, Type::i32);
  ensureImport(SCRATCH_STORE_I32, {Type::i32, Type::i32}, Type::none);
  ensureImport(SCRATCH_LOAD_I64, {}, Type::i64);
  ensureImport(SCRATCH_STORE_I64, {Type::i64}, Type::none);
  ensureImport(SCRATCH_LOAD_F32, {}, Type::f32);
  ensureImport(SCRATCH_STORE_F32, {Type::f32}, Type::none);
  ensureImport(SCRATCH_LOAD_F64, {}, Type::f64);
  ensureImport(SCRATCH_STORE_F64, {Type::f64}, Type::none);
  ensureImport(ATOMIC_WAIT_I32, {Type::i32, Type::i32, Type::i32, Type::i32}, Type::i32);
}

inline bool isHelper(cashew::IString name) {
  return name == SCRATCH_LOAD_I32 || name == SCRATCH_STORE_I32 ||
         name == SCRATCH_LOAD_I64 || name == SCRATCH_STORE_I64 ||
         name == SCRATCH_LOAD_F32 || name == SCRATCH_STORE_F32 ||
         name == SCRATCH_LOAD_F64 || name == SCRATCH_STORE_F64;
}

} // namespace wasm2js

} // namespace ABI

} // namespace wasm

#endif // wasm_abi_abi_h
