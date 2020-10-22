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

//
// Shared execution result checking code
//

#include "shell-interface.h"
#include "wasm.h"

namespace wasm {

typedef std::vector<Literal> Loggings;

// Logs every relevant import call parameter.
struct LoggingExternalInterface : public ShellExternalInterface {
  Loggings& loggings;

  struct State {
    uint32_t tempRet0 = 0;
  } state;
  ;

  LoggingExternalInterface(Loggings& loggings) : loggings(loggings) {}

  Literals callImport(Function* import, LiteralList& arguments) override {
    if (import->module == "fuzzing-support") {
      std::cout << "[LoggingExternalInterface logging";
      loggings.push_back(Literal()); // buffer with a None between calls
      for (auto argument : arguments) {
        std::cout << ' ' << argument;
        loggings.push_back(argument);
      }
      std::cout << "]\n";
      return {};
    } else if (import->module == ENV) {
      if (import->base == "log_execution") {
        std::cout << "[LoggingExternalInterface log-execution";
        for (auto argument : arguments) {
          std::cout << ' ' << argument;
        }
        std::cout << "]\n";
        return {};
      } else if (import->base == "setTempRet0") {
        state.tempRet0 = arguments[0].geti32();
        return {};
      } else if (import->base == "getTempRet0") {
        return {Literal(state.tempRet0)};
      }
    }
    std::cerr << "[LoggingExternalInterface ignoring an unknown import "
              << import->module << " . " << import->base << '\n';
    return {};
  }
};

// gets execution results from a wasm module. this is useful for fuzzing
//
// we can only get results when there are no imports. we then call each method
// that has a result, with some values
struct ExecutionResults {
  std::map<Name, Literals> results;
  Loggings loggings;

  // get results of execution
  void get(Module& wasm) {
    LoggingExternalInterface interface(loggings);
    try {
      ModuleInstance instance(wasm, &interface);
      // execute all exported methods (that are therefore preserved through
      // opts)
      for (auto& exp : wasm.exports) {
        if (exp->kind != ExternalKind::Function) {
          continue;
        }
        std::cout << "[fuzz-exec] calling " << exp->name << "\n";
        auto* func = wasm.getFunction(exp->value);
        if (func->sig.results != Type::none) {
          // this has a result
          Literals ret = run(func, wasm, instance);
          // We cannot compare funcrefs by name because function names can
          // change (after duplicate function elimination or roundtripping)
          // while the function contents are still the same
          for (Literal& val : ret) {
            if (val.type == Type::funcref && !val.isNull()) {
              val = Literal::makeFunc(Name("funcref"));
            }
          }
          results[exp->name] = ret;
          // ignore the result if we hit an unreachable and returned no value
          if (ret.size() > 0) {
            std::cout << "[fuzz-exec] note result: " << exp->name << " => "
                      << ret << '\n';
          }
        } else {
          // no result, run it anyhow (it might modify memory etc.)
          run(func, wasm, instance);
        }
      }
    } catch (const TrapException&) {
      // may throw in instance creation (init of offsets)
    }
  }

  // get current results and check them against previous ones
  void check(Module& wasm) {
    ExecutionResults optimizedResults;
    optimizedResults.get(wasm);
    if (optimizedResults != *this) {
      std::cout << "[fuzz-exec] optimization passes changed execution results";
      exit(1);
    }
  }

  bool operator==(ExecutionResults& other) {
    for (auto& iter : other.results) {
      auto name = iter.first;
      if (results.find(name) == results.end()) {
        std::cout << "[fuzz-exec] missing " << name << '\n';
        return false;
      }
      std::cout << "[fuzz-exec] comparing " << name << '\n';
      if (results[name] != other.results[name]) {
        std::cout << "not identical! " << results[name]
                  << " != " << other.results[name] << "\n";
        return false;
      }
    }
    if (loggings != other.loggings) {
      std::cout << "logging not identical!\n";
      return false;
    }
    return true;
  }

  bool operator!=(ExecutionResults& other) { return !((*this) == other); }

  Literals run(Function* func, Module& wasm) {
    LoggingExternalInterface interface(loggings);
    try {
      ModuleInstance instance(wasm, &interface);
      return run(func, wasm, instance);
    } catch (const TrapException&) {
      // may throw in instance creation (init of offsets)
      return {};
    }
  }

  Literals run(Function* func, Module& wasm, ModuleInstance& instance) {
    try {
      LiteralList arguments;
      // init hang support, if present
      if (auto* ex = wasm.getExportOrNull("hangLimitInitializer")) {
        instance.callFunction(ex->value, arguments);
      }
      // call the method
      for (const auto& param : func->sig.params) {
        // zeros in arguments TODO: more?
        arguments.push_back(Literal::makeZero(param));
      }
      return instance.callFunction(func->name, arguments);
    } catch (const TrapException&) {
      return {};
    }
  }
};

} // namespace wasm
