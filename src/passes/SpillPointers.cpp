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
// Spills values that might be pointers to the C stack. This allows
// Boehm-style GC to see them properly.
//
// To reduce the overhead of the extra operations added here, you
// should probably run optimizations after doing it.
// TODO: add a dead store elimination pass, which would help here
//
//  * There is currently no check that there is enough stack space.
//

#include "abi/stack.h"
#include "cfg/liveness-traversal.h"
#include "ir/import-utils.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

struct SpillPointers
  : public WalkerPass<LivenessWalker<SpillPointers, Visitor<SpillPointers>>> {
  bool isFunctionParallel() override { return true; }

  // Adds writes to memory.
  bool addsEffects() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<SpillPointers>();
  }

  // a mapping of the pointers to all the spillable things. We need to know
  // how to replace them, and as we spill we may modify them. This map
  // gives us, for an Expression** seen during the walk (and placed in the
  // basic block, which is what we iterate on for efficiency) => the
  // current actual pointer, which may have moded
  std::unordered_map<Expression**, Expression**> actualPointers;

  // note calls in basic blocks
  template<typename T> void visitSpillable(T* curr) {
    // if in unreachable code, ignore
    if (!currBasicBlock) {
      return;
    }
    auto* pointer = getCurrentPointer();
    currBasicBlock->contents.actions.emplace_back(pointer);
    // starts out as correct, may change later
    actualPointers[pointer] = pointer;
  }

  void visitCall(Call* curr) { visitSpillable(curr); }
  void visitCallIndirect(CallIndirect* curr) { visitSpillable(curr); }

  static bool isBlacklistedFunctionName(const Name &n)
  {
    const char *blacklisted[] = {
      // These functions need to be blacklisted for correctness: we cannot
      // let the spill pointers pass create a temp stack frame to these functions,
      // or the stackRestore/stackAlloc functions would become no-ops.
      "stackAlloc",
      "stackRestore",

      // This needs to be blacklisted, or core0.test_pthread_dylink_basics fails. Not immediately sure why that is.
      "_emscripten_tls_init",

      // The following functions are blacklisted for performance optimization reasons: (and testing/debugging reasons.. not intended to be final code in any form)
      // These won't ever deal with managed GC pointers, so we can get slightly
      // improved codegen performance by skipping these.
      "stackSave",
      "_emscripten_thread_init",
      "dlmalloc",
      "dlrealloc",
      "dlfree",
      "tmalloc_small",
      "prepend_alloc",
      "sbrk",
      "__emscripten_init_main_thread",
      "__memcpy",
      "__funcs_on_exit",
      "start_multithreaded_collection",
      "gc_collect",
      "_emscripten_proxy_main",
      "emscripten_proxy_async",
      "init_pthread_self",
      "gc_participate_to_garbage_collection",
      "find_and_run_a_finalizer",
      "sweep",
      "gc_enter_fenced_access",
      "gc_malloc",
      "realloc_zeroed",
      "gc_uninterrupted_sleep",
      "gc_sleep",
      "mark_from_queue",
      "wait_for_all_threads_finished_marking",
      "mark",
      "gc_sleep",
      "gc_enter_fence_cb",
      "internal_memalign",
      "realloc_table",
      "dlcalloc",
      "find_insert_index",
      "find_index",
      "free_at_index",
      "find_finalizer_index",
      "mark_current_thread_stack",
      "gc_dump",
      "table_insert",
      "gc_is_ptr",

      "getpid",
      "out",
      "frexp",
      "wctomb",
      "fwrite",
      "fputs",
      "vfprintf",
      "pop_arg_long_double",
      "strnlen",
      "wcrtomb",
      "printf",
      "puts",
      "pop_arg",
      "pad",
      "fflush",
      "printf_core",
      "fmt_fp",      
    };
    for(int i = 0; i < sizeof(blacklisted)/sizeof(blacklisted[0]); ++i)
      if (n == blacklisted[i]) return true;
    return false;
  }

  // main entry point

  int numPointersSpilledTotal = 0;
  int numFunctionsPointersSpilled = 0, numFunctionsPointersNotSpilled = 0, numFunctionsBlacklisted = 0;
  int numPointersSpilled;
  int extraStackSpace;

  void doWalkFunction(Function* func) {
    super::doWalkFunction(func);
    if (isBlacklistedFunctionName(func->name)
      // The passes/SafeHeap.cpp pass replaces assignments with function calls, but the functions that call into SAFE_HEAP might not generate a stack frame (bump stack_pointer)
      // for themselves if they don't call any other functions. This would cause pointer spilling inside SAFE_HEAP_ to stomp on the stack of the caller. So we must skip pointer
      // spilling inside these dynamically code generated SAFE_HEAP functions (i.e. this is needed for correctness, but of course also good for performance in SAFE_HEAP mode)
      || func->name.startsWith("SAFE_HEAP")

      // The following are blacklisted for performance optimizations only:
      || func->name.startsWith("em_task_")
      || func->name.startsWith("_emscripten_thread_")
      || func->name.startsWith("_pthread")
      || func->name.startsWith("__pthread")
      || func->name.startsWith("__wasm")
      || func->name.startsWith("__wasi")
      || func->name.startsWith("emscripten")
      || func->name.startsWith("_emscripten")
      || func->name.startsWith("pthread")
      || func->name.startsWith("emmalloc")
      || func->name.startsWith("legalstub$")
      || func->name.startsWith("dynCall_")
      || func->name.startsWith("__")

)
    {
      ++numFunctionsBlacklisted;
      return;
    }
    numPointersSpilledTotal += numPointersSpilled;
    numPointersSpilled = 0;
    extraStackSpace = 0;
    spillPointers();
    if (numPointersSpilled || extraStackSpace)
    {
      ++numFunctionsPointersSpilled;
      printf("SpillPointers: added %d pointer spill stores in function %s. Stack frame grew by %d bytes.\n",
        numPointersSpilled, func->name.str.data(), extraStackSpace);
    }
    else
      ++numFunctionsPointersNotSpilled;
  }

  // map pointers to their offset in the spill area
  using PointerMap = std::unordered_map<Index, Index>;

  Type pointerType;

  /*
  void visitModule(Module* curr) {
    printf("SpillPointers summary: Added a total of %d spill stores to %d/%d (%.2f%%) functions. (%d had nothing to add, %d were blacklisted). Avg spill stores: %.3f per added function, %.3f per all functions in program.\n",
      numPointersSpilledTotal, numFunctionsPointersSpilled, numFunctionsPointersSpilled + numFunctionsBlacklisted + numFunctionsPointersNotSpilled,
      numFunctionsPointersSpilled * 100.0 / (numFunctionsPointersSpilled + numFunctionsBlacklisted + numFunctionsPointersNotSpilled),
      numFunctionsPointersNotSpilled, numFunctionsBlacklisted,
      (double)numPointersSpilledTotal / numFunctionsPointersSpilled,
      (double)numPointersSpilledTotal / (numFunctionsPointersSpilled + numFunctionsBlacklisted + numFunctionsPointersNotSpilled));
  }
  */

  void spillPointers() {
    std::string HANDLE_STACK_OVERFLOW =
      getPassOptions().getArgumentOrDefault("stack-check-handler", "");

    ImportInfo info(*getModule());
    Function* stack_overflow_check =
      info.getImportedFunction(ENV, HANDLE_STACK_OVERFLOW);

    pointerType = getModule()->memories[0]->indexType;

    // we only care about possible pointers
    auto* func = getFunction();
    PointerMap pointerMap;
    for (Index i = 0; i < func->getNumLocals(); i++) {
      if (func->getLocalType(i) == pointerType) {
        auto offset = pointerMap.size() * pointerType.getByteSize();
        pointerMap[i] = offset;
      }
    }
    // find calls and spill around them
    bool spilled = false;
    Index spillLocal = -1;
    for (auto& curr : basicBlocks) {
      if (liveBlocks.count(curr.get()) == 0) {
        continue; // ignore dead blocks
      }
      auto& liveness = curr->contents;
      auto& actions = liveness.actions;
      Index lastCall = -1;
      for (Index i = 0; i < actions.size(); i++) {
        auto& action = liveness.actions[i];
        if (action.isOther()) {
          lastCall = i;
        }
      }
      if (lastCall == Index(-1)) {
        continue; // nothing to see here
      }
      // scan through the block, spilling around the calls
      // TODO: we can filter on pointerMap everywhere
      SetOfLocals live = liveness.end;
      for (int i = int(actions.size()) - 1; i >= 0; i--) {
        auto& action = actions[i];
        if (action.isGet()) {
          live.insert(action.index);
        } else if (action.isSet()) {
          live.erase(action.index);
        } else if (action.isOther()) {
          auto* pointer = actualPointers[action.origin];
          auto* call = *pointer;
          if (call->type == Type::unreachable) {
            continue; // the call is never reached anyhow, ignore
          }

          // Do not spill pointers right before a call to function
          // __handle_stack_overflow(). This does improve performance, but is
          // primarily needed for correctness, to avoid creating a new stack
          // frame inside function stackAlloc(), which should bump the stack
          // pointer of the caller's stack frame, hence it cannot generate a
          // stack frame inside the function itself. By default stackAlloc()
          // does not call any other functions except __handle_stack_overflow().
          // (same for stackRestore() and stackSave()).
          Call* c = static_cast<Call*>(call);
          if (c->target == HANDLE_STACK_OVERFLOW ||
              (stack_overflow_check &&
               c->target == stack_overflow_check->name)) {
            continue;
          }

          std::vector<Index> toSpill;
          for (auto index : live) {
            if (pointerMap.count(index) > 0) {
              toSpill.push_back(index);
            }
          }
          if (!toSpill.empty()) {
            // we now have a call + the information about which locals
            // should be spilled
            if (!spilled) {
              // prepare stack support: get a pointer to stack space big enough
              // for all our data
              spillLocal = Builder::addVar(func, pointerType);
              spilled = true;
            }
            // the origin was seen at walk, but the thing may have moved
            spillPointersAroundCall(
              pointer, toSpill, spillLocal, pointerMap, func, getModule());
          }
        } else {
          WASM_UNREACHABLE("unexpected action");
        }
      }
    }
    if (spilled) {
      // get the stack space, and set the local to it
      auto* stackPointer = getStackPointerGlobal(*getModule());
      if (!stackPointer) {
        printf("SpillPointers: unable to find stack pointer for function %s\n", func->name.str.data());
        return;
      }

      extraStackSpace += pointerType.getByteSize() * pointerMap.size();
      ABI::getStackSpace(spillLocal,
                         func,
                         pointerType.getByteSize() * pointerMap.size(),
                         *getModule());
    }
  }

  void spillPointersAroundCall(Expression** origin,
                               std::vector<Index>& toSpill,
                               Index spillLocal,
                               PointerMap& pointerMap,
                               Function* func,
                               Module* module) {
    auto* call = *origin;
    Builder builder(*module);
    auto* block = builder.makeBlock();
    // move the operands into locals, as we must spill after they are executed
    auto handleOperand = [&](Expression*& operand) {
      auto temp = builder.addVar(func, operand->type);
      auto* set = builder.makeLocalSet(temp, operand);
      block->list.push_back(set);
      block->finalize();
      if (actualPointers.count(&operand) > 0) {
        // this is something we track, and it's moving - update
        actualPointers[&operand] = &set->value;
      }
      operand = builder.makeLocalGet(temp, operand->type);
    };
    if (call->is<Call>()) {
      for (auto*& operand : call->cast<Call>()->operands) {
        handleOperand(operand);
      }
    } else if (call->is<CallIndirect>()) {
      for (auto*& operand : call->cast<CallIndirect>()->operands) {
        handleOperand(operand);
      }
      handleOperand(call->cast<CallIndirect>()->target);
    } else {
      WASM_UNREACHABLE("unexpected expr");
    }
    // add the spills
    for (auto index : toSpill) {
      block->list.push_back(
        builder.makeStore(pointerType.getByteSize(),
                          pointerMap[index],
                          pointerType.getByteSize(),
                          builder.makeLocalGet(spillLocal, pointerType),
                          builder.makeLocalGet(index, pointerType),
                          pointerType,
                          getModule()->memories[0]->name));
    }
    // add the (modified) call
    block->list.push_back(call);
    block->finalize();
    *origin = block;

    numPointersSpilled += toSpill.size();
  }
};

Pass* createSpillPointersPass() { return new SpillPointers(); }

} // namespace wasm
