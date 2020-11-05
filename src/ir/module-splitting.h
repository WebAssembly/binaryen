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

// module-splitting.h: Provides an interface for decomposing WebAssembly modules
// into multiple modules that can be loaded independently. This works by moving
// functions to a new secondary module and rewriting the primary module to call
// them indirectly. Until the secondary module is instantiated, those indirect
// calls will go to placeholder functions newly imported into the primary
// module. The import names of the placeholder functions are the table indexes
// they are placed at. The secondary module imports all of its dependencies from
// the primary module.
//
// This code currently makes a few assumptions about the modules that will be
// split and will fail assertions if those assumptions are not true.
//
//   1) It assumes that mutable-globals are allowed.
//
//   2) It assumes that all table segment offsets are constants.
//
//   3) It assumes that each function appears in the table at most once.
//
// These requirements will be relaxed as necessary in the future, but for now
// this code should be considered experimental and used with care.

#ifndef wasm_ir_module_splitting_h
#define wasm_ir_module_splitting_h

#include "wasm.h"

namespace wasm {

namespace ModuleSplitting {

struct Config {
  // The set of functions to keep in the primary module. All others are split
  // out into the new secondary module. Must include all imported functions.
  std::set<Name> primaryFuncs;
  // The namespace from which to import primary functions into the secondary
  // module.
  Name importNamespace = "primary";
  // The namespace from which to import placeholder functions into the primary
  // module.
  Name placeholderNamespace = "placeholder";
};

// Returns the new secondary module and modifies the `primary` module in place.
std::unique_ptr<Module> splitFunctions(Module& primary, const Config& config);

} // namespace ModuleSplitting

} // namespace wasm

#endif // wasm_ir_module_splitting_h
