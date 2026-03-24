/*
 * Copyright 2026 WebAssembly Community Group participants
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
// Automatically batch calls to imports. This can be useful to reduce overhead
// on the wasm/JS boundary. For example, consider this code:
//
//   gl_bind_buffer(10, 20);
//   gl_run_shader(123);
//
// If each of these is a call to a JS import, then we cross the wasm/JS
// boundary twice. Instead, we can serialize the commands we want to run on the
// JS side, and call out once to JS, then read the buffer and execute them both,
// doing a single boundary crossing. If there are very many crossings, this
// batching can be worthwhile.
//
// The idea of batching Web API calls is used in Emscripten's GL proxying,
//
//   https://github.com/emscripten-core/emscripten/tree/main/system/lib/gl
//
// where most functions are proxied in an async way to the main thread, which
// means the calling thread effectively only "flushes" the command buffer when
// we need to execute a synchronous method. The WebCC project does this as well,
//
//   https://github.com/io-eric/webcc/blob/main/docs/architecture.md#architecture
//
// This AutoBatch pass is different in that it *automatically* batches calls,
// without a fixed set of APIs that it recognizes. Whenever it sees an import,
//
//   * If the import has no return value, it wraps it in a function that
//     serializes it to the command buffer.
//   * If the import does have a return value, the wrapper flushes the command
//     buffer before calling it.
//
// The serialization format, and the code to serialize in wasm and deserialize
// in JS, is all generated based on the actual imports seen in the wasm. This
// avoids the "big switch of calls" problem that such proxying/serialization
// implementations usually have, where they map integer IDs to functions to be
// called, which has the result of keeping all those functions alive (since it
// doesn't see the integer IDs actually used at runtime).
//
//   --pass-arg=asyncify-asserts
//
//      This enables extra asserts in the output, like checking if we exceed the
//      size of the command buffer.
//
// TODO: flags to control special exports etc.
//

#include "ir/names.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

struct AutoBatch : public Pass {
  AutoBatch() {}

  // The function imports, in order. This maps ids to names.
  std::vector<Name> imports;
  // The reverse map of import names to ids.
  std::unordered_map<Name, Index> importIds;

  bool asserts;

  void run(Module* module) override {
    asserts = hasArgument("autobatch-asserts")

    // Build the mapping of integer ID to imports.
    for (auto& func : module->functions) {
      Index id = imports.size();
      imports.push_back(func->name);
      importIds[func->name] = id;
    }

    // Wrap every import.
    for (auto& func : module->functions) {
      if (func->imported()) {
        if (func->getResults() == Type::none) {
          wrapNonReturning(func.get());
        } else {
          wrapReturning(func.get());
        }
      }
    }
  }


  // Wrap a function that does not return a result. We add it to the command
  // buffer.
  void wrapNonReturning(Function* func) {
  }
};

} // anonymous namespace

Pass* createAutoBatchPass() { return new AutoBatch(); }

} // namespace wasm
