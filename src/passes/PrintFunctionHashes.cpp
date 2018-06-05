/*
 * Copyright 2018 WebAssembly Community Group participants
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
// Prints out the internal hash numbers of each function. This is mostly useful
// for debugging our hashing.
//

#include "wasm.h"
#include "pass.h"
#include "ir/hashed.h"

namespace wasm {


struct PrintFunctionHashes : public Pass {
  void run(PassRunner* runner, Module* module) override {
    auto hashes = FunctionHasher::createMap(module);
    // Hash all the functions
    PassRunner hasherRunner(module);
    hasherRunner.setIsNested(true);
    hasherRunner.add<FunctionHasher>(&hashes);
    hasherRunner.run();
    for (auto& func : module->functions) {
      std::cout << "hash[" << func->name << "] = " << hashes[func.get()] << '\n';
    }
  }
};

Pass *createPrintFunctionHashesPass() {
  return new PrintFunctionHashes();
}

} // namespace wasm
