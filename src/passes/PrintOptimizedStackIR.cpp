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
//


#include "wasm.h"
#include "pass.h"
#include "wasm-stack.h"

namespace wasm {

struct PrintOptimizedStackIR : public WalkerPass<PostWalker<PrintOptimizedStackIR>> {
  // Not parallel: this pass is just for testing and debugging; keep the output
  // sorted by function order.
  bool isFunctionParallel() override { return false; }

  Pass* create() override { return new PrintOptimizedStackIR; }

  void doWalkFunction(Function* func) {
    // Set up a minimal binary writing environment.
    BufferWithRandomAccess buffer;
    WasmBinaryWriter binaryWriter(getModule(), buffer);
    binaryWriter.prepare();
    OptimizingFunctionStackWriter stackWriter(func, binaryWriter, buffer);
    // Print out the Stack IR
    std::cout << func->name << ":\n";
//    int indent = 0;
    for (auto* inst : stackWriter.stackInsts) {
      std::cout << "  ";
      if (!inst) {
        std::cout << "(nullptr)";
      } else {
        switch (inst->op) {
          case StackInst::Basic: {
            std::cout << "basic TODO";
            break;
          }
          case StackInst::BlockEnd: {
            std::cout << "end";
            break;
          }
          case StackInst::IfElse: {
            std::cout << "else";
            break;
          }
          case StackInst::IfEnd: {
            std::cout << "end";
            break;
          }
          case StackInst::LoopEnd: {
            std::cout << "end";
            break;
          }
          default: WASM_UNREACHABLE();
        }
      }
      std::cout << '\n';
    }
  }
};

Pass *createPrintOptimizedStackIRPass() {
  return new PrintOptimizedStackIR();
}

} // namespace wasm
