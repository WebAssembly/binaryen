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

// Instrumenting function `void* malloc(int32_t)` with a user-defined
// name of the tracer `trace_alloc` and function `void free(void*)`
// with the default name of the tracer `trace_free` (`trace_` prefix
// is added by default):
// wasm-opt --trace-calls=malloc:trace_alloc,free -o test-opt.wasm test.wasm
//
//  Before:
//   (call $malloc
//     (local.const 32))
//   (call $free (i32.const 64))
//
//  After:
//   (local $0 i32)
//   (local $1 i32)
//   (local $2 i32)
//   (block (result i32)
//     (call $trace_alloc
//       (local.get $0)
//       (local.tee $1
//         (call $malloc
//           (local.tee $0 (i32.const 2))
//         )
//       )
//     )
//   )
//   (block
//     (call $free
//       (local.tee $3
//         (i32.const 64)
//       )
//     )
//     (call $trace_free
//       (local.get $3)
//     )
//   )

#include <map>

#include "asmjs/shared-constants.h"
#include "ir/import-utils.h"
#include "pass.h"
#include "support/string.h"
#include "wasm-builder.h"

namespace wasm {

using TracedFunctions = std::map<Name /* originName */, Name /* tracerName */>;

struct AddTraceWrappers : public WalkerPass<PostWalker<AddTraceWrappers>> {
  AddTraceWrappers(TracedFunctions tracedFunctions)
    : tracedFunctions(std::move(tracedFunctions)) {}
  void visitCall(Call* curr) {
    auto* target = getModule()->getFunction(curr->target);

    auto iter = tracedFunctions.find(target->name);
    if (iter != tracedFunctions.end()) {
      addInstrumentation(curr, target, iter->second);
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
    } else {
      replaceCurrent(builder.makeBlock(
        {realCall,
         builder.makeCall(
           wrapperName, trackerCallParams, Type::BasicType::none)}));
    }
  }

  TracedFunctions tracedFunctions;
};

struct TraceCalls : public Pass {
  // Adds calls to new imports.
  bool addsEffects() override { return true; }

  void run(Module* module) override {
    auto functionsDefinitions =
      getArgument("trace-calls",
                  "TraceCalls usage: wasm-opt "
                  "--trace-calls=FUNCTION_TO_TRACE[:TRACER_NAME][,...]");

    auto tracedFunctions = parseArgument(functionsDefinitions);

    for (const auto& tracedFunction : tracedFunctions) {
      auto func = module->getFunctionOrNull(tracedFunction.first);
      if (!func) {
        std::cerr << "[TraceCalls] Function '" << tracedFunction.first
                  << "' not found" << std::endl;
      } else {
        addImport(module, *func, tracedFunction.second);
      }
    }

    AddTraceWrappers(std::move(tracedFunctions)).run(getPassRunner(), module);
  }

private:
  Type getTracerParamsType(ImportInfo& info, const Function& func) {
    auto resultsType = func.type.getSignature().results;
    if (resultsType.isTuple()) {
      Fatal() << "Failed to instrument function '" << func.name
              << "': Multi-value result type is not supported";
    }

    std::vector<Type> tracerParamTypes;
    if (resultsType.isConcrete()) {
      tracerParamTypes.push_back(resultsType);
    }
    for (auto& op : func.type.getSignature().params) {
      tracerParamTypes.push_back(op);
    }

    return Type(tracerParamTypes);
  }

  TracedFunctions parseArgument(const std::string& arg) {
    TracedFunctions tracedFunctions;

    for (const auto& definition : String::Split(arg, ",")) {
      if (definition.empty()) {
        // Empty definition, ignore.
        continue;
      }

      std::string originName, traceName;
      parseFunctionName(definition, originName, traceName);

      tracedFunctions[Name(originName)] = Name(traceName);
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

  void addImport(Module* wasm, const Function& f, const Name& tracerName) {
    ImportInfo info(*wasm);

    if (!info.getImportedFunction(ENV, tracerName)) {
      auto import = Builder::makeFunction(
        tracerName, Signature(getTracerParamsType(info, f), Type::none), {});
      import->module = ENV;
      import->base = tracerName;
      wasm->addFunction(std::move(import));
    }
  }
};

Pass* createTraceCallsPass() { return new TraceCalls(); }

} // namespace wasm
