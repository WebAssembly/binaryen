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

// A helper class for managing fake global names. Creates the globals and
// provides mappings for using them.
// Fake globals are used to stash and then use return values from calls. We need
// to store them somewhere that is valid Binaryen IR, but also will be ignored
// by the Asyncify instrumentation, so we don't want to use a local. What we do
// is replace the local used to receive a call's result with a fake global.set
// to stash it, then do a fake global.get to receive it afterwards. (We do it in
// two steps so that if we are async, we only do the first and not the second,
// i.e., we don't store to the target local if not running normally).
class FakeGlobalHelper {
  Module& module;

public:
  FakeGlobalHelper(Module& module) : module(module) {
    Builder builder(module);
    std::string prefix = "asyncify_fake_call_global_";
    for (auto type : collectTypes()) {
      auto global = prefix + Type(type).toString();
      map[type] = global;
      rev[global] = type;
      module.addGlobal(builder.makeGlobal(
        global, type, LiteralUtils::makeZero(type, module), Builder::Mutable));
    }
  }

  ~FakeGlobalHelper() {
    for (auto& pair : map) {
      auto name = pair.second;
      module.removeGlobal(name);
    }
  }

  Name getName(Type type) { return map.at(type); }

  Type getTypeOrNone(Name name) {
    auto iter = rev.find(name);
    if (iter != rev.end()) {
      return iter->second;
    }
    return Type::none;
  }

private:
  std::unordered_map<Type, Name> map;
  std::unordered_map<Name, Type> rev;

  // Collect the types returned from all calls for which call support globals
  // may need to be generated.
  using Types = std::unordered_set<Type>;
  Types collectTypes() {
    ModuleUtils::ParallelFunctionAnalysis<Types> analysis(
      module, [&](Function* func, Types& types) {
        if (!func->body) {
          return;
        }
        struct TypeCollector : PostWalker<TypeCollector> {
          Types& types;
          TypeCollector(Types& types) : types(types) {}
          void visitCall(Call* curr) {
            if (curr->type.isConcrete()) {
              types.insert(curr->type);
            }
          }
          void visitCallIndirect(CallIndirect* curr) {
            if (curr->type.isConcrete()) {
              types.insert(curr->type);
            }
          }
        };
        TypeCollector(types).walk(func->body);
      });
    Types types;
    for (auto& pair : analysis.map) {
      Types& functionTypes = pair.second;
      for (auto t : functionTypes) {
        types.insert(t);
      }
    }
    return types;
  }
};

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

  FakeGlobalHelper fakeGlobals;
  bool asserts;
  bool verbose;
};

std::unique_ptr<ModuleAnalyzer> createAnalyzer(Module* module,
                                               PassOptions& options);
} // namespace wasm::AsyncUtils

#endif // wasm_async_utils_h
