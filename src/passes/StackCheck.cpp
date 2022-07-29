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

struct EnforceStackLimits : public WalkerPass<PostWalker<EnforceStackLimits>> {
  EnforceStackLimits(const Global* stackPointer,
                     const Global* stackBase,
                     const Global* stackLimit,
                     Builder& builder,
                     Name handler)
    : stackPointer(stackPointer), stackBase(stackBase), stackLimit(stackLimit),
      builder(builder), handler(handler) {}

  bool isFunctionParallel() override { return true; }

  Pass* create() override {
    return new EnforceStackLimits(
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
  void run(PassRunner* runner, Module* module) override {
    Global* stackPointer = getStackPointerGlobal(*module);
    if (!stackPointer) {
      BYN_DEBUG(std::cerr << "no stack pointer found\n");
      return;
    }

    // __stack_base and __stack_end are created by the toolchain (emscripten)
    // If we don't find these globals, skip this pass.
    auto stackBase = module->getGlobalOrNull("__stack_base");
    if (!stackBase) {
      BYN_DEBUG(std::cerr << "no stack base found\n");
      return;
    }

    auto stackEnd = module->getGlobalOrNull("__stack_end");
    if (!stackEnd) {
      BYN_DEBUG(std::cerr << "no stack end found\n");
      return;
    }

    Name handler;
    auto handlerName =
      runner->options.getArgumentOrDefault("stack-check-handler", "");
    if (handlerName != "") {
      handler = handlerName;
      importStackOverflowHandler(
        *module, handler, Signature({stackPointer->type}, Type::none));
    }

    Builder builder(*module);

    // Instrument all the code.
    PassRunner innerRunner(module);
    EnforceStackLimits(stackPointer, stackBase, stackEnd, builder, handler)
      .run(&innerRunner, module);
  }
};

Pass* createStackCheckPass() { return new StackCheck; }

} // namespace wasm
