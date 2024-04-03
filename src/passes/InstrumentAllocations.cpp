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
// Instruments the build with code to intercept all allocation function calls
// (malloc, calloc, realloc, free).
// This can be useful in building tools that analyze memory usage.
//
// Instrumenting free():
//  Before:
//   (call $free (i32.const 64))
//
//  After:
//   (local $1 i32)
//   (block
//     (call $free
//       (local.tee $1
//         (i32.const 64)
//       )
//     )
//     (call $trace_free
//       (local.get $1)
//     )
//   )
//
// Instrumenting malloc():
//  Before:
//   (call $malloc
//     (local.const 32))
//
//  After:
//   (local $0 i32)
//   (local $1 i32)
//   (block (result i32)
//     (call $trace_malloc
//       (local.get $0)
//       (local.tee $1
//         (call $malloc
//           (local.tee $0 (i32.const 2))
//         )
//       )
//     )
//   )
//

#include <set>

#include "asmjs/shared-constants.h"
#include "pass.h"
#include "wasm-builder.h"

namespace wasm {

struct TracedFunction {
  Name originName;
  Name tracerName;
  Type params;
  Type results;
};
bool operator<(const TracedFunction& lhs, const TracedFunction& rhs) {
  return lhs.originName < rhs.originName;
}

struct InstrumentAllocations
  : public WalkerPass<PostWalker<InstrumentAllocations>> {
  bool addsEffects() override { return true; }

  void visitCall(Call* curr) {
    auto* target = getModule()->getFunction(curr->target);

    auto function_it = std::find_if(traceFunctions.begin(),
                                    traceFunctions.end(),
                                    [target](const TracedFunction& f) {
                                      return f.originName == target->name;
                                    });
    if (function_it != traceFunctions.end()) {
      addInstrumentation(curr, target, function_it->tracerName);
    }
  }

  void visitModule(Module* curr) {
    for (const auto& traceFunction : traceFunctions) {
      addImport(curr, traceFunction);
    }
  }

private:
  void addInstrumentation(Call* curr,
                          const wasm::Function* target,
                          const Name& wrapperName) {
    Builder builder(*getModule());
    std::vector<wasm::Expression*> realCallParams, trackerCallParams;

    for (const auto& op : curr->operands) {
      auto localVar = builder.addVar(getFunction(), op->type);
      realCallParams.push_back(builder.makeLocalTee(localVar, op, op->type));
      trackerCallParams.push_back(builder.makeLocalGet(localVar, op->type));
    }

    auto resultType = target->type.getSignature().results;
    auto realCall = builder.makeCall(target->name, realCallParams, resultType);

    if (resultType.isConcrete()) {
      auto resultLocal = builder.addVar(getFunction(), resultType);
      trackerCallParams.insert(
        trackerCallParams.begin(),
        builder.makeLocalTee(resultLocal, realCall, resultType));

      replaceCurrent(builder.makeBlock(
        {builder.makeCall(
           wrapperName, trackerCallParams, Type::BasicType::none),
         builder.makeLocalGet(resultLocal, resultType)}));
    } else
      replaceCurrent(builder.makeBlock(
        {realCall,
         builder.makeCall(
           wrapperName, trackerCallParams, Type::BasicType::none)}));
  }

  void addImport(Module* wasm, const TracedFunction& f) {
    auto import =
      Builder::makeFunction(f.tracerName, Signature(f.params, f.results), {});
    import->module = ENV;
    import->base = f.tracerName;
    wasm->addFunction(std::move(import));
  }

  std::set<TracedFunction> traceFunctions = {
    {Name("malloc"), Name("trace_malloc"), {Type::i32, Type::i32}, Type::none},
    {Name("calloc"),
     Name("trace_calloc"),
     {Type::i32, Type::i32, Type::i32},
     Type::none},
    {Name("realloc"),
     Name("trace_realloc"),
     {Type::i32, Type::i32, Type::i32},
     Type::none},
    {Name("free"), Name("trace_free"), {Type::i32}, Type::none}};
};

// declare passes

Pass* createInstrumentAllocationsPass() { return new InstrumentAllocations(); }

} // namespace wasm
