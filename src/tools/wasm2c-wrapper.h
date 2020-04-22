/*
 * Copyright 2020 WebAssembly Community Group participants
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

#include <string>

#include "wasm.h"

namespace wasm {

static std::string generateWasm2CWrapper(Module& wasm) {
  // First, emit implementations of the wasm's imports so that the wasm2c code
  // can call them. The names use wasm2c's name mangling.
  std::string ret = R"(
#include <stdint.h>
#include <stdio.h>

#include "wasm-rt-impl.h"
#include "wasm.h"

void _Z_fuzzingZ2DsupportZ_logZ2Di32Z_vi(u32 x) {
  printf("[LoggingExternalInterface logging %d]\n", x);
}
void (*Z_fuzzingZ2DsupportZ_logZ2Di32Z_vi)(u32) = _Z_fuzzingZ2DsupportZ_logZ2Di32Z_vi;

void _Z_fuzzingZ2DsupportZ_logZ2Di64Z_vj(u64 x) {
  printf("[LoggingExternalInterface logging %ld]\n", (long)x);
}
void (*Z_fuzzingZ2DsupportZ_logZ2Di64Z_vj)(u64) = _Z_fuzzingZ2DsupportZ_logZ2Di64Z_vj;

void _Z_fuzzingZ2DsupportZ_logZ2Di64Z_vii(u32 x, u32 y) {
  printf("[LoggingExternalInterface logging %d %d]\n", x, y);
}
void (*Z_fuzzingZ2DsupportZ_logZ2Di64Z_vii)(u32, u32) = _Z_fuzzingZ2DsupportZ_logZ2Di64Z_vii;

void _Z_fuzzingZ2DsupportZ_logZ2Df32Z_vf(f32 x) {
  printf("[LoggingExternalInterface logging %.17e]\n", x);
}
void (*Z_fuzzingZ2DsupportZ_logZ2Df32Z_vf)(f32) = _Z_fuzzingZ2DsupportZ_logZ2Df32Z_vf;

void _Z_fuzzingZ2DsupportZ_logZ2Df64Z_vd(f64 x) {
  printf("[LoggingExternalInterface logging %.17le]\n", x);
}
void (*Z_fuzzingZ2DsupportZ_logZ2Df64Z_vd)(f64) = _Z_fuzzingZ2DsupportZ_logZ2Df64Z_vd;

// Miscellaneous imports

u32 tempRet0 = 0;

void _Z_envZ_setTempRet0Z_vi(u32 x) {
  tempRet0 = x;
}
void (*Z_envZ_setTempRet0Z_vi)(u32) = _Z_envZ_setTempRet0Z_vi;

u32 _Z_envZ_getTempRet0Z_iv(void) {
  return tempRet0;
}
u32 (*Z_envZ_getTempRet0Z_iv)(void) = _Z_envZ_getTempRet0Z_iv;

// Main

int main(int argc, char** argv) {
  init();

)";

  // For each export in the wasm, emit code to call it and log its result,
  // similar to the other wrappers.
  for (auto& exp : wasm.exports) {
    if (exp->kind != ExternalKind::Function) {
      continue;
    }

    // Always call the hang limit initializer before each export.
    ret += "  (*Z_hangLimitInitializerZ_vv)();\n";

    auto* func = wasm.getFunction(exp->value);

    // Emit a setjmp so that we can handle traps from the compiled wasm.
    ret +=
      std::string("  puts(\"[fuzz-exec] calling ") + exp->name.str + "\");\n";
    ret += "  if (setjmp(g_jmp_buf) == 0) {\n";
    auto result = func->sig.results;

    // Emit the call itself.
    ret += "    ";
    if (result != Type::none) {
      ret += std::string("printf(\"[fuzz-exec] note result: ") + exp->name.str +
             " => ";
      switch (result.getSingle()) {
        case Type::i32:
          ret += "%d\\n\", ";
          break;
        case Type::i64:
          ret += "%ld\\n\", (long)";
          break;
        case Type::f32:
          ret += "%.17e\\n\", ";
          break;
        case Type::f64:
          ret += "%.17le\\n\", ";
          break;
        default:
          Fatal() << "unhandled wasm2c wrapper result type: " << result;
      }
    }

    // Emit the callee's name with wasm2c name mangling.
    ret += std::string("(*Z_") + exp->name.str + "Z_";
    auto params = func->sig.params.expand();

    auto wasm2cSignature = [](Type type) {
      switch (type.getSingle()) {
        case Type::none:
          return 'v';
        case Type::i32:
          return 'i';
        case Type::i64:
          return 'j';
        case Type::f32:
          return 'f';
        case Type::f64:
          return 'd';
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

    // Emit the parameters (all 0s, like the other wrappers).
    bool first = true;
    for (auto param : params) {
      WASM_UNUSED(param);
      if (!first) {
        ret += ", ";
      }
      ret += "0";
      first = false;
    }
    if (result != Type::none) {
      ret += ")";
    }
    ret += ");\n";

    // Handle a longjmp which indicates a trap happened.
    ret += "  } else {\n";
    ret += "    puts(\"exception!\");\n";
    ret += "  }\n";
  }

  ret += R"(

  return 0;
}
)";

  return ret;
}

} // namespace wasm
