/*
 * Copyright 2024 WebAssembly Community Group participants
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
// Run LLVM to optimize the wasm.
//

#include "pass.h"
#include "support/utilities.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "wasm.h"

#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/GlobalAlias.h"
#include "llvm/IR/GlobalValue.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Value.h"

#include <cassert>
#include <iostream>
#include <llvm-18/llvm/IR/BasicBlock.h>
#include <llvm-18/llvm/IR/Constants.h>
#include <llvm-18/llvm/IR/GlobalVariable.h>
#include <llvm-18/llvm/IR/Instructions.h>
#include <llvm-18/llvm/Support/Alignment.h>
#include <llvm-18/llvm/Support/Casting.h>
#include <memory>
#include <string>

using namespace llvm;

namespace wasm {

llvm::Type* convertWasmTypeToLLVMType(Type* wasmType,
                                      llvm::IRBuilder<>& builder);
llvm::Type* determineLoadType(Load* wasmLoad, llvm::IRBuilder<>& builder);

struct LLVMCodeGen : Visitor<LLVMCodeGen, Value*> {

  std::unique_ptr<LLVMContext> llvmCtx;
  std::unique_ptr<llvm::Module> llvmMod;
  std::unique_ptr<IRBuilder<>> llvmBuilder;

  std::unique_ptr<Builder> wasmBuilder;
  Module* module;
  Function* func;

  int funCounter;

  LLVMCodeGen() {
    llvmCtx = std::make_unique<LLVMContext>();
    llvmMod = std::make_unique<llvm::Module>("LLVMOpt", *llvmCtx);
    llvmBuilder = std::make_unique<IRBuilder<>>(*llvmCtx);

    llvmMod->setTargetTriple("wasm32-unknown-unknown");

    funCounter = 0;
  }

  Value* visitModule(Module* module_) {
    module = module_;
    for (auto& mem : module->memories) {
      // Handle memory
      visitMemory(mem.get());
    }
    for (auto& func : module->functions) {
      visitFunction(func.get());
      // if (auto llvmFn = dyn_cast<llvm::Function>(visitFunction(func.get())))
      // {
      //   auto* entryBB = llvm::BasicBlock::Create(*llvmCtx, "entry", llvmFn);
      //   llvmBuilder->SetInsertPoint(entryBB);
      // }
    }
    std::cout << "Module generated successfully!" << std::endl;
    llvmMod->dump();
    return nullptr;
  }

  Value* visitMemory(Memory* mem) {
    // Given: Memory* mem = ...;
    auto pageSize = Memory::kPageSize; // 64KB
    uint64_t totalSize = mem->initial * pageSize;

    // Create global memory buffer
    ArrayType* memType = ArrayType::get(llvmBuilder->getInt8Ty(), totalSize);
    GlobalVariable* llvmMem = new GlobalVariable(
      *llvmMod,
      memType,                                 // Type (e.g., [65536 x i8])
      false,                                   // isConstant = false (mutable)
      GlobalValue::AvailableExternallyLinkage, // TODO: Check this
      ConstantAggregateZero::get(memType),
      "wasm_memory");

    // For shared memory (if needed)
    if (mem->shared) {
      llvmMem->setUnnamedAddr(GlobalValue::UnnamedAddr::Global);
    }
    return nullptr;
  }
  Value* visitFunction(Function* func) {
    std::cout << "[visitFunction]" << std::endl;

    // Create function type
    std::vector<llvm::Type*> llvmParamsTypes;
    std::vector<llvm::Type*> llvmResultTypes;
    for (auto param : func->getParams()) {
      llvmParamsTypes.push_back(
        convertWasmTypeToLLVMType(&param, *llvmBuilder));
    }
    for (auto result : func->getResults()) {
      llvmResultTypes.push_back(
        convertWasmTypeToLLVMType(&result, *llvmBuilder));
    }
    // Currently not support multiple value results.
    assert(llvmResultTypes.size() == 1);
    llvm::FunctionType* funcType =
      llvm::FunctionType::get(llvmResultTypes[0], llvmParamsTypes, false);

    llvm::Function* llvmFn = llvm::Function::Create(
      funcType,
      GlobalValue::ExternalLinkage, // TODO: be used outside, to prevents LLVM
                                    // from assuming the function is unused
      "func" + std::to_string(funCounter++),
      llvmMod.get());

    // Create a new basic block to start insertion into.
    BasicBlock* BB = BasicBlock::Create(*llvmCtx, "entry", llvmFn);
    llvmBuilder->SetInsertPoint(BB);

    if (Value* ret = visit(func->body)) {
      // Finish off the function.
      llvmBuilder->CreateRet(ret);
      return llvmFn;
    }

    // Error reading body, remove function
    llvmFn->eraseFromParent();
    assert(0 && "Now we just trap");
    return nullptr;
  }

  // Visiting.
  Value* visitBlock(Block* block) {
    Value* ret = nullptr;
    for (auto expr : block->list) {
      ret = visit(expr);
    }
    return ret;
  }

  Value* visitConst(Const* c) {
    assert(c->type.isBasic());
    switch (c->type.getBasic()) {
      case wasm::Type::i32:
        return ConstantInt::get(llvmBuilder->getInt32Ty(), c->value.geti32());
      case wasm::Type::f32:
        return ConstantInt::get(llvmBuilder->getFloatTy(), c->value.getf32());
      case wasm::Type::i64:
        return ConstantInt::get(llvmBuilder->getInt64Ty(), c->value.geti64());
      case wasm::Type::f64:
        return ConstantInt::get(llvmBuilder->getDoubleTy(), c->value.getf64());
      case wasm::Type::v128:
      case wasm::Type::none:
      case wasm::Type::unreachable:
        break;
      default:
        WASM_UNREACHABLE("Unknown type");
    }
    return nullptr;
  }

  Value* visitStore(Store* store) {
    // 1. Get the @wasm_memory global variable.
    GlobalVariable* wasmMemory =
      llvmMod->getGlobalVariable("wasm_memory", true);
    assert(wasmMemory && "wasm_memory global not found");

    // 2. Cast the global to i8* (pointer to first byte of memory)
    Value* basePtr = llvmBuilder->CreatePointerCast(
      wasmMemory, llvmBuilder->getInt8Ty()->getPointerTo(), "mem_base");

    // 3. Evaluate the pointer (offset from memory base)
    auto* totalOffset = llvmBuilder->CreateAdd(
      visit(store->ptr),
      ConstantInt::get(llvmBuilder->getInt32Ty(), store->offset.addr),
      "mem_offset");

    // 4. Compute the final address: basePtr + totalOffSet
    Value* addr = llvmBuilder->CreateGEP(
      llvmBuilder->getInt8Ty(), basePtr, totalOffset, "mem_ptr");

    // 5. Determine the type of the value to store
    llvm::Type* storedType =
      convertWasmTypeToLLVMType(&store->valueType, *llvmBuilder);
    Value* typedPtr =
      llvmBuilder->CreateBitCast(addr, storedType->getPointerTo(), "typed_ptr");

    // 6. Create the store instruction
    StoreInst* storeInst =
      llvmBuilder->CreateStore(visit(store->value), typedPtr);
    storeInst->setAlignment(llvm::Align(store->align.addr));

    // Handle alignment (WebAssembly uses pow2 alignment)
    return storeInst;
  }

  Value* visitLoad(Load* load) {
    // As above visitStore
    GlobalVariable* wasmMemory = llvmMod->getGlobalVariable("wasm_memory");
    assert(wasmMemory && "wasm_memory global not found");
    Value* basePtr = llvmBuilder->CreatePointerCast(
      wasmMemory, llvmBuilder->getPtrTy(), "mem_base");
    Value* totalOffset = llvmBuilder->CreateAdd(
      visit(load->ptr),
      ConstantInt::get(llvmBuilder->getInt32Ty(), load->offset.addr),
      "mem_offset");
    Value* finalAddr = llvmBuilder->CreateGEP(
      llvmBuilder->getInt8Ty(), basePtr, totalOffset, "mem_ptr");
    llvm::Type* loadedType = determineLoadType(load, *llvmBuilder);
    Value* typedPtr = llvmBuilder->CreateBitCast(
      finalAddr, loadedType->getPointerTo(), "typed_ptr");

    // Handle alignment (WebAssembly uses pow2 alignment)
    unsigned alignment = load->align != 0 ? (1 << load->align) : load->bytes;
    LoadInst* loadInst =
      llvmBuilder->CreateLoad(loadedType, typedPtr, load->memory.toString());

    loadInst->setAlignment(llvm::Align(alignment));
    loadInst->setVolatile(load->isAtomic); // Atomic implies volatile in LLVM
    return loadInst;
  }
};

struct LLVMOpt : public Pass {
  std::unique_ptr<Pass> create() override {
    return std::make_unique<LLVMOpt>();
  }

  void run(Module* module) override { LLVMCodeGen().visitModule(module); }
};

Pass* createLLVMOptPass() { return new LLVMOpt(); }

llvm::Type* convertWasmTypeToLLVMType(Type* wasmType,
                                      llvm::IRBuilder<>& llvmBuilder) {
  switch (wasmType->getBasic()) {
    case Type::i32:
      return llvmBuilder.getInt32Ty();
    case Type::i64:
      return llvmBuilder.getInt64Ty();
    case Type::f32:
      return llvmBuilder.getFloatTy();
    case Type::f64:
      return llvmBuilder.getDoubleTy();
    case Type::v128: /* handle vector type */
      break;
    default:
      // Handle other cases or throw error
      WASM_UNREACHABLE("Unsupported WASM type");
  }
  return nullptr;
}

llvm::Type* determineLoadType(Load* wasmLoad, llvm::IRBuilder<>& llvmBuilder) {
  // First check the explicit type if available
  if (wasmLoad->type != Type::none) {
    switch (wasmLoad->type.getBasic()) {
      case Type::i32:
        return llvmBuilder.getInt32Ty();
      case Type::i64:
        return llvmBuilder.getInt64Ty();
      case Type::f32:
        return llvmBuilder.getFloatTy();
      case Type::f64:
        return llvmBuilder.getDoubleTy();
      case Type::v128: /* SIMD */
        return llvm::FixedVectorType::get(llvmBuilder.getInt32Ty(), 4);
      default:
        break;
    }
  }

  // Fall back to byte size and signedness
  switch (wasmLoad->bytes) {
    case 1:
      return wasmLoad->signed_ ? llvmBuilder.getInt8Ty()
                               : llvmBuilder.getInt8Ty();
    case 2:
      return wasmLoad->signed_ ? llvmBuilder.getInt16Ty()
                               : llvmBuilder.getInt16Ty();
    case 4:
      return wasmLoad->signed_ ? llvmBuilder.getInt32Ty()
                               : llvmBuilder.getInt32Ty();
    case 8:
      return llvmBuilder.getInt64Ty();
    default:
      assert(false && "Invalid load byte size");
      return llvmBuilder.getInt32Ty(); // fallback
  }
}

} // namespace wasm
