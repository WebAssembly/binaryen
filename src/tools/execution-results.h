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

#include <deque>
#include <memory>

#include "ir/import-names.h"
#include "ir/import-utils.h"
#include "shell-interface.h"
#include "support/utilities.h"
#include "wasm-type.h"
#include "wasm.h"

namespace wasm {

namespace {

using Loggings = std::vector<Literal>;

Tag& getWasmTag() {
  static Tag tag = []() {
    Tag tag;
    tag.module = "fuzzing-support";
    tag.base = "wasmtag";
    tag.name = "imported-wasm-tag";
    tag.type = Signature(Type::i32, Type::none);

    return tag;
  }();
  return tag;
}

Tag& getJsTag() {
  static Tag tag = []() {
    Tag tag;
    tag.module = "fuzzing-support";
    tag.base = "jstag";
    tag.name = "imported-js-tag";
    tag.type = Signature(Type(HeapType::ext, Nullable), Type::none);
    return tag;
  }();
  return tag;
}

constexpr Index jsErrorPayload = 0xbad;

void printValue(Literal value) {
  // Don't print most reference values, as e.g. funcref(N) contains an index,
  // which is not guaranteed to remain identical after optimizations. Do not
  // print the type in detail (as even that may change due to closed-world
  // optimizations); just print a simple type like JS does, 'object' or
  // 'function', but also print null for a null (so a null function does not
  // get printed as object, as in JS we have typeof null == 'object').
  //
  // The only references we print in full are strings and i31s, which have
  // simple and stable internal structures that optimizations will not alter.
  //
  // Non-references can be printed in full.
  if (!value.type.isRef()) {
    std::cout << value;
    return;
  }
  value = value.unwrap();
  auto heapType = value.type.getHeapType();
  if (heapType.isMaybeShared(HeapType::ext) &&
      value.getExternPayload() == jsErrorPayload) {
    std::cout << "jserror";
    return;
  }
  if (heapType.isString() || heapType.isMaybeShared(HeapType::ext) ||
      heapType.isMaybeShared(HeapType::i31)) {
    std::cout << value;
  } else if (value.isNull()) {
    std::cout << "null";
  } else if (heapType.isFunction()) {
    std::cout << "function";
  } else {
    // Print 'object' and its JS-visible prototype, which may be null.
    std::cout << "object(";
    printValue(value.getJSPrototype());
    std::cout << ')';
  }
}

} // namespace

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

  // The imported fuzzing tag for wasm.
  const Tag& wasmTag;

  // The imported tag for js exceptions.
  const Tag& jsTag;

  // The ModuleRunner and this ExternalInterface end up needing links both ways,
  // so we cannot init this in the constructor.
  ModuleRunner* instance = nullptr;

public:
  LoggingExternalInterface(
    Loggings& loggings,
    Module& wasm,
    std::map<Name, std::shared_ptr<ModuleRunner>> linkedInstances_ = {})
    : ShellExternalInterface(linkedInstances_), loggings(loggings), wasm(wasm),
      wasmTag(getWasmTag()), jsTag(getJsTag()) {
    for (auto& exp : wasm.exports) {
      if (exp->kind == ExternalKind::Table && exp->name == "table") {
        exportedTable = *exp->getInternalName();
        break;
      }
    }
  }

  Literal getImportedFunction(Function* import) override {
    if (linkedInstances.count(import->module)) {
      return getImportInstance(import)->getExportedFunction(import->base);
    }
    auto f = [import, this](const Literals& arguments) -> Flow {
      if (import->module == "fuzzing-support") {
        if (import->base.startsWith("log")) {
          // This is a logging function like log-i32 or log-f64.
          std::cout << "[LoggingExternalInterface ";
          if (import->base == "log-branch") {
            // Report this as a special logging, so we can differentiate it
            // from the others in the fuzzer.
            std::cout << "log-branch";
          } else {
            // All others are just reported as loggings.
            std::cout << "logging";
          }
          loggings.push_back(Literal()); // buffer with a None between calls
          for (auto argument : arguments) {
            if (argument.type == Type::i64) {
              // To avoid JS legalization changing logging results, treat a
              // logging of an i64 as two i32s (which is what legalization
              // would turn us into).
              auto low = Literal(int32_t(argument.getInteger()));
              auto high =
                Literal(int32_t(argument.getInteger() >> int32_t(32)));
              std::cout << ' ' << low;
              loggings.push_back(low);
              std::cout << ' ' << high;
              loggings.push_back(high);
            } else {
              std::cout << ' ';
              printValue(argument);
              loggings.push_back(argument);
            }
          }
          std::cout << "]\n";
          return {};
        } else if (import->base == "throw") {
          // Throw something, depending on the value of the argument. 0 means
          // we should throw a JS exception, and any other value means we
          // should throw a wasm exception (with that value as the payload).
          if (arguments[0].geti32() == 0) {
            throwJSException();
          } else {
            auto payload = std::make_shared<ExnData>(&wasmTag, arguments);
            throwException(WasmException{Literal(payload)});
          }
        } else if (import->base == "table-get") {
          // Check for errors here, duplicating tableLoad(), because that will
          // trap, and we just want to throw an exception (the same as JS
          // would).
          if (!exportedTable) {
            throwJSException();
          }
          auto index = arguments[0].getUnsigned();
          auto* table = instance->allTables[exportedTable];
          if (index >= table->size()) {
            throwJSException();
          }
          return table->get(index);
        } else if (import->base == "table-set") {
          if (!exportedTable) {
            throwJSException();
          }
          auto index = arguments[0].getUnsigned();
          auto* table = instance->allTables[exportedTable];
          if (index >= table->size()) {
            throwJSException();
          }
          table->set(index, arguments[1]);
          return {};
        } else if (import->base == "call-export") {
          callExportAsJS(arguments[0].geti32());
          // The second argument determines if we should catch and rethrow
          // exceptions. There is no observable difference in those two modes
          // in the binaryen interpreter, so we don't need to do anything.

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
      // Anything else, we ignore.
      std::cerr << "[LoggingExternalInterface ignoring an unknown import "
                << import->module << " . " << import->base << '\n';
      return {};
    };
    // Use a null instance because this is a host function.
    return Literal(std::make_shared<FuncData>(import->name, nullptr, f),
                   import->type);
  }

  void throwJSException() {
    // JS exceptions contain an externref.
    Literals arguments = {Literal::makeExtern(jsErrorPayload, Unshared)};
    auto payload = std::make_shared<ExnData>(&jsTag, arguments);
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
    auto funcName = *exp->getInternalName();
    return callFunctionAsJS(
      [&](Literals arguments) {
        return instance->callFunction(funcName, arguments);
      },
      wasm.getFunction(funcName)->type.getHeapType());
  }

  Literals callRefAsJS(Literal ref) {
    if (!ref.isFunction()) {
      // Not a callable ref.
      throwJSException();
    }
    return callFunctionAsJS(
      [&](Literals arguments) { return ref.getFuncData()->doCall(arguments); },
      ref.type.getHeapType());
  }

  // Call a function in a "JS-ey" manner, adding arguments as needed, and
  // throwing if necessary, the same way JS does. We are given a method that
  // does the actual call, and the type we are calling.
  Literals callFunctionAsJS(std::function<Flow(Literals)> doCall,
                            HeapType type) {
    auto sig = type.getSignature();

    // Send default values as arguments, or error if we need anything else.
    Literals arguments;
    for (const auto& param : sig.params) {
      // An i64 param can work from JS, but fuzz_shell provides 0, which errors
      // on attempts to convert it to BigInt. Also trap on v128 etc.
      if (param == Type::i64 || trapsOnJSBoundary(param)) {
        throwJSException();
      }
      if (!param.isDefaultable()) {
        throwJSException();
      }
      arguments.push_back(Literal::makeZero(param));
    }

    // Error on illegal results. Note that this happens, as per JS semantics,
    // *before* the call.
    for (const auto& result : sig.results) {
      // An i64 result is fine: a BigInt will be provided. But v128 and
      // [null]exnref still error.
      if (trapsOnJSBoundary(result)) {
        throwJSException();
      }
    }

    // Call the function.
    auto flow = doCall(arguments);
    // Suspending through JS is not valid. This traps - it does not throw a
    // catchable JS exception.
    if (flow.suspendTag) {
      trap("suspend through JS");
    }
    return flow.values;
  }

  bool trapsOnJSBoundary(Type type) {
    if (type == Type::v128) {
      return true;
    }
    if (type.isRef()) {
      // Exnref and [null][exn|cont]ref trap.
      HeapType top = type.getHeapType().getTop();
      if (top.isMaybeShared(HeapType::exn) ||
          top.isMaybeShared(HeapType::cont)) {
        return true;
      }
    }
    return false;
  }

  void setModuleRunner(ModuleRunner* instance_) { instance = instance_; }
};

class FuzzerImportResolver
  : public LinkedInstancesImportResolver<ModuleRunner> {
  using LinkedInstancesImportResolver::LinkedInstancesImportResolver;

  // We can synthesize imported externref globals. Use a deque for stable
  // addresses.
  mutable std::deque<Literals> synthesizedGlobals;

  Tag* getTagOrNull(ImportNames name, const Signature& type) const override {
    if (name.module == "fuzzing-support") {
      if (name.name == "wasmtag") {
        return &wasmTag;
      }
      if (name.name == "jstag") {
        return &jsTag;
      }
    }

    return LinkedInstancesImportResolver::getTagOrNull(name, type);
  }

  virtual Literals*
  getGlobalOrNull(ImportNames name, Type type, bool mut) const override {
    // First look for globals available from linked instances.
    if (auto* global =
          LinkedInstancesImportResolver<ModuleRunner>::getGlobalOrNull(
            name, type, mut)) {
      return global;
    }
    // This is not a known global, but the fuzzer supports synthesizing
    // immutable externref global imports.
    // TODO: Figure out how to share this logic with TranslateToFuzzReader.
    // TODO: Support other types.
    if (mut || !type.isRef() || type.getHeapType() != HeapType::ext) {
      return nullptr;
    }
    // Optimizations may reorder or remove imports, so we need a distinct
    // payload that is independent of the import order. Just compute a simple
    // payload integer from the import names. This must be kept in sync with
    // fuzz_shell.js.
    Index payload = 0;
    for (auto name : {name.module, name.name}) {
      for (auto c : name.str) {
        payload = (payload + static_cast<Index>(c)) % 251;
      }
    }
    synthesizedGlobals.emplace_back(
      Literals{Literal::makeExtern(payload, Unshared)});
    return &synthesizedGlobals.back();
  }

private:
  Tag& wasmTag = getWasmTag();
  Tag& jsTag = getJsTag();
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

  // Execute a module and collect the results. Optionally, provide a second
  // module to link with it (like fuzz_shell's second module).
  void collect(Module& wasm, Module* second = nullptr) {
    try {
      // Instantiate the first module.
      LoggingExternalInterface interface(loggings, wasm);

      // `linkedInstances` is empty at this point and the below constructors
      // make copies.
      std::map<Name, std::shared_ptr<ModuleRunner>> linkedInstances;
      auto instance = std::make_shared<ModuleRunner>(
        wasm,
        &interface,
        linkedInstances,
        std::make_shared<FuzzerImportResolver>(linkedInstances));
      instantiate(*instance, interface);

      // Instantiate the second, if there is one (we instantiate both before
      // running anything, so that we match the behavior of fuzz_shell.js).
      std::unique_ptr<LoggingExternalInterface> secondInterface;
      std::shared_ptr<ModuleRunner> secondInstance;
      if (second) {
        // Link and instantiate the second module.
        linkedInstances["primary"] = instance;
        secondInterface = std::make_unique<LoggingExternalInterface>(
          loggings, *second, linkedInstances);
        secondInstance = std::make_shared<ModuleRunner>(
          *second, secondInterface.get(), linkedInstances);
        instantiate(*secondInstance, *secondInterface);
      }

      // Run.
      callExports(wasm, *instance);
      if (second) {
        std::cout << "[fuzz-exec] running second module\n";
        callExports(*second, *secondInstance);
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

  void instantiate(ModuleRunner& instance,
                   LoggingExternalInterface& interface) {
    // This is not an optimization: we want to execute anything, even relaxed
    // SIMD instructions.
    instance.setRelaxedBehavior(ModuleRunner::RelaxedBehavior::Execute);
    instance.instantiate();
    interface.setModuleRunner(&instance);
  }

  void callExports(Module& wasm, ModuleRunner& instance) {
    // execute all exported methods (that are therefore preserved through
    // opts)
    for (auto& exp : wasm.exports) {
      if (exp->kind == ExternalKind::Function) {
        std::cout << "[fuzz-exec] export " << exp->name << "\n";
        auto* func = wasm.getFunction(*exp->getInternalName());
        FunctionResult ret = run(func, wasm, instance);
        results[exp->name] = ret;
        if (auto* values = std::get_if<Literals>(&ret)) {
          // ignore the result if we hit an unreachable and returned no value
          if (values->size() > 0) {
            std::cout << "[fuzz-exec] note result: " << exp->name << " => ";
            for (auto value : *values) {
              printValue(value);
              std::cout << '\n';
            }
          }
        }
      } else if (exp->kind == ExternalKind::Global) {
        // Log the global's value.
        std::cout << "[fuzz-exec] export " << exp->name << "\n";
        Literals* value = instance.getExportedGlobalOrNull(exp->name);
        assert(value);
        assert(value->size() == 1);
        std::cout << "[LoggingExternalInterface logging ";
        printValue((*value)[0]);
        std::cout << "]\n";
      }
      // Ignore other exports for now. TODO
    }
  }

  // get current results and check them against previous ones
  void check(Module& wasm) {
    ExecutionResults optimizedResults;
    optimizedResults.collect(wasm);
    if (optimizedResults != *this) {
      std::cout << "[fuzz-exec] optimization passes changed results\n";
      exit(1);
    }
  }

  bool areEqual(Literal a, Literal b) {
    // Only compare some references. In general the optimizer may change
    // identities and structures of functions, types, and GC values in ways that
    // are not externally observable. We must therefore limit ourselves to
    // comparing information that _is_ externally observable.
    //
    // TODO: We could compare more information when we know it will be
    // externally visible, for example when the type of the value is public.
    if (!a.type.isRef() || !b.type.isRef()) {
      return a == b;
    }
    // The environment always sees externalized references and is able to
    // observe the difference between external references and externalized
    // internal references. Make sure this is accounted for below by unrapping
    // the references.
    a = a.unwrap();
    b = b.unwrap();
    auto htA = a.type.getHeapType();
    auto htB = b.type.getHeapType();
    // What type hierarchy a heap type is in is generally observable.
    if (htA.getTop() != htB.getTop()) {
      return false;
    }
    // Null values are observable.
    if (htA.isBottom() || htB.isBottom()) {
      return a == b;
    }
    // String values are observable.
    if (htA.isString() || htB.isString()) {
      return a == b;
    }
    // i31 values are observable.
    if (htA.isMaybeShared(HeapType::i31) || htB.isMaybeShared(HeapType::i31)) {
      return a == b;
    }
    // External references are observable. (These cannot be externalized
    // internal references because they've already been unwrapped.)
    if (htA.isMaybeShared(HeapType::ext) || htB.isMaybeShared(HeapType::ext)) {
      return a == b;
    }
    // Configured prototypes are observable. Even if they are also opaque Wasm
    // references, their having different pointer identities is observable.
    // However, we have no way of comparing pointer identities across
    // executions, so just recursively look for externally observable
    // differences in the prototypes.
    if (!areEqual(a.getJSPrototype(), b.getJSPrototype())) {
      return false;
    }

    // Other differences are not observable, so conservatively consider the
    // values equal.
    return true;
  }

  bool areEqual(Literals a, Literals b) {
    if (a.size() != b.size()) {
      std::cout << "literal counts not identical! " << a << " != " << b << '\n';
      return false;
    }
    for (Index i = 0; i < a.size(); i++) {
      if (!areEqual(a[i], b[i])) {
        std::cout << "values not identical! " << a[i] << " != " << b[i] << '\n';
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
      auto& exn = *e.exn.getExnData();
      std::cout << "[exception thrown: " << exn.tag->name;
      for (auto val : exn.payload) {
        std::cout << ' ';
        printValue(val);
      }
      std::cout << "]" << std::endl;
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
