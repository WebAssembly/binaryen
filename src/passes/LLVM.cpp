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

//
// Tested with LLVM 14.
//

#include <llvm/ADT/APInt.h>
//#include <llvm/CodeGen/CommandFlags.h>
#include <llvm/IR/Argument.h>
#include <llvm/IR/Constant.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/LegacyPassManager.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/PassManager.h>
#include <llvm/IR/Verifier.h>
#include <llvm/MC/TargetRegistry.h>
#include <llvm/Passes/PassBuilder.h>
#include <llvm/Support/CodeGen.h>
#include <llvm/Support/InitLLVM.h>
#include <llvm/Support/TargetSelect.h>
#include <llvm/Target/TargetOptions.h>
#include <llvm/Target/TargetMachine.h>

#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

struct LLVM : public wasm::Pass {
  void run(wasm::Module* module) override {
    using namespace llvm;

    LLVMInitializeWebAssemblyTargetInfo();
   
    // Do we need these?
    InitializeAllTargets();
    InitializeAllTargetMCs();
    InitializeAllAsmPrinters();
    InitializeAllAsmParsers();

    // Setup

    LLVMContext context;
    i32 = Type::getInt32Ty(context);
    i64 = Type::getInt64Ty(context);
    f32 = Type::getFloatTy(context);
    f64 = Type::getDoubleTy(context);

    Triple triple("wasm32-unknown-unknown");
    Module mod("byn_mod", context);
    mod.setTargetTriple(triple.getTriple());

    // Build IR in a module

    auto* funcType = FunctionType::get(
      wasmToLLVM(wasm::Type::i32),
      {
        wasmToLLVM(wasm::Type::i32),
        wasmToLLVM(wasm::Type::i32)
      },
      false
    );
    mod.getOrInsertFunction("byn_func", funcType);
    auto* func = mod.getFunction("byn_func");

    IRBuilder builder(context);

    BasicBlock* body = BasicBlock::Create(context, "entry", func);
    builder.SetInsertPoint(body);
    auto* arg = func->getArg(0);
    auto* num = Constant::getIntegerValue(i32, APInt(32, 21));
    auto* addA = builder.CreateAdd(arg, num, "add_a");
    auto* addB = builder.CreateAdd(addA, num, "add_b");
    builder.CreateRet(addB);

    if (verifyModule(mod, &errs())) {
      wasm::Fatal() << "broken LLVM module";
    }
    errs() << mod << '\n';

    // Optimize LLVM IR
    // TODO: see https://llvm.org/docs/NewPassManager.html#just-tell-me-how-to-run-the-default-optimization-pipeline-with-the-new-pass-manager

    LoopAnalysisManager LAM;
    FunctionAnalysisManager FAM;
    CGSCCAnalysisManager CGAM;
    ModuleAnalysisManager MAM;
    PassBuilder PB;

    PB.registerModuleAnalyses(MAM);
    PB.registerCGSCCAnalyses(CGAM);
    PB.registerFunctionAnalyses(FAM);
    PB.registerLoopAnalyses(LAM);
    PB.crossRegisterProxies(LAM, FAM, CGAM, MAM);

    FunctionPassManager MPM = PB.buildFunctionSimplificationPipeline(OptimizationLevel::Os, llvm::ThinOrFullLTOPhase::None); // TODO: opt levels
    MPM.run(*func, FAM);

    errs() << "Optimized:\n\n" << mod << '\n';

    // Emit wasm

    std::string error;
    auto target = TargetRegistry::lookupTarget(triple.getTriple(), error);
    if (!target) {
      wasm::Fatal() << "can't find wasm target";
    }

    std::cout << "before\n";

///    std::string CPUStr = codegen::getCPUStr(),
  //              FeaturesStr = codegen::getFeaturesStr();
   // std::cout << "cpustr " << CPUStr << " : " << FeaturesStr << '\n';

    TargetOptions options;
    auto targetMachine = std::unique_ptr<TargetMachine>(target->createTargetMachine(
        triple.getTriple(), "mvp", "", options, {}));

    legacy::PassManager writerPM;
    SmallVector<char, 128> buffer;
    raw_svector_ostream stream(buffer);
    targetMachine->addPassesToEmitFile(writerPM, stream, nullptr, CodeGenFileType::CGFT_ObjectFile);
  
    // Generate Binaryen IR
  }

  llvm::Type* i32;
  llvm::Type* i64;
  llvm::Type* f32;
  llvm::Type* f64;

  llvm::Type* wasmToLLVM(wasm::Type type) {
    if (type == wasm::Type::i32) {
      return i32;
    }
    if (type == wasm::Type::i64) {
      return i64;
    }
    if (type == wasm::Type::f32) {
      return f32;
    }
    if (type == wasm::Type::f64) {
      return f64;
    }
    WASM_UNREACHABLE("invalid type");
  }
};

namespace wasm {

Pass* createLLVMPass() { return new LLVM(); }

} // namespace wasm
