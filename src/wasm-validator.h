/*
 * Copyright 2015 WebAssembly Community Group participants
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
// Simple WebAssembly module validator.
//
// There are some options regarding how to validate:
//
//  * validateWeb: The Web platform doesn't have i64 values, so it is illegal
//                 to import or export such a value. When this option is set,
//                 such imports/exports are validation errors.
//
//  * validateGlobally: Binaryen supports building modules in parallel, which
//                      means you can add and optimize a function before the
//                      module is complete, for example, you can add function A
//                      with a call to function B before function B exists.
//                      When validateGlobally is disabled, we don't look at
//                      global correctness, and instead only check inside
//                      each function (so in the example above we wouldn't care
//                      about function B not existing yet, but we would care
//                      if e.g. inside function A an i32.add receives an i64).
//
//  * quiet: Whether to log errors verbosely.
//

#ifndef wasm_wasm_validator_h
#define wasm_wasm_validator_h

#include <set>
#include <sstream>
#include <unordered_set>

#include "wasm.h"
#include "wasm-printing.h"

namespace wasm {

struct WasmValidator {
  enum FlagValues {
    Minimal = 0,
    Web = 1 << 0,
    Globally = 1 << 1,
    Quiet = 1 << 2
  };
  typedef uint32_t Flags;

  bool validate(Module& module, FeatureSet features = MVP, Flags flags = Globally);
};

} // namespace wasm

#endif // wasm_wasm_validator_h
