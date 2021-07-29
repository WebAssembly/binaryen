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
// RemoveNonJSOps removes operations that aren't inherently implementable
// in JS. This includes things like 64-bit division, `f32.nearest`,
// `f64.copysign`, etc. Most operations are lowered to a call to an injected
// intrinsic implementation. Intrinsics don't use themselves to implement
// themselves.
//
// You'll find a large wat blob in `wasm-intrinsics.wat` next to this file
// which contains all of the injected intrinsics. We manually copy over any
// needed intrinsics from this module into the module that we're optimizing
// after walking the current module.
//
// StubUnsupportedJSOps stubs out operations that are not fully supported
// even with RemoveNonJSOps. For example, i64->f32 conversions do not have
// perfect rounding in all cases. StubUnsupportedJSOps removes those entirely
// and replaces them with "stub" operations that do nothing. This is only
// really useful for fuzzing as it changes the behavior of the program.
//

#include <pass.h>
#include <wasm.h>

#include "abi/js.h"
#include "asmjs/shared-constants.h"
#include "ir/find_all.h"
#include "ir/literal-utils.h"
#include "ir/memory-utils.h"
#include "ir/module-utils.h"
#include "passes/intrinsics-module.h"
#include "support/insert_ordered.h"
#include "wasm-builder.h"
#include "wasm-s-parser.h"

namespace wasm {

struct RemoveNonJSOpsPass : public WalkerPass<PostWalker<RemoveNonJSOpsPass>> {
  std::unique_ptr<Builder> builder;
  std::unordered_set<Name> neededIntrinsics;
  InsertOrderedSet<std::pair<Name, Type>> neededImportedGlobals;

  bool isFunctionParallel() override { return false; }

  Pass* create() override { return new RemoveNonJSOpsPass; }

  void doWalkModule(Module* module) {
    // Intrinsics may use scratch memory, ensure it.
    ABI::wasm2js::ensureHelpers(module);

    // Discover all of the intrinsics that we need to inject, lowering all
    // operations to intrinsic calls while we're at it.
    if (!builder) {
      builder = make_unique<Builder>(*module);
    }
    PostWalker<RemoveNonJSOpsPass>::doWalkModule(module);

    if (neededIntrinsics.size() == 0) {
      return;
    }

    // Parse the wat blob we have at the end of this file.
    //
    // TODO: only do this once per invocation of wasm2asm
    Module intrinsicsModule;
    std::string input(IntrinsicsModuleWast);
    SExpressionParser parser(const_cast<char*>(input.c_str()));
    Element& root = *parser.root;
    SExpressionWasmBuilder builder(
      intrinsicsModule, *root[0], IRProfile::Normal);

    std::set<Name> neededFunctions;

    // Iteratively link intrinsics from `intrinsicsModule` into our destination
    // module, as needed.
    //
    // Note that intrinsics often use one another. For example the 64-bit
    // division intrinsic ends up using the 32-bit ctz intrinsic, but does so
    // via a native instruction. The loop here is used to continuously reprocess
    // injected intrinsics to ensure that they never contain non-js ops when
    // we're done.
    while (neededIntrinsics.size() > 0) {
      // Recursively probe all needed intrinsics for transitively used
      // functions. This is building up a set of functions we'll link into our
      // module.
      for (auto& name : neededIntrinsics) {
        addNeededFunctions(intrinsicsModule, name, neededFunctions);
      }
      neededIntrinsics.clear();

      // Link in everything that wasn't already linked in. After we've done the
      // copy we then walk the function to rewrite any non-js operations it has
      // as well.
      for (auto& name : neededFunctions) {
        auto* func = module->getFunctionOrNull(name);
        if (!func) {
          func = ModuleUtils::copyFunction(intrinsicsModule.getFunction(name),
                                           *module);
        }
        doWalkFunction(func);
      }
      neededFunctions.clear();
    }

    // Copy all the globals in the intrinsics module
    for (auto& global : intrinsicsModule.globals) {
      ModuleUtils::copyGlobal(global.get(), *module);
    }

    // Intrinsics may use memory, so ensure the module has one.
    MemoryUtils::ensureExists(module->memory);

    // Add missing globals
    for (auto& pair : neededImportedGlobals) {
      auto name = pair.first;
      auto type = pair.second;
      if (!getModule()->getGlobalOrNull(name)) {
        auto global = make_unique<Global>();
        global->name = name;
        global->type = type;
        global->mutable_ = false;
        global->module = ENV;
        global->base = name;
        module->addGlobal(global.release());
      }
    }
  }

  void addNeededFunctions(Module& m, Name name, std::set<Name>& needed) {
    if (needed.count(name)) {
      return;
    }
    needed.insert(name);

    auto function = m.getFunction(name);
    FindAll<Call> calls(function->body);
    for (auto* call : calls.list) {
      auto* called = m.getFunction(call->target);
      if (!called->imported()) {
        this->addNeededFunctions(m, call->target, needed);
      }
    }
  }

  void doWalkFunction(Function* func) {
    if (!builder) {
      builder = make_unique<Builder>(*getModule());
    }
    PostWalker<RemoveNonJSOpsPass>::doWalkFunction(func);
  }

  void visitBinary(Binary* curr) {
    Name name;
    switch (curr->op) {
      case RotLInt32:
        name = WASM_ROTL32;
        break;
      case RotRInt32:
        name = WASM_ROTR32;
        break;
      case RotLInt64:
        name = WASM_ROTL64;
        break;
      case RotRInt64:
        name = WASM_ROTR64;
        break;
      case MulInt64:
        name = WASM_I64_MUL;
        break;
      case DivSInt64:
        name = WASM_I64_SDIV;
        break;
      case DivUInt64:
        name = WASM_I64_UDIV;
        break;
      case RemSInt64:
        name = WASM_I64_SREM;
        break;
      case RemUInt64:
        name = WASM_I64_UREM;
        break;

      default:
        return;
    }
    neededIntrinsics.insert(name);
    replaceCurrent(
      builder->makeCall(name, {curr->left, curr->right}, curr->type));
  }

  void visitUnary(Unary* curr) {
    Name functionCall;
    switch (curr->op) {
      case NearestFloat32:
        functionCall = WASM_NEAREST_F32;
        break;
      case NearestFloat64:
        functionCall = WASM_NEAREST_F64;
        break;

      case PopcntInt64:
        functionCall = WASM_POPCNT64;
        break;
      case PopcntInt32:
        functionCall = WASM_POPCNT32;
        break;

      case CtzInt64:
        functionCall = WASM_CTZ64;
        break;
      case CtzInt32:
        functionCall = WASM_CTZ32;
        break;

      default:
        return;
    }
    neededIntrinsics.insert(functionCall);
    replaceCurrent(builder->makeCall(functionCall, {curr->value}, curr->type));
  }

  void visitGlobalGet(GlobalGet* curr) {
    neededImportedGlobals.insert(std::make_pair(curr->name, curr->type));
  }
};

struct StubUnsupportedJSOpsPass
  : public WalkerPass<PostWalker<StubUnsupportedJSOpsPass>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new StubUnsupportedJSOpsPass; }

  void visitUnary(Unary* curr) {
    switch (curr->op) {
      case ConvertUInt64ToFloat32:
        // See detailed comment in lowerConvertIntToFloat in
        // I64ToI32Lowering.cpp.
        stubOut(curr->value, curr->type);
        break;
      default: {
      }
    }
  }

  void visitCallIndirect(CallIndirect* curr) {
    // Indirect calls of the wrong type trap in wasm, but not in wasm2js. Remove
    // the indirect call, but leave the arguments.
    Builder builder(*getModule());
    std::vector<Expression*> items;
    for (auto* operand : curr->operands) {
      items.push_back(builder.makeDrop(operand));
    }
    items.push_back(builder.makeDrop(curr->target));
    stubOut(builder.makeBlock(items), curr->type);
  }

  void stubOut(Expression* value, Type outputType) {
    Builder builder(*getModule());
    // In some cases we can just replace with the value.
    auto* replacement = value;
    if (outputType == Type::unreachable) {
      // This is unreachable anyhow; just leave the value instead of the
      // original node.
      assert(value->type == Type::unreachable);
    } else if (outputType != Type::none) {
      // Drop the value if we need to.
      if (value->type != Type::none) {
        value = builder.makeDrop(value);
      }
      // Return something with the right output type.
      replacement = builder.makeSequence(
        value, LiteralUtils::makeZero(outputType, *getModule()));
    }
    replaceCurrent(replacement);
  }
};

Pass* createRemoveNonJSOpsPass() { return new RemoveNonJSOpsPass(); }

Pass* createStubUnsupportedJSOpsPass() {
  return new StubUnsupportedJSOpsPass();
}

} // namespace wasm
