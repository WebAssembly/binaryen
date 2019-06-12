#include <wasm-printing.h>
/*
 * Copyright 2019 WebAssembly Community Group participants
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
//     i32  - current bysyncify stack location    //  0
//     i32  - bysyncify stack end                 //  4
//   }
//
// The bysyncify stack is a representation of the call frame, as a list of
// indexes of calls. In the example above, we saw index "0" for calling "bar"
// from "foo". When unwinding, the indexes are added to the stack; when
// rewinding, they are popped off; the current bysyncify stack location is
// undated while doing both operations. The bysyncify stack is also used to
// save locals. Note that the stack end location is provided, which is for
// error detection.
//
// When you start an unwinding operation, you must set the initial fields
// of the data structure, that is, set the current stack location to the
// proper place, and the end to the proper end based on how much memory
// you reserved. Note that bysyncify will grow the stack up.
//
// The pass will also create and export two functions that let you control
// unwinding and rewinding:
//
//  * bysyncify_start_unwind(data : i32): call this to start unwinding the
//    stack from the current location. "data" must point to a valid data
//    structure as described above (with both fields containing valid data).
//  * bysyncify_start_rewind(data : i32): call this to start rewinding the
//    stack vack up to the location stored in the provided data.
//  * bysyncify_stop_rewind(): call this to note that rewinding has
//    concluded, and normal execution can resume.
//
// To use this API, call bysyncify_start_unwind when you want to. The call
// stack will then be unwound, and so execution will resume in the JS or
// other host environment on the outside that called into wasm. Then when
// you want to rewind, call bysyncify_start_rewind, and then call the same
// initial function you called before, so that unwinding can begin. The
// unwinding will reach the same function from which you started the unwind,
// at which point you should call bysyncify_stop_rewind, and then execution
// can resumt normally.
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

static const Name BYSYNCIFY_START_UNWIND = "bysyncify_start_unwind";
static const Name BYSYNCIFY_START_REWIND = "bysyncify_start_rewind";
static const Name BYSYNCIFY_STOP_REWIND = "bysyncify_stop_rewind";

static const Name BYSYNCIFY_UNWIND = "__bysyncify_unwind";

enum class State {
  Normal = 0,
  Unwinding = 1,
  Rewinding = 2
};

enum class DataOffset {
  BStackPos = 0,
  BStackEnd = 4
};

const auto STACK_ALIGN = 4;

// Check if an expression may alter the bysyncify state, either in itself or
// in something called by it.
static bool mayChangeState(Expression* curr) {
  // TODO: currently this assumes that any calls may change the state, which
  //       could be much improved by globally figuring out which calls may
  //       actually reach relevant code.
  EffectAnalyzer effects(PassOptions(), curr);
  // TODO: look at effects.globalsWritten.count(BYSYNCIFY_STATE);? Currently
  //       this code assumes external code will change the state, so import
  //       calls are really what matters, but we look at all calls, non-
  //       recursively
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
public:
  BysyncifyBuilder(Module& wasm) : Builder(wasm) {}

  Expression* makeGetStackPos() {
    return makeLoad(4, false, int32_t(DataOffset::BStackPos), 4,
      makeGlobalGet(BYSYNCIFY_DATA, i32), i32);
  }

  Expression* makeIncStackPos(int32_t by) {
    if (by == 0) {
      return makeNop();
    }
    return makeStore(4, int32_t(DataOffset::BStackPos), 4,
      makeGlobalGet(BYSYNCIFY_DATA, i32),
      makeBinary(
        AddInt32,
        makeGetStackPos(),
        makeConst(Literal(by))
      ),
      i32
    );
  }

  Expression* makeStateCheck(State value) {
    return makeBinary(
      EqInt32,
      makeGlobalGet(BYSYNCIFY_STATE, i32),
      makeConst(Literal(int32_t(value)))
    );
  }
};

// Instrument control flow, around calls and adding skips for rewinding.
struct BysyncifyFlow : public Pass {
  bool isFunctionParallel() override { return true; }

  BysyncifyFlow* create() override { return new BysyncifyFlow(); }

  void runOnFunction(PassRunner* runner, Module* module_, Function* func) override {
    module = module_;
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

  Module* module;

  // Each call in the function has an index, noted during unwind and checked
  // during rewind.
  Index callIndex = 0;

  Expression* process(Expression* curr) {
    if (!mayChangeState(curr)) {
      return makeMaybeSkip(curr);
    }
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
      // At least one of our children may change the state. Clump them as
      // necessary.
      Index i = 0;
      auto& list = block->list;
      while (i < list.size()) {
        if (mayChangeState(list[i])) {
          list[i] = process(list[i]);
          i++;
        } else {
          Index end = i + 1;
          while (end < list.size() && !mayChangeState(list[end])) {
            end++;
          }
          // We have a range of [i, end) in which the state cannot change,
          // so all we need to do is skip it if rewinding.
          if (end == i + 1) {
            list[i] = makeMaybeSkip(list[i]);
          } else {
            auto* block = builder->makeBlock();
            for (auto j = i; j < end; j++) {
              block->list.push_back(list[j]);
            }
            block->finalize();
            list[i] = makeMaybeSkip(block);
            for (auto j = i + 1; j < end; j++) {
              list[j] = builder->makeNop();
            }
          }
          i = end;
        }
      }
      return block;
    } else if (auto* iff = curr->dynCast<If>()) {
      // The state change cannot be in the condition due to flat form, so it
      // must be in one of the children.
      assert(!mayChangeState(iff->condition));
      // We must linearize this, which means we pass through both arms if we
      // are rewinding. This is pretty simple as in flat form the if condition
      // is either a const or a get, so easily copyable.
      // Start with the first arm, for which we reuse the original if.
      auto* otherArm = iff->ifFalse;
      iff->ifFalse = nullptr;
      auto* originalCondition = iff->condition;
      iff->condition = builder->makeBinary(
        OrInt32,
        originalCondition,
        builder->makeStateCheck(State::Rewinding)
      );
      iff->ifTrue = process(iff->ifTrue);
      iff->finalize();
      if (!otherArm) {
        return iff;
      }
      // Add support for the second arm as well.
      auto* otherIf = builder->makeIf(
        builder->makeBinary(
          OrInt32,
          builder->makeUnary(
            EqZInt32,
            ExpressionManipulator::copy(originalCondition, *module)
          ),
          builder->makeStateCheck(State::Rewinding)
        ),
        process(otherArm)
      );
      otherIf->finalize();
      return builder->makeSequence(iff, otherIf);
    } else if (auto* loop = curr->dynCast<Loop>()) {
      loop->body = process(loop->body);
      return loop;
    } else if (doesCall(curr)) {
      return makeCallSupport(curr);
    }
    // We must handle all control flow above, and all things that can change
    // the state, so there should be nothing that can reach here - add it
    // earlier as necessary.
std::cout << "BAD " << *curr << '\n';
    WASM_UNREACHABLE();
  }

  // Possibly skip some code, if rewinding.
  Expression* makeMaybeSkip(Expression* curr) {
    return builder->makeIf(
      builder->makeStateCheck(State::Normal),
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
        builder->makeStateCheck(State::Normal),
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
      builder->makeStateCheck(State::Unwinding),
      builder->makeCall(BYSYNCIFY_UNWIND, {
        builder->makeConst(Literal(int32_t(index)))
      }, none)
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
    return builder->makeIncStackPos(-4);
  }
};

// Instrument local saving/restoring.
struct BysyncifyLocals : public WalkerPass<PostWalker<BysyncifyLocals>> {
  bool isFunctionParallel() override { return true; }

  BysyncifyLocals* create() override { return new BysyncifyLocals(); }

  void visitCall(Call* curr) {
    // Replace calls to the fake intrinsic with a proper unwind.
    if (curr->target == BYSYNCIFY_UNWIND) {
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
    builder = make_unique<BysyncifyBuilder>(*getModule());
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
    // Note the locals we want to preserve, before we add any more helpers.
    numPreservableLocals = func->getNumLocals();
    // The new function body has a prelude to load locals if rewinding,
    // then the actual main body, which does all its unwindings by breaking
    // to the unwind block, which then handles pushing the call index, as
    // well as saving the locals.
    auto tempIndex = builder->addVar(func, i32);
    auto* newBody = builder->makeBlock({
      builder->makeIf(
        builder->makeStateCheck(State::Rewinding),
        makeLocalLoading()
      ),
      builder->makeLocalSet(
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
      newBody->list.push_back(LiteralUtils::makeZero(func->result, *getModule()));
      newBody->finalize(func->result);
    }
    func->body = newBody;
    // Making things like returns conditional may alter types.
    ReFinalize().walkFunctionInModule(func, getModule());
  }

private:
  std::unique_ptr<BysyncifyBuilder> builder;

  Index numPreservableLocals;

  Expression* makeLocalLoading() {
    if (numPreservableLocals == 0) {
      return builder->makeNop();
    }
    auto* func = getFunction();
    Index total = 0;
    for (Index i = 0; i < numPreservableLocals; i++) {
      auto type = func->getLocalType(i);
      auto size = getTypeSize(type);
      total += size;
    }
    auto* block = builder->makeBlock();
    block->list.push_back(builder->makeIncStackPos(-total));
    auto tempIndex = builder->addVar(func, i32);
    block->list.push_back(
      builder->makeLocalSet(tempIndex, builder->makeGetStackPos())
    );
    Index offset = 0;
    for (Index i = 0; i < numPreservableLocals; i++) {
      auto type = func->getLocalType(i);
      auto size = getTypeSize(type);
      assert(size % STACK_ALIGN == 0);
      // TODO: higher alignment?
      // TODO: optimize use of stack pos (add a local, ignore it here)
      block->list.push_back(
        builder->makeLocalSet(
          i,
          builder->makeLoad(size, true, offset, STACK_ALIGN,
            builder->makeLocalGet(tempIndex, i32), type)
        )
      );
      offset += size;
    }
    block->finalize();
    return block;
  }

  Expression* makeLocalSaving() {
    if (numPreservableLocals == 0) {
      return builder->makeNop();
    }
    auto* func = getFunction();
    auto* block = builder->makeBlock();
    auto tempIndex = builder->addVar(func, i32);
    block->list.push_back(
      builder->makeLocalSet(tempIndex, builder->makeGetStackPos())
    );
    Index offset = 0;
    for (Index i = 0; i < numPreservableLocals; i++) {
      auto type = func->getLocalType(i);
      auto size = getTypeSize(type);
      assert(size % STACK_ALIGN == 0);
      // TODO: higher alignment?
      // TODO: optimize use of stack pos (add a local, ignore it here)
      block->list.push_back(
        builder->makeStore(size, offset, STACK_ALIGN,
          builder->makeLocalGet(tempIndex, i32),
          builder->makeLocalGet(i, type),
          type
        )
      );
      offset += size;
    }
    block->list.push_back(builder->makeIncStackPos(offset));
    block->finalize();
    return block;
  }

  Expression* makeCallIndexPush(Index tempIndex) {
    // TODO: add a check against the stack end here
    return builder->makeSequence(
      builder->makeStore(4, 4, 4,
        builder->makeGetStackPos(),
        builder->makeLocalGet(tempIndex, i32),
        i32
      ),
      builder->makeIncStackPos(4)
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
      // dce is useful here, since BysyncifyFlow makes control flow conditional,
      // which may make unreachable code look reachable.
      runner.add("dce");
      runner.add("simplify-locals-nonesting");
      runner.add("vacuum");
      runner.add<BysyncifyFlow>();
      //runner.setIsNested(true);
      runner.setValidateGlobally(false);
      runner.run();
    }
    // Next, add local saving/restoring logic. We optimize before doing this,
    // to undo the extra code generated by flattening, and optimize after as
    // well to simplify the code as much as possible.
    {
      PassRunner runner(module);
      runner.addDefaultFunctionOptimizationPasses();
      runner.add<BysyncifyLocals>();
      runner.addDefaultFunctionOptimizationPasses();
      //runner.setIsNested(true);
      runner.setValidateGlobally(false);
      runner.run();
    }
    // Finally, add global module support, including functions (that should
    // not have been seen by the previous passes) and globals. Note that we
    // can't validate globally until we get here.
    addModuleSupport(module);
  }

private:
  void addModuleSupport(Module* module) {
    Builder builder(*module);
    module->addGlobal(builder.makeGlobal(BYSYNCIFY_STATE, i32, builder.makeConst(Literal(int32_t(0))), Builder::Mutable));
    module->addGlobal(builder.makeGlobal(BYSYNCIFY_DATA, i32, builder.makeConst(Literal(int32_t(0))), Builder::Mutable));

    auto makeFunction = [&](Name name, std::vector<Type> params, State state, Expression* extra) {
      Expression* body = builder.makeGlobalSet(BYSYNCIFY_STATE, builder.makeConst(Literal(int32_t(state))));
      if (extra) {
        body = builder.makeSequence(body, extra);
      }
      auto* func = builder.makeFunction(name, std::move(params), none, std::vector<Type>{}, body);
      module->addFunction(func);
      module->addExport(builder.makeExport(name, name, ExternalKind::Function));
    };

    makeFunction(BYSYNCIFY_START_UNWIND, { i32 }, State::Unwinding, builder.makeGlobalSet(BYSYNCIFY_DATA, builder.makeLocalGet(0, i32)));
    makeFunction(BYSYNCIFY_START_REWIND, { i32 }, State::Rewinding, builder.makeGlobalSet(BYSYNCIFY_DATA, builder.makeLocalGet(0, i32)));
    makeFunction(BYSYNCIFY_STOP_REWIND,       {}, State::Normal,    nullptr);
  }
};

Pass* createBysyncifyPass() { return new Bysyncify(); }

} // namespace wasm
