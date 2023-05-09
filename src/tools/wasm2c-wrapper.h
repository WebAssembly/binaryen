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

#include <sstream>
#include <string>

#include "wasm.h"

namespace wasm {

// Mangle a name in (hopefully) exactly the same way wasm2c does.
inline std::string wasm2cMangle(Name name, Signature sig) {
  const char escapePrefix = 'Z';
  std::string mangled = "Z_";
  for (unsigned char c : name.str) {
    if ((isalnum(c) && c != escapePrefix) || c == '_') {
      // This character is ok to emit as it is.
      mangled += c;
    } else {
      // This must be escaped, as prefix + hex character code.
      mangled += escapePrefix;
      std::stringstream ss;
      ss << std::hex << std::uppercase << unsigned(c);
      mangled += ss.str();
    }
  }

  // Emit the result and params.
  mangled += "Z_";

  auto wasm2cSignature = [](Type type) {
    TODO_SINGLE_COMPOUND(type);
    switch (type.getBasic()) {
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

  mangled += wasm2cSignature(sig.results);
  if (sig.params.isTuple()) {
    for (const auto& param : sig.params) {
      mangled += wasm2cSignature(param);
    }
  } else {
    mangled += wasm2cSignature(sig.params);
  }

  return mangled;
}

inline std::string generateWasm2CWrapper(Module& wasm) {
  // First, emit implementations of the wasm's imports so that the wasm2c code
  // can call them. The names use wasm2c's name mangling.
  std::string ret = R"(
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>

#include "wasm-rt-impl.h"
#include "wasm.h"

void _Z_fuzzingZ2DsupportZ_logZ2Di32Z_vi(u32 x) {
  printf("[LoggingExternalInterface logging %d]\n", x);
}
void (*Z_fuzzingZ2DsupportZ_logZ2Di32Z_vi)(u32) = _Z_fuzzingZ2DsupportZ_logZ2Di32Z_vi;

void _Z_fuzzingZ2DsupportZ_logZ2Di64Z_vj(u64 x) {
  printf("[LoggingExternalInterface logging %" PRId64 "]\n", (int64_t)x);
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

  // We go through each export and call it, in turn. Note that we use a loop
  // so we can do all this with a single setjmp. A setjmp is needed to handle
  // wasm traps, and emitting a single one helps compilation speed into wasm as
  // compile times are O(size * num_setjmps).
  for (size_t curr = 0;; curr++) {
  )";
  ret += R"(
    // Prepare to call the export, so we can catch traps.
    if (WASM_RT_SETJMP(g_jmp_buf) != 0) {
      puts("exception!");
    } else {
      // Call the proper export.
      switch(curr) {
)";

  // For each function export in the wasm, emit code to call it and log its
  // result, similar to the other wrappers.
  size_t functionExportIndex = 0;

  for (auto& exp : wasm.exports) {
    if (exp->kind != ExternalKind::Function) {
      continue;
    }

    ret += "        case " + std::to_string(functionExportIndex++) + ":\n";

    auto* func = wasm.getFunction(exp->value);

    ret += std::string("          puts(\"[fuzz-exec] calling ") +
           exp->name.toString() + "\");\n";
    auto result = func->getResults();

    // Emit the call itself.
    ret += "            ";
    if (result != Type::none) {
      ret += std::string("printf(\"[fuzz-exec] note result: ") +
             exp->name.toString() + " => ";
      TODO_SINGLE_COMPOUND(result);
      switch (result.getBasic()) {
        case Type::i32:
          ret += "%d\\n\", ";
          break;
        case Type::i64:
          ret += "%\" PRId64 \"\\n\", (int64_t)";
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

    // Call the export.
    ret += "(*";

    // Emit the callee's name with wasm2c name mangling.
    ret += wasm2cMangle(exp->name, func->getSig());

    ret += ")(";

    // Emit the parameters (all 0s, like the other wrappers).
    bool first = true;
    for ([[maybe_unused]] const auto& param : func->getParams()) {
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

    // Break from the big switch.
    ret += "          break;\n";
  }

  ret += R"(        default:
          return 0; // All done.
      }
    }
  }
  return 0;
}
)";

  return ret;
}

} // namespace wasm
