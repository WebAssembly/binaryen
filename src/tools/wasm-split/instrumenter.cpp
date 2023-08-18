/*
 * Copyright 2021 WebAssembly Community Group participants
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

#include "instrumenter.h"
#include "ir/module-utils.h"
#include "ir/names.h"
#include "support/name.h"
#include "wasm-builder.h"
#include "wasm-type.h"

namespace wasm {

Instrumenter::Instrumenter(const WasmSplitOptions& options, uint64_t moduleHash)
  : options(options), moduleHash(moduleHash) {}

void Instrumenter::run(Module* wasm) {
  this->wasm = wasm;

  size_t numFuncs = 0;
  ModuleUtils::iterDefinedFunctions(*wasm, [&](Function*) { ++numFuncs; });
  // Calculate the size of the profile:
  //   8 bytes module hash +
  //   4 bytes for the integer for each function
  const size_t profileSize = 8 + 4 * numFuncs;

  ensureFirstMemory(profileSize);
  addSecondaryMemory(numFuncs);
  instrumentFuncs();
  addProfileExport(profileSize, numFuncs);
}

void Instrumenter::ensureFirstMemory(size_t profileSize) {
  // Make sure there is a memory with enough pages to write into
  size_t pages = (profileSize + Memory::kPageSize - 1) / Memory::kPageSize;
  if (wasm->memories.empty()) {
    wasm->addMemory(Builder::makeMemory("0"));
    wasm->memories[0]->initial = pages;
    wasm->memories[0]->max = pages;
  } else if (wasm->memories[0]->initial < pages) {
    wasm->memories[0]->initial = pages;
    if (wasm->memories[0]->max < pages) {
      wasm->memories[0]->max = pages;
    }
  }

  if (wasm->features.hasAtomics()) {
    wasm->memories[0]->shared = true;
  }
}

void Instrumenter::addSecondaryMemory(size_t numFuncs) {
  Type pointerType = wasm->memories[0]->indexType;
  bool isShared = wasm->memories[0]->shared;

  secondaryMemory = Names::getValidMemoryName(*wasm, "profile-data");
  // Create a memory with enough pages to write into
  size_t pages = (numFuncs + Memory::kPageSize - 1) / Memory::kPageSize;
  auto mem =
    Builder::makeMemory(secondaryMemory, pages, pages, isShared, pointerType);
  wasm->addMemory(std::move(mem));
}

void Instrumenter::instrumentFuncs() {
  // Inject code at the beginning of each function that will set a 1 in memory
  // at the offset equal to the index of the defined function
  Builder builder(*wasm);
  Index funcIdx = 0;
  assert(!wasm->memories.empty());
  ModuleUtils::iterDefinedFunctions(*wasm, [&](Function* func) {
    Expression* store;
    if (wasm->features.hasAtomics()) {
      // (i32.atomic.store8 offset=funcidx (i32.const 0) (i32.const 1))
      store = builder.makeAtomicStore(1,
                                      funcIdx,
                                      builder.makeConstPtr(0, Type::i32),
                                      builder.makeConst(uint32_t(1)),
                                      Type::i32,
                                      secondaryMemory);
    } else {
      // (i32.store8 offset=funcidx (i32.const 0) (i32.const 1))
      store = builder.makeStore(1,
                                funcIdx,
                                1,
                                builder.makeConstPtr(0, Type::i32),
                                builder.makeConst(uint32_t(1)),
                                Type::i32,
                                secondaryMemory);
    }
    func->body = builder.makeSequence(store, func->body, func->body->type);
    ++funcIdx;
  });
}

// wasm-split profile format:
//
// The wasm-split profile is a binary format designed to be simple to produce
// and consume. It is comprised of:
//
//   1. An 8-byte module hash
//
//   2. A 4-byte integer for each defined function
//
// The module hash is meant to guard against bugs where the module that was
// instrumented and the module that is being split are different. The integer is
// 1 for functions that were called during the instrumented run and 0 otherwise.

void Instrumenter::addProfileExport(size_t profileSize, size_t numFuncs) {
  // Create and export a function to dump the profile into a given memory
  // buffer. The function takes the available address and buffer size as
  // arguments and returns the total size of the profile. It only actually
  // writes the profile if the given space is sufficient to hold it.
  auto name = Names::getValidFunctionName(*wasm, options.profileExport);
  auto writeProfile = Builder::makeFunction(
    name, Signature({Type::i32, Type::i32}, Type::i32), {});
  writeProfile->hasExplicitName = true;
  writeProfile->setLocalName(0, "addr");
  writeProfile->setLocalName(1, "size");

  // Create the function body
  Builder builder(*wasm);
  auto getAddr = [&]() { return builder.makeLocalGet(0, Type::i32); };
  auto getSize = [&]() { return builder.makeLocalGet(1, Type::i32); };
  auto hashConst = [&]() { return builder.makeConst(int64_t(moduleHash)); };
  auto profileSizeConst = [&]() {
    return builder.makeConst(int32_t(profileSize));
  };

  // Write the hash followed by an integer for each defined function
  Expression* writeData = builder.makeStore(
    8, 0, 1, getAddr(), hashConst(), Type::i64, wasm->memories[0]->name);
  uint32_t offset = 8;

  Index funcIdxVar = Builder::addVar(writeProfile.get(), "funcIdx", Type::i32);
  auto getFuncIdx = [&]() {
    return builder.makeLocalGet(funcIdxVar, Type::i32);
  };
  // (block $outer
  //   (loop $l
  //     (br_if $outer (i32.eq (local.get $funcIdx) (i32.const numFuncs))
  //     (i32.store offset=8
  //       (i32.add
  //         (local.get $addr)
  //         (i32.mul (local.get $funcIdx) (i32.const 4))
  //       )
  // If Atomics:
  //       (i32.atomic.load8_u (local.get $funcIdx))
  // Else:
  //       (i32.load8_u (local.get $funcIdx))
  //     )
  //     (local.set $funcIdx
  //      (i32.add (local.get $funcIdx) (i32.const 1)
  //     )
  //     (br $l)
  //   )
  // )
  Expression* load;
  if (wasm->features.hasAtomics()) {
    load =
      builder.makeAtomicLoad(1, 0, getFuncIdx(), Type::i32, secondaryMemory);
  } else {
    load = builder.makeLoad(
      1, false, 0, 1, getFuncIdx(), Type::i32, secondaryMemory);
  }

  writeData = builder.blockify(
    writeData,
    builder.makeBlock(
      "outer",
      builder.makeLoop(
        "l",
        builder.blockify(
          builder.makeBreak(
            "outer",
            nullptr,
            builder.makeBinary(
              EqInt32, getFuncIdx(), builder.makeConst(uint32_t(numFuncs)))),
          builder.makeStore(
            4,
            offset,
            4,
            builder.makeBinary(
              AddInt32,
              getAddr(),
              builder.makeBinary(
                MulInt32, getFuncIdx(), builder.makeConst(uint32_t(4)))),
            load,
            Type::i32,
            wasm->memories[0]->name),
          builder.makeLocalSet(
            funcIdxVar,
            builder.makeBinary(
              AddInt32, getFuncIdx(), builder.makeConst(uint32_t(1)))),
          builder.makeBreak("l")))));

  writeProfile->body = builder.makeSequence(
    builder.makeIf(builder.makeBinary(GeUInt32, getSize(), profileSizeConst()),
                   writeData),
    profileSizeConst());

  // Create an export for the function
  wasm->addFunction(std::move(writeProfile));
  wasm->addExport(
    Builder::makeExport(options.profileExport, name, ExternalKind::Function));

  // Export the memory if it is not already exported or imported.
  if (!wasm->memories[0]->imported()) {
    bool memoryExported = false;
    for (auto& ex : wasm->exports) {
      if (ex->kind == ExternalKind::Memory) {
        memoryExported = true;
        break;
      }
    }
    if (!memoryExported) {
      wasm->addExport(Builder::makeExport(
        "profile-memory",
        Names::getValidExportName(*wasm, wasm->memories[0]->name),
        ExternalKind::Memory));
    }
  }
}

} // namespace wasm
