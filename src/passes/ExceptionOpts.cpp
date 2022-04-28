/*
 * Copyright 2022 WebAssembly Community Group participants
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

// Performs an interprocedural analysis using the call graph to decide whether
// each function can throw or not, and use the info to optimize out trys whose
// try body does not throw. For trys with non-throwing bodies, this removes all
// kinds of trys and removes catch bodies as well.
//
// Vacuum already does this for trivial cases, meaning a try body without any
// possibly throwing instructions (call, call_indirect, call_ref, throw, and
// rethrow). This pass improves on that by analyzing the call graph to figure
// out which function cannot throw.
//
// Functions that are not analyzable due to call graph cycles are treated as
// throwable unless proven otherwise.

#include "ir/module-utils.h"
#include "ir/utils.h"

#define DEBUG_TYPE "exception-opts"
//#define EXCEPTION_OPTS_DEBUG

namespace wasm {

#ifdef EXCEPTION_OPTS_DEBUG
// Variables to measure stats
static std::atomic<int> numRemovedTrys = 0;
static std::atomic<int> numTrys = 0;
static bool optimizing_phase = false;
static std::set<Function*> throwingFuncs;
static std::mutex throwingFuncsMutex;
static std::map<Function*, int> throwingLeafFuncs;
#endif

struct ExceptionOpts : public Pass {
  enum class ThrowKind { CanThrow, CannotThrow, Unknown };
  struct Info
    : public ModuleUtils::CallGraphPropertyAnalysis<Info>::FunctionInfo {
    ThrowKind throws = ThrowKind::Unknown;
  };

  // This is similar to EffectAnalyzer, but only analyzes exceptions and does it
  // in a more fine-grained way. Aside from logging stuff, this mainly does two
  // more things than EffectAnalyzer for exceptions:
  // - If a try body does not throw, even if its catch body throws, this ignores
  //   it.
  // - If a try-delegate targets an outer try, EffectAnalyzer conservatively
  //   assumes that try as throwable, even if the try-delegate doesn't contain
  //   any throwable instructions. This makes the outer targetted try throwable
  //   only if the try-delegate contains throwable expressions.
  //
  // We can in theory add these to EffectAnalyzer, but it require more
  // bookeeping and thus space, and EffectAnalyzer is used in a lot of places,
  // so I'm not sure if it's worth it.
  //
  // This also can quit the analysis as soon as the expression is found to be
  // throwable, using clearTask() function.
  struct ExceptionAnalyzer : public PostWalker<ExceptionAnalyzer> {
    Module* wasm;
    const std::map<Function*, Info>& throwInfoMap;
    // Expressions that are guaranteed not to throw. nullptr if not provided.
    const std::set<Expression*>* notThrowingExprs;

    // Depth of try-catch_all.
    size_t tryCatchAllDepth = 0;
    // We keep track of "seen" delegate targets to make early exit possible in
    // case we see a 'delegate' with an unseen target, which means the target
    // exists outside of the current expression.
    std::set<Name> seenDelegateTargets;
    // Delegate targets that are targetted by throwing expressions.
    std::set<Name> throwingDelegateTargets;
    // Stack of trys
    std::vector<Try*> tryStack;
    // Stack of whether the try body throws. Used for catch body rechability
    // analysis.
    std::vector<bool> tryBodyThrowsStack;
    // Stack of whether the catch body is reachable or not. Computed using
    // tryBodyThrowsStack; if a try body does not throw, its corresponding catch
    // body is not reachable.
    std::vector<bool> catchReachableStack;

    // Set if this expression throws
    bool throws = false;
    // Set if it cannot be decided if this expression throws or not. Happens
    // when this expression contains a call whose throwability is not decided,
    // outside of any try-catch_all.
    bool unknown = false;

#ifdef EXCEPTION_OPTS_DEBUG
    enum class ThrowReason { Throw, Rethrow, Call, CallIndirect, Unknown };
    ThrowReason throwReason = ThrowReason::Unknown;
#endif

    ExceptionAnalyzer(Module* wasm,
                      const std::map<Function*, Info>& throwInfoMap,
                      const std::set<Expression*>* notThrowingExprs)
      : wasm(wasm), throwInfoMap(throwInfoMap),
        notThrowingExprs(notThrowingExprs) {}
    ExceptionAnalyzer(Module* wasm,
                      const std::map<Function*, Info>& throwInfoMap)
      : wasm(wasm), throwInfoMap(throwInfoMap), notThrowingExprs(nullptr) {}

    static void scan(ExceptionAnalyzer* self, Expression** currp) {
      Expression* curr = *currp;
      // If this is an expression that is guaranteed not to throw, don't go into
      // the expression.
      if (self->notThrowingExprs && self->notThrowingExprs->count(curr)) {
        return;
      }

      // We need to decrement try depth before catch starts, so handle it
      // separately
      if (curr->is<Try>()) {
        self->pushTask(doVisitTry, currp);
        self->pushTask(doEndCatch, currp);
        auto& catchBodies = curr->cast<Try>()->catchBodies;
        for (int i = int(catchBodies.size()) - 1; i >= 0; i--) {
          self->pushTask(scan, &catchBodies[i]);
        }
        self->pushTask(doStartCatch, currp);
        self->pushTask(scan, &curr->cast<Try>()->body);
        self->pushTask(doStartTry, currp);
        return;
      }
      PostWalker<ExceptionAnalyzer>::scan(self, currp);
    }

    static void doStartTry(ExceptionAnalyzer* self, Expression** currp) {
      Try* curr = (*currp)->cast<Try>();
      self->seenDelegateTargets.insert(curr->name);
      // We only count 'try's with a 'catch_all' because instructions within a
      // 'try' without a 'catch_all' can still throw outside of the try.
      if (curr->hasCatchAll()) {
        self->tryCatchAllDepth++;
      }
      self->tryStack.push_back(curr);
      self->tryBodyThrowsStack.push_back(false);
    }

    static void doStartCatch(ExceptionAnalyzer* self, Expression** currp) {
      Try* curr = (*currp)->cast<Try>();
      // If there's a throwing expression that targets the current try, this try
      // becomes a throwing expression.
      if (curr->name.is() && self->throwingDelegateTargets.count(curr->name)) {
        self->processThrowingExpression(curr);
        self->throwingDelegateTargets.erase(curr->name);
        self->tryBodyThrowsStack.back() = true;
      }
      self->seenDelegateTargets.erase(curr->name);
      // We only count 'try's with a 'catch_all' because instructions within a
      // 'try' without a 'catch_all' can still throw outside of the try.
      if (curr->hasCatchAll()) {
        assert(self->tryCatchAllDepth > 0 && "try depth cannot be negative");
        self->tryCatchAllDepth--;
      }
      self->tryStack.pop_back();
      // If a try body can throw, its corresponding catch body is reachable.
      self->catchReachableStack.push_back(self->tryBodyThrowsStack.back());
      self->tryBodyThrowsStack.pop_back();
    }

    static void doEndCatch(ExceptionAnalyzer* self, Expression** currp) {
      self->catchReachableStack.pop_back();
    }

    void markAsThrowOrUnknown(Expression* curr) {
      if (Call* call = curr->dynCast<Call>()) {
        auto* func = wasm->getFunction(call->target);
        if (throwInfoMap.at(func).throws == ThrowKind::Unknown && !throws) {
          unknown = true;
          clearTask();
          return;
        }
      }

#ifdef EXCEPTION_OPTS_DEBUG
      // Bookeeping why it throws for later analysis
      if (Call* call = curr->dynCast<Call>()) {
        std::lock_guard<std::mutex> lock(throwingFuncsMutex);
        if (optimizing_phase) {
          throwingFuncs[wasm->getFunction(call->target)]++;
        }
        throwReason = ThrowReason::Call;
      } else if (curr->is<CallIndirect>() || curr->is<CallRef>()) {
        throwReason = ThrowReason::CallIndirect;
      } else if (curr->is<Throw>()) {
        throwReason = ThrowReason::Throw;
      } else if (curr->is<Rethrow>()) {
        throwReason = ThrowReason::Rethrow;
      }
#endif

      throws = true;
      unknown = false;
      // Now we know that this throws, we don't need to examine other parts of
      // the expression.
      clearTask();
      return;
    }

    bool reachable(Expression* curr) {
      // If any of the catch body in the current stack is not reachable due to
      // its corresponding try body not throwing, this expression is not
      // reachable, so is safe to ignore.
      for (int i = catchReachableStack.size() - 1; i >= 0; i--) {
        if (catchReachableStack[i] == false) {
          return false;
        }
      }
      return true;
    }

    void processThrowingExpression(Expression* curr) {
      // If we are within a try body, mark the innermost try body as throwable
      // for later catch block reachability analysis.
      if (!tryBodyThrowsStack.empty()) {
        tryBodyThrowsStack.back() = true;
      }

      // If this expression is within a catch block due to its corresponding try
      // body not throwing, ignore this.
      if (!reachable(curr)) {
        return;
      }

      // If this isn't nested within any try-catch_alls, this can throw and we
      // can end the analysis.
      if (tryCatchAllDepth == 0) {
        markAsThrowOrUnknown(curr);
        return;
      }

      // Even if this is nested within a try-catch_all, if there is an inner
      // try-delegate that escapes it, the expression can throw. Traverse the
      // trys from the innermost one to check that.
      for (int i = tryStack.size() - 1; i >= 0; i--) {
        Try* try_ = tryStack[i];
        // If we encounter a try-catch_all first, this can't throw.
        if (try_->hasCatchAll()) {
          break;
        }
        // If we encounter a try-delegate first:
        if (try_->isDelegate()) {
          // If the delegate's target is not among the trys we've seen so far,
          // this delegate targets a try outside of the expression being
          // examined or the caller. Either way, the whole expression can
          // throw.
          if (!seenDelegateTargets.count(try_->delegateTarget)) {
            markAsThrowOrUnknown(curr);
            return;
          }
          // If the delegate's target is among the trys we've seen, the whole
          // expression may or may not throw. Record the target label as
          // throwing so that we can check this later.
          throwingDelegateTargets.insert(try_->delegateTarget);
          break;
        }
      }
    }

    void visitCall(Call* curr) {
      Function* func = wasm->getFunction(curr->target);
      if (throwInfoMap.at(func).throws != ThrowKind::CannotThrow) {
        processThrowingExpression(curr);
      }
    }
    void visitCallIndirect(CallIndirect* curr) {
      processThrowingExpression(curr);
    }
    void visitCallRef(CallRef* curr) { processThrowingExpression(curr); }
    void visitThrow(Throw* curr) { processThrowingExpression(curr); }
    void visitRethrow(Rethrow* curr) { processThrowingExpression(curr); }
  };

  void run(PassRunner* runner, Module* wasm) override {
    if (!wasm->features.hasExceptionHandling()) {
      return;
    }

    ModuleUtils::CallGraphPropertyAnalysis<Info> callGraph(
      *wasm, [&](Function* func, Info& info) {
        if (func->imported()) {
          info.throws = ThrowKind::CanThrow;
        }
      });

#ifdef EXCEPTION_OPTS_DEBUG
    std::cerr << "\n-- Callgraph\n";
    for (const auto& [func, info] : callGraph.map) {
      std::cerr << "\nfunc: " << func->name << "\n";
      std::cerr << "  calledBy:\n";
      for (auto* func : info.calledBy) {
        std::cerr << "    " << func->name
                  << (func->imported() ? " (import)" : "") << "\n";
      }
      std::cerr << "  callsTo:\n";
      for (const auto* func : info.callsTo) {
        std::cerr << "    " << func->name
                  << (func->imported() ? " (import)" : "") << "\n";
      }
    }
    std::cerr << "\n";
#endif

    // 'numCalleesLeft' contains, for each function, the number of defined (=
    // not imported) callees that have not been examined yet. To begin, for
    // every function, record the number of its defined callees.
    std::unordered_map<Function*, int> numCalleesLeft;
    for (auto& [func, info] : callGraph.map) {
      if (!func->imported()) {
        size_t numCallees = info.callsTo.size();
        for (auto* callee : info.callsTo) {
          if (callee->imported()) {
            numCallees--;
          }
        }
        numCalleesLeft[func] = numCallees;
      }
    }

    // HACK Currently these fwo functions call each other, making this a cycle,
    // and a large number of functions call std::terminate. Either of these
    // throws. Break this cycle manually for the moment.
    // https://github.com/emscripten-core/emscripten/issues/16407
    for (auto& [func, info] : callGraph.map) {
      if (!func->imported()) {
        if (func->name.startsWith("std::terminate") ||
            func->name.startsWith("std::__terminate")) {
          callGraph.map[func].throws = ThrowKind::CannotThrow;
          numCalleesLeft[func] = 0;
        }
      }
    }

    std::vector<Function*> worklist;
    std::set<Function*> analyzedFuncs;

    for (auto& [func, numCallees] : numCalleesLeft) {
      if (numCallees == 0) {
        worklist.push_back(func);
      }
    }

    auto analyzeFunc = [&](Function* func) -> bool {
      ExceptionAnalyzer effect(wasm, callGraph.map);
      effect.walk(func->body);

      assert(!(effect.throws && effect.unknown));
      if (effect.throws) {
        callGraph.map[func].throws = ThrowKind::CanThrow;
      } else if (!effect.unknown) {
        callGraph.map[func].throws = ThrowKind::CannotThrow;
      }
      if (!effect.unknown) {
        analyzedFuncs.insert(func);
        return true;
      }
      return false;
    };

    // We add functions whose number of defined callees is 0 to the worklist,
    // and as we pop functions from the worklist and examine them, decrement
    // their callers' 'numCalleesLeft' value. If any of those callers' number of
    // left callees reaches 0, add the callers to the worklist too.
    auto processWorklist = [&]() {
      while (!worklist.empty()) {
        auto* func = worklist.back();
        worklist.pop_back();
        if (analyzedFuncs.count(func)) {
          continue;
        }
        if (!analyzeFunc(func)) {
          continue;
        }

        for (auto* caller : callGraph.map[func].calledBy) {
          // HACK We already made these two functions' number of left callees
          // 0; see above.
          if (caller->name.startsWith("std::terminate") ||
              caller->name.startsWith("std::__terminate")) {
            continue;
          }
          numCalleesLeft[caller]--;
          assert(numCalleesLeft[caller] >= 0);
          if (numCalleesLeft[caller] == 0) {
            worklist.push_back(caller);
          }
        }
      }
    };

    // Here we analyze each function to determine whether it can throw or not.
    // We start from functions whose number of defined callees is 0 (= leaves in
    // the call graph) and go towards the root nodes. This cannot handle
    // functions that are within cycles in the call graph.
    processWorklist();

    // Now we are left with functions that are within cycles in the call graph.
    // Detecting and breaking cycles can be nontrivial, but there are still
    // analyzable functions even if they are within cycles; for example, if a
    // function contains a definitely throwing instruction (throw or
    // call_indirect) outside of a try-catch_all, we can say it throws. Also,
    // even if we don't know if some of its callees throw, if they are all
    // within a try-catch_all, we can say it does not throw.
    //
    // So pick a random unanalyzed function and see if we can analyze it, and if
    // so, add its callers whose number of unanalyzed callees reaches 0 to the
    // worklist. Repeat this until we reach the fixed point.
    //
    // In theory this can be time-consuming for big programs, but in practice
    // this seems to converge quickly.
    //
    // Even after this we are left with some analyzable functions that are
    // in cycles. In my experiment with wasm-opt binary, the portion of
    // unanalyzable functions after this was only around 10%, and with that the
    // code size win was still negligible. We may come up with a new
    // cycle-breaking mechanism, but I doubt it will improve code size at this
    // point.
    for (int i = 0;; i++) {
      WASM_UNUSED(i); // Only used when EXCEPTION_OPTS_DEBUG is defined
      size_t numAnalyzed = analyzedFuncs.size();
      ModuleUtils::iterDefinedFunctions(*wasm, [&](Function* func) {
        if (analyzedFuncs.count(func)) {
          return;
        }
        // If this function was successfully analyzed, i.e., decided whether it
        // throws or not, this may have unlocked more callers for analysis.
        // Process the worklist until it is empty.
        if (analyzeFunc(func)) {
          processWorklist();
        }
      });
#ifdef EXCEPTION_OPTS_DEBUG
      std::cerr << "Iter " << i
                << ": # of analyzable functions = " << analyzedFuncs.size()
                << "\n";
#endif
      if (numAnalyzed == analyzedFuncs.size()) {
        break;
      }
    }

#ifdef EXCEPTION_OPTS_DEBUG
    int numDefinedFuncs = numCalleesLeft.size();
    std::cerr << "\n\n-- Analyzable functions\n";
    std::cerr << "# of defined functions = " << numDefinedFuncs << "\n";
    std::cerr << "# of analyzable functions = " << analyzedFuncs.size() << "\n";
    if (!numCalleesLeft.empty()) {
      std::cerr << "Ratio of analyzable functions = "
                << (float)analyzedFuncs.size() / numDefinedFuncs << "\n";
    }
    std::cerr << "\n";

    std::cerr << "\n\n-- Exception analysis result\n";
    int numCanThrow = 0, numCannotThrow = 0, numUnknown = 0;
    ModuleUtils::iterDefinedFunctions(*wasm, [&](Function* func) {
      std::string msg;
      if (callGraph.map[func].throws == ThrowKind::CanThrow) {
        msg = "CanThrow";
        numCanThrow++;
      } else if (callGraph.map[func].throws == ThrowKind::CannotThrow) {
        msg = "CannotThrow";
        numCannotThrow++;
      } else {
        msg = "Unknown";
        numUnknown++;
      }
      std::cerr << "func: " << func->name << ": " << msg << "\n";
    });
    std::cerr << "\nThrowing functions = " << numCanThrow << " / "
              << numDefinedFuncs << " (" << (float)numCanThrow / numDefinedFuncs
              << ")\n";
    std::cerr << "Non-throwing functions = " << numCannotThrow << " / "
              << numDefinedFuncs << " ("
              << (float)numCannotThrow / numDefinedFuncs << ")\n";
    std::cerr << "Unknown functions = " << numUnknown << " / "
              << numDefinedFuncs << " (" << (float)numUnknown / numDefinedFuncs
              << ")\n\n";
#endif

    // If some functions' throability is still unknown, treat them as throwable.
    ModuleUtils::iterDefinedFunctions(*wasm, [&](Function* func) {
      if (callGraph.map[func].throws == ThrowKind::Unknown) {
        callGraph.map[func].throws = ThrowKind::CanThrow;
      }
    });

    // Optimize trys out if their body doesn't throw, using functions' throwing
    // info we gathered above.
#ifdef EXCEPTION_OPTS_DEBUG
    optimizing_phase = true;
#endif
    struct ExceptionOptimizer
      : public WalkerPass<PostWalker<ExceptionOptimizer>> {
      const std::map<Function*, Info>& throwInfoMap;
      std::set<Expression*> notThrowingExprs;

      bool isFunctionParallel() override { return true; }

      ExceptionOptimizer(const std::map<Function*, Info>& throwInfoMap)
        : throwInfoMap(throwInfoMap) {}
      ExceptionOptimizer* create() override {
        return new ExceptionOptimizer(throwInfoMap);
      }

      void visitTry(Try* curr) {
        ExceptionAnalyzer effect(getModule(), throwInfoMap, &notThrowingExprs);
        effect.walk(curr->body);
#ifdef EXCEPTION_OPTS_DEBUG
        numTrys++;
#endif
        if (!effect.throws) {
#ifdef EXCEPTION_OPTS_DEBUG
          numRemovedTrys++;
#endif
          replaceCurrent(curr->body);
          // Update not throwing expressions so that it can be used later
          notThrowingExprs.insert(curr->body);
        }
      }
    };
    ExceptionOptimizer opt(callGraph.map);
    opt.run(runner, wasm);
#ifdef EXCEPTION_OPTS_DEBUG
    optimizing_phase = false;
#endif

    // Because we have replaced expressions above, refinalize the module.
    ReFinalize().run(runner, wasm);

#ifdef EXCEPTION_OPTS_DEBUG
    // Given a possibly throwing function, figure out all possibly throwing leaf
    // functions (= functions without any callees) that are eventually called by
    // this function, and add them to 'throwingLeafFuncs'. This function is used
    // to figure out which functions are mostly reponsible for making functions
    // throwable.
    auto addLeafThrowingCall = [&](Function* caller) {
      assert(callGraph.map[caller].throws == ThrowKind::CanThrow);
      if (caller->imported()) {
        throwingLeafFuncs[caller]++;
        return;
      }
      // If this caller was not analyzed due to call graph cycles, there is no
      // 'leaf'.
      if (!analyzedFuncs.count(caller)) {
        throwingLeafFuncs[caller]++;
        return;
      }

      std::vector<Function*> worklist;
      worklist.push_back(caller);
      std::set<Function*> visited;
      while (!worklist.empty()) {
        auto* func = worklist.back();
        worklist.pop_back();
        if (visited.count(func)) {
          continue;
        }
        visited.insert(func);
        int numThrowingCallees = 0;
        for (auto* callee : callGraph.map[func].callsTo) {
          if (callGraph.map[callee].throws == ThrowKind::CanThrow) {
            worklist.push_back(callee);
            numThrowingCallees++;
          }
        }
        if (numThrowingCallees == 0) {
          throwingLeafFuncs[func]++;
        }
      }
    };
    for (auto func : throwingFuncs) {
      addLeafThrowingCall(func);
    }

    std::vector<std::pair<Function*, int>> throwingLeafFuncVec;
    for (auto& [func, count] : throwingLeafFuncs) {
      throwingLeafFuncVec.push_back(std::make_pair(func, count));
    }
    std::sort(throwingLeafFuncVec.begin(),
              throwingLeafFuncVec.end(),
              [](const std::pair<Function*, int>& a,
                 const std::pair<Function*, int>& b) -> bool {
                return a.second > b.second;
              });

    std::cerr << "\n\n-- Leaf throwing calls (most frequent first):\n";
    int numImported = 0, numThrow = 0, numRethrow = 0, numCallIndirect = 0,
        numCycle = 0;
    for (auto& [func, count] : throwingLeafFuncVec) {
      std::cerr << count << ": " << func->name << "\n";
      if (func->imported()) {
        std::cerr << "  imported\n";
        numImported++;
        continue;
      }
      if (!analyzedFuncs.count(func)) {
        std::cerr << "  cycle\n";
        numCycle++;
        continue;
      }
      ExceptionAnalyzer effect(wasm, callGraph.map);
      effect.walk(func->body);
      assert(effect.throws);
      // This is a leaf call, so the reason shouldn't be 'Call'
      assert(effect.throwReason != ExceptionAnalyzer::ThrowReason::Call);

      if (effect.throwReason == ExceptionAnalyzer::ThrowReason::Throw) {
        std::cerr << "  throw\n";
        numThrow++;
      } else if (effect.throwReason ==
                 ExceptionAnalyzer::ThrowReason::Rethrow) {
        std::cerr << "  rethrow\n";
        numRethrow++;
      } else if (effect.throwReason ==
                 ExceptionAnalyzer::ThrowReason::CallIndirect) {
        std::cerr << "  call_indirect\n";
        numCallIndirect++;
      } else {
        assert(false);
      }
    }
    std::cerr << "\n\n-- Reasons that leaf functions can throw:\n";
    std::cerr << "  Imported function = " << numImported << "\n";
    std::cerr << "  Have 'throw's = " << numThrow << "\n";
    std::cerr << "  Have 'rethrow's = " << numRethrow << "\n";
    std::cerr << "  Have 'call_indirect's/'call_ref's = " << numCallIndirect
              << "\n";
    std::cerr << "  Not analyzable (due to cycles) = " << numCycle << "\n";

    std::cerr << "\n\n-- Optimization result:\n";
    std::cerr << "# of trys = " << numTrys << "\n";
    std::cerr << "# of trys removed = " << numRemovedTrys << "\n";
    if (numTrys > 0) {
      std::cerr << "Ratio of removed trys = " << (float)numRemovedTrys / numTrys
                << "\n";
    }
#endif
  }
};

Pass* createExceptionOptsPass() { return new ExceptionOpts(); }

} // namespace wasm
