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
// Write out the name list of the module, similar to `nm`.
//

#include "wasm.h"
#include "pass.h"
#include "ir/module-utils.h"
#include "ir/utils.h"

namespace wasm {

struct NameList : public Pass {
  void run(PassRunner* runner, Module* module) override {
    ModuleUtils::iterDefinedFunctions(*module, [&](Function* func) {
      std::cout << "    " << func->name << " : " << Measurer::measure(func->body) << '\n';
    });
  }
};

Pass *createNameListPass() {
  return new NameList();
}

} // namespace wasm

