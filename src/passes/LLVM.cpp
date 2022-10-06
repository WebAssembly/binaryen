/*
 * Copyright 2022 WebAssembly Community Group participants
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

#include <llvm/Support/InitLLVM.h>

#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

struct LLVM : public Pass {
  void run(Module* module) override {
    std::cout << "LLVM pass\n";

    // Initialize LLVM without any commandline arguments; we just need the lib.
    int argc = 1;
    const char* argvData[1];
    argvData[0] = "binaryen";
    const char** argv = argvData;
    llvm::InitLLVM X(argc, argv);
  }
};

// declare passes

Pass* createLLVMPass() { return new LLVM(); }

} // namespace wasm
