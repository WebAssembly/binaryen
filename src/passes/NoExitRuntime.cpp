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
// Assumes the program will never exit the runtime (as in the emscripten
// NO_EXIT_RUNTIME option). That means that atexit()s do not need to be
// run.
//

#include <asmjs/shared-constants.h>
#include <pass.h>
#include <wasm-builder.h>
#include <wasm.h>

using namespace std;

namespace wasm {

struct NoExitRuntime : public WalkerPass<PostWalker<NoExitRuntime>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new NoExitRuntime; }

  // Remove all possible manifestations of atexit, across asm2wasm and llvm wasm
  // backend.
  std::array<Name, 4> ATEXIT_NAMES = {
    {"___cxa_atexit", "__cxa_atexit", "_atexit", "atexit"}};

  void visitCall(Call* curr) {
    auto* import = getModule()->getFunctionOrNull(curr->target);
    if (!import || !import->imported() || import->module != ENV) {
      return;
    }
    for (auto name : ATEXIT_NAMES) {
      if (name == import->base) {
        replaceCurrent(Builder(*getModule()).replaceWithIdenticalType(curr));
      }
    }
  }
};

Pass* createNoExitRuntimePass() { return new NoExitRuntime(); }

} // namespace wasm
