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
#include <stdint.h>
#include <stdio.h>

#include "wasm.h"

void _Z_fuzzingZ2DsupportZ_logZ2Di32Z_vi(u32 x) {
  printf("[LoggingExternalInterface logging %d]\n", x);
}
void (*Z_fuzzingZ2DsupportZ_logZ2Di32Z_vi)(u32) = _Z_fuzzingZ2DsupportZ_logZ2Di32Z_vi;

void _Z_fuzzingZ2DsupportZ_logZ2Di64Z_vj(u64 x) {
  printf("[LoggingExternalInterface logging %lld]\n", x);
}
void (*Z_fuzzingZ2DsupportZ_logZ2Di64Z_vj)(u64) = _Z_fuzzingZ2DsupportZ_logZ2Di64Z_vj;

void _Z_fuzzingZ2DsupportZ_logZ2Df32Z_vf(f32 x) {
  printf("[LoggingExternalInterface logging %f]\n", x);
}
void (*Z_fuzzingZ2DsupportZ_logZ2Df32Z_vf)(f32) = _Z_fuzzingZ2DsupportZ_logZ2Df32Z_vf;

void _Z_fuzzingZ2DsupportZ_logZ2Df64Z_vd(f64 x) {
  printf("[LoggingExternalInterface logging %lf]\n", x);
}
void (*Z_fuzzingZ2DsupportZ_logZ2Df64Z_vd)(f64) = _Z_fuzzingZ2DsupportZ_logZ2Df64Z_vd;

int main(int argc, char** argv) {
  init();

)";

  for (auto& exp : wasm.exports) {
    if (exp->kind != ExternalKind::Function) {
      continue;
    }

    auto* func = wasm.getFunction(exp->value);

    ret += "  puts(\"[fuzz-exec] calling hashMemory\");\n";
    ret += "  (*Z_hangLimitInitializerZ_vv)();\n";

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
      ret += std::string("\\n\", (*Z_") + exp->name.str + "Z_";
      // wasm2c emits names with a special signature
      auto params = func->sig.params.expand();

      auto wasm2cSignature = [](Type type) {
        switch (type.getSingle()) {
          case Type::none: return 'v';
          case Type::i32: return 'i';
          case Type::i64: return 'j';
          case Type::f32: return 'f';
          case Type::f64: return 'd';
          default:
            Fatal() << "unhandled wasm2c wrapper signature type: " << type;
        }
      };

      ret += wasm2cSignature(result);
      if (params.empty()) {
        ret += wasm2cSignature(Type::none);
      } else {
        for (auto param : params) {
          ret += wasm2cSignature(param);
        }
      }
      ret += ")(";
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
