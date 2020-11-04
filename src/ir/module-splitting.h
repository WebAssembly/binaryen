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

#ifndef wasm_ir_module_splitting_h
#define wasm_ir_module_splitting_h

#include "wasm.h"

namespace wasm {

namespace ModuleSplitting {

struct Config {
  // The set of functions to keep in the primary module. All others are split
  // out into the new secondary module.
  std::set<Name> primaryFuncs;
  // The namespace from which to import primary functions into the secondary
  // module.
  Name importNamespace = "primary";
  // The namespace from which to import placeholder functions into the primary
  // module.
  Name placeholderNamespace = "placeholder";
};

std::unique_ptr<Module> splitFunctions(Module& primary, const Config& config);

} // namespace ModuleSplitting

} // namespace wasm

#endif // wasm_ir_module_splitting_h
