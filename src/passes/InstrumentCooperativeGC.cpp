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
// Instruments the build with code to log execution at each function
// entry, loop header, and return. This can be useful in debugging, to log out
// a trace, and diff it to another (running in another browser, to
// check for bugs, for example).
//
// The logging is performed by calling an ffi with an id for each
// call site. You need to provide that import on the JS side.
//
// This pass is more effective on flat IR (--flatten) since when it
// instruments say a return, there will be no code run in the return's
// value.
//

#include "asmjs/shared-constants.h"
#include "shared-constants.h"
#include <pass.h>
#include <wasm-builder.h>
#include <wasm.h>

namespace wasm {

Name GC_FUNC("gc_participate_to_garbage_collection");

struct InstrumentCooperativeGC : public WalkerPass<PostWalker<InstrumentCooperativeGC>> {
  // Adds calls to internal function.
  bool addsEffects() override { return true; }

  bool currentFunctionIsBlacklisted;

  bool isBlacklistedFunctionName(const Name &n)
  {
    const char *blacklisted[] = {
      "wait_for_all_participants",
      "start_multithreaded_collection",
      "start_multithreaded_marking",
      "wait_for_all_threads_finished_marking",
      "hash_ptr",
      "find_insert_index",
      "find_index",
      "table_insert",
      "realloc_table",
      "free_at_index",
      "mark",
      "sweep",
      "collect_when_stack_is_empty",
      "hash_finalizer",
      "find_finalizer_index",
      "find_and_run_a_finalizer",
      "insert_finalizer",
      "wait_for_all_participants",
      "start_multithreaded_collection",
      "start_multithreaded_marking",
      "wait_for_all_threads_finished_marking",
      "mark_from_queue",
      "finish_multithreaded_marking",
      "hash_root",
      "insert_root",
      "attempt_allocate",
      "realloc_table",
      "claim_more_memory",
      "main",
      "__wasm_init_memory",
      "__wasm_call_ctors",
      "stackSave",
      "stackRestore",
      "stackAlloc",
      "emscripten_wasm_worker_initialize"
    };
    for(int i = 0; i < sizeof(blacklisted)/sizeof(blacklisted[0]); ++i)
      if (n == blacklisted[i]) return true;
    return false;
  }

  void visitLoop(Loop* curr) {
    if (currentFunctionIsBlacklisted) return;

    Builder builder(*getModule());
    curr->body = builder.makeSequence(
      builder.makeCall(GC_FUNC, {}, Type::none),
      curr->body);
  }

  void visitFunction(Function* curr) {
    currentFunctionIsBlacklisted = (curr->imported() || curr->name.startsWith("gc_") || curr->name.startsWith("__") || 
      curr->name.startsWith("emmalloc_") || curr->name.startsWith("dlmalloc_") ||
      isBlacklistedFunctionName(curr->name));
  }

private:
  Expression* makeIntrumentGCCall(Expression* curr) {
    Builder builder(*getModule());
    return builder.makeSequence(
      builder.makeCall(GC_FUNC, {}, Type::none),
      curr);
  }
};

Pass* createInstrumentCooperativeGCPass() { return new InstrumentCooperativeGC(); }

} // namespace wasm
