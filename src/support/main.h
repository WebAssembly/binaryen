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

//
// Cross-platform definition of main.
//
// Users will write main like:
//
//     int BYN_MAIN(int argc, const pchar* argv[]) { ... }
//

#ifndef wasm_support_main_h
#define wasm_support_main_h

#include "support/pchar.h"

#ifdef _WIN32
#define BYN_MAIN wmain
#else
#define BYN_MAIN main
#endif

#endif // wasm_support_main_h
