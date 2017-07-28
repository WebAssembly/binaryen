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

namespace wasm {

static void verifyBitwiseEqual(Literal a, Literal b) {
  if (a == b) return;
  // accept equal nans if equal in all bits
  assert(a.type == b.type);
  if (a.type == f32) {
    assert(a.reinterpreti32() == b.reinterpreti32());
  } else if (a.type == f64) {
    assert(a.reinterpreti64() == b.reinterpreti64());
  } else {
    abort();
  }
}

// gets execution results from a wasm module. this is useful for fuzzing
//
// we can only get results when there are no imports. we then call each method
// that has a result, with some values
struct ExecutionResults {
  std::map<Name, Literal> results;

  // get results of execution
  void get(Module& wasm) {
    if (wasm.imports.size() > 0) {
      std::cout << "[fuzz-exec] imports, so quitting\n";
      return;
    }
    auto* hangLimitInitializer = wasm.getFunctionOrNull("hangLimitInitializer");
    for (auto& func : wasm.functions) {
      // init hang detection, if present
      if (hangLimitInitializer) {
        std::cout << "[fuzz-exec] init hang limit\n";
        run(hangLimitInitializer, wasm);
      }
      if (func->result != none) {
        // this has a result
        results[func->name] = run(func.get(), wasm);
        std::cout << "[fuzz-exec] note result: " << func->name.str << " => " << results[func->name] << '\n';
      } else {
        // no result, run it anyhow (it might modify memory etc.)
        run(func.get(), wasm);
        std::cout << "[fuzz-exec] no result for void func: " << func->name.str << '\n';
      }
    }
    std::cout << "[fuzz-exec] " << results.size() << " results noted\n";
  }

  // get current results and check them against previous ones
  void check(Module& wasm) {
    ExecutionResults optimizedResults;
    optimizedResults.get(wasm);
    if (optimizedResults != *this) {
      std::cout << "[fuzz-exec] optimization passes changed execution results";
      abort();
    }
    std::cout << "[fuzz-exec] results match\n";
  }

  bool operator==(ExecutionResults& other) {
    for (auto& iter : results) {
      auto name = iter.first;
      if (other.results.find(name) != other.results.end()) {
        verifyBitwiseEqual(results[name], other.results[name]);
      }
    }
    return true;
  }

  bool operator!=(ExecutionResults& other) {
    return !((*this) == other);
  }

  Literal run(Function* func, Module& wasm) {
    ShellExternalInterface interface;
    try {
      ModuleInstance instance(wasm, &interface);
      LiteralList arguments;
      for (WasmType param : func->params) {
        // zeros in arguments TODO: more?
        arguments.push_back(Literal(param));
      }
      return instance.callFunction(func->name, arguments);
    } catch (const TrapException&) {
      // may throw in instance creation (init of offsets) or call itself
      return Literal();
    }
  }
};

} // namespace wasm

