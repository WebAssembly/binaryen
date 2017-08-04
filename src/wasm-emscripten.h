/*
 * Copyright 2016 WebAssembly Community Group participants
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

#ifndef wasm_wasm_emscripten_h
#define wasm_wasm_emscripten_h

#include "wasm.h"

namespace wasm {

class LinkerObject;

namespace emscripten {

void generateRuntimeFunctions(LinkerObject& linker);
void generateMemoryGrowthFunction(Module&);

// Create thunks for use with emscripten Runtime.dynCall. Creates one for each
// signature in the indirect function table.
std::vector<Function*> makeDynCallThunks(Module& wasm, std::vector<Name> const& tableSegmentData);

void generateEmscriptenMetadata(std::ostream& o,
                                Module& wasm,
                                std::unordered_map<Address, Address> segmentsByAddress,
                                Address staticBump,
                                std::vector<Name> const& initializerFunctions);

} // namespace emscripten

} // namespace wasm

#endif // wasm_wasm_emscripten_h
