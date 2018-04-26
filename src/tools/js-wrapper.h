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
  ret += "if (typeof console === 'undefined') {\n"
         "  console = { log: print };\n"
         "}\n"
         "var binary;\n"
         "if (typeof process === 'object' && typeof require === 'function' /* node.js detection */) {\n"
         "  var args = process.argv.slice(2);\n"
         "  binary = require('fs').readFileSync(args[0]);\n"
         "  if (!binary.buffer) binary = new Uint8Array(binary);\n"
         "} else {\n"
         "  var args;\n"
         "  if (typeof scriptArgs != 'undefined') {\n"
         "    args = scriptArgs;\n"
         "  } else if (typeof arguments != 'undefined') {\n"
         "    args = arguments;\n"
         "  }\n"
         "  if (typeof readbuffer === 'function') {\n"
         "    binary = new Uint8Array(readbuffer(args[0]));\n"
         "  } else {\n"
         "    binary = read(args[0], 'binary');\n"
         "  }\n"
         "}\n"
         "var instance = new WebAssembly.Instance(new WebAssembly.Module(binary), {});\n";
  for (auto& exp : wasm.exports) {
    auto* func = wasm.getFunctionOrNull(exp->value);
    if (!func) continue; // something exported other than a function
    auto bad = false; // check for things we can't support
    for (Type param : func->params) {
      if (param == i64) bad = true;
    }
    if (func->result == i64) bad = true;
    if (bad) continue;
    ret += "if (instance.exports.hangLimitInitializer) instance.exports.hangLimitInitializer();\n";
    ret += "try {\n";
    ret += std::string("  console.log('calling: ") + exp->name.str + "');\n";
    if (func->result != none) {
      ret += "  console.log('   result: ' + ";
    }
    ret += std::string("instance.exports.") + exp->name.str + "(";
    bool first = true;
    for (Type param : func->params) {
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
    ret += "} catch (e) {\n";
    ret += "  console.log('   exception: ' + e);\n";
    ret += "}\n";
  }
  ret += "console.log('done.')\n";
  return ret;
}

} // namespace wasm

