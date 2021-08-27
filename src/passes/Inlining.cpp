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

#include <atomic>

#include "ir/debug.h"
#include "ir/element-utils.h"
#include "ir/literal-utils.h"
#include "ir/module-utils.h"
#include "ir/names.h"
#include "ir/type-updating.h"
#include "ir/utils.h"
#include "parsing.h"
#include "pass.h"
#include "passes/opt-utils.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

// Useful into on a function, helping us decide if we can inline it
struct FunctionInfo {
  std::atomic<Index> refs;
  Index size;
  bool hasCalls;
  bool hasLoops;
  bool hasTryDelegate;
  bool usedGlobally; // in a table or export
  bool uninlineable;

  FunctionInfo() { clear(); }

  void clear() {
    refs = 0;
    size = 0;
    hasCalls = false;
    hasLoops = false;
    hasTryDelegate = false;
    usedGlobally = false;
    uninlineable = false;
  }

  // Provide an explicit = operator as the |refs| field lacks one by default.
  FunctionInfo& operator=(FunctionInfo& other) {
    refs.store(other.refs.load());
    size = other.size;
    hasCalls = other.hasCalls;
    hasLoops = other.hasLoops;
    hasTryDelegate = other.hasTryDelegate;
    usedGlobally = other.usedGlobally;
    uninlineable = other.uninlineable;
    return *this;
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

//
// Function splitting.
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
// Instead of inlining the condition, we take the simpler approach of outlining
// the rest of the code. By splitting the function into an easily-inlineable
// part, and a separate "heavy" part, we can achieve our goal by letting
// normal inlining run on the easily-inlineable piece. That is, given foo()
// above, we transform it to this:
//
//  function foo(x) {
//    if (x) return;
//    foo$heavy(x);
//  }
//
// And we create a new function
//
//  function foo$heavy(x) {
//    ..lots and lots of other code..
//  }
//
// We then depend on the modified foo() being inlined, at which point we return
// to the result mentioned earlier.

struct FunctionSplitter {
  Module* module;
  PassOptions& options;

  // Receive the module and the info about function inlineability. We will
  // update that info if/when we split.
  FunctionSplitter(Module* module, PassOptions& options)
    : module(module), options(options) {}

  // Check if an uninlineable function could be split in order to at least
  // inline part of it.
  bool worthSplitting(Function* func) { return maybeSplit(func); }

  // Returns the function we can inline, after we split the function into
  // pieces.
  Function* getInlineableSplitFunction(Function* func) {
    Function* inlineable = nullptr;
    auto success = maybeSplit(func, &inlineable);
    assert(success && inlineable);
    return inlineable;
  }

  Function* getOutlinedSplitFunction(Function* func) {
    assert(splits.count(func));
    return splits[func].outlined;
  }

private:
  // The two pieces we get after splitting a function into two.
  struct Split {
    // Whether we can split the original function. If not, the other two fields
    // here are null.
    bool splittable = false;

    // The inlineable function, that is, a lightweight condition we want to
    // inline.
    Function* inlineable = nullptr;

    // The outlined function, that is, heavy code we do not want to inline.
    Function* outlined = nullptr;
  };

  // All the split checks and actual splits we have already performed. This maps
  // the original function to the two split pieces of it.
  std::unordered_map<Function*, Split> splits;

  // Check if we can split a function. Returns whether we can. If the out param
  // is provided, also actually does the split, and returns the inlineable split
  // function in that out param.
  bool maybeSplit(Function* func, Function** inlineableOut = nullptr) {
    // Check if we've processed this input before.
    auto iter = splits.find(func);
    if (iter != splits.end()) {
      if (!iter->second.splittable) {
        return false;
      }
      if (iter->second.inlineable) {
        if (inlineableOut) {
          *inlineableOut = iter->second.inlineable;
        }
        return true;
      }
      // Otherwise, we are splittable but have not performed the split yet;
      // proceed to do so.
    }

    // The default value of split.splittable is false, so if we fail we just
    // need to return false from this function. On success, we update this info
    // in startSplit().
    auto& split = splits[func];

    auto* body = func->body;

    // All the patterns we look for atm start with an if at the very top of the
    // function. If that if conditionalizes almost all the work in the function,
    // then it seems promising to inling that if's condition (by outlining the
    // heavy work, as mentioned earlier).
    if (!isBlockStartingWithIf(body)) {
      return false;
    }
    auto* iff = getIf(body);

    // If the condition is not very simple, the benefits of this optimization
    // are not obvious.
    if (!isSimple(iff->condition)) {
      return false;
    }

    Builder builder(*module);

    // Pattern A: Check if the function begins with
    //
    //  if (simple) return;
    //
    // TODO: support a return value
    if (!iff->ifFalse && func->getResults() == Type::none &&
        iff->ifTrue->is<Return>()) {
      // If we were just checking, stop and report success.
      if (!inlineableOut) {
        split.splittable = true;
        return true;
      }

      startSplit(split, func);

      // The inlineable function now only has the if, which will call the
      // outlined heavy work with a flipped condition.
      auto* inlineableIf = getIf(split.inlineable->body);
      std::vector<Expression*> args;
      for (Index i = 0; i < func->getNumParams(); i++) {
        args.push_back(builder.makeLocalGet(i, func->getLocalType(i)));
      }
      inlineableIf->condition =
        builder.makeUnary(EqZInt32, inlineableIf->condition);
      inlineableIf->ifTrue =
        builder.makeCall(split.outlined->name, args, Type::none);
      split.inlineable->body = inlineableIf;

      // The outlined heavy work no longer needs the initial if.
      // TODO: If we handle the case with indirect calls and other global uses
      //       then we could not do this, as those calls would skip the first
      //       function with the condition that calls the heavy work.
      auto& outlinedList = split.outlined->body->cast<Block>()->list;
      outlinedList.erase(outlinedList.begin());

      *inlineableOut = split.inlineable;
      return true;
    }

    auto& list = body->cast<Block>()->list;

    // Pattern B: Represents a function whose entire body looks like
    //
    //  if (A) {
    //    ..heavy work..
    //  }
    //  B; // a value flowing out, if there is a return value
    //
    // where A and B are very simple. The body of the if must be unreachable.
    if (!iff->ifFalse && iff->ifTrue->type == Type::unreachable &&
        list.size() == 2 && isSimple(list[1])) {
      if (!inlineableOut) {
        split.splittable = true;
        return true;
      }

      startSplit(split, func);

      // The inlineable function now only has the if, which will call the
      // outlined heavy work, plus the content after the if.
      auto* inlineableIf = getIf(split.inlineable->body);
      std::vector<Expression*> args; // TODO helper
      for (Index i = 0; i < func->getNumParams(); i++) {
        args.push_back(builder.makeLocalGet(i, func->getLocalType(i)));
      }
      inlineableIf->ifTrue = builder.makeReturn(
        builder.makeCall(split.outlined->name, args, func->getResults()));

      // The outlined function just contains the heavy work.
      // TODO: see comment in the pattern above
      split.outlined->body = getIf(split.outlined->body)->ifTrue;

      *inlineableOut = split.inlineable;
      return true;
    }

    return false;
  }

  void startSplit(Split& split, Function* func) {
    split.splittable = true;

    // TODO: we could avoid some of the copying here
    split.inlineable = ModuleUtils::copyFunction(
      func,
      *module,
      Names::getValidFunctionName(
        *module, func->name.str + std::string("$byn-outline-A-inlineable")));
    split.outlined = ModuleUtils::copyFunction(
      func,
      *module,
      Names::getValidFunctionName(
        *module, func->name.str + std::string("$byn-outline-A-outlined")));
  }

  static bool isBlockStartingWithIf(Expression* curr) {
    auto* block = curr->dynCast<Block>();
    return block && !block->list.empty() && block->list[0]->is<If>();
  }

  static If* getIf(Expression* curr) {
    assert(isBlockStartingWithIf(curr));
    return curr->cast<Block>()->list[0]->cast<If>();
  }

  // Checks if an expression is very simple - something simple enough that we
  // are willing to inline it in this optimization. This should basically take
  // almost no cost at all to compute.
  bool isSimple(Expression* curr) {
    // For now, support local and global gets, and unary operations.
    // TODO: Generalize? Use costs.h?
    if (curr->type == Type::unreachable) {
      return false;
    }
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
};

struct Inlining : public Pass {
  // This pass changes locals and parameters.
  // FIXME DWARF updating does not handle local changes yet.
  bool invalidatesDWARF() override { return true; }

  // whether to optimize where we inline
  bool optimize = false;

  // the information for each function. recomputed in each iteraction
  NameInfoMap infos;

  std::unique_ptr<FunctionSplitter> functionSplitter;

  PassRunner* runner = nullptr;
  Module* module = nullptr;

  void run(PassRunner* runner_, Module* module_) override {
    runner = runner_;
    module = module_;

    // When optimizing heavily for size, we may potentially split functions in
    // order to inline parts of them.
    if (runner->options.optimizeLevel >= 3 && !runner->options.shrinkLevel) {
      functionSplitter =
        std::make_unique<FunctionSplitter>(module, runner->options);
    }

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

      calculateInfos();

      iterationNumber++;
      std::unordered_set<Function*> inlinedInto;
      iteration(inlinedInto);
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

  void calculateInfos() {
    infos.clear();
    // fill in info, as we operate on it in parallel (each function to its own
    // entry)
    for (auto& func : module->functions) {
      infos[func->name];
    }
    PassRunner runner(module);
    FunctionInfoScanner scanner(&infos);
    scanner.run(&runner, module);
    // fill in global uses
    scanner.walkModuleCode(module);
    for (auto& ex : module->exports) {
      if (ex->kind == ExternalKind::Function) {
        infos[ex->value].usedGlobally = true;
      }
    }
    if (module->start.is()) {
      infos[module->start].usedGlobally = true;
    }
  }

  void iteration(std::unordered_set<Function*>& inlinedInto) {
    // decide which to inline
    InliningState state;
    ModuleUtils::iterDefinedFunctions(*module, [&](Function* func) {
      if (worthInlining(func->name)) {
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
    for (auto& kv : state.actionsForFunction) {
      Name name = kv.first;
      auto& actions = kv.second;
      auto* func = module->getFunction(name);
      // if we've inlined a function, don't inline into it in this iteration,
      // avoid risk of races
      // note that we do not risk stalling progress, as each iteration() will
      // inline at least one call before hitting this
      if (inlinedUses.count(func->name)) {
        continue;
      }
      for (auto& action : actions) {
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

        // Success - we can inline.
#ifdef INLINING_DEBUG
        std::cout << "inline " << inlinedName << " into " << func->name << '\n';
#endif
        action.contents = getActuallyInlinedFunction(action.contents);
        doInlining(module, func, action);
        inlinedUses[inlinedName]++;
        inlinedInto.insert(func);
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

  bool worthInlining(Name name) {
    // Check if the function itself is worth inlining as it is.
    if (infos[name].worthInlining(runner->options)) {
      return true;
    }

    // Otherwise, check if we can at least inline part of it, if we are
    // interested in such things.
    if (functionSplitter &&
        functionSplitter->worthSplitting(module->getFunction(name))) {
      return true;
    }

    return false;
  }

  // Gets the actual function to be inlined. Normally this is the function
  // itself, but if it is a function we must first split then it will be the
  // inlineable part of the split.
  //
  // This is called right before actually performing the inlining, that is, we
  // are guaranteed to inline after this.
  Function* getActuallyInlinedFunction(Function* func) {
    // If we want to inline this function itself, do so.
    if (infos[func->name].worthInlining(runner->options)) {
      return func;
    }

    // Otherwise, this is a case where we want to inline part of it, after
    // splitting.
    assert(functionSplitter);
    auto* ret = functionSplitter->getInlineableSplitFunction(func);

    // As we are going to inline this function, and not the original one that
    // we are splitting, we need to update the FunctionInfo data accordingly -
    // specifically, the |refs| field, which indicates how many calls exist to a
    // function, must always be accurate.
/*
    auto& originalInfo = infos[func->name];
    auto& inlineableInfo = infos[ret->name];
    auto& outlinedInfo =
      infos[functionSplitter->getOutlinedSplitFunction(func)->name];

    // There is a call from the function we are inlining into to the new
    // inlineable one, which replaces a call to the original function that we
    // are splitting.
    originalInfo.refs--;
    inlineableInfo.refs++;

    // Note that as we are about to inline the inlineable function, we will
    // reduce its refs back to zero while doing so, so each time we get to this
    // location we will have incremented its refs from 0 to 1. This assertion
    // ensures that we never end up with a non-inlined appearance of the
    // inlineable function, which we never want.
    assert(inlineableInfo.refs == 1);

    // There is an additional call to the outlined function, from the inlineable
    // one (that will shortly be code inside the function we are inling into).
    outlinedInfo.refs++;
*/

    return ret;
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

} // anonymous namespace

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

Pass* createInliningPass() { return new Inlining(); }

Pass* createInliningOptimizingPass() {
  auto* ret = new Inlining();
  ret->optimize = true;
  return ret;
}

Pass* createInlineMainPass() { return new InlineMainPass(); }

} // namespace wasm
