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

using Loggings = std::vector<Literal>;

// Logs every relevant import call parameter.
struct LoggingExternalInterface : public ShellExternalInterface {
private:
  Loggings& loggings;

  struct State {
    // Legalization for JS emits get/setTempRet0 calls ("temp ret 0" means a
    // temporary return value of 32 bits; "0" is the only important value for
    // 64-bit legalization, which needs one such 32-bit chunk in addition to
    // the normal return value which can handle 32 bits).
    uint32_t tempRet0 = 0;
  } state;

  // The name of the table exported by the name 'table.' Imports access it.
  Name exportedTable;
  Module& wasm;

  // The name of the imported fuzzing tag for wasm.
  Name wasmTag;

  // The name of the imported tag for js exceptions. If it is not imported, we
  // use a default name here (which should differentiate it from any wasm
  // exceptions).
  Name jsTag = "__private";

  // The ModuleRunner and this ExternalInterface end up needing links both ways,
  // so we cannot init this in the constructor.
  ModuleRunner* instance = nullptr;

public:
  LoggingExternalInterface(Loggings& loggings, Module& wasm)
    : loggings(loggings), wasm(wasm) {
    for (auto& exp : wasm.exports) {
      if (exp->kind == ExternalKind::Table && exp->name == "table") {
        exportedTable = *exp->getInternalName();
        break;
      }
    }

    for (auto& tag : wasm.tags) {
      if (tag->module == "fuzzing-support") {
        if (tag->base == "wasmtag") {
          wasmTag = tag->name;
        } else if (tag->base == "jstag") {
          jsTag = tag->name;
        }
      }
    }
  }

  Flow callImport(Function* import, const Literals& arguments) override {
    if (import->module == "fuzzing-support") {
      if (import->base.startsWith("log")) {
        // This is a logging function like log-i32 or log-f64
        std::cout << "[LoggingExternalInterface ";
        if (import->base == "log-branch") {
          // Report this as a special logging, so we can differentiate it from
          // the others in the fuzzer.
          std::cout << "log-branch";
        } else {
          // All others are just reported as loggings.
          std::cout << "logging";
        }
        loggings.push_back(Literal()); // buffer with a None between calls
        for (auto argument : arguments) {
          if (argument.type == Type::i64) {
            // To avoid JS legalization changing logging results, treat a
            // logging of an i64 as two i32s (which is what legalization would
            // turn us into).
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
      } else if (import->base == "throw") {
        // Throw something, depending on the value of the argument. 0 means we
        // should throw a JS exception, and any other value means we should
        // throw a wasm exception (with that value as the payload).
        if (arguments[0].geti32() == 0) {
          throwJSException();
        } else {
          auto payload = std::make_shared<ExnData>(wasmTag, arguments);
          throwException(WasmException{Literal(payload)});
        }
      } else if (import->base == "table-get") {
        // Check for errors here, duplicating tableLoad(), because that will
        // trap, and we just want to throw an exception (the same as JS would).
        if (!exportedTable) {
          throwJSException();
        }
        auto index = arguments[0].getUnsigned();
        if (index >= tables[exportedTable].size()) {
          throwJSException();
        }
        return {tableLoad(exportedTable, index)};
      } else if (import->base == "table-set") {
        if (!exportedTable) {
          throwJSException();
        }
        auto index = arguments[0].getUnsigned();
        if (index >= tables[exportedTable].size()) {
          throwJSException();
        }
        tableStore(exportedTable, index, arguments[1]);
        return {};
      } else if (import->base == "call-export") {
        callExportAsJS(arguments[0].geti32());
        // The second argument determines if we should catch and rethrow
        // exceptions. There is no observable difference in those two modes in
        // the binaryen interpreter, so we don't need to do anything.

        // Return nothing. If we wanted to return a value we'd need to have
        // multiple such functions, one for each signature.
        return {};
      } else if (import->base == "call-export-catch") {
        try {
          callExportAsJS(arguments[0].geti32());
          return {Literal(int32_t(0))};
        } catch (const WasmException& e) {
          return {Literal(int32_t(1))};
        }
      } else if (import->base == "call-ref") {
        // Similar to call-export*, but with a ref.
        callRefAsJS(arguments[0]);
        return {};
      } else if (import->base == "call-ref-catch") {
        try {
          callRefAsJS(arguments[0]);
          return {Literal(int32_t(0))};
        } catch (const WasmException& e) {
          return {Literal(int32_t(1))};
        }
      } else if (import->base == "sleep") {
        // Do not actually sleep, just return the id.
        return {arguments[1]};
      } else {
        WASM_UNREACHABLE("unknown fuzzer import");
      }
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

  void throwJSException() {
    // JS exceptions contain an externref. Use the same type of value as a JS
    // exception would have, which is a reference to an object, and which will
    // print out "object" in the logging from JS. A trivial struct is enough for
    // us to log the same thing here.
    auto empty = HeapType(Struct{});
    auto inner = Literal(std::make_shared<GCData>(empty, Literals{}), empty);
    Literals arguments = {inner.externalize()};
    auto payload = std::make_shared<ExnData>(jsTag, arguments);
    throwException(WasmException{Literal(payload)});
  }

  Literals callExportAsJS(Index index) {
    if (index >= wasm.exports.size()) {
      // No export.
      throwJSException();
    }
    auto& exp = wasm.exports[index];
    if (exp->kind != ExternalKind::Function) {
      // No callable export.
      throwJSException();
    }
    return callFunctionAsJS(*exp->getInternalName());
  }

  Literals callRefAsJS(Literal ref) {
    if (!ref.isFunction()) {
      // Not a callable ref.
      throwJSException();
    }
    return callFunctionAsJS(ref.getFunc());
  }

  // Call a function in a "JS-ey" manner, adding arguments as needed, and
  // throwing if necessary, the same way JS does.
  Literals callFunctionAsJS(Name name) {
    auto* func = wasm.getFunction(name);

    // Send default values as arguments, or error if we need anything else.
    Literals arguments;
    for (const auto& param : func->getParams()) {
      // An i64 param can work from JS, but fuzz_shell provides 0, which errors
      // on attempts to convert it to BigInt. v128 and exnref are disalloewd.
      if (param == Type::i64 || param == Type::v128 || param.isExn()) {
        throwJSException();
      }
      if (!param.isDefaultable()) {
        throwJSException();
      }
      arguments.push_back(Literal::makeZero(param));
    }

    // Error on illegal results. Note that this happens, as per JS semantics,
    // *before* the call.
    for (const auto& result : func->getResults()) {
      // An i64 result is fine: a BigInt will be provided. But v128 and exnref
      // still error.
      if (result == Type::v128 || result.isExn()) {
        throwJSException();
      }
    }

    // Call the function.
    auto flow = instance->callFunction(func->name, arguments);
    // Suspending through JS is not valid.
    if (flow.suspendTag) {
      throwJSException();
    }
    return flow.values;
  }

  void setModuleRunner(ModuleRunner* instance_) { instance = instance_; }
};

// gets execution results from a wasm module. this is useful for fuzzing
//
// we can only get results when there are no imports. we then call each method
// that has a result, with some values
struct ExecutionResults {
  struct Trap {};
  struct Exception {};
  using FunctionResult = std::variant<Literals, Trap, Exception>;
  std::map<Name, FunctionResult> results;
  Loggings loggings;

  // If set, we should ignore this and not compare it to anything.
  bool ignore = false;

  // get results of execution
  void get(Module& wasm) {
    LoggingExternalInterface interface(loggings, wasm);
    try {
      ModuleRunner instance(wasm, &interface);
      // This is not an optimization: we want to execute anything, even relaxed
      // SIMD instructions.
      instance.setRelaxedBehavior(ModuleRunner::RelaxedBehavior::Execute);
      instance.instantiate();
      interface.setModuleRunner(&instance);
      // execute all exported methods (that are therefore preserved through
      // opts)
      for (auto& exp : wasm.exports) {
        if (exp->kind != ExternalKind::Function) {
          continue;
        }
        std::cout << "[fuzz-exec] calling " << exp->name << "\n";
        auto* func = wasm.getFunction(*exp->getInternalName());
        FunctionResult ret = run(func, wasm, instance);
        results[exp->name] = ret;
        if (auto* values = std::get_if<Literals>(&ret)) {
          // ignore the result if we hit an unreachable and returned no value
          if (values->size() > 0) {
            std::cout << "[fuzz-exec] note result: " << exp->name << " => ";
            for (auto value : *values) {
              printValue(value);
            }
          }
        }
      }
    } catch (const TrapException&) {
      // May throw in instance creation (init of offsets).
    } catch (const HostLimitException&) {
      // May throw in instance creation (e.g. array.new of huge size).
      // This should be ignored and not compared with, as optimizations can
      // change whether a host limit is reached.
      ignore = true;
    }
  }

  void printValue(Literal value) {
    // Unwrap an externalized GC value to get the actual value, but not strings,
    // which are normally a subtype of ext.
    if (Type::isSubType(value.type, Type(HeapType::ext, Nullable)) &&
        !value.type.isString()) {
      value = value.internalize();
    }

    // An anyref literal is a string.
    if (value.type.isRef() &&
        value.type.getHeapType().isMaybeShared(HeapType::any)) {
      value = value.externalize();
    }

    // Don't print most reference values, as e.g. funcref(N) contains an index,
    // which is not guaranteed to remain identical after optimizations. Do not
    // print the type in detail (as even that may change due to closed-world
    // optimizations); just print a simple type like JS does, 'object' or
    // 'function', but also print null for a null (so a null function does not
    // get printed as object, as in JS we have typeof null == 'object').
    //
    // The only references we print in full are strings and i31s, which have
    // simple and stable internal structures that optimizations will not alter.
    auto type = value.type;
    if (type.isRef()) {
      if (type.isString() || type.getHeapType().isMaybeShared(HeapType::i31)) {
        std::cout << value << '\n';
      } else if (value.isNull()) {
        std::cout << "null\n";
      } else if (type.isFunction()) {
        std::cout << "function\n";
      } else {
        std::cout << "object\n";
      }
      return;
    }

    // Non-references can be printed in full.
    std::cout << value << '\n';
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
    // Don't compare references. There are several issues here that we can't
    // fully handle, see https://github.com/WebAssembly/binaryen/issues/3378,
    // but the core issue is that since we optimize assuming a closed world, the
    // types and structure of GC data can arbitrarily change after
    // optimizations, even in ways that are externally visible from outside
    // the module.
    //
    // We can, however, compare strings as they refer to simple data that has a
    // consistent representation (the same reasons as why we can print them in
    // printValue(), above).
    //
    // TODO: Once we support optimizing under some form of open-world
    // assumption, we should be able to check that the types and/or structure of
    // GC data passed out of the module does not change.
    if (a.type.isRef() && !a.type.isString() &&
        !a.type.getHeapType().isMaybeShared(HeapType::i31)) {
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
    if (ignore || other.ignore) {
      std::cout << "ignoring comparison of ExecutionResults!\n";
      return true;
    }
    for (auto& [name, _] : other.results) {
      if (results.find(name) == results.end()) {
        std::cout << "[fuzz-exec] missing " << name << '\n';
        return false;
      }
      std::cout << "[fuzz-exec] comparing " << name << '\n';
      if (results[name].index() != other.results[name].index()) {
        return false;
      }
      auto* values = std::get_if<Literals>(&results[name]);
      auto* otherValues = std::get_if<Literals>(&other.results[name]);
      if (values && otherValues && !areEqual(*values, *otherValues)) {
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

  FunctionResult run(Function* func, Module& wasm, ModuleRunner& instance) {
    // Clear the continuation state after each run of an export.
    struct CleanUp {
      ModuleRunner& instance;
      CleanUp(ModuleRunner& instance) : instance(instance) {}
      ~CleanUp() { instance.clearContinuationStore(); }
    } cleanUp(instance);

    try {
      // call the method
      Literals arguments;
      for (const auto& param : func->getParams()) {
        // zeros in arguments TODO: more?
        if (!param.isDefaultable()) {
          std::cout << "[trap fuzzer can only send defaultable parameters to "
                       "exports]\n";
          return Trap{};
        }
        arguments.push_back(Literal::makeZero(param));
      }
      auto flow = instance.callFunction(func->name, arguments);
      if (flow.suspendTag) {
        std::cout << "[exception thrown: unhandled suspend]" << std::endl;
        return Exception{};
      }
      return flow.values;
    } catch (const TrapException&) {
      return Trap{};
    } catch (const WasmException& e) {
      std::cout << "[exception thrown: " << e << "]" << std::endl;
      return Exception{};
    } catch (const HostLimitException&) {
      // This should be ignored and not compared with, as optimizations can
      // change whether a host limit is reached.
      ignore = true;
      return {};
    }
  }
};

} // namespace wasm
