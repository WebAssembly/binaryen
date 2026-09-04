/*
 * Copyright 2024 WebAssembly Community Group participants
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

#ifndef wasm_tools_fuzzing_fuzz_stats_h
#define wasm_tools_fuzzing_fuzz_stats_h

namespace wasm {

class Module;

namespace FuzzStats {

// Collect statistics on the module if statistics collection is enabled via the
// BINARYEN_FUZZ_STATS environment variable. If not enabled, does nothing.
void collect(Module& wasm);

} // namespace FuzzStats

} // namespace wasm

#endif // wasm_tools_fuzzing_fuzz_stats_h
