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

#include <llvm/ADT/APInt.h>
#include <llvm/IR/Constant.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Verifier.h>
#include <llvm/Support/InitLLVM.h>

#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

struct LLVM : public wasm::Pass {
  void run(wasm::Module* module) override {
    std::cout << "LLVM pass\n";

#if 0
    // Initialize LLVM without any commandline arguments; we just need the lib.
    // XXX do we even need this?
    int argc = 1;
    const char* argvData[1];
    argvData[0] = "binaryen";
    const char** argv = argvData;
    llvm::InitLLVM X(argc, argv);
#endif

    {
      using namespace llvm;

      LLVMContext context;
      auto i32 = Type::getInt32Ty(context);

      Module mod("byn_mod", context);
      mod.setTargetTriple("wasm32-unknown-unknown");

      mod.getOrInsertFunction("byn_func", i32);
      auto* func = mod.getFunction("byn_func");

      IRBuilder builder(context);

      BasicBlock* body = BasicBlock::Create(context, "entry", func);
      builder.SetInsertPoint(body);
      auto num1 = Constant::getIntegerValue(i32, APInt(32, 41));
      auto num2 = Constant::getIntegerValue(i32, APInt(32, 1));
      auto* add = builder.CreateAdd(num1, num2, "addd");
      errs() << "add: " << *add << '\n';
      auto* ret = builder.CreateRet(add);
      errs() << "ret: " << *ret << '\n';

      if (verifyModule(mod, &errs())) {
        wasm::Fatal() << "broken LLVM module";
      }
      errs() << mod << '\n';
    }
  }
};

namespace wasm {

Pass* createLLVMPass() { return new LLVM(); }

} // namespace wasm
