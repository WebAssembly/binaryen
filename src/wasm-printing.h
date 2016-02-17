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

#ifndef __wasm_printing_h__
#define __wasm_printing_h__

#include "wasm.h"
#include "pass.h"

namespace wasm {

inline std::ostream& printWasm(Module* module, std::ostream& o) {
  PassRunner passRunner(nullptr);
  passRunner.add<Printer>(o);
  passRunner.run(module);
  return o;
}

extern std::ostream& printWasm(Expression* expression, std::ostream& o);

}

#endif

