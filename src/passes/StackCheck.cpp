/*
 * Copyright 2020 WebAssembly Community Group participants
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
// Enforce stack pointer limits.  This pass will add checks around all
// assignments to the __stack_pointer global that LLVM uses for its
// shadow stack.
//

#include "abi/js.h"
#include "ir/abstract.h"
#include "ir/import-utils.h"
#include "ir/names.h"
#include "pass.h"
#include "shared-constants.h"
#include "support/debug.h"
#include "wasm-emscripten.h"

#define DEBUG_TYPE "stack-check"

namespace wasm {

// Exported function to set the base and the limit.
static Name SET_STACK_LIMITS("__set_stack_limits");

static void
importStackOverflowHandler(Module& module, Name name, Signature sig) {
  ImportInfo info(module);

  if (!info.getImportedFunction(ENV, name)) {
    auto import = Builder::makeFunction(name, sig, {});
    import->module = ENV;
    import->base = name;
    module.addFunction(std::move(import));
  }
}

static void addExportedFunction(Module& module,
                                std::unique_ptr<Function> function) {
  auto export_ =
    Builder::makeExport(function->name, function->name, ExternalKind::Function);
  module.addFunction(std::move(function));
  module.addExport(std::move(export_));
}

struct EnforceStackLimits : public WalkerPass<PostWalker<EnforceStackLimits>> {
  EnforceStackLimits(const Global* stackPointer,
                     const Global* stackBase,
                     const Global* stackLimit,
                     Builder& builder,
                     Name handler)
    : stackPointer(stackPointer), stackBase(stackBase), stackLimit(stackLimit),
      builder(builder), handler(handler) {}

  bool isFunctionParallel() override { return true; }

  // Only affects linear memory operations.
  bool requiresNonNullableLocalFixups() override { return false; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<EnforceStackLimits>(
      stackPointer, stackBase, stackLimit, builder, handler);
  }

  Expression* stackBoundsCheck(Function* func, Expression* value) {
    // Add a local to store the value of the expression. We need the value
    // twice: once to check if it has overflowed, and again to assign to store
    // it.
    auto newSP = Builder::addVar(func, stackPointer->type);
    // If we imported a handler, call it. That can show a nice error in JS.
    // Otherwise, just trap.
    Expression* handlerExpr;
    if (handler.is()) {
      handlerExpr =
        builder.makeCall(handler,
                         {builder.makeLocalGet(newSP, stackPointer->type)},
                         stackPointer->type);
    } else {
      handlerExpr = builder.makeUnreachable();
    }

    // If it is >= the base or <= the limit, then error.
    auto check = builder.makeIf(
      builder.makeBinary(
        BinaryOp::OrInt32,
        builder.makeBinary(
          Abstract::getBinary(stackPointer->type, Abstract::GtU),
          builder.makeLocalTee(newSP, value, stackPointer->type),
          builder.makeGlobalGet(stackBase->name, stackBase->type)),
        builder.makeBinary(
          Abstract::getBinary(stackPointer->type, Abstract::LtU),
          builder.makeLocalGet(newSP, stackPointer->type),
          builder.makeGlobalGet(stackLimit->name, stackLimit->type))),
      handlerExpr);
    // (global.set $__stack_pointer (local.get $newSP))
    auto newSet = builder.makeGlobalSet(
      stackPointer->name, builder.makeLocalGet(newSP, stackPointer->type));
    return builder.blockify(check, newSet);
  }

  void visitGlobalSet(GlobalSet* curr) {
    if (getModule()->getGlobalOrNull(curr->name) == stackPointer) {
      replaceCurrent(stackBoundsCheck(getFunction(), curr->value));
    }
  }

private:
  const Global* stackPointer;
  const Global* stackBase;
  const Global* stackLimit;
  Builder& builder;
  Name handler;
};

struct StackCheck : public Pass {
  // Adds calls to new imports.
  bool addsEffects() override { return true; }

  void run(Module* module) override {
    Global* stackPointer = getStackPointerGlobal(*module);
    if (!stackPointer) {
      BYN_DEBUG(std::cerr << "no stack pointer found\n");
      return;
    }

    // Pick appropriate names.
    auto stackBaseName = Names::getValidGlobalName(*module, "__stack_base");
    auto stackLimitName = Names::getValidGlobalName(*module, "__stack_limit");

    Name handler;
    auto handlerName = getArgumentOrDefault("stack-check-handler", "");
    if (handlerName != "") {
      handler = handlerName;
      importStackOverflowHandler(
        *module, handler, Signature({stackPointer->type}, Type::none));
    }

    Builder builder(*module);

    // Add the globals.
    Type indexType =
      module->memories.empty() ? Type::i32 : module->memories[0]->indexType;
    auto stackBase =
      module->addGlobal(builder.makeGlobal(stackBaseName,
                                           stackPointer->type,
                                           builder.makeConstPtr(0, indexType),
                                           Builder::Mutable));
    auto stackLimit =
      module->addGlobal(builder.makeGlobal(stackLimitName,
                                           stackPointer->type,
                                           builder.makeConstPtr(0, indexType),
                                           Builder::Mutable));

    // Instrument all the code.
    EnforceStackLimits(stackPointer, stackBase, stackLimit, builder, handler)
      .run(getPassRunner(), module);

    // Generate the exported function.
    auto limitsFunc = builder.makeFunction(
      SET_STACK_LIMITS,
      Signature({stackPointer->type, stackPointer->type}, Type::none),
      {});
    auto* getBase = builder.makeLocalGet(0, stackPointer->type);
    auto* storeBase = builder.makeGlobalSet(stackBaseName, getBase);
    auto* getLimit = builder.makeLocalGet(1, stackPointer->type);
    auto* storeLimit = builder.makeGlobalSet(stackLimitName, getLimit);
    limitsFunc->body = builder.makeBlock({storeBase, storeLimit});
    addExportedFunction(*module, std::move(limitsFunc));
  }
};

Pass* createStackCheckPass() { return new StackCheck; }

} // namespace wasm
