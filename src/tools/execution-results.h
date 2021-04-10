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
    // Legalization for JS emits get/setTempRet0 calls ("temp ret 0" means a
    // temporary return value of 32 bits; "0" is the only important value for
    // 64-bit legalization, which needs one such 32-bit chunk in addition to
    // the normal return value which can handle 32 bits).
    uint32_t tempRet0 = 0;
  } state;

  LoggingExternalInterface(Loggings& loggings) : loggings(loggings) {}

  Literals callImport(Function* import, LiteralList& arguments) override {
    if (import->module == "fuzzing-support") {
      std::cout << "[LoggingExternalInterface logging";
      loggings.push_back(Literal()); // buffer with a None between calls
      for (auto argument : arguments) {
        if (argument.type == Type::i64) {
          // To avoid JS legalization changing logging results, treat a logging
          // of an i64 as two i32s (which is what legalization would turn us
          // into).
          auto low = Literal(int32_t(argument.getInteger()));
          auto high = Literal(int32_t(argument.getInteger() >> int32_t(32)));
          std::cout << ' ' << low;
          loggings.push_back(low);
          std::cout << ' ' << high;
          loggings.push_back(high);
        } else {
          std::cout << ' ' << argument;
          loggings.push_back(argument);
        }
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
          results[exp->name] = ret;
          // ignore the result if we hit an unreachable and returned no value
          if (ret.size() > 0) {
            std::cout << "[fuzz-exec] note result: " << exp->name << " => ";
            auto resultType = func->sig.results;
            if (resultType.isRef()) {
              // Don't print reference values, as funcref(N) contains an index
              // for example, which is not guaranteed to remain identical after
              // optimizations.
              std::cout << resultType << '\n';
            } else {
              std::cout << ret << '\n';
            }
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
      std::cout << "[fuzz-exec] optimization passes changed results\n";
      exit(1);
    }
  }

  bool areEqual(Literal a, Literal b) {
    if (a.type != b.type) {
      std::cout << "types not identical! " << a << " != " << b << '\n';
      return false;
    }
    if (a.type.isRef()) {
      // Don't compare references - only their types. There are several issues
      // here that we can't fully handle, see
      // https://github.com/WebAssembly/binaryen/issues/3378, but the core issue
      // is that we are comparing results between two separate wasm modules (and
      // a separate instance of each) - we can't really identify an identical
      // reference between such things. We can only compare things structurally,
      // for which we compare the types.
      return true;
    }
    if (a != b) {
      std::cout << "values not identical! " << a << " != " << b << '\n';
      return false;
    }
    return true;
  }

  bool areEqual(Literals a, Literals b) {
    if (a.size() != b.size()) {
      std::cout << "literal counts not identical! " << a << " != " << b << '\n';
      return false;
    }
    for (Index i = 0; i < a.size(); i++) {
      if (!areEqual(a[i], b[i])) {
        return false;
      }
    }
    return true;
  }

  bool operator==(ExecutionResults& other) {
    for (auto& iter : other.results) {
      auto name = iter.first;
      if (results.find(name) == results.end()) {
        std::cout << "[fuzz-exec] missing " << name << '\n';
        return false;
      }
      std::cout << "[fuzz-exec] comparing " << name << '\n';
      if (!areEqual(results[name], other.results[name])) {
        return false;
      }
    }
    if (loggings.size() != other.loggings.size()) {
      std::cout << "logging counts not identical!\n";
      return false;
    }
    for (Index i = 0; i < loggings.size(); i++) {
      if (!areEqual(loggings[i], other.loggings[i])) {
        return false;
      }
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
        if (!param.isDefaultable()) {
          std::cout << "[trap fuzzer can only send defaultable parameters to "
                       "exports]\n";
        }
        arguments.push_back(Literal::makeZero(param));
      }
      return instance.callFunction(func->name, arguments);
    } catch (const TrapException&) {
      return {};
    }
  }
};

} // namespace wasm
