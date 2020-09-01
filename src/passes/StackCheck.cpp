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
#include "ir/import-utils.h"
#include "pass.h"
#include "shared-constants.h"
#include "support/debug.h"
#include "wasm-emscripten.h"

#define DEBUG_TYPE "stack-check"

namespace wasm {

// The base is where the stack begins. As it goes down, that is the highest
// valid address.
static Name STACK_BASE("__stack_base");
// The limit is the farthest it can grow to, which is the lowest valid address.
static Name STACK_LIMIT("__stack_limit");
// Old version, which sets the limit.
// TODO: remove this
static Name SET_STACK_LIMIT("__set_stack_limit");
// New version, which sets the base and the limit.
static Name SET_STACK_LIMITS("__set_stack_limits");

static void importStackOverflowHandler(Module& module, Name name) {
  ImportInfo info(module);

  if (!info.getImportedFunction(ENV, name)) {
    auto* import = new Function;
    import->name = name;
    import->module = ENV;
    import->base = name;
    import->sig = Signature(Type::none, Type::none);
    module.addFunction(import);
  }
}

static void addExportedFunction(Module& module, Function* function) {
  module.addFunction(function);
  auto export_ = new Export;
  export_->name = export_->value = function->name;
  export_->kind = ExternalKind::Function;
  module.addExport(export_);
}

static void generateSetStackLimitFunctions(Module& module) {
  Builder builder(module);
  // One-parameter version
  Function* limitFunc =
    builder.makeFunction(SET_STACK_LIMIT, Signature(Type::i32, Type::none), {});
  LocalGet* getArg = builder.makeLocalGet(0, Type::i32);
  Expression* store = builder.makeGlobalSet(STACK_LIMIT, getArg);
  limitFunc->body = store;
  addExportedFunction(module, limitFunc);
  // Two-parameter version
  Function* limitsFunc = builder.makeFunction(
    SET_STACK_LIMITS, Signature({Type::i32, Type::i32}, Type::none), {});
  LocalGet* getBase = builder.makeLocalGet(0, Type::i32);
  Expression* storeBase = builder.makeGlobalSet(STACK_BASE, getBase);
  LocalGet* getLimit = builder.makeLocalGet(1, Type::i32);
  Expression* storeLimit = builder.makeGlobalSet(STACK_LIMIT, getLimit);
  limitsFunc->body = builder.makeBlock({storeBase, storeLimit});
  addExportedFunction(module, limitsFunc);
}

struct EnforceStackLimits : public WalkerPass<PostWalker<EnforceStackLimits>> {
  EnforceStackLimits(Global* stackPointer,
                     Global* stackBase,
                     Global* stackLimit,
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
      handlerExpr = builder.makeCall(handler, {}, Type::none);
    } else {
      handlerExpr = builder.makeUnreachable();
    }
    // If it is >= the base or <= the limit, then error.
    auto check = builder.makeIf(
      builder.makeBinary(
        BinaryOp::OrInt32,
        builder.makeBinary(
          BinaryOp::GtUInt32,
          builder.makeLocalTee(newSP, value, stackPointer->type),
          builder.makeGlobalGet(stackBase->name, stackBase->type)
        ),
        builder.makeBinary(
          BinaryOp::LtUInt32,
          builder.makeLocalGet(newSP, stackPointer->type),
          builder.makeGlobalGet(stackLimit->name, stackLimit->type)
        )
      ),
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
  Global* stackPointer;
  Global* stackBase;
  Global* stackLimit;
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

    Name handler;
    auto handlerName =
      runner->options.getArgumentOrDefault("stack-check-handler", "");
    if (handlerName != "") {
      handler = handlerName;
      importStackOverflowHandler(*module, handler);
    }

    Builder builder(*module);
    Global* stackBase = builder.makeGlobal(STACK_BASE,
                                           stackPointer->type,
                                           builder.makeConst(int32_t(0)),
                                           Builder::Mutable);
    module->addGlobal(stackBase);

    Global* stackLimit = builder.makeGlobal(STACK_LIMIT,
                                            stackPointer->type,
                                            builder.makeConst(int32_t(0)),
                                            Builder::Mutable);
    module->addGlobal(stackLimit);

    PassRunner innerRunner(module);
    EnforceStackLimits(stackPointer, stackBase, stackLimit, builder, handler)
      .run(&innerRunner, module);
    generateSetStackLimitFunctions(*module);
  }
};

Pass* createStackCheckPass() { return new StackCheck; }

} // namespace wasm
