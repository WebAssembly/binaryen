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

#include "ir/branch-utils.h"
#include "ir/debug.h"
#include "ir/drop.h"
#include "ir/eh-utils.h"
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
    refs = other.refs.load();
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

static bool canHandleParams(Function* func) {
  // We cannot inline a function if we cannot handle placing its params in a
  // locals, as all params become locals.
  for (auto param : func->getParams()) {
    if (!TypeUpdating::canHandleAsLocal(param)) {
      return false;
    }
  }
  return true;
}

using NameInfoMap = std::unordered_map<Name, FunctionInfo>;

struct FunctionInfoScanner
  : public WalkerPass<PostWalker<FunctionInfoScanner>> {
  bool isFunctionParallel() override { return true; }

  FunctionInfoScanner(NameInfoMap* infos) : infos(infos) {}

  std::unique_ptr<Pass> create() override {
    return std::make_unique<FunctionInfoScanner>(infos);
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

    if (!canHandleParams(curr)) {
      info.uninlineable = true;
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

  std::unique_ptr<Pass> create() override {
    return std::make_unique<Planner>(state);
  }

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
  bool isReturn;
  Builder* builder;
  PassOptions& options;

  Updater(PassOptions& options) : options(options) {}

  void visitReturn(Return* curr) {
    replaceCurrent(builder->makeBreak(returnName, curr->value));
  }
  // Return calls in inlined functions should only break out of the scope of
  // the inlined code, not the entire function they are being inlined into. To
  // achieve this, make the call a non-return call and add a break. This does
  // not cause unbounded stack growth because inlining and return calling both
  // avoid creating a new stack frame.
  template<typename T> void handleReturnCall(T* curr, Type results) {
    if (isReturn) {
      // If the inlined callsite was already a return_call, then we can keep
      // return_calls in the inlined function rather than downgrading them.
      // That is, if A->B and B->C and both those calls are return_calls
      // then after inlining A->B we want to now have A->C be a
      // return_call.
      return;
    }
    curr->isReturn = false;
    curr->type = results;
    // There might still be unreachable children causing this to be unreachable.
    curr->finalize();
    if (results.isConcrete()) {
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
      handleReturnCall(curr, curr->heapType.getSignature().results);
    }
  }
  void visitCallRef(CallRef* curr) {
    Type targetType = curr->target->type;
    if (targetType.isNull()) {
      // We don't know what type the call should return, but we can't leave it
      // as a potentially-invalid return_call_ref, either.
      replaceCurrent(getDroppedChildrenAndAppend(
        curr, *module, options, Builder(*module).makeUnreachable()));
      return;
    }
    if (curr->isReturn) {
      handleReturnCall(curr, targetType.getHeapType().getSignature().results);
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
static Expression* doInlining(Module* module,
                              Function* into,
                              const InliningAction& action,
                              PassOptions& options) {
  Function* from = action.contents;
  auto* call = (*action.callSite)->cast<Call>();
  // Works for return_call, too
  Type retType = module->getFunction(call->target)->getResults();
  Builder builder(*module);
  auto* block = builder.makeBlock();
  block->name = Name(std::string("__inlined_func$") + from->name.toString());
  // In the unlikely event that the function already has a branch target with
  // this name, fix that up, as otherwise we can get unexpected capture of our
  // branches, that is, we could end up with this:
  //
  //  (block $X             ;; a new block we add as the target of returns
  //    (from's contents
  //      (block $X         ;; a block in from's contents with a colliding name
  //        (br $X          ;; a new br we just added that replaces a return
  //
  // Here the br wants to go to the very outermost block, to represent a
  // return from the inlined function's code, but it ends up captured by an
  // internal block. We also need to be careful of the call's children:
  //
  //  (block $X             ;; a new block we add as the target of returns
  //    (local.set $param
  //      (call's first parameter
  //        (br $X)         ;; nested br in call's first parameter
  //      )
  //    )
  //
  // (In this case we could use a second block and define the named block $X
  // after the call's parameters, but that adds work for an extremely rare
  // situation.)
  if (BranchUtils::hasBranchTarget(from->body, block->name) ||
      BranchUtils::BranchSeeker::has(call, block->name)) {
    auto fromNames = BranchUtils::getBranchTargets(from->body);
    auto callNames = BranchUtils::BranchAccumulator::get(call);
    block->name = Names::getValidName(block->name, [&](Name test) {
      return !fromNames.count(test) && !callNames.count(test);
    });
  }
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
  Updater updater(options);
  updater.module = module;
  updater.returnName = block->name;
  updater.isReturn = call->isReturn;
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
    if (!LiteralUtils::canMakeZero(type)) {
      // Non-zeroable locals do not need to be zeroed out. As they have no zero
      // value they by definition should not be used before being written to, so
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
// Function splitting / partial inlining / inlining of conditions.
//
// A function may be too costly to inline, but it may be profitable to
// *partially* inline it. The specific cases optimized here are functions with a
// condition,
//
//  function foo(x) {
//    if (x) return;
//    ..lots and lots of other code..
//  }
//
// If the other code after the if is large enough or costly enough, then we will
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
//  function caller(x) {
//    if (0) foo(0);
//    if (x) foo(x);
//  }
//
// By inlining the condition out of foo() we gain two benefits:
//
//  * In the first call here the condition is zero, which means we can
//    statically optimize out the call entirely.
//  * Even if we can't do that (as in the second call) if at runtime we see the
//    condition is false then we avoid the call. That means we perform what is
//    hopefully a cheap branch instead of a call and then a branch.
//
// The cost to doing this is an increase in code size, and so this is only done
// when optimizing heavily for speed.
//
// To implement partial inlining we split the function to be inlined. Starting
// with
//
//  function foo(x) {
//    if (x) return;
//    ..lots and lots of other code..
//  }
//
// We create the "inlineable" part of it, and the code that is "outlined":
//
//  function foo$inlineable(x) {
//    if (x) return;
//    foo$outlined(x);
//  }
//  function foo$outlined(x) {
//    ..lots and lots of other code..
//  }
//
// (Note how if the second function were inlined into the first, we would end
// up where we started, with the original function.) After splitting the
// function in this way, we simply inline the inlineable part using the normal
// mechanism for that. That ends up replacing  foo(x);  with
//
//  if (x) foo$outlined(x);
//
// which is what we wanted.
//
// To reduce the complexity of this feature, it is implemented almost entirely
// in its own class, FunctionSplitter. The main inlining logic just calls out to
// the splitter to check if a function is worth splitting, and to get the split
// part if so.
//

struct FunctionSplitter {
  Module* module;
  PassOptions& options;

  FunctionSplitter(Module* module, PassOptions& options)
    : module(module), options(options) {}

  // Check if an function could be split in order to at least inline part of it,
  // in a worthwhile manner.
  //
  // Even if this returns true, we may not end up inlining the function, as the
  // main inlining logic has a few other considerations to take into account
  // (like limitations on which functions can be inlined into in each iteration,
  // the number of iterations, etc.). Therefore this function will only find out
  // if we *can* split, but not actually do any splitting.
  bool canSplit(Function* func) {
    if (!canHandleParams(func)) {
      return false;
    }

    return maybeSplit(func);
  }

  // Returns the function we should inline, after we split the function into two
  // pieces as described above (that is, in the example above, this would return
  // foo$inlineable).
  //
  // This is called when we are definitely inlining the function, and so it will
  // perform the splitting (if that has not already been done before).
  Function* getInlineableSplitFunction(Function* func) {
    Function* inlineable = nullptr;
    [[maybe_unused]] auto success = maybeSplit(func, &inlineable);
    assert(success && inlineable);
    return inlineable;
  }

  // Clean up. When we are done we no longer need the inlineable functions on
  // the module, as they have been inlined into all the places we wanted them
  // for.
  //
  // Returns a list of the names of the functions we split.
  std::vector<Name> finish() {
    std::vector<Name> ret;
    std::unordered_set<Name> inlineableNames;
    for (auto& [func, split] : splits) {
      auto* inlineable = split.inlineable;
      if (inlineable) {
        inlineableNames.insert(inlineable->name);
        ret.push_back(func);
      }
    }
    module->removeFunctions([&](Function* func) {
      return inlineableNames.find(func->name) != inlineableNames.end();
    });
    return ret;
  }

private:
  // Information about splitting a function.
  struct Split {
    // Whether we can split the function. If this is false, the other two will
    // remain nullptr forever; if this is true then we will populate them the
    // first time we need them.
    bool splittable = false;

    // The inlineable function out of the two that we generate by splitting.
    // That is, foo$inlineable from above.
    Function* inlineable = nullptr;

    // The outlined function, that is, foo$outlined from above.
    Function* outlined = nullptr;
  };

  // All the splitting we have already performed.
  //
  // Note that this maps from function names, and not Function*, as the main
  // inlining code can remove functions as it goes, but we can rely on names
  // staying constant.
  std::unordered_map<Name, Split> splits;

  // Check if we can split a function. Returns whether we can. If the out param
  // is provided, also actually does the split, and returns the inlineable split
  // function in that out param.
  bool maybeSplit(Function* func, Function** inlineableOut = nullptr) {
    // Check if we've processed this input before.
    auto iter = splits.find(func->name);
    if (iter != splits.end()) {
      if (!iter->second.splittable) {
        // We've seen before that this cannot be split.
        return false;
      }
      // We can split this function. If we've already done so, return that
      // cached result.
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
    // need to return false from this function. If, on the other hand, we can
    // split, then we will update this split info accordingly.
    auto& split = splits[func->name];

    auto* body = func->body;

    // If the body is a block, and we have breaks to that block, then we cannot
    // outline any code - we can't outline a break without the break's target.
    if (auto* block = body->dynCast<Block>()) {
      if (BranchUtils::BranchSeeker::has(block, block->name)) {
        return false;
      }
    }

    // All the patterns we look for right now start with an if at the very top
    // of the function.
    auto* iff = getIf(body);
    if (!iff) {
      return false;
    }

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
      // The body must be a block, because if it were not then the function
      // would be easily inlineable (just an if with a simple condition and a
      // return), and we would not even attempt to do splitting.
      assert(body->is<Block>());

      split.splittable = true;
      // If we were just checking, stop and report success.
      if (!inlineableOut) {
        return true;
      }

      // Note that "A" in the name here identifies this as being a split from
      // pattern A. The second pattern B will have B in the name.
      split.inlineable = copyFunction(func, "inlineable-A");
      auto* outlined = copyFunction(func, "outlined-A");

      // The inlineable function should only have the if, which will call the
      // outlined function with a flipped condition.
      auto* inlineableIf = getIf(split.inlineable->body);
      inlineableIf->condition =
        builder.makeUnary(EqZInt32, inlineableIf->condition);
      inlineableIf->ifTrue = builder.makeCall(
        outlined->name, getForwardedArgs(func, builder), Type::none);
      split.inlineable->body = inlineableIf;

      // The outlined function no longer needs the initial if.
      auto& outlinedList = outlined->body->cast<Block>()->list;
      outlinedList.erase(outlinedList.begin());

      *inlineableOut = split.inlineable;
      return true;
    }

    // Pattern B: Represents a function whose entire body looks like
    //
    //  if (A_1) {
    //    ..heavy work..
    //  }
    //  ..
    //  if (A_k) {
    //    ..heavy work..
    //  }
    //  B; // an optional final value (which can be a return value)
    //
    // where there is a small number of such ifs with arguments A1..A_k, and
    // A_1..A_k and B (if the final value B exists) are very simple.
    //
    // Also, each if body must either be unreachable, or it must have type none
    // and have no returns. If it is unreachable, for example because it is a
    // return, then we will just return a value in the inlineable function:
    //
    //  if (A_i) {
    //    return outlined(..);
    //  }
    //
    // Or, if an if body has type none, then for now we assume that we do not
    // need to return a value from there, which makes things simpler, and in
    // that case we just do this, which continues onward in the function:
    //
    //  if (A_i) {
    //    outlined(..);
    //  }
    //
    // TODO: handle a possible returned value in this case as well.
    //
    // Note that the if body type must be unreachable or none, as this is an if
    // without an else.

    // Find the number of ifs.
    const Index MaxIfs = options.inlining.partialInliningIfs;
    Index numIfs = 0;
    while (getIf(body, numIfs) && numIfs <= MaxIfs) {
      numIfs++;
    }
    if (numIfs == 0 || numIfs > MaxIfs) {
      return false;
    }

    // Look for a final item after the ifs.
    auto* finalItem = getItem(body, numIfs);

    // The final item must be simple (or not exist, which is simple enough).
    if (finalItem && !isSimple(finalItem)) {
      return false;
    }

    // There must be no other items after the optional final one.
    if (finalItem && getItem(body, numIfs + 1)) {
      return false;
    }
    // This has the general shape we seek. Check each if.
    for (Index i = 0; i < numIfs; i++) {
      auto* iff = getIf(body, i);
      // The if must have a simple condition and no else arm.
      if (!isSimple(iff->condition) || iff->ifFalse) {
        return false;
      }
      if (iff->ifTrue->type == Type::none) {
        // This must have no returns.
        if (!FindAll<Return>(iff->ifTrue).list.empty()) {
          return false;
        }
      } else {
        // This is an if without an else, and so the type is either none of
        // unreachable;
        assert(iff->ifTrue->type == Type::unreachable);
      }
    }

    // Success, this matches the pattern. Exit if we were just checking.
    split.splittable = true;
    if (!inlineableOut) {
      return true;
    }

    split.inlineable = copyFunction(func, "inlineable-B");

    // The inlineable function should only have the ifs, which will call the
    // outlined heavy work.
    for (Index i = 0; i < numIfs; i++) {
      // For each if, create an outlined function with the body of that if,
      // and call that from the if.
      auto* inlineableIf = getIf(split.inlineable->body, i);
      auto* outlined = copyFunction(func, "outlined-B");
      outlined->body = inlineableIf->ifTrue;

      // The outlined function either returns the same results as the original
      // one, or nothing, depending on if a value is returned here.
      auto valueReturned =
        func->getResults() != Type::none && outlined->body->type != Type::none;
      outlined->setResults(valueReturned ? func->getResults() : Type::none);
      inlineableIf->ifTrue = builder.makeCall(outlined->name,
                                              getForwardedArgs(func, builder),
                                              outlined->getResults());
      if (valueReturned) {
        inlineableIf->ifTrue = builder.makeReturn(inlineableIf->ifTrue);
      }
    }

    // We can just leave the final value at the end, if it exists.

    *inlineableOut = split.inlineable;
    return true;
  }

  Function* copyFunction(Function* func, std::string prefix) {
    // TODO: We copy quite a lot more than we need here, and throw stuff out.
    //       It is simple to just copy the entire thing to get the params and
    //       results and all that, but we could be more efficient.
    prefix = "byn-split-" + prefix;
    return ModuleUtils::copyFunction(
      func,
      *module,
      Names::getValidFunctionName(*module,
                                  prefix + '$' + func->name.toString()));
  }

  // Get the i-th item in a sequence of initial items in an expression. That is,
  // if the item is a block, it may have several such items, and otherwise there
  // is a single item, that item itself. This basically provides a simpler
  // interface than checking if something is a block or not when there is just
  // one item.
  //
  // Returns nullptr if there is no such item.
  static Expression* getItem(Expression* curr, Index i = 0) {
    if (auto* block = curr->dynCast<Block>()) {
      auto& list = block->list;
      if (i < list.size()) {
        return list[i];
      }
    }
    if (i == 0) {
      return curr;
    }
    return nullptr;
  }

  // Get the i-th if in a sequence of initial ifs in an expression. If no such
  // if exists, returns nullptr.
  static If* getIf(Expression* curr, Index i = 0) {
    auto* item = getItem(curr, i);
    if (!item) {
      return nullptr;
    }
    if (auto* iff = item->dynCast<If>()) {
      return iff;
    }
    return nullptr;
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
    if (auto* is = curr->dynCast<RefIsNull>()) {
      return isSimple(is->value);
    }
    return false;
  }

  // Returns a list of local.gets, one for each of the parameters to the
  // function. This forwards the arguments passed to the inlineable function to
  // the outlined one.
  std::vector<Expression*> getForwardedArgs(Function* func, Builder& builder) {
    std::vector<Expression*> args;
    for (Index i = 0; i < func->getNumParams(); i++) {
      args.push_back(builder.makeLocalGet(i, func->getLocalType(i)));
    }
    return args;
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

  Module* module = nullptr;

  void run(Module* module_) override {
    module = module_;

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
    //
    // In addition to inlining into a function, we track how many times we do
    // other potentially repetitive operations like splitting a function before
    // inlining, as any such repetitive operation should be limited in how many
    // times we perform it. (An exception is how many times we inlined a
    // function, which we do not want to limit - it can be profitable to inline
    // a call into a great many callsites, over many iterations.)
    //
    // (Track names here, and not Function pointers, as we can remove functions
    // while inlining, and it may be confusing during debugging to have a
    // pointer to something that was removed.)
    std::unordered_map<Name, Index> iterationCounts;

    const size_t MaxIterationsForFunc = 5;

    while (iterationNumber <= numOriginalFunctions) {
#ifdef INLINING_DEBUG
      std::cout << "inlining loop iter " << iterationNumber
                << " (numFunctions: " << module->functions.size() << ")\n";
#endif
      iterationNumber++;

      std::unordered_set<Function*> inlinedInto;

      prepare();
      iteration(inlinedInto);

      if (inlinedInto.empty()) {
        return;
      }

#ifdef INLINING_DEBUG
      std::cout << "  inlined into " << inlinedInto.size() << " funcs.\n";
#endif

      for (auto* func : inlinedInto) {
        EHUtils::handleBlockNestedPops(func, *module);
      }

      for (auto* func : inlinedInto) {
        if (++iterationCounts[func->name] >= MaxIterationsForFunc) {
          return;
        }
      }

      if (functionSplitter) {
        auto splitNames = functionSplitter->finish();
        for (auto name : splitNames) {
          if (++iterationCounts[name] >= MaxIterationsForFunc) {
            return;
          }
        }
      }
    }
  }

  void prepare() {
    infos.clear();
    // fill in info, as we operate on it in parallel (each function to its own
    // entry)
    for (auto& func : module->functions) {
      infos[func->name];
    }
    {
      FunctionInfoScanner scanner(&infos);
      scanner.run(getPassRunner(), module);
      scanner.walkModuleCode(module);
    }
    for (auto& ex : module->exports) {
      if (ex->kind == ExternalKind::Function) {
        infos[ex->value].usedGlobally = true;
      }
    }
    if (module->start.is()) {
      infos[module->start].usedGlobally = true;
    }

    // When optimizing heavily for size, we may potentially split functions in
    // order to inline parts of them.
    if (getPassOptions().optimizeLevel >= 3 && !getPassOptions().shrinkLevel) {
      functionSplitter =
        std::make_unique<FunctionSplitter>(module, getPassOptions());
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
    // Fill in actionsForFunction, as we operate on it in parallel (each
    // function to its own entry). Also generate a vector of the function names
    // so that in the later loop we can iterate on it deterministically and
    // without iterator invalidation.
    std::vector<Name> funcNames;
    for (auto& func : module->functions) {
      state.actionsForFunction[func->name];
      funcNames.push_back(func->name);
    }
    // find and plan inlinings
    Planner(&state).run(getPassRunner(), module);
    // perform inlinings TODO: parallelize
    std::unordered_map<Name, Index> inlinedUses; // how many uses we inlined
    // which functions were inlined into
    for (auto name : funcNames) {
      auto* func = module->getFunction(name);
      // if we've inlined a function, don't inline into it in this iteration,
      // avoid risk of races
      // note that we do not risk stalling progress, as each iteration() will
      // inline at least one call before hitting this
      if (inlinedUses.count(func->name)) {
        continue;
      }
      for (auto& action : state.actionsForFunction[name]) {
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

        // Update the action for the actual inlining we are about to perform
        // (when splitting, we will actually inline one of the split pieces and
        // not the original function itself; note how even if we do that then
        // we are still removing a call to the original function here, and so
        // we do not need to change anything else lower down - we still want to
        // note that we got rid of one use of the original function).
        action.contents = getActuallyInlinedFunction(action.contents);

        // Perform the inlining and update counts.
        doInlining(module, func, action, getPassOptions());
        inlinedUses[inlinedName]++;
        inlinedInto.insert(func);
        assert(inlinedUses[inlinedName] <= infos[inlinedName].refs);
      }
    }
    for (auto func : inlinedInto) {
      // Anything we inlined into may now have non-unique label names, fix it
      // up.
      wasm::UniqueNameMapper::uniquify(func->body);
    }
    if (optimize && inlinedInto.size() > 0) {
      OptUtils::optimizeAfterInlining(inlinedInto, module, getPassRunner());
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
    if (infos[name].worthInlining(getPassOptions())) {
      return true;
    }

    // Otherwise, check if we can at least inline part of it, if we are
    // interested in such things.
    if (functionSplitter &&
        functionSplitter->canSplit(module->getFunction(name))) {
      return true;
    }

    return false;
  }

  // Gets the actual function to be inlined. Normally this is the function
  // itself, but if it is a function that we must first split (i.e., we only
  // want to partially inline it) then it will be the inlineable part of the
  // split.
  //
  // This is called right before actually performing the inlining, that is, we
  // are guaranteed to inline after this.
  Function* getActuallyInlinedFunction(Function* func) {
    // If we want to inline this function itself, do so.
    if (infos[func->name].worthInlining(getPassOptions())) {
      return func;
    }

    // Otherwise, this is a case where we want to inline part of it, after
    // splitting.
    assert(functionSplitter);
    return functionSplitter->getInlineableSplitFunction(func);
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
  void run(Module* module) override {
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
    doInlining(
      module, main, InliningAction(callSite, originalMain), getPassOptions());
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
