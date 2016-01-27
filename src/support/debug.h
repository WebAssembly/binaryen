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
// Debug helpers.
//

#ifndef wasm_support_debug_h
#define wasm_support_debug_h

#include <fstream>
#include <iostream>
#include <string>
#include <utility>
#include <vector>

namespace wasm {
// Installs a signal handler that prints stack traces.
void setDebugSignalHandler(const char *programName);
}

#endif // wasm_support_debug_h
