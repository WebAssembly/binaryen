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
// Instruments the build with code to intercept selected function calls.
// This can be e.g. used to trace allocations (malloc, free, calloc, realloc)
// and build tools for memory usage analysis.
// The pass supports SIMD but the multi-value feature is not supported yet.
//
// Instrumenting void free(void*):
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
// Instrumenting void* malloc(int32_t) with a user-defined tracer
// (trace_allocation):
//  Before:
//   (call $malloc
//     (local.const 32))
//
//  After:
//   (local $0 i32)
//   (local $1 i32)
//   (block (result i32)
//     (call $trace_allocation
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
#include "ir/import-utils.h"
#include "pass.h"
#include "support/string.h"
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

static Type strToType(const std::string& strType) {
  if (strType == "i32") {
    return Type::i32;
  } else if (strType == "i64") {
    return Type::i64;
  } else if (strType == "f32") {
    return Type::f32;
  } else if (strType == "f64") {
    return Type::f64;
  } else if (strType == "v128") {
    return Type::v128;
  } else {
    Fatal() << "Failed to parse type '" << strType << "'";
  }
}

struct AddTraceWrappers : public WalkerPass<PostWalker<AddTraceWrappers>> {
  AddTraceWrappers(std::set<TracedFunction> tracedFunctions)
    : tracedFunctions(std::move(tracedFunctions)) {}
  void visitCall(Call* curr) {
    auto* target = getModule()->getFunction(curr->target);

    auto iter = std::find_if(tracedFunctions.begin(),
                             tracedFunctions.end(),
                             [target](const TracedFunction& f) {
                               return f.originName == target->name;
                             });
    if (iter != tracedFunctions.end()) {
      addInstrumentation(curr, target, iter->tracerName);
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

  std::set<TracedFunction> tracedFunctions;
};

struct TraceCalls : public Pass {
  // Adds calls to new imports.
  bool addsEffects() override { return true; }

  void run(Module* module) override {
    auto functionsDefinitions = getPassOptions().getArgument(
      "trace-calls",
      "TraceCalls usage: wasm-opt "
      "--trace-calls=FUNCTION_TO_TRACE[:TRACER_NAME][,RESULT1_TYPE]"
      "[,PARAM1_TYPE[,PARAM2_TYPE[,...]]][;...]");

    auto tracedFunctions = parseArgument(functionsDefinitions);

    for (const auto& tracedFunction : tracedFunctions) {
      addImport(module, tracedFunction);
    }

    AddTraceWrappers(std::move(tracedFunctions)).run(getPassRunner(), module);
  }

private:
  std::set<TracedFunction> parseArgument(const std::string& arg) {
    std::set<TracedFunction> tracedFunctions;

    for (const auto& definition : String::Split(arg, ";")) {
      auto parts = String::Split(definition, ",");
      if (parts.size() == 0) {
        // Empty definition, ignore.
        continue;
      }

      std::string originName, traceName;
      parseFunctionName(parts[0], originName, traceName);

      std::vector<Type> paramsAndResults;
      for (size_t i = 1; i < parts.size(); i++) {
        paramsAndResults.push_back(strToType(parts[i]));
      }

      tracedFunctions.emplace(TracedFunction{
        Name(originName), Name(traceName), paramsAndResults, Type::none});
    }

    return tracedFunctions;
  }

  void parseFunctionName(const std::string& str,
                         std::string& originName,
                         std::string& traceName) {
    auto parts = String::Split(str, ":");
    switch (parts.size()) {
      case 1:
        originName = parts[0];
        traceName = "trace_" + originName;
        break;
      case 2:
        originName = parts[0];
        traceName = parts[1];
        break;
      default:
        Fatal() << "Failed to parse function name ('" << str
                << "'): expected format FUNCTION_TO_TRACE[:TRACER_NAME]";
    }
  }

  void addImport(Module* wasm, const TracedFunction& f) {
    ImportInfo info(*wasm);

    if (!info.getImportedFunction(ENV, f.tracerName)) {
      auto import =
        Builder::makeFunction(f.tracerName, Signature(f.params, f.results), {});
      import->module = ENV;
      import->base = f.tracerName;
      wasm->addFunction(std::move(import));
    }
  }
};

Pass* createTraceCallsPass() { return new TraceCalls(); }

} // namespace wasm
