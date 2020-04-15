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
// Emit a C  wrapper file that can run the wasm after it is compiled with
// wasm2c, useful for fuzzing.
//

namespace wasm {

static std::string generateWasm2CWrapper(Module& wasm) {
  std::string ret;
  ret += R"(
#include <stdio.h>

#include "wasm.h"

int main(int argc, char** argv) {

)";

  for (auto& exp : wasm.exports) {
    if (exp->kind != ExternalKind::Function) {
      continue;
    }

    auto* func = wasm.getFunction(exp->value);

    ret += "  puts(\"[fuzz-exec] calling hashMemory\");\n";
    ret += "  hangLimitInitializer();\n";

    ret += std::string("  puts(\"[fuzz-exec] calling ") + exp->name.str + "\");\n";
    auto result = func->sig.results;//.getSingle();
    if (result != Type::none) {
      ret += std::string("  printf(\"[fuzz-exec] note result: ") + exp->name.str + " => ";
      switch (result.getSingle()) {
        case Type::i32:
          ret += "%d";
          break;
        case Type::i64:
          ret += "%lld";
          break;
        case Type::f32:
          ret += "%f";
          break;
        case Type::f64:
          ret += "%lf";
          break;
        default:
          Fatal() << "unhandled wasm2c wrapper result type: " << result;
      }
      ret += std::string("\\n\", Z_") + exp->name.str + "Z_";
      // wasm2c emits names with a special signature
      auto params = func->sig.params.expand();

      auto wasm2cSignature = [](Type type) {
        switch (type.getSingle()) {
          case Type::i32: return 'i';
          case Type::i64: return 'j';
          case Type::f32: return 'f';
          case Type::f64: return 'd';
          default:
            Fatal() << "unhandled wasm2c wrapper signature type: " << type;
        }
      };

      ret += wasm2cSignature(result);
      for (auto param : params) {
        ret += wasm2cSignature(param);
      }
      ret += "(";
      if (!params.empty()) {
        bool first = true;
        for (auto param : params) {
          WASM_UNUSED(param);
          if (!first) {
            ret += ", ";
          }
          ret += "0";
          first = false;
        }
      }
      ret += "));\n";
    }
  }

  ret += R"(

  return 0;
}
)";

  return ret;
}

} // namespace wasm
