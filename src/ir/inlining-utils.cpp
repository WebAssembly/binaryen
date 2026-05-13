/*
 * Copyright 2026 WebAssembly Community Group participants
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

#include "ir/branch-utils.h"
#include "ir/inlining-utils.h"
#include "ir/metadata.h"
#include "ir/names.h"
#include "ir/type-updating.h"
#include "ir/utils.h"
#include "wasm.h"
#include "wasm-builder.h"

namespace wasm::InliningUtils {

namespace {

// Process code after inlining, updating everything we need to.
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
        "__return_call",
        [&](Name test) { return !blockNames.contains(test); },
        i);
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

} // anonymous namespace

void doCodeInlining(Module* module,
                    Function* into,
                    const InliningAction& action,
                    PassOptions& options) {
  Function* from = action.contents;
  auto* call = (*action.callSite)->cast<Call>();

  // Works for return_call, too
  Type retType = module->getFunction(call->target)->getResults();

  // Build the block that will contain the inlined contents.
  Builder builder(*module);
  auto* block = builder.makeBlock();
  auto name = std::string("__inlined_func$") + from->name.toString();
  if (action.nameHint) {
    name += '$' + std::to_string(action.nameHint);
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
      return !fromNames.contains(test) && !callNames.contains(test);
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
                          [&](Name test) { return !intoNames.contains(test); });
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
  metadata::copyBetweenFunctions(from->body, contents, from, into);
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
}

// Updates the outer function after we inline into it. This is a general
// operation that does not depend on what we inlined, it just makes sure that we
// refinalize everything, have no duplicate break labels, etc.
void updateAfterInlining(Module* module, Function* into) {
  // Anything we inlined into may now have non-unique label names, fix it up.
  // Note that we must do this before refinalization, as otherwise duplicate
  // block labels can lead to errors (the IR must be valid before we
  // refinalize).
  wasm::UniqueNameMapper::uniquify(into->body);
  // Inlining unreachable contents can make things in the function we inlined
  // into unreachable.
  ReFinalize().walkFunctionInModule(into, module);
  // New locals we added may require fixups for nondefaultability. We do this
  // here and not in the main pass (or its subpasses) so that we only do it
  // where needed.
  TypeUpdating::handleNonDefaultableLocals(into, *module);
}

void doInlining(Module* module,
                Function* into,
                const InliningAction& action,
                PassOptions& options) {
  doCodeInlining(module, into, action, options);
  updateAfterInlining(module, into);
}

} // namespace wasm::InliningUtils
