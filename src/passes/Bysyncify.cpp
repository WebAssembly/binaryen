/*
 * Copyright 2016 WebAssembly Community Group participants
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
// Bysyncify: async/await style code transformation, that allows pausing
// and resuming. This lets a language support synchronous operations in
// an async manner, for example, you can do a blocking wait, and that will
// be turned into code that unwinds the stack at the "blocking" operation,
// then is able to rewind it back up when the actual async operation
// comples, the so the code appears to have been running synchronously
// all the while.
//
// The approach here is a third-generation design after Emscripten's original
// Asyncify and then Emterpreter-Async approaches:
//
//  * Asyncify rewrote control flow in LLVM IR. A problem is that this causes
//    many more phis to appear, and since we must save locals to the stack,
//    that means the code size increase can be extreme.
//  * Emterpreter-Async avoids any risk of code size increase by running it
//    in a little bytecode VM, which also makes pausing/resuming trivial.
//    Speed is the main downside here, however, the approach did prove that by
//    *selectively* emterpretifying only certain code, many projects can run
//    at full speed - often just the "main loop" must be emterpreted, while
//    high-speed code that it calls, and in which cannot be an async operation,
//    remain at full speed.
//
// Bysyncify's design learns from both of those:
//
//  * The code rewrite is done in Binaryen, that is, at the wasm level. At
//    this level we will only need to save wasm locals, and not LLVM SSA
//    registers which are far more numerous.
//  * We aim for very low but non-zero overhead. Low overhead is very important
//    for obvious reasons, while Emterpreter-Async proved it is tolerable to
//    have *some* overhead, if the transform can be applied selectively.
//
// The specific transform implemented here is simpler than Asyncify but should
// still have low overhead when properly optimized. Asyncify worked at the CFG
// level and added branches from the entry directly to all possible resume
// points. Bysyncify on the other hand does *not* try to get there directly.
// The transformed code looks conceptually like this:
//
//   void foo(int x) {
//     // new prelude
//     if (rewinding) {
//       loadLocals();
//     }
//     // main body starts here
//     if (!rewinding) {
//       // some code we must skip while rewinding
//       x = x + 1;
//       x = x / 2;
//     }
//     if (!rewinding or nextCall() == 0) {
//       bar(x);
//       if (unwinding) {
//         noteUnWound(0);
//         saveLocals();
//         return;
//       }
//     }
//     if (!rewinding) {
//       // more code we must skip while rewinding
//       while (x & 7) {
//         x = x + 1;
//       }
//     }
//     return x;
//   }
//
// The general idea is that while rewinding we just "keep going forward",
// skipping code we should not run. That is, instead of jumping directly
// to the right place, we have ifs that skip along instead. The ifs for
// rewinding and unwinding should be well-predicted, so the overhead should
// not be very high. However, we do need to reach the right location via
// such skipping, which means that in a very large function the rewind
// takes some extra time. On the other hand, though, code that cannot
// unwind or rewind (like that look near the end) can run at full speed.
// Overall, this should allow good performance with small overhead that is
// mostly noticed at rewind time.
//
// After this pass is run a new i32 global "__bysyncify_state" is added, which
// has the following values:
//
//   0: normal execution
//   1: unwinding the stack
//   2: rewinding the stack
//
// There is also "__bysyncify_data" which is normally 0, and that when
// rewinding and unwinding contains a pointer to a data structure with the
// info needed to rewind and unwind:
//
//   {
//     i32  - C stack start
//     i32  - C stack end
//     i32  - current bysyncify stack location
//     i32  - bysyncify stack end
//     i32* - bysyncify stack
//   }
//
// The C stack is the normal C stack (which must be preserved in the case
// of coroutines, but if the same execution frame will be resumed later).
// The bysyncify stack is a representation of the call frame, as a list of
// indexes of calls. In the example above, we saw index "0" for calling "bar"
// from "foo". When unwinding, the indexes are added to the stack; when
// rewinding, they are popped off; the current bysyncify stack location is
// undated while doing both operations. The bysyncify stack is also used to
// save locals. Note that the stack end location is provided, which is for
// error detection.
//
// Usage: Run this pass on your code. Note that it depends on flat IR, so
// you should run --flatten before. (As that pass creates many new locals,
// you probably want to do some flat-preserving optimization afterwards.)
// You can then control things as follows:
//
//  * To unwind, set __bysyncify_state to 1, create a __bysyncify_data buffer,
//    initialize it (set all the fields), and assign it to __bysyncify_data.
//  * To rewind, set __bysyncify_state to 2, and make sure that __bysyncify_data
//    points to the proper buffer.
//
// This pass will create a "bysyncify_set" export which you can call
// from outside, which receives two parameters, for __bysyncify_state and
// __bysyncify_data. TODO make this optional?
//


#include "ir/effects.h"
#include "ir/flat.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

static const Name BYSYNCIFY_STATE = "__bysyncify_state";
static const Name BYSYNCIFY_DATA = "__bysyncify_data";
static const Name BYSYNCIFY_SET = "__bysyncify_set";
static const Name BYSYNCIFY_UNWIND = "bysyncify_unwind";

namespace {

// Check if an expression may alter the bysyncify state, either in itself or
// in something called by it.
static bool mayChangeState(Expression* curr) {
  // TODO: currently this assumes that any calls may change the state, which
  //       could be much improved by globally figuring out which calls may
  //       actually reach relevant code.
  EffectAnalyzer effects(PassOptions(), curr);
  return effects.calls || effects.globalsWritten.count(BYSYNCIFY_STATE);
}

struct BysyncifyFunction : public WalkerPass<PostWalker<BysyncifyFunction>> {
  bool isFunctionParallel() override { return true; }

  BysyncifyFunction* create() override { return new BysyncifyFunction(); }

  void visitCall(Call* curr) {
  }

  void doWalkFunction(Function* func) {
    // If the function cannot change our state, we have nothing to do -
    // we will never unwind or rewind the stack here.
    if (!mayChangeState(func->body)) {
      return;
    }
    Flat::verifyFlatness(func);
    // Rewrite the function body.
    walk(func->body);
    // Emit the final body, including preamble and postamble etc.
    Builder builder(*getModule());
    // After the normal function body, emit a barrier before the postamble.
    Expression* barrier;
    if (func->result == none) {
      // The function may have ended without a return; ensure one.
      barrier = builder.makeReturn();
    } else {
      // The function must have returned or hit an unreachable, but emit one
      // to make possible bugs easier to figure out (as this should never be
      // reached). The optimizer can remove this anyhow.
      barrier = builder.makeUnreachable();
    }
    func->body = builder.makeBlock({
      makeLocalLoading(),
      builder.makeBlock(
        BYSYNCIFY_UNWIND,
        builder.makeSequence(
          func->body,
          barrier
        )
      ),
      makeLocalSaving()
    });
  }

private:
  Expression* makeLocalLoading() {
    Builder builder(*getModule());
    return builder.makeNop();
  }

  Expression* makeLocalSaving() {
    Builder builder(*getModule());
    return builder.makeNop();
  }
};

} // anonymous namespace

struct Bysyncify : public Pass {
  void run(PassRunner* runner, Module* module) override {
    {
      PassRunner runner(module);
      runner.add<BysyncifyFunction>();
      runner.setIsNested(true);
      runner.run();
    }
    addModuleSupport(module);
  }

private:
  void addModuleSupport(Module* module) {
    Builder builder(*module);
    module->addGlobal(builder.makeGlobal(BYSYNCIFY_STATE, i32, builder.makeConst(Literal(int32_t(0))), Builder::Mutable));
    module->addGlobal(builder.makeGlobal(BYSYNCIFY_DATA, i32, builder.makeConst(Literal(int32_t(0))), Builder::Mutable));
    auto* set = builder.makeFunction(BYSYNCIFY_SET, { i32, i32 }, none, {}, builder.makeBlock({
      builder.makeGlobalSet(BYSYNCIFY_STATE, builder.makeLocalGet(0, i32)),
      builder.makeGlobalSet(BYSYNCIFY_DATA, builder.makeLocalGet(1, i32))
    }));
    module->addFunction(set);
    module->addExport(builder.makeExport(BYSYNCIFY_SET, BYSYNCIFY_SET, ExternalKind::Function));
  }
};

Pass* createBysyncifyPass() { return new Bysyncify(); }

} // namespace wasm
