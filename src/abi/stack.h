/*
 * Copyright 2017 WebAssembly Community Group participants
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

#ifndef wasm_abi_stack_h
#define wasm_abi_stack_h

#include "abi.h"
#include "asmjs/shared-constants.h"
#include "ir/find_all.h"
#include "ir/global-utils.h"
#include "shared-constants.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace ABI {

enum { StackAlign = 16 };

inline Index stackAlign(Index size) {
  return (size + StackAlign - 1) & -StackAlign;
}

// Allocate some space on the stack, and assign it to a local.
// The local will have the same constant value in all the function, so you can
// just local.get it anywhere there.
//
// FIXME: This function assumes that the stack grows upward, per the convention
// used by fastcomp.  The stack grows downward when using the WASM backend.

inline void
getStackSpace(Index local, Function* func, Index size, Module& wasm) {
  // Attempt to locate the stack pointer by recognizing code idioms
  // used by Emscripten.  First, look for a global initialized to an
  // imported variable named "STACKTOP" in environment "env".
  auto* stackPointer =
    GlobalUtils::getGlobalInitializedToImport(wasm, ENV, "STACKTOP");
  // Starting with Emscripten 1.38.24, the stack pointer variable is
  // initialized with a literal constant, eliminating the import that
  // we used to locate the stack pointer by name.  We must match a more
  // complicated idiom, expecting to see the module structured as follows:
  //
  //(module
  //  ...
  //  (export "stackSave" (func $stackSave))
  //  ...
  //  (func $stackSave (; 410 ;) (; has Stack IR ;) (result i32)
  //    (global.get $STACKTOP)
  //  )
  //  ...
  //)
  if (!stackPointer) {
    auto* stackSaveFunctionExport = wasm.getExportOrNull("stackSave");
    if (stackSaveFunctionExport &&
        stackSaveFunctionExport->kind == ExternalKind::Function) {
      auto* stackSaveFunction =
        wasm.getFunction(stackSaveFunctionExport->value);
      assert(!stackSaveFunction->imported());
      auto* globalGet = stackSaveFunction->body->dynCast<GlobalGet>();
      if (globalGet) {
        stackPointer = wasm.getGlobal(globalGet->name);
      }
    }
  }
  if (!stackPointer) {
    Fatal() << "getStackSpace: failed to find the stack pointer";
  }
  // align the size
  size = stackAlign(size);
  // TODO: find existing stack usage, and add on top of that - carefully
  Builder builder(wasm);
  auto* block = builder.makeBlock();
  block->list.push_back(builder.makeLocalSet(
    local, builder.makeGlobalGet(stackPointer->name, PointerType)));
  // TODO: add stack max check
  Expression* added;
  if (PointerType == i32) {
    added = builder.makeBinary(AddInt32,
                               builder.makeLocalGet(local, PointerType),
                               builder.makeConst(Literal(int32_t(size))));
  } else {
    WASM_UNREACHABLE("unhandled PointerType");
  }
  block->list.push_back(builder.makeGlobalSet(stackPointer->name, added));
  auto makeStackRestore = [&]() {
    return builder.makeGlobalSet(stackPointer->name,
                                 builder.makeLocalGet(local, PointerType));
  };
  // add stack restores to the returns
  FindAllPointers<Return> finder(func->body);
  for (auto** ptr : finder.list) {
    auto* ret = (*ptr)->cast<Return>();
    if (ret->value && ret->value->type != unreachable) {
      // handle the returned value
      auto* block = builder.makeBlock();
      auto temp = builder.addVar(func, ret->value->type);
      block->list.push_back(builder.makeLocalSet(temp, ret->value));
      block->list.push_back(makeStackRestore());
      block->list.push_back(
        builder.makeReturn(builder.makeLocalGet(temp, ret->value->type)));
      block->finalize();
      *ptr = block;
    } else {
      // restore, then return
      *ptr = builder.makeSequence(makeStackRestore(), ret);
    }
  }
  // add stack restores to the body
  if (func->body->type == none) {
    block->list.push_back(func->body);
    block->list.push_back(makeStackRestore());
  } else if (func->body->type == unreachable) {
    block->list.push_back(func->body);
    // no need to restore the old stack value, we're gone anyhow
  } else {
    // save the return value
    auto temp = builder.addVar(func, func->sig.results);
    block->list.push_back(builder.makeLocalSet(temp, func->body));
    block->list.push_back(makeStackRestore());
    block->list.push_back(builder.makeLocalGet(temp, func->sig.results));
  }
  block->finalize();
  func->body = block;
}

} // namespace ABI

} // namespace wasm

#endif // wasm_abi_stack_h
