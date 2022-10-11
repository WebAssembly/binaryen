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
// Use
#define BINARYEN_LLVM_DEBUG 1
// to add debugging and logging.

#include <llvm/ADT/APInt.h>
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
#include <llvm/Target/TargetMachine.h>

#include "ir/iteration.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm-binary.h"
#include "wasm.h"

using namespace llvm;

struct LLVMPass : public wasm::Pass {
  // Global state. Each LLVM pass instance creates a context and the other data
  // structures we will need. We also create a single module for the lifetime of
  // the pass. As we compile code, we modify the contents inside that module by
  // adding and removing functions.
  Triple triple;
  std::unique_ptr<llvm::LLVMContext> context;
  std::unique_ptr<llvm::Module> mod;
  std::unique_ptr<TargetMachine> targetMachine;

  llvm::Type* i32;
  llvm::Type* i64;
  llvm::Type* f32;
  llvm::Type* f64;

  // Initialization of LLVM.
  void initLLVM() {
    static bool done = false;
    if (done) {
      return;
    }

    // Perhaps we could call only LLVMInitializeWebAssemblyTargetInfo() etc?
    InitializeAllTargets();
    InitializeAllTargetMCs();
    InitializeAllAsmPrinters();
    InitializeAllAsmParsers();

    done = true;
  }

  // Initialize this Pass instance's global state.
  void initPassInstance() {
    triple = Triple("wasm32-unknown-unknown");

    context = std::make_unique<LLVMContext>();

    i32 = Type::getInt32Ty(*context);
    i64 = Type::getInt64Ty(*context);
    f32 = Type::getFloatTy(*context);
    f64 = Type::getDoubleTy(*context);

    mod = std::make_unique<Module>("byn_mod", *context);
    mod->setTargetTriple(triple.getTriple());

    std::string error;
    auto target = TargetRegistry::lookupTarget(triple.getTriple(), error);
    if (!target) {
      wasm::Fatal() << "can't find wasm target: " << error;
    }

    targetMachine = std::unique_ptr<TargetMachine>(target->createTargetMachine(
        triple.getTriple(), "mvp", "", {}, {}));
  }

  llvm::Function* makeLLVMFunction() {
    auto* funcType = FunctionType::get(
      *wasmToLLVM(wasm::Type::i32),
      {
        *wasmToLLVM(wasm::Type::i32),
        *wasmToLLVM(wasm::Type::i32)
      },
      false
    );
    mod->getOrInsertFunction("byn_func", funcType);
    auto* func = mod->getFunction("byn_func");

    IRBuilder builder(*context);

    BasicBlock* body = BasicBlock::Create(*context, "entry", func);
    builder.SetInsertPoint(body);
    auto* arg = func->getArg(0);
    auto* num = Constant::getIntegerValue(i32, APInt(32, 21));
    auto* addA = builder.CreateAdd(arg, num, "add_a");
    auto* addB = builder.CreateAdd(addA, num, "add_b");
    builder.CreateRet(addB);

#if BINARYEN_LLVM_DEBUG
    if (verifyModule(*mod, &errs())) {
      wasm::Fatal() << "broken LLVM module";
    }
    errs() << *mod << '\n';
#endif

    return func;
  }

  // Optimize an LLVM function using the LLVM optimizer.
  void optimize(Function* func) {
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

    auto MPM = PB.buildFunctionSimplificationPipeline(OptimizationLevel::Os, llvm::ThinOrFullLTOPhase::None); // TODO: opt levels
    MPM.run(*func, FAM);

#if BINARYEN_LLVM_DEBUG
    errs() << "Optimized:\n\n" << *mod << '\n';
#endif
  }

  // Translate the current LLVM module to Binaryen IR.
  std::unique_ptr<wasm::Module> llvmToBinaryen(FeatureSet features) {
    // Try to use a buffer big enough for a typical wasm output from LLVM (which
    // seems to be around 141 bytes atm).
    SmallVector<char, 256> buffer;
    raw_svector_ostream stream(buffer);

    legacy::PassManager writerPM;
    targetMachine->addPassesToEmitFile(writerPM, stream, nullptr, CodeGenFileType::CGFT_ObjectFile);

    writerPM.run(*mod);

#if BINARYEN_LLVM_DEBUG
    std::cerr << "wasm binary size after LLVM: " << buffer.size() << '\n';
#endif

    // XXX avoid copy?
    std::vector<char> data(buffer.begin(), buffer.end());

    // Generate Binaryen IR
    // TODO: this warns on reading an object file. For our uses here this is ok
    //       for now, but perhaps we should emit a proper wasm executable?
    auto newModule = std::make_unique<wasm::Module>();
    wasm::WasmBinaryBuilder reader(*newModule, features, data);
    try {
      reader.read();
    } catch (wasm::ParseException& p) {
      p.dump(std::cerr);
      std::cerr << '\n';
      wasm::Fatal() << "error in parsing wasm binary";
    }

#if BINARYEN_LLVM_DEBUG
    std::cout << *newModule << '\n';
#endif

    return newModule;
  }

  // Reset the state of our global LLVM module, removing current changes so that
  // it is ready for further work later. This removes any functions we added,
  // after which the module is empty.
  void resetLLVMModule() {
    auto& list = mod->getFunctionList();
    list.clear();
  }

  // Pass entry point. TODO: parallelize?

  void run(wasm::Module* module) override {
    initLLVM();
    initPassInstance();

    auto* func = makeLLVMFunction();

    optimize(func);

    auto newModule = llvmToBinaryen(module->features);

    resetLLVMModule();
  }

  // Internal helpers.

  // Walk the IR, looking for things to run through LLVM. We do not just try to
  // convert entire functions to LLVM IR since they may not fit (e.g. if they
  // have usage of GC types). Instead, find isolated code portions that can be
  // optimized. TODO: also investigate the reverse, converting entire functions
  // while keeping unconvertible portions on the side somehow.
  struct Optimizer : public wasm::PostWalker<Optimizer, wasm::UnifiedExpressionVisitor<Optimizer>> {
    LLVMPass& parent;

    Optimizer(LLVMPass& parent) : parent(parent) {}

    // Recursively traverse the children to build LLVM IR, and find the
    // variables (unknown things) which will become parameters. That is, if
    // we have something like this:
    //
    //  (x + 20) / foo()
    //
    // We can convert + and / to LLVM instructions, and the constant 20 as
    // well. The local x and the call foo() will become parameters:
    //
    //  func llvmfunc(a, b) { return (a + 20) / b }
    //
    // We then run the LLVM optimizer on that, and apply the results if they
    // are beneficial.
    struct RecursiveProcessor {
      enum Mode {
        // The first pass scans the code and sees if it is worth working on.
        Scan,
        // The second pass generates LLVM IR.
        Generate,
      } mode;

      LLVMPass& parent;

      RecursiveProcessor(Mode mode, LLVMPass& parent) : mode(mode), parent(parent) {}

      bool fail = false;

      // Each parameter is indexed by its location in |params|.
      SmallVector<wasm::Expression*, 4> params;
      std::unordered_map<wasm::Expression*, wasm::Index> paramMap;

      // When generating, a map of each wasm expression in the original IR to
      // the LLVM IR we are mapping it to.
      std::unordered_map<wasm::Expression*, Value*> wasmLLVMMap;

      void process(wasm::Expression* curr) {
        if (!parent.wasmToLLVM(curr->type)) {
          // We cannot handle this type at all. Give up.
          fail = true;
          return;
        }

        if (auto* c = curr->dynCast<wasm::Const>()) {
          if (mode == Generate) {
            // XXX
          }
        } else if (auto* binary = curr->dynCast<wasm::Binary>()) {
          switch (binary->op) {
            case wasm::AddInt32: {
              process(binary->left);
              process(binary->right);

              if (mode == Generate) {
                // XXX
              }
              break;
            }
            default: {
              // Fall through to the parameter code path below.
            }
          }
        }

        // Otherwise, this is not something we can convert to LLVM IR. But it
        // has a type we can handle (we ruled that problem out earlier), so turn
        // it into a parameter.
        if (mode == Generate) {
          paramMap[curr] = params.size();
          params.push_back(curr);
        }
      }
    };

    void visitExpression(wasm::Expression* curr) {
      RecursiveProcessor scan(RecursiveProcessor::Scan, parent);
      if (scan.fail) {
        return;
      }

      RecursiveProcessor generate(RecursiveProcessor::Generate, parent);

    }
  };

  // Returns the LLVM type for a wasm type, if there is one.
  std::optional<Type*> wasmToLLVM(wasm::Type type) {
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
    return {};
  }
};

namespace wasm {

Pass* createLLVMPass() { return new LLVMPass(); }

} // namespace wasm
