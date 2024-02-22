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

#include "asmjs/shared-constants.h"
#include "ir/find_all.h"
#include "ir/global-utils.h"
#include "shared-constants.h"
#include "wasm-builder.h"
#include "wasm-emscripten.h"
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

inline void
getStackSpace(Index local, Function* func, Index size, Module& wasm) {
  auto* stackPointer = getStackPointerGlobal(wasm);
  if (!stackPointer) {
    Fatal() << "getStackSpace: failed to find the stack pointer";
  }
  // align the size
  size = stackAlign(size);
  auto pointerType =
    !wasm.memories.empty() ? wasm.memories[0]->indexType : Type::i32;
  // TODO: find existing stack usage, and add on top of that - carefully
  Builder builder(wasm);
  auto* block = builder.makeBlock();
  // TODO: add stack max check
  Expression* added;
  if (pointerType == Type::i32) {
    // The stack goes downward in the LLVM wasm backend.
    added =
      builder.makeBinary(SubInt32,
                         builder.makeGlobalGet(stackPointer->name, pointerType),
                         builder.makeConst(int32_t(size)));
  } else {
    WASM_UNREACHABLE("unhandled pointerType");
  }
  block->list.push_back(builder.makeGlobalSet(
    stackPointer->name, builder.makeLocalTee(local, added, pointerType)));
  auto makeStackRestore = [&]() {
    return builder.makeGlobalSet(
      stackPointer->name,
      builder.makeBinary(AddInt32,
                         builder.makeLocalGet(local, pointerType),
                         builder.makeConst(int32_t(size))));
  };
  // add stack restores to the returns
  FindAllPointers<Return> finder(func->body);
  for (auto** ptr : finder.list) {
    auto* ret = (*ptr)->cast<Return>();
    if (ret->value && ret->value->type != Type::unreachable) {
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
  if (func->body->type == Type::none) {
    block->list.push_back(func->body);
    block->list.push_back(makeStackRestore());
  } else if (func->body->type == Type::unreachable) {
    block->list.push_back(func->body);
    // no need to restore the old stack value, we're gone anyhow
  } else {
    // save the return value
    auto temp = builder.addVar(func, func->getResults());
    block->list.push_back(builder.makeLocalSet(temp, func->body));
    block->list.push_back(makeStackRestore());
    block->list.push_back(builder.makeLocalGet(temp, func->getResults()));
  }
  block->finalize();
  func->body = block;
}

} // namespace ABI

} // namespace wasm

#endif // wasm_abi_stack_h
