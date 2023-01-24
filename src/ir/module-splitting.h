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
// module. If the primary module has a single segment with a non-constant
// offset, the placeholder function import names are the offsets from that base
// global of the corresponding functions in the table. Otherwise, the
// placeholder import names are the absolute table indices of the corresponding
// functions. The secondary module imports all of its dependencies from the
// primary module.
//
// This code currently makes a couple assumptions about the modules that will be
// split and will fail assertions if those assumptions are not true.
//
//   1) It assumes that mutable-globals are allowed.
//
//   2) It assumes that either all segment offsets are constants or there is
//      exactly one segment that may have a non-constant offset.
//
// These requirements will be relaxed as necessary in the future, but for now
// this code should be considered experimental and used with care.

#ifndef wasm_ir_module_splitting_h
#define wasm_ir_module_splitting_h

#include "wasm.h"

namespace wasm::ModuleSplitting {

static const Name LOAD_SECONDARY_MODULE("__load_secondary_module");

struct Config {
  // The set of functions to keep in the primary module. All others are split
  // out into the new secondary module. Must include the start function if it
  // exists. May or may not include imported functions, which are always kept in
  // the primary module regardless.
  std::set<Name> primaryFuncs;
  // The namespace from which to import primary functions into the secondary
  // module.
  Name importNamespace = "primary";
  // The namespace from which to import placeholder functions into the primary
  // module.
  Name placeholderNamespace = "placeholder";
  // The prefix to attach to the name of any newly created exports. This can be
  // used to differentiate between "real" exports of the module and exports that
  // should only be consumed by the secondary module.
  std::string newExportPrefix = "";
  // Whether the export names of newly created exports should be minimized. If
  // false, the original function names will be used (after `newExportPrefix`)
  // as the new export names.
  bool minimizeNewExportNames = false;
  // When JSPI support is enabled the secondary module loading is handled by an
  // imported function.
  bool jspi = false;
};

struct Results {
  std::unique_ptr<Module> secondary;
  std::map<size_t, Name> placeholderMap;
};

// Returns the new secondary module and modifies the `primary` module in place.
Results splitFunctions(Module& primary, const Config& config);

} // namespace wasm::ModuleSplitting

#endif // wasm_ir_module_splitting_h
