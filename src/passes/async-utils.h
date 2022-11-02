/*
 * Copyright 2022 WebAssembly Community Group participants
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

#ifndef wasm_async_utils_h
#define wasm_async_utils_h

#include "ir/module-utils.h"
#include "pass.h"
#include "support/string.h"

namespace wasm::AsyncUtils {

static const Name ASYNCIFY_START_UNWIND = "asyncify_start_unwind";
static const Name ASYNCIFY_STOP_UNWIND = "asyncify_stop_unwind";
static const Name ASYNCIFY_START_REWIND = "asyncify_start_rewind";
static const Name ASYNCIFY_STOP_REWIND = "asyncify_stop_rewind";
static const Name ASYNCIFY_GET_CALL_INDEX = "__asyncify_get_call_index";
static const Name ASYNCIFY_CHECK_CALL_INDEX = "__asyncify_check_call_index";

// Analyze the entire module to see which calls may change the state, that
// is, start an unwind or rewind), either in itself or in something called
// by it.
// Handles global module management, needed from the various parts of this
// transformation.
class ModuleAnalyzer {
  Module& module;
  bool canIndirectChangeState;

  struct Info
    : public ModuleUtils::CallGraphPropertyAnalysis<Info>::FunctionInfo {
    // The function name.
    Name name;
    // If this function can start an unwind/rewind.
    bool canChangeState = false;
    // If this function is part of the runtime that receives an unwinding
    // and starts a rewinding. If so, we do not instrument it, see above.
    // This is only relevant when handling things entirely inside wasm,
    // as opposed to imports.
    bool isBottomMostRuntime = false;
    // If this function is part of the runtime that starts an unwinding
    // and stops a rewinding. If so, we do not instrument it, see above.
    // The difference between the top-most and bottom-most runtime is that
    // the top-most part is still marked as changing the state; so things
    // that call it are instrumented. This is not done for the bottom.
    bool isTopMostRuntime = false;
    bool inRemoveList = false;
    bool addedFromList = false;
  };

  typedef std::map<Function*, Info> Map;
  Map map;

public:
  ModuleAnalyzer(Module& module,
                 std::function<bool(Name, Name)> canImportChangeState,
                 bool canIndirectChangeState,
                 const String::Split& removeListInput,
                 const String::Split& addListInput,
                 const String::Split& onlyListInput,
                 bool asserts,
                 bool verbose);

  bool needsInstrumentation(Function* func) {
    auto& info = map[func];
    return info.canChangeState && !info.isTopMostRuntime;
  }

  bool canChangeState(Expression* curr, Function* func);

  bool asserts;
  bool verbose;
};

std::unique_ptr<ModuleAnalyzer> createAnalyzer(Module* module,
                                               PassOptions& options);
} // namespace wasm::AsyncUtils

#endif // wasm_async_utils_h
