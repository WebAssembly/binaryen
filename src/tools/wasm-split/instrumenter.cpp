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

Instrumenter::Instrumenter(const std::string& profileExport,
                           uint64_t moduleHash)
  : profileExport(profileExport), moduleHash(moduleHash) {}

void Instrumenter::run(PassRunner* runner, Module* wasm) {
  this->runner = runner;
  this->wasm = wasm;
  addGlobals();
  instrumentFuncs();
  addProfileExport();
}

void Instrumenter::addGlobals() {
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
  // Inject the following code at the beginning of each function to advance the
  // monotonic counter and set the function's timestamp if it hasn't already
  // been set.
  //
  //   (if (i32.eqz (global.get $timestamp))
  //     (block
  //       (global.set $monotonic_counter
  //         (i32.add
  //           (global.get $monotonic_counter)
  //           (i32.const 1)
  //         )
  //       )
  //       (global.set $timestamp
  //         (global.get $monotonic_counter)
  //       )
  //     )
  //   )
  Builder builder(*wasm);
  auto globalIt = functionGlobals.begin();
  ModuleUtils::iterDefinedFunctions(*wasm, [&](Function* func) {
    func->body = builder.makeSequence(
      builder.makeIf(
        builder.makeUnary(EqZInt32,
                          builder.makeGlobalGet(*globalIt, Type::i32)),
        builder.makeSequence(
          builder.makeGlobalSet(
            counterGlobal,
            builder.makeBinary(AddInt32,
                               builder.makeGlobalGet(counterGlobal, Type::i32),
                               builder.makeConst(Literal::makeOne(Type::i32)))),
          builder.makeGlobalSet(
            *globalIt, builder.makeGlobalGet(counterGlobal, Type::i32)))),
      func->body,
      func->body->type);
    ++globalIt;
  });
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
  auto name = Names::getValidFunctionName(*wasm, profileExport);
  auto writeProfile = Builder::makeFunction(
    name, Signature({Type::i32, Type::i32}, Type::i32), {});
  writeProfile->hasExplicitName = true;
  writeProfile->setLocalName(0, "addr");
  writeProfile->setLocalName(1, "size");

  // Calculate the size of the profile:
  //   8 bytes module hash +
  //   4 bytes for the timestamp for each function
  const size_t profileSize = 8 + 4 * functionGlobals.size();

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

  writeProfile->body = builder.makeSequence(
    builder.makeIf(builder.makeBinary(GeUInt32, getSize(), profileSizeConst()),
                   writeData),
    profileSizeConst());

  // Create an export for the function
  wasm->addFunction(std::move(writeProfile));
  wasm->addExport(
    Builder::makeExport(profileExport, name, ExternalKind::Function));

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

  // TODO: export the memory if it is not already exported.
}

} // namespace wasm
