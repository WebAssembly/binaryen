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

//
// Grand Unified Flow Analysis (GUFA)
//
// Optimize based on information about what content can appear in each location
// in the program. This does a whole-program analysis to find that out and
// hopefully learn more than the type system does - for example, a type might be
// $A, which means $A or any subtype can appear there, but perhaps the analysis
// can find that only $A', a particular subtype, can appear there in practice,
// and not $A or any subtypes of $A', etc. Or, we may find that no type is
// actually possible at a particular location, say if we can prove that the
// casts on the way to that location allow nothing through. We can also find
// that only a particular value is possible of that type.
//
// GUFA will infer constants and unreachability, and add those to the code. This
// can increase code size if further optimizations are not run later like dead
// code elimination and vacuum. The "optimizing" variant of this pass will run
// such followup opts automatically in functions where we make changes, and so
// it is useful if GUFA is run near the end of the optimization pipeline.
//
// TODO: GUFA + polymorphic devirtualization + traps-never-happen. If we see
//       that the possible call targets are {A, B, C}, and GUFA info lets us
//       prove that A, C will trap if called - say, if they cast the first
//       parameter to something GUFA proved it cannot be - then we can ignore
//       them, and devirtualize to a call to B.
//

#include "ir/drop.h"
#include "ir/eh-utils.h"
#include "ir/possible-contents.h"
#include "ir/properties.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm.h"

namespace wasm {

namespace {

struct GUFAOptimizer
  : public WalkerPass<
      PostWalker<GUFAOptimizer, UnifiedExpressionVisitor<GUFAOptimizer>>> {
  bool isFunctionParallel() override { return true; }

  ContentOracle& oracle;
  bool optimizing;

  GUFAOptimizer(ContentOracle& oracle, bool optimizing)
    : oracle(oracle), optimizing(optimizing) {}

  std::unique_ptr<Pass> create() override {
    return std::make_unique<GUFAOptimizer>(oracle, optimizing);
  }

  bool optimized = false;

  // As we optimize, we replace expressions and create new ones. For new ones
  // we can infer their contents based on what they replaced, e.g., if we
  // replaced a local.get with a const, then the PossibleContents of the const
  // are the same as the local.get (in this simple example, we could also just
  // infer them from the const itself, of course). Rather than update the
  // ContentOracle with new contents, which is a shared object among threads,
  // each function-parallel worker stores a map of new things it created to the
  // contents for them.
  std::unordered_map<Expression*, PossibleContents> newContents;

  Expression* replaceCurrent(Expression* rep) {
    newContents[rep] = oracle.getContents(getCurrent());

    return WalkerPass<
      PostWalker<GUFAOptimizer,
                 UnifiedExpressionVisitor<GUFAOptimizer>>>::replaceCurrent(rep);
  }

  const PossibleContents getContents(Expression* curr) {
    // If this is something we added ourselves, use that; otherwise the info is
    // in the oracle.
    if (auto iter = newContents.find(curr); iter != newContents.end()) {
      return iter->second;
    }

    return oracle.getContents(curr);
  }

  void visitExpression(Expression* curr) {
    // Skip things we can't improve in any way.
    auto type = curr->type;
    if (type == Type::unreachable || type == Type::none ||
        Properties::isConstantExpression(curr)) {
      return;
    }

    if (type.isTuple()) {
      // TODO: tuple types.
      return;
    }

    // Ok, this is an interesting location that we might optimize. See what the
    // oracle says is possible there.
    auto contents = getContents(curr);

    auto& options = getPassOptions();
    auto& wasm = *getModule();
    Builder builder(wasm);

    if (contents.getType() == Type::unreachable) {
      // This cannot contain any possible value at all. It must be unreachable
      // code.
      replaceCurrent(getDroppedChildrenAndAppend(
        curr, wasm, options, builder.makeUnreachable()));
      optimized = true;
      return;
    }

    // This is reachable. Check if we can emit something optimized for it.
    // TODO: can we handle more general things here too?
    if (!contents.canMakeExpression()) {
      return;
    }

    if (contents.isNull() && curr->type.isNullable()) {
      // Null values are all identical, so just fix up the type here if we need
      // to (the null's type might not fit in this expression, if it passed
      // through casts).
      if (!Type::isSubType(contents.getType(), curr->type)) {
        contents = PossibleContents::literal(
          Literal::makeNull(curr->type.getHeapType()));
      }

      // Note that if curr's type is *not* nullable, then the code will trap at
      // runtime (the null must arrive through a cast that will trap). We handle
      // that below, so we don't need to think about it here.

      // TODO: would emitting a more specific null be useful when valid?
    }

    auto* c = contents.makeExpression(wasm);

    // We can only place the constant value here if it has the right type. For
    // example, a block may return (ref any), that is, not allow a null, but in
    // practice only a null may flow there if it goes through casts that will
    // trap at runtime.
    // TODO: GUFA should eventually do this, but it will require it properly
    //       filtering content not just on ref.cast as it does now, but also
    //       ref.as etc. Once it does those we could assert on the type being
    //       valid here.
    if (Type::isSubType(c->type, curr->type)) {
      replaceCurrent(getDroppedChildrenAndAppend(curr, wasm, options, c));
      optimized = true;
    } else {
      // The type is not compatible: we cannot place |c| in this location, even
      // though we have proven it is the only value possible here.
      if (Properties::isConstantExpression(c)) {
        // The type is not compatible and this is a simple constant expression
        // like a ref.func. That means this code must be unreachable. (See below
        // for the case of a non-constant.)
        replaceCurrent(getDroppedChildrenAndAppend(
          curr, wasm, options, builder.makeUnreachable()));
        optimized = true;
      } else {
        // This is not a constant expression, but we are certain it is the right
        // value. Atm the only such case we handle is a global.get of an
        // immutable global. We don't know what the value will be, nor its
        // specific type, but we do know that a global.get will get that value
        // properly. However, in this case it does not have the right type for
        // this location. That can happen since the global.get does not have
        // exactly the proper type for the contents: the global.get might be
        // nullable, for example, even though the contents are not actually a
        // null. For example, consider what happens here:
        //
        //  (global $foo (ref null any) (struct.new $Foo))
        //  ..
        //    (ref.as_non_null
        //      (global.get $foo))
        //
        // We create a $Foo in the global $foo, so its value is not a null. But
        // the global's type is nullable, so the global.get's type will be as
        // well. When we get to the ref.as_non_null, we then want to replace it
        // with a global.get - in fact that's what its child already is, showing
        // it is the right content for it - but that global.get would not have a
        // non-nullable type like a ref.as_non_null must have, so we cannot
        // simply replace it.
        //
        // For now, do nothing here, but in some cases we could probably
        // optimize (e.g. by adding a ref.as_non_null in the example) TODO
        assert(c->is<GlobalGet>());
      }
    }
  }

  void visitRefEq(RefEq* curr) {
    if (curr->type == Type::unreachable) {
      // Leave this for DCE.
      return;
    }

    auto leftContents = getContents(curr->left);
    auto rightContents = getContents(curr->right);

    if (!PossibleContents::haveIntersection(leftContents, rightContents)) {
      // The contents prove the two sides cannot contain the same reference, so
      // we infer 0.
      //
      // Note that this is fine even if one of the sides is None. In that case,
      // no value is possible there, and the intersection is empty, so we will
      // get here and emit a 0. That 0 will never be reached as the None child
      // will be turned into an unreachable, so it does not cause any problem.
      auto* result = Builder(*getModule()).makeConst(Literal(int32_t(0)));
      replaceCurrent(getDroppedChildrenAndAppend(
        curr, *getModule(), getPassOptions(), result));
    }
  }

  void visitRefTest(RefTest* curr) {
    if (curr->type == Type::unreachable) {
      // Leave this for DCE.
      return;
    }

    auto refContents = getContents(curr->ref);
    auto refType = refContents.getType();
    if (refType.isRef()) {
      // We have some knowledge of the type here. Use that to optimize: RefTest
      // returns 1 if the input is of a subtype of the intended type, that is,
      // we are looking for a type in that cone of types.
      auto intendedContents = PossibleContents::fullConeType(curr->castType);

      auto optimize = [&](int32_t result) {
        auto* last = Builder(*getModule()).makeConst(Literal(int32_t(result)));
        replaceCurrent(getDroppedChildrenAndAppend(
          curr, *getModule(), getPassOptions(), last));
      };

      if (!PossibleContents::haveIntersection(refContents, intendedContents)) {
        optimize(0);
      } else if (PossibleContents::isSubContents(refContents,
                                                 intendedContents)) {
        optimize(1);
      }
    }
  }

  // TODO: If an instruction would trap on null, like struct.get, we could
  //       remove it here if it has no possible contents and if we are in
  //       traps-never-happen mode (that is, we'd have proven it can only trap,
  //       but we assume no traps happen, so it must be dead code). That info
  //       is present in OptimizeInstructions where it removes redundant
  //       ref.as_non_null (it removes them because it knows that the parent
  //       will trap on null anyhow), so maybe there is a way to share that
  //       information about parents.

  void visitFunction(Function* func) {
    if (!optimized) {
      return;
    }

    // Optimization may introduce more unreachables, which we need to
    // propagate.
    ReFinalize().walkFunctionInModule(func, getModule());

    // We may add blocks around pops, which we must fix up.
    EHUtils::handleBlockNestedPops(func, *getModule());

    // If we are in "optimizing" mode, we'll also run some more passes on this
    // function that we just optimized. If not, leave now.
    if (!optimizing) {
      return;
    }

    PassRunner runner(getPassRunner());
    // New unreachables we added have created dead code we can remove. If we do
    // not do this, then running GUFA repeatedly can actually increase code size
    // (by adding multiple unneeded unreachables).
    runner.add("dce");
    // New drops we added allow us to remove more unused code and values. As
    // with unreachables, without a vacuum we may increase code size as in
    // nested expressions we may apply the same value multiple times:
    //
    //  (block $out
    //   (block $in
    //    (i32.const 10)))
    //
    // In each of the blocks we'll infer the value must be 10, so we'll end up
    // with this repeating code:
    //
    //  (block ;; a new block just to drop the old outer block
    //   (drop
    //    (block $out
    //     (drop
    //      (block $in
    //       (i32.const 10)
    //      )
    //     )
    //     (i32.const 10)
    //    )
    //   )
    //   (i32.const 10)
    //  )
    runner.add("vacuum");
    runner.runOnFunction(func);
  }
};

struct GUFAPass : public Pass {
  bool optimizing;

  GUFAPass(bool optimizing) : optimizing(optimizing) {}

  void run(Module* module) override {
    ContentOracle oracle(*module);
    GUFAOptimizer(oracle, optimizing).run(getPassRunner(), module);
  }
};

} // anonymous namespace

Pass* createGUFAPass() { return new GUFAPass(false); }
Pass* createGUFAOptimizingPass() { return new GUFAPass(true); }

} // namespace wasm
