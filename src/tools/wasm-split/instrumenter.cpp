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
#include "wasm-type.h"

namespace wasm {

Instrumenter::Instrumenter(const WasmSplitOptions& options, uint64_t moduleHash)
  : options(options), moduleHash(moduleHash) {}

void Instrumenter::run(PassRunner* runner, Module* wasm) {
  this->runner = runner;
  this->wasm = wasm;
  addGlobals();
  instrumentFuncs();
  addProfileExport();
}

void Instrumenter::addGlobals() {
  if (options.storageKind != WasmSplitOptions::StorageKind::InGlobals) {
    // Don't need globals
    return;
  }
  // Create fresh global names (over-reserves, but that's ok)
  counterGlobal = Names::getValidGlobalName(*wasm, "monotonic_counter");
  functionGlobals.reserve(wasm->functions.size());
  ModuleUtils::iterDefinedFunctions(*wasm, [&](Function* func) {
    functionGlobals.push_back(Names::getValidGlobalName(
      *wasm, std::string(func->name.c_str()) + "_timestamp"));
  });

  // Create and add new globals
  auto addGlobal = [&](Name name) {
    auto global = Builder::makeGlobal(
      name,
      Type::i32,
      Builder(*wasm).makeConst(Literal::makeZero(Type::i32)),
      Builder::Mutable);
    global->hasExplicitName = true;
    wasm->addGlobal(std::move(global));
  };
  addGlobal(counterGlobal);
  for (auto& name : functionGlobals) {
    addGlobal(name);
  }
}

void Instrumenter::instrumentFuncs() {
  // Inject code at the beginning of each function to advance the monotonic
  // counter and set the function's timestamp if it hasn't already been set.
  Builder builder(*wasm);
  switch (options.storageKind) {
    case WasmSplitOptions::StorageKind::InGlobals: {
      // (if (i32.eqz (global.get $timestamp))
      //   (block
      //     (global.set $monotonic_counter
      //       (i32.add
      //         (global.get $monotonic_counter)
      //         (i32.const 1)
      //       )
      //     )
      //     (global.set $timestamp
      //       (global.get $monotonic_counter)
      //     )
      //   )
      // )
      auto globalIt = functionGlobals.begin();
      ModuleUtils::iterDefinedFunctions(*wasm, [&](Function* func) {
        func->body = builder.makeSequence(
          builder.makeIf(
            builder.makeUnary(EqZInt32,
                              builder.makeGlobalGet(*globalIt, Type::i32)),
            builder.makeSequence(
              builder.makeGlobalSet(
                counterGlobal,
                builder.makeBinary(
                  AddInt32,
                  builder.makeGlobalGet(counterGlobal, Type::i32),
                  builder.makeConst(Literal::makeOne(Type::i32)))),
              builder.makeGlobalSet(
                *globalIt, builder.makeGlobalGet(counterGlobal, Type::i32)))),
          func->body,
          func->body->type);
        ++globalIt;
      });
      break;
    }
    case WasmSplitOptions::StorageKind::InMemory: {
      if (!wasm->features.hasAtomics()) {
        Fatal() << "error: --in-memory requires atomics to be enabled";
      }
      // (i32.atomic.store8 offset=funcidx (i32.const 0) (i32.const 1))
      Index funcIdx = 0;
      ModuleUtils::iterDefinedFunctions(*wasm, [&](Function* func) {
        func->body = builder.makeSequence(
          builder.makeAtomicStore(1,
                                  funcIdx,
                                  builder.makeConstPtr(0),
                                  builder.makeConst(uint32_t(1)),
                                  Type::i32),
          func->body,
          func->body->type);
        ++funcIdx;
      });
      break;
    }
  }
}

// wasm-split profile format:
//
// The wasm-split profile is a binary format designed to be simple to produce
// and consume. It is comprised of:
//
//   1. An 8-byte module hash
//
//   2. A 4-byte timestamp for each defined function
//
// The module hash is meant to guard against bugs where the module that was
// instrumented and the module that is being split are different. The timestamps
// are non-zero for functions that were called during the instrumented run and 0
// otherwise. Functions with smaller non-zero timestamps were called earlier in
// the instrumented run than funtions with larger timestamps.

void Instrumenter::addProfileExport() {
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

  size_t numFuncs = 0;
  ModuleUtils::iterDefinedFunctions(*wasm, [&](Function*) { ++numFuncs; });

  // Calculate the size of the profile:
  //   8 bytes module hash +
  //   4 bytes for the timestamp for each function
  const size_t profileSize = 8 + 4 * numFuncs;

  // Create the function body
  Builder builder(*wasm);
  auto getAddr = [&]() { return builder.makeLocalGet(0, Type::i32); };
  auto getSize = [&]() { return builder.makeLocalGet(1, Type::i32); };
  auto hashConst = [&]() { return builder.makeConst(int64_t(moduleHash)); };
  auto profileSizeConst = [&]() {
    return builder.makeConst(int32_t(profileSize));
  };

  // Write the hash followed by all the time stamps
  Expression* writeData =
    builder.makeStore(8, 0, 1, getAddr(), hashConst(), Type::i64);
  uint32_t offset = 8;

  switch (options.storageKind) {
    case WasmSplitOptions::StorageKind::InGlobals: {
      for (const auto& global : functionGlobals) {
        writeData = builder.blockify(
          writeData,
          builder.makeStore(4,
                            offset,
                            1,
                            getAddr(),
                            builder.makeGlobalGet(global, Type::i32),
                            Type::i32));
        offset += 4;
      }
      break;
    }
    case WasmSplitOptions::StorageKind::InMemory: {
      Index funcIdxVar =
        Builder::addVar(writeProfile.get(), "funcIdx", Type::i32);
      auto getFuncIdx = [&]() {
        return builder.makeLocalGet(funcIdxVar, Type::i32);
      };
      // (block $outer
      //   (loop $l
      //     (br_if $outer (i32.eq (local.get $fucIdx) (i32.const numFuncs))
      //     (i32.store offset=8
      //       (i32.add
      //         (local.get $addr)
      //         (i32.mul (local.get $funcIdx) (i32.const 4))
      //       )
      //       (i32.atomic.load8_u (local.get $funcIdx))
      //     )
      //     (local.set $funcIdx
      //      (i32.add (local.get $fundIdx) (i32.const 1)
      //     )
      //     (br $l)
      //   )
      // )
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
                builder.makeBinary(EqInt32,
                                   getFuncIdx(),
                                   builder.makeConst(uint32_t(numFuncs)))),
              builder.makeStore(
                4,
                offset,
                4,
                builder.makeBinary(
                  AddInt32,
                  getAddr(),
                  builder.makeBinary(
                    MulInt32, getFuncIdx(), builder.makeConst(uint32_t(4)))),
                builder.makeAtomicLoad(1, 0, getFuncIdx(), Type::i32),
                Type::i32),
              builder.makeLocalSet(
                funcIdxVar,
                builder.makeBinary(
                  AddInt32, getFuncIdx(), builder.makeConst(uint32_t(1)))),
              builder.makeBreak("l")))));
      break;
    }
  }

  writeProfile->body = builder.makeSequence(
    builder.makeIf(builder.makeBinary(GeUInt32, getSize(), profileSizeConst()),
                   writeData),
    profileSizeConst());

  // Create an export for the function
  wasm->addFunction(std::move(writeProfile));
  wasm->addExport(
    Builder::makeExport(options.profileExport, name, ExternalKind::Function));

  // Also make sure there is a memory with enough pages to write into
  size_t pages = (profileSize + Memory::kPageSize - 1) / Memory::kPageSize;
  if (!wasm->memory.exists) {
    wasm->memory.exists = true;
    wasm->memory.initial = pages;
    wasm->memory.max = pages;
  } else if (wasm->memory.initial < pages) {
    wasm->memory.initial = pages;
    if (wasm->memory.max < pages) {
      wasm->memory.max = pages;
    }
  }

  // Export the memory if it is not already exported or imported.
  if (!wasm->memory.imported()) {
    bool memoryExported = false;
    for (auto& ex : wasm->exports) {
      if (ex->kind == ExternalKind::Memory) {
        memoryExported = true;
        break;
      }
    }
    if (!memoryExported) {
      wasm->addExport(
        Builder::makeExport("profile-memory",
                            Names::getValidExportName(*wasm, wasm->memory.name),
                            ExternalKind::Memory));
    }
  }
}

} // namespace wasm
