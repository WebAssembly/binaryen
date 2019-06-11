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
//   {                                            // offsets
//     i32  - C stack start                       //  0
//     i32  - C stack end                         //  4
//     i32  - current bysyncify stack location    //  8
//     i32  - bysyncify stack end                 // 12
//     i32* - bysyncify stack data itself         // 16
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
// Usage: Run this pass on your code. You can then control things as follows:
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
#include "ir/literal-utils.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

static const Name BYSYNCIFY_STATE = "__bysyncify_state";
static const Name BYSYNCIFY_DATA = "__bysyncify_data";
static const Name BYSYNCIFY_SET = "__bysyncify_set";
static const Name BYSYNCIFY_UNWIND = "__bysyncify_unwind";

enum class State {
  Normal = 0,
  Unwinding = 1,
  Rewinding = 2
};

enum class DataOffset {
  CStackStart = 0,
  CStackEnd = 4,
  BStackPos = 8,
  BStackEnd = 12,
  BStackData = 16
};

// Check if an expression may alter the bysyncify state, either in itself or
// in something called by it.
static bool mayChangeState(Expression* curr) {
  // TODO: currently this assumes that any calls may change the state, which
  //       could be much improved by globally figuring out which calls may
  //       actually reach relevant code.
  EffectAnalyzer effects(PassOptions(), curr);
  // TODO: look at effects.globalsWritten.count(BYSYNCIFY_STATE);? Currently
  //       this code assumes external code will change the state, so import
  //       calls are really what matters.
  return effects.calls;
}

// Checks if something performs a call: either a direct or indirect call,
// and perhaps it is dropped or assigned to a local.
static bool doesCall(Expression* curr) {
  if (auto* set = curr->dynCast<LocalSet>()) {
    curr = set->value;
  } else if (auto* drop = curr->dynCast<Drop>()) {
    curr = drop->value;
  }
  return curr->is<Call>() || curr->is<CallIndirect>();
}

class BysyncifyBuilder : public Builder {
  Expression* makeGetStackPos() {
    return makeLoad(4, false, int32_t(DataOffset::BStackPos), 4,
      makeGlobalGet(BYSYNCIFY_DATA, i32), i32);
  }
};

// Instrument control flow, around calls and adding skips for rewinding.
struct BysyncifyFlow : public Pass {
  bool isFunctionParallel() override { return true; }

  BysyncifyFlow* create() override { return new BysyncifyFlow(); }

  void runOnFunction(PassRunner* runner, Module* module, Function* func) override {
    // If the function cannot change our state, we have nothing to do -
    // we will never unwind or rewind the stack here.
    if (!mayChangeState(func->body)) {
      return;
    }
    // Rewrite the function body.
    builder = make_unique<BysyncifyBuilder>(*module);
    func->body = process(func->body);
    if (func->result != none) {
      // Rewriting control flow may alter things; make sure the function ends in
      // something valid (which the optimizer can remove later).
      func->body = builder->makeSequence(func->body, builder->makeUnreachable());
    }
    // Making things like returns conditional may alter types.
    ReFinalize().walkFunctionInModule(func, module);
  }

private:
  std::unique_ptr<BysyncifyBuilder> builder;

  // Each call in the function has an index, noted during unwind and checked
  // during rewind.
  Index callIndex = 0;

  Expression* process(Expression* curr) {
    // The IR is in flat form, which makes this much simpler. We basically
    // need to add skips to avoid code when rewinding, and checks around calls
    // with unwinding/rewinding support.
    //
    // Aside from that, we must "linearize" all control flow so that we can
    // reach the right part when unwinding. For example, for an if we do this:
    //
    //    if (condition()) {
    //      side1();
    //    } else {
    //      side2();
    //    }
    // =>
    //    if (!rewinding) {
    //      temp = condition();
    //    }
    //    if (rewinding || temp) {
    //      side1();
    //    }
    //    if (rewinding || !temp) {
    //      side2();
    //    }
    //
    // This way we will linearly get through all the code in the function,
    // if we are rewinding. In a similar way we skip over breaks, etc.; just
    // "keep on truckin'".
    //
    // Note that temp locals added in this way are just normal locals, and in
    // particular they are saved and loaded. That way if we resume from the
    // first if arm we will avoid the second.

    if (auto* block = curr->dynCast<Block>()) {
      // TODO: clump children and their checks.
      for (auto*& item : block->list) {
        item = process(item);
      }
      return block;
    //} else if (auto* iff = curr->dynCast<If>()) {
    //  return iff;
    } else if (doesCall(curr)) {
      return makeCallSupport(curr);
    }
    // We must have handled any control flow before now, and in particular,
    // there cannot be anything that can change the state in our children.
    // As a result, all we need to do here is skip executing this code if we
    // are rewinding.
    assert(!mayChangeState(curr));
    return makeMaybeSkip(curr);
  }

  // Possibly skip some code, if rewinding.
  Expression* makeMaybeSkip(Expression* curr) {
    return builder->makeIf(
      makeStateCheck(State::Normal),
      curr
    );
  }

  Expression* makeCallSupport(Expression* curr) {
    assert(doesCall(curr));
    assert(curr->type == none);
    auto index = callIndex++;
    // Execute the call, if either normal execution, or if rewinding and this is the right
    // call to go into.
    // If we execute
    return builder->makeIf(
      builder->makeIf(
        makeStateCheck(State::Normal),
        builder->makeConst(Literal(int32_t(1))),
        builder->makeIf(
          makeCallIndexPeek(index),
          builder->makeSequence(
            makeCallIndexPop(),
            builder->makeConst(Literal(int32_t(1)))
          ),
          builder->makeConst(Literal(int32_t(0)))
        )
      ),
      builder->makeSequence(
        curr,
        makePossibleUnwind(index)
      )
    );
  }

  Expression* makePossibleUnwind(Index index) {
    // In this pass we emit an "unwind" as a call to a fake intrinsic. We
    // will implement it in the later pass. (We can't create the unwind block
    // target here, as the optimizer would remove it later; we can only add
    // it when we add its contents, later.)
    return builder->makeIf(
      makeStateCheck(State::Unwinding),
      builder->makeCall(BYSYNCIFY_UNWIND, {
        builder->makeConst(Literal(int32_t(index)))
      }, none)
    );
  }

  Expression* makeStateCheck(State value) {
    return builder->makeBinary(
      EqInt32,
      builder->makeGlobalGet(BYSYNCIFY_STATE, i32),
      builder->makeConst(Literal(int32_t(value)))
    );
  }

  Expression* makeCallIndexPeek(Index index) {
    return builder->makeBinary(
      EqInt32,
      builder->makeLoad(4, false, 0, 4, builder->makeGetStackPos(), i32),
      builder->makeConst(Literal(int32_t(index)))
    );
  }

  Expression* makeCallIndexPop() {
    return builder->makeStore(4, int32_t(DataOffset::BStackPos), 4,
      builder->makeGlobalGet(BYSYNCIFY_DATA, i32),
      builder->makeBinary(
        SubInt32,
        builder->makeGetStackPos(),
        builder->makeConst(Literal(int32_t(4)))
      ),
      i32
    );
  }
};

// Instrument local saving/restoring.
struct BysyncifyLocals : public WalkerPass<PostWalker<BysyncifyLocals>> {
  bool isFunctionParallel() override { return true; }

  BysyncifyLocals* create() override { return new BysyncifyLocals(); }

  void visitCall(Call* curr) {
    // Replace calls to the fake intrinsic with a proper unwind.
    if (curr->name == BYSYNCIFY_UNWIND) {
      replaceCurrent(
        builder->makeBreak(BYSYNCIFY_UNWIND, curr->operands[0])
      );
    }
  }

  void doWalkFunction(Function* func) {
    // If the function cannot change our state, we have nothing to do -
    // we will never unwind or rewind the stack here.
    if (!mayChangeState(func->body)) {
      return;
    }
    // Rewrite the function body.
    builder = make_unique<BysyncifyBuilder>(*module);
    walk(func->body);
    // After the normal function body, emit a barrier before the postamble.
    Expression* barrier;
    if (func->result == none) {
      // The function may have ended without a return; ensure one.
      barrier = builder->makeReturn();
    } else {
      // The function must have returned or hit an unreachable, but emit one
      // to make possible bugs easier to figure out (as this should never be
      // reached). The optimizer can remove this anyhow.
      barrier = builder->makeUnreachable();
    }
    auto tempIndex = builder->addVar(func, i32);
    auto* newBody = builder->makeBlock({
      makeLocalLoading(),
      builder->makeSetLocal(
        tempIndex,
        builder->makeBlock(
          BYSYNCIFY_UNWIND,
          builder->makeSequence(
            func->body,
            barrier
          )
        )
      ),
      makeCallIndexPush(tempIndex),
      makeLocalSaving()
    });
    if (func->result != none) {
      // If we unwind, we must still "return" a value, even if it will be
      // ignored on the outside.
      newBody->list.push_back(LiteralUtils::makeZero(func->result, *module));
      newBody->finalize(func->result);
    }
    func->body = newBody;
    // Making things like returns conditional may alter types.
    ReFinalize().walkFunctionInModule(func, module);
  }

private:
  std::unique_ptr<BysyncifyBuilder> builder;

  Expression* makeLocalLoading() {
    return builder->makeNop();
  }

  Expression* makeLocalSaving() {
    return builder->makeNop();
  }

  Expression* makeCallIndexPush(Index tempIndex) {
    // TODO: add a check against the stack end here
    return builder->makeSequence(
      builder->makeStore(4, 4, 4,
        builder->makeGetStackPos(),
        builder->makeGetLocal(tempIndex, i32),
        i32
      ),
      builder->makeStore(4, int32_t(DataOffset::BStackPos), 4,
        builder->makeGlobalGet(BYSYNCIFY_DATA, i32),
        builder->makeBinary(
          AddInt32,
          builder->makeGetStackPos(),
          builder->makeConst(Literal(int32_t(4)))
        ),
        i32
      )
    );
  }
};

} // anonymous namespace

struct Bysyncify : public Pass {
  void run(PassRunner* runner, Module* module) override {
    // First, instrument the flow of code, adding code instrumentation and
    // skips for when rewinding. We do this on flat IR.
    {
      PassRunner runner(module);
      runner.add("flatten");
      runner.add<BysyncifyFlow>();
      runner.setIsNested(true);
      runner.run();
    }
    // Next, add local saving/restoring logic. We optimize before doing this,
    // to undo the extra code generated by flattening.
    {
      PassRunner runner(module);
      runner.addDefaultFunctionOptimizationPasses(true);
      runner.add<BysyncifyLocals>();
      runner.setIsNested(true);
      runner.run();
    }
    // Finally, add global module support, including functions (that should
    // not have been seen by the previous passes).
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
