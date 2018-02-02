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

namespace wasm {

static std::string generateSpecWrapper(Module& wasm) {
  std::string ret;
  for (auto& exp : wasm.exports) {
    auto* func = wasm.getFunctionOrNull(exp->value);
    if (!func) continue; // something exported other than a function
    ret += std::string("(invoke \"hangLimitInitializer\") (invoke \"") + exp->name.str + "\" ";
    for (Type param : func->params) {
      // zeros in arguments TODO more?
      switch (param) {
        case i32: ret += "(i32.const 0)"; break;
        case i64: ret += "(i64.const 0)"; break;
        case f32: ret += "(f32.const 0)"; break;
        case f64: ret += "(f64.const 0)"; break;
        default: WASM_UNREACHABLE();
      }
      ret += " ";
    }
    ret += ") ";
  }
  return ret;
}

} // namespace wasm

