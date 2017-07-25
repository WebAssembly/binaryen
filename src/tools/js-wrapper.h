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
// Emit a JavaScript wrapper to run a wasm module with some test
// values, useful for fuzzing.
//

namespace wasm {

static std::string generateJSWrapper(Module& wasm) {
  std::string ret;
  ret += "// the variable 'binary' must exist and contain the wasm file\n";
  ret += "var instance = new WebAssembly.Instance(new WebAssembly.Module(binary), {})\n";
  for (auto& exp : wasm.exports) {
    auto* func = wasm.getFunctionOrNull(exp->value);
    if (!func) continue; // something exported other than a function
    auto bad = false; // check for things we can't support
    for (WasmType param : func->params) {
      if (param == i64) bad = true;
    }
    if (func->result == i64) bad = true;
    if (bad) continue;
    if (func->result != none) {
      ret += "console.log(";
    }
    ret += std::string("instance.") + exp->name.str + "(";
    bool first = true;
    for (WasmType param : func->params) {
      WASM_UNUSED(param);
      // zeros in arguments TODO more?
      if (first) {
        first = false;
      } else {
        ret += ", ";
      }
      ret += "0";
    }
    ret += ")";
    if (func->result != none) {
      ret += ")"; // for console.log
    }
    ret += ";\n";
  }
  return ret;
}

} // namespace wasm

