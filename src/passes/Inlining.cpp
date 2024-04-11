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
#include "ir/find_all.h"
#include "ir/literal-utils.h"
#include "ir/localize.h"
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

enum class InliningMode {
  // We do not know yet if this function can be inlined, as that has
  // not been computed yet.
  Unknown,
  // This function cannot be inlinined in any way.
  Uninlineable,
  // This function can be inlined fully, that is, normally: the entire function
  // can be inlined. This is in contrast to split/partial inlining, see below.
  Full,
  // This function cannot be inlined normally, but we can use split inlining,
  // using pattern "A" or "B" (see below).
  SplitPatternA,
  SplitPatternB
};

// Useful into on a function, helping us decide if we can inline it
struct FunctionInfo {
  std::atomic<Index> refs;
  Index size;
  bool hasCalls;
  bool hasLoops;
  bool hasTryDelegate;
  // Something is used globally if there is a reference to it in a table or
  // export etc.
  bool usedGlobally;
  // We consider a function to be a trivial call if the body is just a call with
  // trivial arguments, like this:
  //
  //  (func $forward (param $x) (param $y)
  //    (call $target (local.get $x) (local.get $y))
  //  )
  //
  // Specifically the body must be a call, and the operands to the call must be
  // of size 1 (generally, LocalGet or Const).
  bool isTrivialCall;
  InliningMode inliningMode;

  FunctionInfo() { clear(); }

  void clear() {
    refs = 0;
    size = 0;
    hasCalls = false;
    hasLoops = false;
    hasTryDelegate = false;
    usedGlobally = false;
    isTrivialCall = false;
    inliningMode = InliningMode::Unknown;
  }

  // Provide an explicit = operator as the |refs| field lacks one by default.
  FunctionInfo& operator=(FunctionInfo& other) {
    refs = other.refs.load();
    size = other.size;
    hasCalls = other.hasCalls;
    hasLoops = other.hasLoops;
    hasTryDelegate = other.hasTryDelegate;
    usedGlobally = other.usedGlobally;
    isTrivialCall = other.isTrivialCall;
    inliningMode = other.inliningMode;
    return *this;
  }

  // See pass.h for how defaults for these options were chosen.
  bool worthFullInlining(PassOptions& options) {
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
    // More than one use, so we can't eliminate it after inlining, and inlining
    // it will hurt code size. Stop if we are focused on size or not heavily
    // focused on speed.
    if (options.shrinkLevel > 0 || options.optimizeLevel < 3) {
      return false;
    }
    if (hasCalls) {
      // This has calls. If it is just a trivial call itself then inline, as we
      // will save a call that way - basically we skip a trampoline in the
      // middle - but if it is something more complex, leave it alone, as we may
      // not help much (and with recursion we may end up with a wasteful
      // increase in code size).
      //
      // Note that inlining trivial calls may increase code size, e.g. if they
      // use a parameter more than once (forcing us after inlining to save that
      // value to a local, etc.), but here we are optimizing for speed and not
      // size, so we risk it.
      return isTrivialCall;
    }
    // This doesn't have calls. Inline if loops do not prevent us (normally, a
    // loop suggests a lot of work and so inlining is less useful).
    return !hasLoops || options.inlining.allowFunctionsWithLoops;
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

  FunctionInfoScanner(NameInfoMap& infos) : infos(infos) {}

  std::unique_ptr<Pass> create() override {
    return std::make_unique<FunctionInfoScanner>(infos);
  }

  void visitLoop(Loop* curr) {
    // having a loop
    infos[getFunction()->name].hasLoops = true;
  }

  void visitCall(Call* curr) {
    // can't add a new element in parallel
    assert(infos.count(curr->target) > 0);
    infos[curr->target].refs++;
    // having a call
    infos[getFunction()->name].hasCalls = true;
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
      infos[getFunction()->name].hasTryDelegate = true;
    }
  }

  void visitRefFunc(RefFunc* curr) {
    assert(infos.count(curr->func) > 0);
    infos[curr->func].refs++;
  }

  void visitFunction(Function* curr) {
    auto& info = infos[curr->name];

    if (!canHandleParams(curr)) {
      info.inliningMode = InliningMode::Uninlineable;
    }

    info.size = Measurer::measure(curr->body);

    if (auto* call = curr->body->dynCast<Call>()) {
      if (info.size == call->operands.size() + 1) {
        // This function body is a call with some trivial (size 1) operands like
        // LocalGet or Const, so it is a trivial call.
        info.isTrivialCall = true;
      }
    }
  }

private:
  NameInfoMap& infos;
};

struct InliningAction {
  Expression** callSite;
  Function* contents;
  bool insideATry;

  InliningAction(Expression** callSite, Function* contents, bool insideATry)
    : callSite(callSite), contents(contents), insideATry(insideATry) {}
};

struct InliningState {
  // Maps functions worth inlining to the mode with which we can inline them.
  std::unordered_map<Name, InliningMode> inlinableFunctions;
  // function name => actions that can be performed in it
  std::unordered_map<Name, std::vector<InliningAction>> actionsForFunction;
};

struct Planner : public WalkerPass<TryDepthWalker<Planner>> {
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
    if (state->inlinableFunctions.count(curr->target) && !isUnreachable &&
        curr->target != getFunction()->name) {
      // nest the call in a block. that way the location of the pointer to the
      // call will not change even if we inline multiple times into the same
      // function, otherwise call1(call2()) might be a problem
      auto* block = Builder(*getModule()).makeBlock(curr);
      replaceCurrent(block);
      // can't add a new element in parallel
      assert(state->actionsForFunction.count(getFunction()->name) > 0);
      state->actionsForFunction[getFunction()->name].emplace_back(
        &block->list[0], getModule()->getFunction(curr->target), tryDepth > 0);
    }
  }

private:
  InliningState* state;
};

struct Updater : public TryDepthWalker<Updater> {
  Module* module;
  std::map<Index, Index> localMapping;
  Name returnName;
  Type resultType;
  bool isReturn;
  Builder* builder;
  PassOptions& options;

  struct ReturnCallInfo {
    // The original `return_call` or `return_call_indirect` or `return_call_ref`
    // with its operands replaced with `local.get`s.
    Expression* call;
    // The branch that is serving as the "return" part of the original
    // `return_call`.
    Break* branch;
  };

  // Collect information on return_calls in the inlined body. Each will be
  // turned into branches out of the original inlined body followed by
  // non-return version of the original `return_call`, followed by a branch out
  // to the caller. The branch labels will be filled in at the end of the walk.
  std::vector<ReturnCallInfo> returnCallInfos;

  Updater(PassOptions& options) : options(options) {}

  void visitReturn(Return* curr) {
    replaceCurrent(builder->makeBreak(returnName, curr->value));
  }

  template<typename T> void handleReturnCall(T* curr, Signature sig) {
    if (isReturn || !curr->isReturn) {
      // If the inlined callsite was already a return_call, then we can keep
      // return_calls in the inlined function rather than downgrading them.
      // That is, if A->B and B->C and both those calls are return_calls
      // then after inlining A->B we want to now have A->C be a
      // return_call.
      return;
    }

    if (tryDepth == 0) {
      // Return calls in inlined functions should only break out of
      // the scope of the inlined code, not the entire function they
      // are being inlined into. To achieve this, make the call a
      // non-return call and add a break. This does not cause
      // unbounded stack growth because inlining and return calling
      // both avoid creating a new stack frame.
      curr->isReturn = false;
      curr->type = sig.results;
      // There might still be unreachable children causing this to be
      // unreachable.
      curr->finalize();
      if (sig.results.isConcrete()) {
        replaceCurrent(builder->makeBreak(returnName, curr));
      } else {
        replaceCurrent(builder->blockify(curr, builder->makeBreak(returnName)));
      }
    } else {
      // Set the children to locals as necessary, then add a branch out of the
      // inlined body. The branch label will be set later when we create branch
      // targets for the calls.
      Block* childBlock = ChildLocalizer(curr, getFunction(), *module, options)
                            .getChildrenReplacement();
      Break* branch = builder->makeBreak(Name());
      childBlock->list.push_back(branch);
      childBlock->type = Type::unreachable;
      replaceCurrent(childBlock);

      curr->isReturn = false;
      curr->type = sig.results;
      returnCallInfos.push_back({curr, branch});
    }
  }

  void visitCall(Call* curr) {
    handleReturnCall(curr, module->getFunction(curr->target)->getSig());
  }

  void visitCallIndirect(CallIndirect* curr) {
    handleReturnCall(curr, curr->heapType.getSignature());
  }

  void visitCallRef(CallRef* curr) {
    Type targetType = curr->target->type;
    if (!targetType.isSignature()) {
      // We don't know what type the call should return, but it will also never
      // be reached, so we don't need to do anything here.
      return;
    }
    handleReturnCall(curr, targetType.getHeapType().getSignature());
  }

  void visitLocalGet(LocalGet* curr) {
    curr->index = localMapping[curr->index];
  }

  void visitLocalSet(LocalSet* curr) {
    curr->index = localMapping[curr->index];
  }

  void walk(Expression*& curr) {
    PostWalker<Updater>::walk(curr);
    if (returnCallInfos.empty()) {
      return;
    }

    Block* body = builder->blockify(curr);
    curr = body;
    auto blockNames = BranchUtils::BranchAccumulator::get(body);

    for (Index i = 0; i < returnCallInfos.size(); ++i) {
      auto& info = returnCallInfos[i];

      // Add a block containing the previous body and a branch up to the caller.
      // Give the block a name that will allow this return_call's original
      // callsite to branch out of it then execute the call before returning to
      // the caller.
      auto name = Names::getValidName(
        "__return_call", [&](Name test) { return !blockNames.count(test); }, i);
      blockNames.insert(name);
      info.branch->name = name;
      Block* oldBody = builder->makeBlock(body->list, body->type);
      body->list.clear();

      if (resultType.isConcrete()) {
        body->list.push_back(builder->makeBlock(
          name, {builder->makeBreak(returnName, oldBody)}, Type::none));
      } else {
        oldBody->list.push_back(builder->makeBreak(returnName));
        oldBody->name = name;
        oldBody->type = Type::none;
        body->list.push_back(oldBody);
      }
      body->list.push_back(info.call);
      body->finalize(resultType);
    }
  }
};

// Core inlining logic. Modifies the outside function (adding locals as
// needed), and returns the inlined code.
//
// An optional name hint can be provided, which will then be used in the name of
// the block we put the inlined code in. Using a unique name hint in each call
// of this function can reduce the risk of name overlaps (which cause fixup work
// in UniqueNameMapper::uniquify).
static Expression* doInlining(Module* module,
                              Function* into,
                              const InliningAction& action,
                              PassOptions& options,
                              Index nameHint = 0) {
  Function* from = action.contents;
  auto* call = (*action.callSite)->cast<Call>();

  // Works for return_call, too
  Type retType = module->getFunction(call->target)->getResults();

  // Build the block that will contain the inlined contents.
  Builder builder(*module);
  auto* block = builder.makeBlock();
  auto name = std::string("__inlined_func$") + from->name.toString();
  if (nameHint) {
    name += '$' + std::to_string(nameHint);
  }
  block->name = Name(name);

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
  // situation.) The latter case does not apply if the call is a
  // return_call inside a try, because in that case the call's
  // children do not appear inside the same block as the inlined body.
  bool hoistCall = call->isReturn && action.insideATry;
  if (BranchUtils::hasBranchTarget(from->body, block->name) ||
      (!hoistCall && BranchUtils::BranchSeeker::has(call, block->name))) {
    auto fromNames = BranchUtils::getBranchTargets(from->body);
    auto callNames = hoistCall ? BranchUtils::NameSet{}
                               : BranchUtils::BranchAccumulator::get(call);
    block->name = Names::getValidName(block->name, [&](Name test) {
      return !fromNames.count(test) && !callNames.count(test);
    });
  }

  // Prepare to update the inlined code's locals and other things.
  Updater updater(options);
  updater.setFunction(into);
  updater.module = module;
  updater.resultType = from->getResults();
  updater.returnName = block->name;
  updater.isReturn = call->isReturn;
  updater.builder = &builder;
  // Set up a locals mapping
  for (Index i = 0; i < from->getNumLocals(); i++) {
    updater.localMapping[i] = builder.addVar(into, from->getLocalType(i));
  }

  if (hoistCall) {
    // Wrap the existing function body in a block we can branch out of before
    // entering the inlined function body. This block must have a name that is
    // different from any other block name above the branch.
    auto intoNames = BranchUtils::BranchAccumulator::get(into->body);
    auto bodyName =
      Names::getValidName(Name("__original_body"),
                          [&](Name test) { return !intoNames.count(test); });
    if (retType.isConcrete()) {
      into->body = builder.makeBlock(
        bodyName, {builder.makeReturn(into->body)}, Type::none);
    } else {
      into->body = builder.makeBlock(
        bodyName, {into->body, builder.makeReturn()}, Type::none);
    }

    // Sequence the inlined function body after the original caller body.
    into->body = builder.makeSequence(into->body, block, retType);

    // Replace the original callsite with an expression that assigns the
    // operands into the params and branches out of the original body.
    auto numParams = from->getParams().size();
    if (numParams) {
      auto* branchBlock = builder.makeBlock();
      for (Index i = 0; i < numParams; i++) {
        branchBlock->list.push_back(
          builder.makeLocalSet(updater.localMapping[i], call->operands[i]));
      }
      branchBlock->list.push_back(builder.makeBreak(bodyName));
      branchBlock->finalize(Type::unreachable);
      *action.callSite = branchBlock;
    } else {
      *action.callSite = builder.makeBreak(bodyName);
    }
  } else {
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
        // Non-zeroable locals do not need to be zeroed out. As they have no
        // zero value they by definition should not be used before being written
        // to, so any value we set here would not be observed anyhow.
        continue;
      }
      block->list.push_back(
        builder.makeLocalSet(updater.localMapping[from->getVarIndexBase() + i],
                             LiteralUtils::makeZero(type, *module)));
    }
    if (call->isReturn) {
      assert(!action.insideATry);
      if (retType.isConcrete()) {
        *action.callSite = builder.makeReturn(block);
      } else {
        *action.callSite = builder.makeSequence(block, builder.makeReturn());
      }
    } else {
      *action.callSite = block;
    }
  }

  // Generate and update the inlined contents
  auto* contents = ExpressionManipulator::copy(from->body, *module);
  debug::copyDebugInfo(from->body, contents, from, into);
  updater.walk(contents);
  block->list.push_back(contents);
  block->type = retType;

  // The ReFinalize below will handle propagating unreachability if we need to
  // do so, that is, if the call was reachable but now the inlined content we
  // replaced it with was unreachable. The opposite case requires special
  // handling: ReFinalize works under the assumption that code can become
  // unreachable, but it does not go back from that state. But inlining can
  // cause that:
  //
  //  (call $A                               ;; an unreachable call
  //    (unreachable)
  //  )
  // =>
  //  (block $__inlined_A_body (result i32)  ;; reachable code after inlining
  //    (unreachable)
  //  )
  //
  // That is, if the called function wraps the input parameter in a block with a
  // declared type, then the block is not unreachable. And then we might error
  // if the outside expects the code to be unreachable - perhaps it only
  // validates that way. To fix this, if the call was unreachable then we make
  // the inlined code unreachable as well. That also maximizes DCE
  // opportunities by propagating unreachability as much as possible.
  //
  // (Note that we don't need to do this for a return_call, which is always
  // unreachable anyhow.)
  if (call->type == Type::unreachable && !call->isReturn) {
    // Make the replacement code unreachable. Note that we can't just add an
    // unreachable at the end, as the block might have breaks to it (returns are
    // transformed into those).
    Expression* old = block;
    if (old->type.isConcrete()) {
      old = builder.makeDrop(old);
    }
    *action.callSite = builder.makeSequence(old, builder.makeUnreachable());
  }
  // Anything we inlined into may now have non-unique label names, fix it up.
  // Note that we must do this before refinalization, as otherwise duplicate
  // block labels can lead to errors (the IR must be valid before we
  // refinalize).
  wasm::UniqueNameMapper::uniquify(into->body);
  // Inlining unreachable contents can make things in the function we inlined
  // into unreachable.
  ReFinalize().walkFunctionInModule(into, module);
  // New locals we added may require fixups for nondefaultability.
  // FIXME Is this not done automatically?
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
  // Even if this returns a split inlining mode, we may not end up inlining the
  // function, as the main inlining logic has a few other considerations to take
  // into account (like limitations on which functions can be inlined into in
  // each iteration, the number of iterations, etc.). Therefore this function
  // may only find out if we *can* split, but not actually do any splitting.
  //
  // Note that to avoid wasteful work, this function may return "Full" inlining
  // mode instead of a split inlining. That is, if it detects that a partial
  // inlining will trigger a follow up full inline of the splitted function
  // then it will instead return "InliningMode::Full" directly. In more detail,
  // imagine we have
  //
  //   foo(10);
  //
  // which calls
  //
  //   func foo(x) {
  //     if (x) {
  //       CODE
  //     }
  //   }
  //
  // If we partially inline then the call becomes
  //
  //   if (10) {
  //     outlined-CODE()
  //   }
  //
  // That is, we've only inlined the |if| out of foo(), and we call a function
  // that contains the code in CODE. But if CODE is small enough to be inlined
  // then a later iteration of the inliner will do just that. The result of this
  // split inlining and then full inlining of the outlined code is exactly the
  // same as if we normally inlined from the beginning, but it adds more work,
  // so we'd like to avoid it, which we do by seeing when a split would be
  // followed by inlining the remainder, and then we return Full here and just
  // inline it all normally.
  //
  // Note that the above issue shows that we may in some cases inline more than
  // the normal inlining limit. That is, if the inlining limit is 20, and CODE
  // in the example above was 19, then foo()'s size was 21 (when we add the if
  // and get of |x|). That leads to the situation where foo() is too big to
  // normally inline, but the outlined CODE can then be inlined. And this shows
  // that we end up inlining a function of size 21, even though it is larger
  // than our inlining limit. We consider this acceptable because it only
  // occurs on functions slightly larger than the inlining limit, and only if
  // they have the simple forms that split inlining recognizes, that we think
  // are useful to inline. Alternatively, if we wanted to avoid this, it would
  // add complexity because we'd need to recognize the outlined function with
  // CODE in it and *not* inline it even though it is small enough, after
  // splitting, to be inlined. That is, splitting creates smaller functions, so
  // it can lead to more inlining (but, again, that makes sense since we only
  // split on very specific patterns we believe are worth handling in that
  // manner).
  InliningMode getSplitDrivenInliningMode(Function* func, FunctionInfo& info) {
    const Index MaxIfs = options.inlining.partialInliningIfs;
    assert(MaxIfs > 0);

    auto* body = func->body;

    // If the body is a block, and we have breaks to that block, then we cannot
    // outline any code - we can't outline a break without the break's target.
    if (auto* block = body->dynCast<Block>()) {
      if (BranchUtils::BranchSeeker::has(block, block->name)) {
        return InliningMode::Uninlineable;
      }
    }

    // All the patterns we look for right now start with an if at the very top
    // of the function.
    auto* iff = getIf(body);
    if (!iff) {
      return InliningMode::Uninlineable;
    }

    // If the condition is not very simple, the benefits of this optimization
    // are not obvious.
    if (!isSimple(iff->condition)) {
      return InliningMode::Uninlineable;
    }

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

      auto outlinedFunctionSize = info.size - Measurer::measure(iff);
      // If outlined function will be worth normal inline, skip the intermediate
      // state and inline fully now. Note that if full inlining is disabled we
      // will not do this, and instead inline partially.
      if (!func->noFullInline &&
          outlinedFunctionWorthInlining(info, outlinedFunctionSize)) {
        return InliningMode::Full;
      }

      return InliningMode::SplitPatternA;
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
    Index numIfs = 0;
    while (getIf(body, numIfs) && numIfs <= MaxIfs) {
      numIfs++;
    }
    if (numIfs == 0 || numIfs > MaxIfs) {
      return InliningMode::Uninlineable;
    }

    // Look for a final item after the ifs.
    auto* finalItem = getItem(body, numIfs);

    // The final item must be simple (or not exist, which is simple enough).
    if (finalItem && !isSimple(finalItem)) {
      return InliningMode::Uninlineable;
    }

    // There must be no other items after the optional final one.
    if (finalItem && getItem(body, numIfs + 1)) {
      return InliningMode::Uninlineable;
    }
    // This has the general shape we seek. Check each if.
    for (Index i = 0; i < numIfs; i++) {
      auto* iff = getIf(body, i);
      // The if must have a simple condition and no else arm.
      if (!isSimple(iff->condition) || iff->ifFalse) {
        return InliningMode::Uninlineable;
      }
      if (iff->ifTrue->type == Type::none) {
        // This must have no returns.
        if (!FindAll<Return>(iff->ifTrue).list.empty()) {
          return InliningMode::Uninlineable;
        }
      } else {
        // This is an if without an else, and so the type is either none or
        // unreachable, and we ruled out none before.
        assert(iff->ifTrue->type == Type::unreachable);
      }
    }
    // Success, this matches the pattern.

    // If the outlined function will be worth inlining normally, skip the
    // intermediate state and inline fully now. (As above, if full inlining is
    // disabled, we only partially inline.)
    if (numIfs == 1) {
      auto outlinedFunctionSize = Measurer::measure(iff->ifTrue);
      if (!func->noFullInline &&
          outlinedFunctionWorthInlining(info, outlinedFunctionSize)) {
        return InliningMode::Full;
      }
    }

    return InliningMode::SplitPatternB;
  }

  // Returns the function we should inline, after we split the function into two
  // pieces as described above (that is, in the example above, this would return
  // foo$inlineable).
  //
  // This is called when we are definitely inlining the function, and so it will
  // perform the splitting (if that has not already been done before).
  Function* getInlineableSplitFunction(Function* func,
                                       InliningMode inliningMode) {
    assert(inliningMode == InliningMode::SplitPatternA ||
           inliningMode == InliningMode::SplitPatternB);
    auto& split = splits[func->name];

    if (!split.inlineable) {
      // We haven't performed the split, do it now.
      split.inlineable = doSplit(func, inliningMode);
    }

    return split.inlineable;
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

  bool outlinedFunctionWorthInlining(FunctionInfo& origin, Index sizeEstimate) {
    FunctionInfo info;
    // Start with a copy of the origin's info, and apply the size estimate.
    // This is not accurate, for example the origin function may have
    // loop or calls even though this section may not have.
    // This is a conservative estimate, that is, it will return true only when
    // it should, but might return false when a more precise analysis would
    // return true. And it is a practical estimation to avoid extra future work.
    info = origin;
    info.size = sizeEstimate;
    return info.worthFullInlining(options);
  }

  Function* doSplit(Function* func, InliningMode inliningMode) {
    Builder builder(*module);

    if (inliningMode == InliningMode::SplitPatternA) {
      // Note that "A" in the name here identifies this as being a split from
      // pattern A. The second pattern B will have B in the name.
      Function* inlineable = copyFunction(func, "inlineable-A");
      auto* outlined = copyFunction(func, "outlined-A");

      // The inlineable function should only have the if, which will call the
      // outlined function with a flipped condition.
      auto* inlineableIf = getIf(inlineable->body);
      inlineableIf->condition =
        builder.makeUnary(EqZInt32, inlineableIf->condition);
      inlineableIf->ifTrue = builder.makeCall(
        outlined->name, getForwardedArgs(func, builder), Type::none);
      inlineable->body = inlineableIf;

      // The outlined function no longer needs the initial if.
      auto& outlinedList = outlined->body->cast<Block>()->list;
      outlinedList.erase(outlinedList.begin());

      return inlineable;
    }

    assert(inliningMode == InliningMode::SplitPatternB);

    Function* inlineable = copyFunction(func, "inlineable-B");

    const Index MaxIfs = options.inlining.partialInliningIfs;
    assert(MaxIfs > 0);

    // The inlineable function should only have the ifs, which will call the
    // outlined heavy work.
    for (Index i = 0; i < MaxIfs; i++) {
      // For each if, create an outlined function with the body of that if,
      // and call that from the if.
      auto* inlineableIf = getIf(inlineable->body, i);
      if (!inlineableIf) {
        break;
      }
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

    return inlineable;
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
      FunctionInfoScanner scanner(infos);
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
    // order to inline parts of them, if partialInliningIfs is enabled.
    auto& options = getPassOptions();
    if (options.optimizeLevel >= 3 && !options.shrinkLevel &&
        options.inlining.partialInliningIfs) {
      functionSplitter = std::make_unique<FunctionSplitter>(module, options);
    }
  }

  void iteration(std::unordered_set<Function*>& inlinedInto) {
    // decide which to inline
    InliningState state;
    ModuleUtils::iterDefinedFunctions(*module, [&](Function* func) {
      InliningMode inliningMode = getInliningMode(func->name);
      assert(inliningMode != InliningMode::Unknown);
      if (inliningMode != InliningMode::Uninlineable) {
        state.inlinableFunctions[func->name] = inliningMode;
      }
    });
    if (state.inlinableFunctions.empty()) {
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
        doInlining(module, func, action, getPassOptions(), inlinedNameHint++);
        inlinedUses[inlinedName]++;
        inlinedInto.insert(func);
        assert(inlinedUses[inlinedName] <= infos[inlinedName].refs);
      }
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

  // See explanation in doInlining() for the parameter nameHint.
  Index inlinedNameHint = 0;

  // Decide for a given function whether to inline, and if so in what mode.
  InliningMode getInliningMode(Name name) {
    auto* func = module->getFunction(name);
    auto& info = infos[name];

    if (info.inliningMode != InliningMode::Unknown) {
      return info.inliningMode;
    }

    // Check if the function itself is worth inlining as it is.
    if (!func->noFullInline && info.worthFullInlining(getPassOptions())) {
      return info.inliningMode = InliningMode::Full;
    }

    // Otherwise, check if we can at least inline part of it, if we are
    // interested in such things.
    if (!func->noPartialInline && functionSplitter) {
      info.inliningMode = functionSplitter->getSplitDrivenInliningMode(
        module->getFunction(name), info);
      return info.inliningMode;
    }

    // Cannot be fully or partially inlined => uninlineable.
    info.inliningMode = InliningMode::Uninlineable;
    return info.inliningMode;
  }

  // Gets the actual function to be inlined. Normally this is the function
  // itself, but if it is a function that we must first split (i.e., we only
  // want to partially inline it) then it will be the inlineable part of the
  // split.
  //
  // This is called right before actually performing the inlining, that is, we
  // are guaranteed to inline after this.
  Function* getActuallyInlinedFunction(Function* func) {
    InliningMode inliningMode = infos[func->name].inliningMode;
    // If we want to inline this function itself, do so.
    if (inliningMode == InliningMode::Full) {
      return func;
    }

    // Otherwise, this is a case where we want to inline part of it, after
    // splitting.
    assert(functionSplitter);
    return functionSplitter->getInlineableSplitFunction(func, inliningMode);
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
    doInlining(module,
               main,
               InliningAction(callSite, originalMain, true),
               getPassOptions());
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
