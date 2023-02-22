/*
 * Copyright 2017 WebAssembly Community Group participants
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
// Emit a wasm spec interpreter wrapper to run a wasm module with some test
// values, useful for fuzzing.
//

#include "wasm-type.h"
#include "wasm.h"

namespace wasm {

inline std::string generateSpecWrapper(Module& wasm) {
  std::string ret;
  for (auto& exp : wasm.exports) {
    auto* func = wasm.getFunctionOrNull(exp->value);
    if (!func) {
      continue; // something exported other than a function
    }
    ret += std::string("(invoke \"") + exp->name.toString() + "\" ";
    for (const auto& param : func->getParams()) {
      // zeros in arguments TODO more?
      TODO_SINGLE_COMPOUND(param);
      switch (param.getBasic()) {
        case Type::i32:
          ret += "(i32.const 0)";
          break;
        case Type::i64:
          ret += "(i64.const 0)";
          break;
        case Type::f32:
          ret += "(f32.const 0)";
          break;
        case Type::f64:
          ret += "(f64.const 0)";
          break;
        case Type::v128:
          ret += "(v128.const i32x4 0 0 0 0)";
          break;
        case Type::none:
        case Type::unreachable:
          WASM_UNREACHABLE("unexpected type");
      }
      ret += " ";
    }
    ret += ") ";
  }
  return ret;
}

} // namespace wasm
