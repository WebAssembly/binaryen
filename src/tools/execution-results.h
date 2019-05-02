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

#include "ir/import-utils.h"
#include "shell-interface.h"
#include "wasm.h"

namespace wasm {

typedef std::vector<Literal> Loggings;

// Logs every relevant import call parameter.
struct LoggingExternalInterface : public ShellExternalInterface {
  Loggings& loggings;

  LoggingExternalInterface(Loggings& loggings) : loggings(loggings) {}

  Literal callImport(Function* import, LiteralList& arguments) override {
    if (import->module == "fuzzing-support") {
      std::cout << "[LoggingExternalInterface logging";
      loggings.push_back(Literal()); // buffer with a None between calls
      for (auto argument : arguments) {
        std::cout << ' ' << argument;
        loggings.push_back(argument);
      }
      std::cout << "]\n";
    }
    return Literal();
  }
};

// gets execution results from a wasm module. this is useful for fuzzing
//
// we can only get results when there are no imports. we then call each method
// that has a result, with some values
struct ExecutionResults {
  std::map<Name, Literal> results;
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
        if (func->result != none) {
          // this has a result
          results[exp->name] = run(func, wasm, instance);
          // ignore the result if we hit an unreachable and returned no value
          if (isConcreteType(results[exp->name].type)) {
            std::cout << "[fuzz-exec] note result: " << exp->name << " => "
                      << results[exp->name] << '\n';
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
      abort();
    }
  }

  bool operator==(ExecutionResults& other) {
    for (auto& iter : other.results) {
      auto name = iter.first;
      if (results.find(name) == results.end()) {
        std::cout << "[fuzz-exec] missing " << name << '\n';
        abort();
      }
      std::cout << "[fuzz-exec] comparing " << name << '\n';
      if (results[name] != other.results[name]) {
        std::cout << "not identical!\n";
        abort();
      }
    }
    if (loggings != other.loggings) {
      std::cout << "logging not identical!\n";
      abort();
    }
    return true;
  }

  bool operator!=(ExecutionResults& other) { return !((*this) == other); }

  Literal run(Function* func, Module& wasm) {
    LoggingExternalInterface interface(loggings);
    try {
      ModuleInstance instance(wasm, &interface);
      return run(func, wasm, instance);
    } catch (const TrapException&) {
      // may throw in instance creation (init of offsets)
      return Literal();
    }
  }

  Literal run(Function* func, Module& wasm, ModuleInstance& instance) {
    try {
      LiteralList arguments;
      // init hang support, if present
      if (auto* ex = wasm.getExportOrNull("hangLimitInitializer")) {
        instance.callFunction(ex->value, arguments);
      }
      // call the method
      for (Type param : func->params) {
        // zeros in arguments TODO: more?
        arguments.push_back(Literal(param));
      }
      return instance.callFunction(func->name, arguments);
    } catch (const TrapException&) {
      return Literal();
    }
  }
};

} // namespace wasm
