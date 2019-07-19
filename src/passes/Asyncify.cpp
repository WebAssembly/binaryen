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
// Asyncify: async/await style code transformation, that allows pausing
// and resuming. This lets a language support synchronous operations in
// an async manner, for example, you can do a blocking wait, and that will
// be turned into code that unwinds the stack at the "blocking" operation,
// then is able to rewind it back up when the actual async operation
// comples, the so the code appears to have been running synchronously
// all the while. Use cases for this include coroutines, python generators,
// etc.
//
// The approach here is a third-generation design after Emscripten's original
// Asyncify and then Emterpreter-Async approaches:
//
//  * Old Asyncify rewrote control flow in LLVM IR. A problem is that this
//    needs to save all SSA registers as part of the local state, which can be
//    very costly. A further increase can happen because of phis that are
//    added because of control flow transformations. As a result we saw
//    pathological cases where the code size increase was unacceptable.
//  * Emterpreter-Async avoids any risk of code size increase by running it
//    in a little bytecode VM, which also makes pausing/resuming trivial.
//    Speed is the main downside here; however, the approach did prove that by
//    *selectively* emterpretifying only certain code, many projects can run
//    at full speed - often just the "main loop" must be emterpreted, while
//    high-speed code that it calls, and in which cannot be an async operation,
//    remain at full speed.
//
// New Asyncify's design learns from both of those:
//
//  * The code rewrite is done in Binaryen, that is, at the wasm level. At
//    this level we will only need to save wasm locals, which is a much smaller
//    number than LLVM's SSA registers.
//  * We aim for low but non-zero overhead. Low overhead is very important
//    for obvious reasons, while Emterpreter-Async proved it is tolerable to
//    have *some* overhead, if the transform can be applied selectively.
//
// The specific transform implemented here is nicknamed "Bysyncify" (as it is
// in BinarYen, and "B" comes after "A"). It is simpler than old Asyncify but
// has low overhead when properly optimized. Old Asyncify worked at the CFG
// level and added branches there; new Asyncify on the other hand works on the
// structured control flow of wasm and simply "skips over" code when rewinding
// the stack, and jumps out when unwinding. The transformed code looks
// conceptually like this:
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
//     // If rewinding, do this call only if it is the right one.
//     if (!rewinding or nextCall == 0) {
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
//     [..]
//
// The general idea is that while rewinding we just "keep going forward",
// skipping code we should not run. That is, instead of jumping directly
// to the right place, we have ifs that skip along instead. The ifs for
// rewinding and unwinding should be well-predicted, so the overhead should
// not be very high. However, we do need to reach the right location via
// such skipping, which means that in a very large function the rewind
// takes some extra time. On the other hand, though, code that cannot
// unwind or rewind (like that loop near the end) can run at full speed.
// Overall, this should allow good performance with small overhead that is
// mostly noticed at rewind time.
//
// After this pass is run a new i32 global "__asyncify_state" is added, which
// has the following values:
//
//   0: normal execution
//   1: unwinding the stack
//   2: rewinding the stack
//
// There is also "__asyncify_data" which when rewinding and unwinding
// contains a pointer to a data structure with the info needed to rewind
// and unwind:
//
//   {                                            // offsets
//     i32  - current asyncify stack location    //  0
//     i32  - asyncify stack end                 //  4
//   }
//
// The asyncify stack is a representation of the call frame, as a list of
// indexes of calls. In the example above, we saw index "0" for calling "bar"
// from "foo". When unwinding, the indexes are added to the stack; when
// rewinding, they are popped off; the current asyncify stack location is
// undated while doing both operations. The asyncify stack is also used to
// save locals. Note that the stack end location is provided, which is for
// error detection.
//
// Note: all pointers are assumed to be 4-byte aligned.
//
// When you start an unwinding operation, you must set the initial fields
// of the data structure, that is, set the current stack location to the
// proper place, and the end to the proper end based on how much memory
// you reserved. Note that asyncify will grow the stack up.
//
// The pass will also create four functions that let you control unwinding
// and rewinding:
//
//  * asyncify_start_unwind(data : i32): call this to start unwinding the
//    stack from the current location. "data" must point to a data
//    structure as described above (with fields containing valid data).
//
//  * asyncify_stop_unwind(): call this to note that unwinding has
//    concluded. If no other code will run before you start to rewind,
//    this is not strictly necessary, however, if you swap between
//    coroutines, or even just want to run some normal code during a
//    "sleep", then you must call this at the proper time. Otherwise,
//    the code will think it is still unwinding when it should not be,
//    which means it will keep unwinding in a meaningless way.
//
//  * asyncify_start_rewind(data : i32): call this to start rewinding the
//    stack vack up to the location stored in the provided data. This prepares
//    for the rewind; to start it, you must call the first function in the
//    call stack to be unwound.
//
//  * asyncify_stop_rewind(): call this to note that rewinding has
//    concluded, and normal execution can resume.
//
// These four functions are exported so that you can call them from the
// outside. If you want to manage things from inside the wasm, then you
// couldn't have called them before they were created by this pass. To work
// around that, you can create imports to asyncify.start_unwind,
// asyncify.stop_unwind, asyncify.start_rewind, and asyncify.stop_rewind;
// if those exist when this pass runs then it will turn those into direct
// calls to the functions that it creates. Note that when doing everything
// in wasm like this, Asyncify must not instrument your "runtime" support
// code, that is, the code that initiates unwinds and rewinds and stops them.
// If it did, the unwind would not stop until you left the wasm module
// entirely, etc. Therefore we do not instrument a function if it has
// a call to the four asyncify_* methods. Note that you may need to disable
// inlining if that would cause code that does need to be instrumented
// show up in that runtime code.
//
// To use this API, call asyncify_start_unwind when you want to. The call
// stack will then be unwound, and so execution will resume in the JS or
// other host environment on the outside that called into wasm. When you
// return there after unwinding, call asyncify_stop_unwind. Then when
// you want to rewind, call asyncify_start_rewind, and then call the same
// initial function you called before, so that unwinding can begin. The
// unwinding will reach the same function from which you started, since
// we are recreating the call stack. At that point you should call
// asyncify_stop_rewind and then execution can resume normally.
//
// Note that the asyncify_* API calls will verify that the data structure
// is valid, checking if the current location is past the end. If so, they
// will throw a wasm unreachable. No check is done during unwinding or
// rewinding, to keep things fast - in principle, from when unwinding begins
// and until it ends there should be no memory accesses aside from the
// asyncify code itself (and likewise when rewinding), so there should be
// no chance of memory corruption causing odd errors. However, the low
// overhead of this approach does cause an error only to be shown when
// unwinding/rewinding finishes, and not at the specific spot where the
// stack end was exceeded.
//
// By default this pass is very carefuly: it assumes that any import and
// any indirect call may start an unwind/rewind operation. If you know more
// specific information you can inform asyncify about that, which can reduce
// a great deal of overhead, as it can instrument less code. The relevant
// options to wasm-opt etc. are:
//
//   --pass-arg=asyncify-imports@module1.base1,module2.base2,module3.base3
//
//      Each module.base in that comma-separated list will be considered to
//      be an import that can unwind/rewind, and all others are assumed not to
//      (aside from the asyncify.* imports, which are always assumed to).
//      Each entry can end in a '*' in which case it is matched as a prefix.
//
//   --pass-arg=asyncify-ignore-imports
//
//      Ignore all imports (except for bynsyncify.*), that is, assume none of
//      them can start an unwind/rewind. (This is effectively the same as
//      providing asyncify-imports with a list of non-existent imports.)
//
//   --pass-arg=asyncify-ignore-indirect
//
//      Ignore all indirect calls. This implies that you know an call stack
//      will never need to be unwound with an indirect call somewhere in it.
//      If that is true for your codebase, then this can be extremely useful
//      as otherwise it looks like any indirect call can go to a lot of places.
//

#include "ir/effects.h"
#include "ir/literal-utils.h"
#include "ir/memory-utils.h"
#include "ir/module-utils.h"
#include "ir/utils.h"
#include "pass.h"
#include "support/string.h"
#include "support/unique_deferring_queue.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

static const Name ASYNCIFY_STATE = "__asyncify_state";
static const Name ASYNCIFY_DATA = "__asyncify_data";
static const Name ASYNCIFY_START_UNWIND = "asyncify_start_unwind";
static const Name ASYNCIFY_STOP_UNWIND = "asyncify_stop_unwind";
static const Name ASYNCIFY_START_REWIND = "asyncify_start_rewind";
static const Name ASYNCIFY_STOP_REWIND = "asyncify_stop_rewind";
static const Name ASYNCIFY_UNWIND = "__asyncify_unwind";
static const Name ASYNCIFY = "asyncify";
static const Name START_UNWIND = "start_unwind";
static const Name STOP_UNWIND = "stop_unwind";
static const Name START_REWIND = "start_rewind";
static const Name STOP_REWIND = "stop_rewind";
static const Name ASYNCIFY_GET_CALL_INDEX = "__asyncify_get_call_index";
static const Name ASYNCIFY_CHECK_CALL_INDEX = "__asyncify_check_call_index";

// TODO: having just normal/unwind_or_rewind would decrease code
//       size, but make debugging harder
enum class State { Normal = 0, Unwinding = 1, Rewinding = 2 };

enum class DataOffset { BStackPos = 0, BStackEnd = 4 };

const auto STACK_ALIGN = 4;

// A helper class for managing fake global names. Creates the globals and
// provides mappings for using them.
class GlobalHelper {
  Module& module;

public:
  GlobalHelper(Module& module) : module(module) {
    map[i32] = "asyncify_fake_call_global_i32";
    map[i64] = "asyncify_fake_call_global_i64";
    map[f32] = "asyncify_fake_call_global_f32";
    map[f64] = "asyncify_fake_call_global_f64";
    Builder builder(module);
    for (auto& pair : map) {
      auto type = pair.first;
      auto name = pair.second;
      rev[name] = type;
      module.addGlobal(builder.makeGlobal(
        name, type, LiteralUtils::makeZero(type, module), Builder::Mutable));
    }
  }

  ~GlobalHelper() {
    for (auto& pair : map) {
      auto name = pair.second;
      module.removeGlobal(name);
    }
  }

  Name getName(Type type) { return map.at(type); }

  Type getTypeOrNone(Name name) {
    auto iter = rev.find(name);
    if (iter != rev.end()) {
      return iter->second;
    }
    return none;
  }

private:
  std::map<Type, Name> map;
  std::map<Name, Type> rev;
};

// Analyze the entire module to see which calls may change the state, that
// is, start an unwind or rewind), either in itself or in something called
// by it.
// Handles global module management, needed from the various parts of this
// transformation.
class ModuleAnalyzer {
  Module& module;
  bool canIndirectChangeState;

  struct Info {
    // If this function can start an unwind/rewind.
    bool canChangeState = false;
    // If this function is part of the runtime that receives an unwinding
    // and starts a rewinding. If so, we do not instrument it, see above.
    // This is only relevant when handling things entirely inside wasm,
    // as opposed to imports.
    bool isBottomMostRuntime = false;
    // If this function is part of the runtime that starts an unwinding
    // and stops a rewinding. If so, we do not instrument it, see above.
    // The difference between the top-most and bottom-most runtime is that
    // the top-most part is still marked as changing the state; so things
    // that call it are instrumented. This is not done for the bottom.
    bool isTopMostRuntime = false;
    std::set<Function*> callsTo;
    std::set<Function*> calledBy;
  };

  typedef std::map<Function*, Info> Map;
  Map map;

public:
  ModuleAnalyzer(Module& module,
                 std::function<bool(Name, Name)> canImportChangeState,
                 bool canIndirectChangeState)
    : module(module), canIndirectChangeState(canIndirectChangeState),
      globals(module) {
    // Scan to see which functions can directly change the state.
    // Also handle the asyncify imports, removing them (as we will implement
    // them later), and replace calls to them with calls to the later proper
    // name.
    ModuleUtils::ParallelFunctionMap<Info> scanner(
      module, [&](Function* func, Info& info) {
        if (func->imported()) {
          // The relevant asyncify imports can definitely change the state.
          if (func->module == ASYNCIFY &&
              (func->base == START_UNWIND || func->base == STOP_REWIND)) {
            info.canChangeState = true;
          } else {
            info.canChangeState =
              canImportChangeState(func->module, func->base);
          }
          return;
        }
        struct Walker : PostWalker<Walker> {
          void visitCall(Call* curr) {
            auto* target = module->getFunction(curr->target);
            if (target->imported() && target->module == ASYNCIFY) {
              // Redirect the imports to the functions we'll add later.
              if (target->base == START_UNWIND) {
                curr->target = ASYNCIFY_START_UNWIND;
                info->canChangeState = true;
                info->isTopMostRuntime = true;
              } else if (target->base == STOP_UNWIND) {
                curr->target = ASYNCIFY_STOP_UNWIND;
                info->isBottomMostRuntime = true;
              } else if (target->base == START_REWIND) {
                curr->target = ASYNCIFY_START_REWIND;
                info->isBottomMostRuntime = true;
              } else if (target->base == STOP_REWIND) {
                curr->target = ASYNCIFY_STOP_REWIND;
                info->canChangeState = true;
                info->isTopMostRuntime = true;
              } else {
                Fatal() << "call to unidenfied asyncify import: "
                        << target->base;
              }
              return;
            }
            info->callsTo.insert(target);
          }
          void visitCallIndirect(CallIndirect* curr) {
            if (canIndirectChangeState) {
              info->canChangeState = true;
            }
            // TODO optimize the other case, at least by type
          }
          Info* info;
          Module* module;
          bool canIndirectChangeState;
        };
        Walker walker;
        walker.info = &info;
        walker.module = &module;
        walker.canIndirectChangeState = canIndirectChangeState;
        walker.walk(func->body);

        if (info.isBottomMostRuntime) {
          info.canChangeState = false;
          // TODO: issue warnings on suspicious things, like a function in
          //       the bottom-most runtime also doing top-most runtime stuff
          //       like starting and unwinding.
        }
      });

    map.swap(scanner.map);

    // Remove the asyncify imports, if any.
    for (auto& pair : map) {
      auto* func = pair.first;
      if (func->imported() && func->module == ASYNCIFY) {
        module.removeFunction(func->name);
      }
    }

    // Find what is called by what.
    for (auto& pair : map) {
      auto* func = pair.first;
      auto& info = pair.second;
      for (auto* target : info.callsTo) {
        map[target].calledBy.insert(func);
      }
    }

    // Close over, finding all functions that can reach something that can
    // change the state.
    // The work queue contains an item we just learned can change the state.
    UniqueDeferredQueue<Function*> work;
    for (auto& func : module.functions) {
      if (map[func.get()].canChangeState) {
        work.push(func.get());
      }
    }
    while (!work.empty()) {
      auto* func = work.pop();
      for (auto* caller : map[func].calledBy) {
        if (!map[caller].canChangeState && !map[caller].isBottomMostRuntime) {
          map[caller].canChangeState = true;
          work.push(caller);
        }
      }
    }
  }

  bool needsInstrumentation(Function* func) {
    auto& info = map[func];
    return info.canChangeState && !info.isTopMostRuntime;
  }

  bool canChangeState(Expression* curr) {
    // Look inside to see if we call any of the things we know can change the
    // state.
    // TODO: caching, this is O(N^2)
    struct Walker : PostWalker<Walker> {
      void visitCall(Call* curr) {
        // We only implement these at the very end, but we know that they
        // definitely change the state.
        if (curr->target == ASYNCIFY_START_UNWIND ||
            curr->target == ASYNCIFY_STOP_REWIND ||
            curr->target == ASYNCIFY_GET_CALL_INDEX ||
            curr->target == ASYNCIFY_CHECK_CALL_INDEX) {
          canChangeState = true;
          return;
        }
        if (curr->target == ASYNCIFY_STOP_UNWIND ||
            curr->target == ASYNCIFY_START_REWIND) {
          isBottomMostRuntime = true;
          return;
        }
        // The target may not exist if it is one of our temporary intrinsics.
        auto* target = module->getFunctionOrNull(curr->target);
        if (target && (*map)[target].canChangeState) {
          canChangeState = true;
        }
      }
      void visitCallIndirect(CallIndirect* curr) {
        if (canIndirectChangeState) {
          canChangeState = true;
        }
        // TODO optimize the other case, at least by type
      }
      Module* module;
      Map* map;
      bool canIndirectChangeState;
      bool canChangeState = false;
      bool isBottomMostRuntime = false;
    };
    Walker walker;
    walker.module = &module;
    walker.map = &map;
    walker.canIndirectChangeState = canIndirectChangeState;
    walker.walk(curr);
    if (walker.isBottomMostRuntime) {
      walker.canChangeState = false;
    }
    return walker.canChangeState;
  }

  GlobalHelper globals;
};

// Checks if something performs a call: either a direct or indirect call,
// and perhaps it is dropped or assigned to a local. This captures all the
// cases of a call in flat IR.
static bool doesCall(Expression* curr) {
  if (auto* set = curr->dynCast<LocalSet>()) {
    curr = set->value;
  } else if (auto* drop = curr->dynCast<Drop>()) {
    curr = drop->value;
  }
  return curr->is<Call>() || curr->is<CallIndirect>();
}

class AsyncifyBuilder : public Builder {
public:
  AsyncifyBuilder(Module& wasm) : Builder(wasm) {}

  Expression* makeGetStackPos() {
    return makeLoad(4,
                    false,
                    int32_t(DataOffset::BStackPos),
                    4,
                    makeGlobalGet(ASYNCIFY_DATA, i32),
                    i32);
  }

  Expression* makeIncStackPos(int32_t by) {
    if (by == 0) {
      return makeNop();
    }
    return makeStore(
      4,
      int32_t(DataOffset::BStackPos),
      4,
      makeGlobalGet(ASYNCIFY_DATA, i32),
      makeBinary(AddInt32, makeGetStackPos(), makeConst(Literal(by))),
      i32);
  }

  Expression* makeStateCheck(State value) {
    return makeBinary(EqInt32,
                      makeGlobalGet(ASYNCIFY_STATE, i32),
                      makeConst(Literal(int32_t(value))));
  }
};

// Instrument control flow, around calls and adding skips for rewinding.
struct AsyncifyFlow : public Pass {
  bool isFunctionParallel() override { return true; }

  ModuleAnalyzer* analyzer;

  AsyncifyFlow* create() override { return new AsyncifyFlow(analyzer); }

  AsyncifyFlow(ModuleAnalyzer* analyzer) : analyzer(analyzer) {}

  void
  runOnFunction(PassRunner* runner, Module* module_, Function* func_) override {
    module = module_;
    func = func_;
    // If the function cannot change our state, we have nothing to do -
    // we will never unwind or rewind the stack here.
    if (!analyzer->needsInstrumentation(func)) {
      return;
    }
    // Rewrite the function body.
    builder = make_unique<AsyncifyBuilder>(*module);
    // Each function we enter will pop one from the stack, which is the index
    // of the next call to make.
    auto* block = builder->makeBlock(
      {builder->makeIf(builder->makeStateCheck(
                         State::Rewinding), // TODO: such checks can be !normal
                       makeCallIndexPop()),
       process(func->body)});
    if (func->result != none) {
      // Rewriting control flow may alter things; make sure the function ends in
      // something valid (which the optimizer can remove later).
      block->list.push_back(builder->makeUnreachable());
    }
    block->finalize();
    func->body = block;
    // Making things like returns conditional may alter types.
    ReFinalize().walkFunctionInModule(func, module);
  }

private:
  std::unique_ptr<AsyncifyBuilder> builder;

  Module* module;
  Function* func;

  // Each call in the function has an index, noted during unwind and checked
  // during rewind.
  Index callIndex = 0;

  Expression* process(Expression* curr) {
    if (!analyzer->canChangeState(curr)) {
      return makeMaybeSkip(curr);
    }
    // The IR is in flat form, which makes this much simpler: there are no
    // unnecessarily nested side effects or control flow, so we can add
    // skips for rewinding in an easy manner, putting a single if around
    // whole chunks of code. Also calls are separated out so that it is easy
    // to add the necessary checks for them for unwinding/rewinding support.
    //
    // Aside from that, we must "linearize" all control flow so that we can
    // reach the right part when rewinding, which is done by always skipping
    // forward. For example, for an if we do this:
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
        if (analyzer->canChangeState(list[i])) {
          list[i] = process(list[i]);
          i++;
        } else {
          Index end = i + 1;
          while (end < list.size() && !analyzer->canChangeState(list[end])) {
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
      assert(!analyzer->canChangeState(iff->condition));
      // We must linearize this, which means we pass through both arms if we
      // are rewinding.
      if (!iff->ifFalse) {
        iff->condition = builder->makeBinary(
          OrInt32, iff->condition, builder->makeStateCheck(State::Rewinding));
        iff->ifTrue = process(iff->ifTrue);
        iff->finalize();
        return iff;
      }
      auto conditionTemp = builder->addVar(func, i32);
      // TODO: can avoid pre if the condition is a get or a const
      auto* pre =
        makeMaybeSkip(builder->makeLocalSet(conditionTemp, iff->condition));
      iff->condition = builder->makeLocalGet(conditionTemp, i32);
      iff->condition = builder->makeBinary(
        OrInt32, iff->condition, builder->makeStateCheck(State::Rewinding));
      iff->ifTrue = process(iff->ifTrue);
      auto* otherArm = iff->ifFalse;
      iff->ifFalse = nullptr;
      iff->finalize();
      // Add support for the second arm as well.
      auto* otherIf = builder->makeIf(
        builder->makeBinary(
          OrInt32,
          builder->makeUnary(EqZInt32,
                             builder->makeLocalGet(conditionTemp, i32)),
          builder->makeStateCheck(State::Rewinding)),
        process(otherArm));
      otherIf->finalize();
      return builder->makeBlock({pre, iff, otherIf});
    } else if (auto* loop = curr->dynCast<Loop>()) {
      loop->body = process(loop->body);
      return loop;
    } else if (doesCall(curr)) {
      return makeCallSupport(curr);
    }
    // We must handle all control flow above, and all things that can change
    // the state, so there should be nothing that can reach here - add it
    // earlier as necessary.
    // std::cout << *curr << '\n';
    WASM_UNREACHABLE();
  }

  // Possibly skip some code, if rewinding.
  Expression* makeMaybeSkip(Expression* curr) {
    return builder->makeIf(builder->makeStateCheck(State::Normal), curr);
  }

  Expression* makeCallSupport(Expression* curr) {
    // TODO: stop doing this after code can no longer reach a call that may
    //       change the state
    assert(doesCall(curr));
    assert(curr->type == none);
    // The case of a set is tricky: we must *not* execute the set when
    // unwinding, since at that point we have a fake value for the return,
    // and if we applied it to the local, it would end up saved and then
    // potentially used later - and with coalescing, that may interfere
    // with other things. Note also that at this point in the process we
    // have not yet written the load saving/loading code, so the optimizer
    // doesn't see that locals will have another use at the beginning and
    // end of the function. We don't do that yet because we don't want it
    // to force the final number of locals to be too high, but we also
    // must be careful to never touch a local unnecessarily to avoid bugs.
    // To implement this, write to a fake global; we'll fix it up after
    // AsyncifyLocals locals adds local saving/restoring.
    auto* set = curr->dynCast<LocalSet>();
    if (set) {
      auto name = analyzer->globals.getName(set->value->type);
      curr = builder->makeGlobalSet(name, set->value);
      set->value = builder->makeGlobalGet(name, set->value->type);
    }
    // Instrument the call itself (or, if a drop, the drop+call).
    auto index = callIndex++;
    // Execute the call, if either normal execution, or if rewinding and this
    // is the right call to go into.
    // TODO: we can read the next call index once in each function (but should
    //       avoid saving/restoring that local later)
    curr = builder->makeIf(
      builder->makeIf(builder->makeStateCheck(State::Normal),
                      builder->makeConst(Literal(int32_t(1))),
                      makeCallIndexPeek(index)),
      builder->makeSequence(curr, makePossibleUnwind(index, set)));
    return curr;
  }

  Expression* makePossibleUnwind(Index index, Expression* ifNotUnwinding) {
    // In this pass we emit an "unwind" as a call to a fake intrinsic. We
    // will implement it in the later pass. (We can't create the unwind block
    // target here, as the optimizer would remove it later; we can only add
    // it when we add its contents, later.)
    return builder->makeIf(
      builder->makeStateCheck(State::Unwinding),
      builder->makeCall(
        ASYNCIFY_UNWIND, {builder->makeConst(Literal(int32_t(index)))}, none),
      ifNotUnwinding);
  }

  Expression* makeCallIndexPeek(Index index) {
    // Emit an intrinsic for this, as we store the index into a local, and
    // don't want it to be seen by asyncify itself.
    return builder->makeCall(ASYNCIFY_CHECK_CALL_INDEX,
                             {builder->makeConst(Literal(int32_t(index)))},
                             i32);
  }

  Expression* makeCallIndexPop() {
    // Emit an intrinsic for this, as we store the index into a local, and
    // don't want it to be seen by asyncify itself.
    return builder->makeCall(ASYNCIFY_GET_CALL_INDEX, {}, none);
  }
};

// Instrument local saving/restoring.
struct AsyncifyLocals : public WalkerPass<PostWalker<AsyncifyLocals>> {
  bool isFunctionParallel() override { return true; }

  ModuleAnalyzer* analyzer;

  AsyncifyLocals* create() override { return new AsyncifyLocals(analyzer); }

  AsyncifyLocals(ModuleAnalyzer* analyzer) : analyzer(analyzer) {}

  void visitCall(Call* curr) {
    // Replace calls to the fake intrinsics.
    if (curr->target == ASYNCIFY_UNWIND) {
      replaceCurrent(builder->makeBreak(ASYNCIFY_UNWIND, curr->operands[0]));
    } else if (curr->target == ASYNCIFY_GET_CALL_INDEX) {
      replaceCurrent(builder->makeSequence(
        builder->makeIncStackPos(-4),
        builder->makeLocalSet(
          rewindIndex,
          builder->makeLoad(4, false, 0, 4, builder->makeGetStackPos(), i32))));
    } else if (curr->target == ASYNCIFY_CHECK_CALL_INDEX) {
      replaceCurrent(builder->makeBinary(
        EqInt32,
        builder->makeLocalGet(rewindIndex, i32),
        builder->makeConst(
          Literal(int32_t(curr->operands[0]->cast<Const>()->value.geti32())))));
    }
  }

  void visitGlobalSet(GlobalSet* curr) {
    auto type = analyzer->globals.getTypeOrNone(curr->name);
    if (type != none) {
      replaceCurrent(
        builder->makeLocalSet(getFakeCallLocal(type), curr->value));
    }
  }

  void visitGlobalGet(GlobalGet* curr) {
    auto type = analyzer->globals.getTypeOrNone(curr->name);
    if (type != none) {
      replaceCurrent(builder->makeLocalGet(getFakeCallLocal(type), type));
    }
  }

  Index getFakeCallLocal(Type type) {
    auto iter = fakeCallLocals.find(type);
    if (iter != fakeCallLocals.end()) {
      return iter->second;
    }
    return fakeCallLocals[type] = builder->addVar(getFunction(), type);
  }

  void doWalkFunction(Function* func) {
    // If the function cannot change our state, we have nothing to do -
    // we will never unwind or rewind the stack here.
    if (!analyzer->needsInstrumentation(func)) {
      return;
    }
    // Note the locals we want to preserve, before we add any more helpers.
    numPreservableLocals = func->getNumLocals();
    // The new function body has a prelude to load locals if rewinding,
    // then the actual main body, which does all its unwindings by breaking
    // to the unwind block, which then handles pushing the call index, as
    // well as saving the locals.
    // An index is needed for getting the unwinding and rewinding call indexes
    // around TODO: can this be the same index?
    auto unwindIndex = builder->addVar(func, i32);
    rewindIndex = builder->addVar(func, i32);
    // Rewrite the function body.
    builder = make_unique<AsyncifyBuilder>(*getModule());
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
    auto* newBody = builder->makeBlock(
      {builder->makeIf(builder->makeStateCheck(State::Rewinding),
                       makeLocalLoading()),
       builder->makeLocalSet(
         unwindIndex,
         builder->makeBlock(ASYNCIFY_UNWIND,
                            builder->makeSequence(func->body, barrier))),
       makeCallIndexPush(unwindIndex),
       makeLocalSaving()});
    if (func->result != none) {
      // If we unwind, we must still "return" a value, even if it will be
      // ignored on the outside.
      newBody->list.push_back(
        LiteralUtils::makeZero(func->result, *getModule()));
      newBody->finalize(func->result);
    }
    func->body = newBody;
    // Making things like returns conditional may alter types.
    ReFinalize().walkFunctionInModule(func, getModule());
  }

private:
  std::unique_ptr<AsyncifyBuilder> builder;

  Index rewindIndex;
  Index numPreservableLocals;
  std::map<Type, Index> fakeCallLocals;

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
      builder->makeLocalSet(tempIndex, builder->makeGetStackPos()));
    Index offset = 0;
    for (Index i = 0; i < numPreservableLocals; i++) {
      auto type = func->getLocalType(i);
      auto size = getTypeSize(type);
      assert(size % STACK_ALIGN == 0);
      // TODO: higher alignment?
      block->list.push_back(builder->makeLocalSet(
        i,
        builder->makeLoad(size,
                          true,
                          offset,
                          STACK_ALIGN,
                          builder->makeLocalGet(tempIndex, i32),
                          type)));
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
      builder->makeLocalSet(tempIndex, builder->makeGetStackPos()));
    Index offset = 0;
    for (Index i = 0; i < numPreservableLocals; i++) {
      auto type = func->getLocalType(i);
      auto size = getTypeSize(type);
      assert(size % STACK_ALIGN == 0);
      // TODO: higher alignment?
      block->list.push_back(
        builder->makeStore(size,
                           offset,
                           STACK_ALIGN,
                           builder->makeLocalGet(tempIndex, i32),
                           builder->makeLocalGet(i, type),
                           type));
      offset += size;
    }
    block->list.push_back(builder->makeIncStackPos(offset));
    block->finalize();
    return block;
  }

  Expression* makeCallIndexPush(Index tempIndex) {
    // TODO: add a check against the stack end here
    return builder->makeSequence(
      builder->makeStore(4,
                         0,
                         4,
                         builder->makeGetStackPos(),
                         builder->makeLocalGet(tempIndex, i32),
                         i32),
      builder->makeIncStackPos(4));
  }
};

} // anonymous namespace

struct Asyncify : public Pass {
  void run(PassRunner* runner, Module* module) override {
    bool optimize = runner->options.optimizeLevel > 0;

    // Ensure there is a memory, as we need it.
    MemoryUtils::ensureExists(module->memory);

    // Find which things can change the state.
    auto stateChangingImports =
      runner->options.getArgumentOrDefault("asyncify-imports", "");
    auto ignoreImports =
      runner->options.getArgumentOrDefault("asyncify-ignore-imports", "");
    bool allImportsCanChangeState =
      stateChangingImports == "" && ignoreImports == "";
    String::Split listedImports(stateChangingImports, ",");
    auto ignoreIndirect =
      runner->options.getArgumentOrDefault("asyncify-ignore-indirect", "");

    // Scan the module.
    ModuleAnalyzer analyzer(*module,
                            [&](Name module, Name base) {
                              if (allImportsCanChangeState) {
                                return true;
                              }
                              std::string full =
                                std::string(module.str) + '.' + base.str;
                              for (auto& listedImport : listedImports) {
                                if (String::wildcardMatch(listedImport, full)) {
                                  return true;
                                }
                              }
                              return false;
                            },
                            ignoreIndirect == "");

    // Add necessary globals before we emit code to use them.
    addGlobals(module);

    // Instrument the flow of code, adding code instrumentation and
    // skips for when rewinding. We do this on flat IR so that it is
    // practical to add code around each call, without affecting
    // anything else.
    {
      PassRunner runner(module);
      runner.add("flatten");
      // Dce is useful here, since AsyncifyFlow makes control flow conditional,
      // which may make unreachable code look reachable. It also lets us ignore
      // unreachable code here.
      runner.add("dce");
      if (optimize) {
        // Optimizing before BsyncifyFlow is crucial, especially coalescing,
        // because the flow changes add many branches, break up if-elses, etc.,
        // all of which extend the live ranges of locals. In other words, it is
        // not possible to coalesce well afterwards.
        runner.add("simplify-locals-nonesting");
        runner.add("reorder-locals");
        runner.add("coalesce-locals");
        runner.add("simplify-locals-nonesting");
        runner.add("reorder-locals");
        runner.add("merge-blocks");
      }
      runner.add(make_unique<AsyncifyFlow>(&analyzer));
      runner.setIsNested(true);
      runner.setValidateGlobally(false);
      runner.run();
    }
    // Next, add local saving/restoring logic. We optimize before doing this,
    // to undo the extra code generated by flattening, and to arrive at the
    // minimal amount of locals (which is important as we must save and
    // restore those locals). We also and optimize after as well to simplify
    // the code as much as possible.
    {
      PassRunner runner(module);
      if (optimize) {
        runner.addDefaultFunctionOptimizationPasses();
      }
      runner.add(make_unique<AsyncifyLocals>(&analyzer));
      if (optimize) {
        runner.addDefaultFunctionOptimizationPasses();
      }
      runner.setIsNested(true);
      runner.setValidateGlobally(false);
      runner.run();
    }
    // Finally, add function support (that should not have been seen by
    // the previous passes).
    addFunctions(module);
  }

private:
  void addGlobals(Module* module) {
    Builder builder(*module);
    module->addGlobal(builder.makeGlobal(ASYNCIFY_STATE,
                                         i32,
                                         builder.makeConst(Literal(int32_t(0))),
                                         Builder::Mutable));
    module->addGlobal(builder.makeGlobal(ASYNCIFY_DATA,
                                         i32,
                                         builder.makeConst(Literal(int32_t(0))),
                                         Builder::Mutable));
  }

  void addFunctions(Module* module) {
    Builder builder(*module);
    auto makeFunction = [&](Name name, bool setData, State state) {
      std::vector<Type> params;
      if (setData) {
        params.push_back(i32);
      }
      auto* body = builder.makeBlock();
      body->list.push_back(builder.makeGlobalSet(
        ASYNCIFY_STATE, builder.makeConst(Literal(int32_t(state)))));
      if (setData) {
        body->list.push_back(
          builder.makeGlobalSet(ASYNCIFY_DATA, builder.makeLocalGet(0, i32)));
      }
      // Verify the data is valid.
      auto* stackPos =
        builder.makeLoad(4,
                         false,
                         int32_t(DataOffset::BStackPos),
                         4,
                         builder.makeGlobalGet(ASYNCIFY_DATA, i32),
                         i32);
      auto* stackEnd =
        builder.makeLoad(4,
                         false,
                         int32_t(DataOffset::BStackEnd),
                         4,
                         builder.makeGlobalGet(ASYNCIFY_DATA, i32),
                         i32);
      body->list.push_back(
        builder.makeIf(builder.makeBinary(GtUInt32, stackPos, stackEnd),
                       builder.makeUnreachable()));
      body->finalize();
      auto* func = builder.makeFunction(
        name, std::move(params), none, std::vector<Type>{}, body);
      module->addFunction(func);
      module->addExport(builder.makeExport(name, name, ExternalKind::Function));
    };

    makeFunction(ASYNCIFY_START_UNWIND, true, State::Unwinding);
    makeFunction(ASYNCIFY_STOP_UNWIND, false, State::Normal);
    makeFunction(ASYNCIFY_START_REWIND, true, State::Rewinding);
    makeFunction(ASYNCIFY_STOP_REWIND, false, State::Normal);
  }
};

Pass* createAsyncifyPass() { return new Asyncify(); }

} // namespace wasm
