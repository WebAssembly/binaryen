/*
 * Copyright 2017 WebAssembly Community Group participants
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
// Pass that supports potentially-trapping float operations.
//

#ifndef wasm_passes_FloatTrap_h
#define wasm_passes_FloatTrap_h

#include "pass.h"
#include "wasm.h"
#include "support/name.h"

namespace wasm {

struct FloatTrap : public WalkerPass<PostWalker<FloatTrap>> {
public:
  enum class Mode {
    Allow,
    Clamp,
    JS
  };

  // Needs to be non-parallel so that visitModule gets called after visiting
  // each node in the module, so we can add the functions that we created.
  bool isFunctionParallel() override { return false; }

  FloatTrap(Mode mode);

  Pass* create() override { return new FloatTrap(mode); }

  void visitUnary(Unary* curr);
  void visitBinary(Binary* curr);
  void visitModule(Module* curr);

private:
  Mode mode;
  // Need to defer adding generated functions because adding functions while
  // iterating over existing functions causes problems.
  std::map<Name, Function*> generatedFunctions;
  bool didAddF64ToI64JSImport;

  Expression* makeTrappingBinary(Binary* curr);
  Expression* makeTrappingUnary(Unary* curr);

  void ensureF64ToI64JSImport();
  void ensureBinaryFunc(Binary* curr);
  void ensureUnaryFunc(Unary *curr);

  Name getBinaryFuncName(Binary* curr);
  Name getUnaryFuncName(Unary* curr);
};

} // namespace wasm

#endif // wasm_passes_FloatTrap_h
