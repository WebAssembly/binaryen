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
// Inlining.
//
// Two versions are provided: inlining and inlining-optimizing. You
// probably want the optimizing version, which will optimize locations
// we inlined into, as inlining by itself creates a block to house the
// inlined code, some temp locals, etc., which can usually be removed
// by optimizations. Note that the two versions use the same heuristics,
// so we don't take into account the overhead if you don't optimize
// afterwards. The non-optimizing version is mainly useful for debugging,
// or if you intend to run a full set of optimizations anyhow on
// everything later.
//
// In addition, additional passes exist for inlinig of the main() function
// (InlineMain) and of conditions (InlineConditions).
//

#include <atomic>

#include "ir/debug.h"
#include "ir/element-utils.h"
#include "ir/literal-utils.h"
#include "ir/module-utils.h"
#include "ir/type-updating.h"
#include "ir/utils.h"
#include "parsing.h"
#include "pass.h"
#include "passes/opt-utils.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

// Useful into on a function, helping us decide if we can inline it
struct FunctionInfo {
  std::atomic<Index> refs;
  Index size;
  bool hasCalls;
  bool hasLoops;
  bool hasTryDelegate;
  bool usedGlobally; // in a table or export
  bool uninlineable;

  FunctionInfo() {
    refs = 0;
    size = 0;
    hasCalls = false;
    hasLoops = false;
    hasTryDelegate = false;
    usedGlobally = false;
    uninlineable = false;
  }

  // See pass.h for how defaults for these options were chosen.
  bool worthInlining(PassOptions& options) {
    if (uninlineable) {
      return false;
    }
    // Until we have proper support for try-delegate, ignore such functions.
    // FIXME https://github.com/WebAssembly/binaryen/issues/3634
    if (hasTryDelegate) {
      return false;
    }
    // If it's small enough that we always want to inline such things, do so.
    if (size <= options.inlining.alwaysInlineMaxSize) {
      return true;
    }
    // If it has one use, then inlining it would likely reduce code size, at
    // least for reasonable function sizes.
    if (refs == 1 && !usedGlobally &&
        size <= options.inlining.oneCallerInlineMaxSize) {
      return true;
    }
    // If it's so big that we have no flexible options that could allow it,
    // do not inline.
    if (size > options.inlining.flexibleInlineMaxSize) {
      return false;
    }
    // More than one use, so we can't eliminate it after inlining,
    // so only worth it if we really care about speed and don't care
    // about size. First, check if it has calls. In that case it is not
    // likely to speed us up, and also if we want to inline such
    // functions we would need to be careful to avoid infinite recursion.
    if (hasCalls) {
      return false;
    }
    return options.optimizeLevel >= 3 && options.shrinkLevel == 0 &&
           (!hasLoops || options.inlining.allowFunctionsWithLoops);
  }
};

typedef std::unordered_map<Name, FunctionInfo> NameInfoMap;

struct FunctionInfoScanner
  : public WalkerPass<PostWalker<FunctionInfoScanner>> {
  bool isFunctionParallel() override { return true; }

  FunctionInfoScanner(NameInfoMap* infos) : infos(infos) {}

  FunctionInfoScanner* create() override {
    return new FunctionInfoScanner(infos);
  }

  void visitLoop(Loop* curr) {
    // having a loop
    (*infos)[getFunction()->name].hasLoops = true;
  }

  void visitCall(Call* curr) {
    // can't add a new element in parallel
    assert(infos->count(curr->target) > 0);
    (*infos)[curr->target].refs++;
    // having a call
    (*infos)[getFunction()->name].hasCalls = true;
  }

  // N.B.: CallIndirect and CallRef are intentionally omitted here, as we only
  //       note direct calls. Direct calls can lead to infinite recursion
  //       which we need to avoid, while indirect ones may in theory be
  //       optimized to direct calls later, but we take that risk - which is
  //       worthwhile as if we do manage to turn an indirect call into something
  //       else then it can be a big speedup, so we do want to inline code that
  //       has such indirect calls.

  void visitTry(Try* curr) {
    if (curr->isDelegate()) {
      (*infos)[getFunction()->name].hasTryDelegate = true;
    }
  }

  void visitRefFunc(RefFunc* curr) {
    assert(infos->count(curr->func) > 0);
    (*infos)[curr->func].refs++;
  }

  void visitFunction(Function* curr) {
    auto& info = (*infos)[curr->name];

    // We cannot inline a function if we cannot handle placing it in a local, as
    // all params become locals.
    for (auto param : curr->getParams()) {
      if (!TypeUpdating::canHandleAsLocal(param)) {
        info.uninlineable = true;
      }
    }

    info.size = Measurer::measure(curr->body);
  }

  void visitExport(Export* curr) {
    if (curr->kind == ExternalKind::Function) {
      (*infos)[curr->value].usedGlobally = true;
    }
  }

  void visitModule(Module* curr) {
    if (curr->start.is()) {
      (*infos)[curr->start].usedGlobally = true;
    }
  }

private:
  NameInfoMap* infos;
};

struct InliningAction {
  Expression** callSite;
  Function* contents;

  InliningAction(Expression** callSite, Function* contents)
    : callSite(callSite), contents(contents) {}
};

struct InliningState {
  std::unordered_set<Name> worthInlining;
  // function name => actions that can be performed in it
  std::unordered_map<Name, std::vector<InliningAction>> actionsForFunction;
};

struct Planner : public WalkerPass<PostWalker<Planner>> {
  bool isFunctionParallel() override { return true; }

  Planner(InliningState* state) : state(state) {}

  Planner* create() override { return new Planner(state); }

  void visitCall(Call* curr) {
    // plan to inline if we know this is valid to inline, and if the call is
    // actually performed - if it is dead code, it's pointless to inline.
    // we also cannot inline ourselves.
    bool isUnreachable;
    if (curr->isReturn) {
      // Tail calls are only actually unreachable if an argument is
      isUnreachable = std::any_of(
        curr->operands.begin(), curr->operands.end(), [](Expression* op) {
          return op->type == Type::unreachable;
        });
    } else {
      isUnreachable = curr->type == Type::unreachable;
    }
    if (state->worthInlining.count(curr->target) && !isUnreachable &&
        curr->target != getFunction()->name) {
      // nest the call in a block. that way the location of the pointer to the
      // call will not change even if we inline multiple times into the same
      // function, otherwise call1(call2()) might be a problem
      auto* block = Builder(*getModule()).makeBlock(curr);
      replaceCurrent(block);
      // can't add a new element in parallel
      assert(state->actionsForFunction.count(getFunction()->name) > 0);
      state->actionsForFunction[getFunction()->name].emplace_back(
        &block->list[0], getModule()->getFunction(curr->target));
    }
  }

private:
  InliningState* state;
};

struct Updater : public PostWalker<Updater> {
  Module* module;
  std::map<Index, Index> localMapping;
  Name returnName;
  Builder* builder;
  void visitReturn(Return* curr) {
    replaceCurrent(builder->makeBreak(returnName, curr->value));
  }
  // Return calls in inlined functions should only break out of the scope of
  // the inlined code, not the entire function they are being inlined into. To
  // achieve this, make the call a non-return call and add a break. This does
  // not cause unbounded stack growth because inlining and return calling both
  // avoid creating a new stack frame.
  template<typename T> void handleReturnCall(T* curr, Type targetType) {
    curr->isReturn = false;
    curr->type = targetType;
    if (targetType.isConcrete()) {
      replaceCurrent(builder->makeBreak(returnName, curr));
    } else {
      replaceCurrent(builder->blockify(curr, builder->makeBreak(returnName)));
    }
  }
  void visitCall(Call* curr) {
    if (curr->isReturn) {
      handleReturnCall(curr, module->getFunction(curr->target)->getResults());
    }
  }
  void visitCallIndirect(CallIndirect* curr) {
    if (curr->isReturn) {
      handleReturnCall(curr, curr->sig.results);
    }
  }
  void visitCallRef(CallRef* curr) {
    if (curr->isReturn) {
      handleReturnCall(curr,
                       curr->target->type.getHeapType().getSignature().results);
    }
  }
  void visitLocalGet(LocalGet* curr) {
    curr->index = localMapping[curr->index];
  }
  void visitLocalSet(LocalSet* curr) {
    curr->index = localMapping[curr->index];
  }
};

// Core inlining logic. Modifies the outside function (adding locals as
// needed), and returns the inlined code.
static Expression*
doInlining(Module* module, Function* into, const InliningAction& action) {
  Function* from = action.contents;
  auto* call = (*action.callSite)->cast<Call>();
  // Works for return_call, too
  Type retType = module->getFunction(call->target)->getResults();
  Builder builder(*module);
  auto* block = builder.makeBlock();
  block->name = Name(std::string("__inlined_func$") + from->name.str);
  if (call->isReturn) {
    if (retType.isConcrete()) {
      *action.callSite = builder.makeReturn(block);
    } else {
      *action.callSite = builder.makeSequence(block, builder.makeReturn());
    }
  } else {
    *action.callSite = block;
  }
  // Prepare to update the inlined code's locals and other things.
  Updater updater;
  updater.module = module;
  updater.returnName = block->name;
  updater.builder = &builder;
  // Set up a locals mapping
  for (Index i = 0; i < from->getNumLocals(); i++) {
    updater.localMapping[i] = builder.addVar(into, from->getLocalType(i));
  }
  // Assign the operands into the params
  for (Index i = 0; i < from->getParams().size(); i++) {
    block->list.push_back(
      builder.makeLocalSet(updater.localMapping[i], call->operands[i]));
  }
  // Zero out the vars (as we may be in a loop, and may depend on their
  // zero-init value
  for (Index i = 0; i < from->vars.size(); i++) {
    auto type = from->vars[i];
    if (type.isNonNullable()) {
      // Non-nullable locals do not need to be zeroed out. They have no zero
      // value, and by definition should not be used before being written to, so
      // any value we set here would not be observed anyhow.
      continue;
    }
    block->list.push_back(
      builder.makeLocalSet(updater.localMapping[from->getVarIndexBase() + i],
                           LiteralUtils::makeZero(type, *module)));
  }
  // Generate and update the inlined contents
  auto* contents = ExpressionManipulator::copy(from->body, *module);
  if (!from->debugLocations.empty()) {
    debug::copyDebugInfo(from->body, contents, from, into);
  }
  updater.walk(contents);
  block->list.push_back(contents);
  block->type = retType;
  // If the function returned a value, we just set the block containing the
  // inlined code to have that type. or, if the function was void and
  // contained void, that is fine too. a bad case is a void function in which
  // we have unreachable code, so we would be replacing a void call with an
  // unreachable.
  if (contents->type == Type::unreachable && block->type == Type::none) {
    // Make the block reachable by adding a break to it
    block->list.push_back(builder.makeBreak(block->name));
  }
  TypeUpdating::handleNonDefaultableLocals(into, *module);
  return block;
}

struct Inlining : public Pass {
  // This pass changes locals and parameters.
  // FIXME DWARF updating does not handle local changes yet.
  bool invalidatesDWARF() override { return true; }

  // whether to optimize where we inline
  bool optimize = false;

  // the information for each function. recomputed in each iteraction
  NameInfoMap infos;

  void run(PassRunner* runner, Module* module) override {
    // No point to do more iterations than the number of functions, as it means
    // we are infinitely recursing (which should be very rare in practice, but
    // it is possible that a recursive call can look like it is worth inlining).
    Index iterationNumber = 0;

    auto numOriginalFunctions = module->functions.size();

    // Track in how many iterations a function was inlined into. We are willing
    // to inline many times into a function within an iteration, as e.g. that
    // helps the case of many calls of a small getter. However, if we only do
    // more inlining in separate iterations then it is likely code that was the
    // result of previous inlinings that is now being inlined into. That is, an
    // old inlining added a call to somewhere, and now we are inlining into that
    // call. This is typically recursion, which to some extent can help, but
    // then like loop unrolling it loses its benefit quickly, so set a limit
    // here.
    std::unordered_map<Function*, Index> iterationsInlinedInto;

    const size_t MaxIterationsForFunc = 5;

    while (iterationNumber <= numOriginalFunctions) {
#ifdef INLINING_DEBUG
      std::cout << "inlining loop iter " << iterationNumber
                << " (numFunctions: " << module->functions.size() << ")\n";
#endif

      calculateInfos(module);

      iterationNumber++;
      std::unordered_set<Function*> inlinedInto;
      iteration(runner, module, inlinedInto);
      if (inlinedInto.empty()) {
        return;
      }

#ifdef INLINING_DEBUG
      std::cout << "  inlined into " << inlinedInto.size() << " funcs.\n";
#endif

      for (auto* func : inlinedInto) {
        if (++iterationsInlinedInto[func] >= MaxIterationsForFunc) {
          return;
        }
      }
    }
  }

  void calculateInfos(Module* module) {
    infos.clear();
    // fill in info, as we operate on it in parallel (each function to its own
    // entry)
    for (auto& func : module->functions) {
      infos[func->name];
    }
    PassRunner runner(module);
    FunctionInfoScanner scanner(&infos);
    scanner.run(&runner, module);
    scanner.walkModuleCode(module);
  }

  void iteration(PassRunner* runner,
                 Module* module,
                 std::unordered_set<Function*>& inlinedInto) {
    // decide which to inline
    InliningState state;
    ModuleUtils::iterDefinedFunctions(*module, [&](Function* func) {
      if (infos[func->name].worthInlining(runner->options)) {
        state.worthInlining.insert(func->name);
      }
    });
    if (state.worthInlining.size() == 0) {
      return;
    }
    // fill in actionsForFunction, as we operate on it in parallel (each
    // function to its own entry)
    for (auto& func : module->functions) {
      state.actionsForFunction[func->name];
    }
    // find and plan inlinings
    Planner(&state).run(runner, module);
    // perform inlinings TODO: parallelize
    std::unordered_map<Name, Index> inlinedUses; // how many uses we inlined
    // which functions were inlined into
    for (auto& func : module->functions) {
      // if we've inlined a function, don't inline into it in this iteration,
      // avoid risk of races
      // note that we do not risk stalling progress, as each iteration() will
      // inline at least one call before hitting this
      if (inlinedUses.count(func->name)) {
        continue;
      }
      for (auto& action : state.actionsForFunction[func->name]) {
        auto* inlinedFunction = action.contents;
        // if we've inlined into a function, don't inline it in this iteration,
        // avoid risk of races
        // note that we do not risk stalling progress, as each iteration() will
        // inline at least one call before hitting this
        if (inlinedInto.count(inlinedFunction)) {
          continue;
        }
        Name inlinedName = inlinedFunction->name;
        if (!isUnderSizeLimit(func->name, inlinedName)) {
          continue;
        }
#ifdef INLINING_DEBUG
        std::cout << "inline " << inlinedName << " into " << func->name << '\n';
#endif
        doInlining(module, func.get(), action);
        inlinedUses[inlinedName]++;
        inlinedInto.insert(func.get());
        assert(inlinedUses[inlinedName] <= infos[inlinedName].refs);
      }
    }
    // anything we inlined into may now have non-unique label names, fix it up
    for (auto func : inlinedInto) {
      wasm::UniqueNameMapper::uniquify(func->body);
    }
    if (optimize && inlinedInto.size() > 0) {
      OptUtils::optimizeAfterInlining(inlinedInto, module, runner);
    }
    // remove functions that we no longer need after inlining
    module->removeFunctions([&](Function* func) {
      auto name = func->name;
      auto& info = infos[name];
      return inlinedUses.count(name) && inlinedUses[name] == info.refs &&
             !info.usedGlobally;
    });
  }

  // Checks if the combined size of the code after inlining is under the
  // absolute size limit. We have an absolute limit in order to avoid
  // extremely-large sizes after inlining, as they may hit limits in VMs and/or
  // slow down startup (measurements there indicate something like ~1 second to
  // optimize a 100K function). See e.g.
  // https://github.com/WebAssembly/binaryen/pull/3730#issuecomment-867939138
  // https://github.com/emscripten-core/emscripten/issues/13899#issuecomment-825073344
  bool isUnderSizeLimit(Name target, Name source) {
    // Estimate the combined binary size from the number of instructions.
    auto combinedSize = infos[target].size + infos[source].size;
    auto estimatedBinarySize = Measurer::BytesPerExpr * combinedSize;
    // The limit is arbitrary, but based on the links above. It is a very high
    // value that should appear very rarely in practice (for example, it does
    // not occur on the Emscripten benchmark suite of real-world codebases).
    const Index MaxCombinedBinarySize = 400 * 1024;
    return estimatedBinarySize < MaxCombinedBinarySize;
  }
};

Pass* createInliningPass() { return new Inlining(); }

Pass* createInliningOptimizingPass() {
  auto* ret = new Inlining();
  ret->optimize = true;
  return ret;
}

//
// InlineMain
//
// Inline __original_main into main, if they exist. This works around the odd
// thing that clang/llvm currently do, where __original_main contains the user's
// actual main (this is done as a workaround for main having two different
// possible signatures).
//

static const char* MAIN = "main";
static const char* ORIGINAL_MAIN = "__original_main";

struct InlineMainPass : public Pass {
  void run(PassRunner* runner, Module* module) override {
    auto* main = module->getFunctionOrNull(MAIN);
    auto* originalMain = module->getFunctionOrNull(ORIGINAL_MAIN);
    if (!main || main->imported() || !originalMain ||
        originalMain->imported()) {
      return;
    }
    FindAllPointers<Call> calls(main->body);
    Expression** callSite = nullptr;
    for (auto* call : calls.list) {
      if ((*call)->cast<Call>()->target == ORIGINAL_MAIN) {
        if (callSite) {
          // More than one call site.
          return;
        }
        callSite = call;
      }
    }
    if (!callSite) {
      // No call at all.
      return;
    }
    doInlining(module, main, InliningAction(callSite, originalMain));
  }
};

Pass* createInlineMainPass() { return new InlineMainPass(); }

//
// InlineConditions
//
// A function may be too costly to inline, but it may be profitable to
// *partially* inline it. The specific case optimized here are functions with a
// condition,
//
//  function foo(x) {
//    if (x) return;
//    ..lots and lots of other code..
//  }
//
// If the other code after the if is large enough or costly enough then we will
// not inline the entire function. But it is useful to inline the condition.
// Consider this caller:
//
//  function caller(x) {
//    foo(0);
//    foo(x);
//  }
//
// If we inline the condition, we end up with this:
//
//  function caller(x {
//    if (0) foo(0);
//    if (x) foo(x);
//  }
//
// Note that we just inlined the condition here, and did not modify foo()
// itself (yet, see later). Just by copying the condition out of foo() we gain
// two benefits:
//
//  * In the first call here the condition is zero, which means we can
//    statically optimize out the call entirely.
//  * Even if we can't do that, as in the second call, if at runtime we see the
//    condition is false then we avoid the call. Calling just to check a cheap
//    condition and immediately return is very costly, which this can avoid.
//
// The cost to doing this is an increase in code size. Another cost is that we
// check the condition twice. We can reduce the second cost by seeing if the
// called function has no unseen callers (no indirect calls, not exported), and
// if so, we can remove the condition in the function.
//

struct InlineConditionsPass : public Pass {
private:
  // Subclasses of this abstract class define particular conditions that we can
  // inline out of functions. It is hard to be 100% general here, but we aim to
  // cover common cases.
  struct Condition {
    virtual ~Condition() {}

    // Check if a function matches the pattern of a condition that we represent.
    virtual bool match(Function* func) = 0;

    // Apply the inlining operation: We are given the call, and return a
    // replacement for the call that has the condition, and in an appropriate
    // place inside it has the call. For example, if we are the pattern
    //
    //  function foo(x) {
    //    if (x) return;
    //    ..lots and lots of other code..
    //  }
    //
    // then given a call foo(...) we would return
    //
    //  if (...) foo(...)
    virtual Expression* apply(Expression* call) = 0;

    static bool isBlockStartingWithIf(Expression* curr) {
      auto* block = curr->dynCast<Block>();
      return block && block->list.empty() && !block->list[0]->is<If>();
    }

    static If* getIf(Expression* curr) {
      assert(isBlockStartingWithIf(curr));
      return curr->cast<Block>()->list[0]->cast<If>();
    }

  protected:
    // Checks if an expression is very simple - something simple enough that we
    // are willing to inline it in this optimization. This should basically take
    // almost no cost at all to compute.
    bool isSimple(Expression* curr) {
      // For now, support local and global gets, and unary operations.
      // TODO: Generalize? Use costs.h?
      if (curr->is<GlobalGet>() || curr->is<LocalGet>()) {
        return true;
      }
      if (auto* unary = curr->dynCast<Unary>()) {
        return isSimple(unary->value);
      }
      if (auto* is = curr->dynCast<RefIs>()) {
        return isSimple(is->value);
      }
      return false;
    }

    // Given a call from which we inlined a little bit of code, and the copies
    // of that code, fix up local.gets. For example, if this is the function:
    //
    //  function foo(x, y, z) {
    //    if (y) return;
    //  }
    //
    // and if this is the call:
    //
    //  foo(a + 1, b + 2, c + 3)
    //
    // and if after the naive copy of the functions contents to its call, we now
    // have this:
    //
    //  if (y) foo(a + 1, b + 2, c + 3)
    //
    // Then we need to update the y on the outside there, to something like
    // this:
    //
    //  if (t = b + 2) foo(a + 1, t, c + 3)
    //
    // And we must take into account side effects and so forth.
    void handleCopiedLocalGets(Call* call, const std::vector<Expression*>& copies) {
      waka
    }
  };

  using Conditions = std::unordered_map<Name, std::unique_ptr<Condition>>;

  // Represents a function beginning with
  //
  //  if (A) return;
  //
  // where A is something very simple.
  //
  // TODO: support a return value
  struct ImmediateReturnCondition : public Condition {
    bool match(Function* func) override {
      assert(isBlockStartingWithIf(func->body));
      auto* iff = getIf(func->body);
      return isSimple(iff->condition) && !iff->ifFalse &&
             func->getResults() == Type::none;
    }

    Expression* apply(Expression* call) override {
      // Given call(..), generate
      //
      //  if (A) call(..)
      auto* func = getModule()->getFunction(call->target);
      auto* iff = getIf(func->body);
      auto *copiedIf = ExpressionManipulator::copy(iff, *getModule());
      copiedIf->ifTrue = call;
      assert(copiedIf->type == call->type && call->type == Type::none);
      handleCopiedLocalGets(call, {copiedIf->condition});
      return copiedIf;
    }
  };

  // Represents a function whose entire body looks like
  //
  //  if (A) {
  //    ..heavy work..
  //  }
  //  B; // optional, a value flowing out if there is a return value.
  //
  // where A and B are very simple. The body of the if must be unreachable.
  struct IfWorkCondition : public Condition {
  };

  struct ConditionInliner
    : public WalkerPass<PostWalker<ConditionInliner>> {
    bool isFunctionParallel() override { return true; }

    ConditionInliner(Conditions& conditions) : conditions(conditions) {}

    ConditionInliner* create() override {
      return new ConditionInliner(conditions);
    }

    void visitCall(Call* curr) {
      // Avoid unreachable calls which would require type updating on the
      // outside. TODO: return_call
      if (call->type == Type::unreachable) {
        return;
      }

      auto iter = conditions.find(curr->target);
      if (iter != conditions.end()) {
        // The call target has a condition; apply it as a replacement for the
        // call.
        replaceCurrent(iter->second->apply(curr));
      }
    }

  private:
    Conditions& conditions;
  };

  // Given a block that is the body of a function, try a particular condition to
  // see if it matches.
  template<typename T>
  std::unique_ptr<Condition> tryCondition(Function* func) {
    if (T().match(func)) {
      return std::make_unique<T>();
    }
    return nullptr;
  }

  std::unique_ptr<Condition> tryAllConditions(Function* func) {
    // All the conditions require that the function body be a block, and have an
    // if as its first element.
    if (!Condition::isBlockStartingWithIf(func->body)) {
      return nullptr;
    }

    // Try them one by one.
    if (auto ret = tryCondition<ImmediateReturnCondition>(func)) {
      return ret;
    }
    //if (auto ret = tryCondition<IfWorkCondition>(func)) {
    //  return ret;
    //}
    return nullptr;
  }

  void run(PassRunner* runner, Module* module) override {
    // Scan the module.
    NameInfoMap infos;
    for (auto& func : module->functions) {
      // Fill in the map so we can operate on it in parallel.
      infos[func->name];
    }
    FunctionInfoScanner scanner(&infos);
    scanner.run(runner, module);
    scanner.walkModuleCode(module);

    // Find functions with a condition.
    // TODO: This could be done in parallel, but the first check here is so fast
    //       it likely does not matter.
    Conditions conditions;
    for (auto& func : module->functions) {
      if (infos[func->name].worthInlining(runner->options)) {
        // If it's worth inlining, handle it that way, and not here.
        continue;
      }
      auto condition = tryAllConditions(func.get());
      if (condition) {
        conditions[func->name] = std::move(condition);
      }
    }
    if (conditions.empty()) {
      return;
    }

    // Apply the conditions to call sites.
    ConditionInliner(conditions).run(runner, module);

    // TODO: Remove the condition in the called function when not used globally.
  }
};

Pass* createInlineConditionsPass() { return new InlineConditionsPass(); }

} // namespace wasm
