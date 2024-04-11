/*
 * Copyright 2021 WebAssembly Community Group participants
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
// Find struct fields that are always written to with a constant value, and
// replace gets of them with that value.
//
// For example, if we have a vtable of type T, and we always create it with one
// of the fields containing a ref.func of the same function F, and there is no
// write to that field of a different value (even using a subtype of T), then
// anywhere we see a get of that field we can place a ref.func of F.
//
// FIXME: This pass assumes a closed world. When we start to allow multi-module
//        wasm GC programs we need to check for type escaping.
//

#include "ir/bits.h"
#include "ir/gc-type-utils.h"
#include "ir/module-utils.h"
#include "ir/possible-constant.h"
#include "ir/struct-utils.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

namespace {

using PCVStructValuesMap = StructUtils::StructValuesMap<PossibleConstantValues>;
using PCVFunctionStructValuesMap =
  StructUtils::FunctionStructValuesMap<PossibleConstantValues>;

// A wrapper for a boolean value that provides a combine() method as is used in
// the StructUtils propagation logic.
struct Bool {
  bool value = false;

  Bool() {}
  Bool(bool value) : value(value) {}

  operator bool() const { return value; }

  bool combine(bool other) { return value = value || other; }
};

using BoolStructValuesMap = StructUtils::StructValuesMap<Bool>;
using BoolFunctionStructValuesMap = StructUtils::FunctionStructValuesMap<Bool>;

// Optimize struct gets based on what we've learned about writes.
//
// TODO Aside from writes, we could use information like whether any struct of
//      this type has even been created (to handle the case of struct.sets but
//      no struct.news).
struct FunctionOptimizer : public WalkerPass<PostWalker<FunctionOptimizer>> {
  bool isFunctionParallel() override { return true; }

  // Only modifies struct.get operations.
  bool requiresNonNullableLocalFixups() override { return false; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<FunctionOptimizer>(infos);
  }

  FunctionOptimizer(PCVStructValuesMap& infos) : infos(infos) {}

  void visitStructGet(StructGet* curr) {
    auto type = curr->ref->type;
    if (type == Type::unreachable) {
      return;
    }

    Builder builder(*getModule());

    // Find the info for this field, and see if we can optimize. First, see if
    // there is any information for this heap type at all. If there isn't, it is
    // as if nothing was ever noted for that field.
    PossibleConstantValues info;
    assert(!info.hasNoted());
    auto iter = infos.find(type.getHeapType());
    if (iter != infos.end()) {
      // There is information on this type, fetch it.
      info = iter->second[curr->index];
    }

    if (!info.hasNoted()) {
      // This field is never written at all. That means that we do not even
      // construct any data of this type, and so it is a logic error to reach
      // this location in the code. (Unless we are in an open-world
      // situation, which we assume we are not in.) Replace this get with a
      // trap. Note that we do not need to care about the nullability of the
      // reference, as if it should have trapped, we are replacing it with
      // another trap, which we allow to reorder (but we do need to care about
      // side effects in the reference, so keep it around).
      replaceCurrent(builder.makeSequence(builder.makeDrop(curr->ref),
                                          builder.makeUnreachable()));
      changed = true;
      return;
    }

    // If the value is not a constant, then it is unknown and we must give up.
    if (!info.isConstant()) {
      return;
    }

    // We can do this! Replace the get with a trap on a null reference using a
    // ref.as_non_null (we need to trap as the get would have done so), plus the
    // constant value. (Leave it to further optimizations to get rid of the
    // ref.)
    Expression* value = info.makeExpression(*getModule());
    auto field = GCTypeUtils::getField(type, curr->index);
    assert(field);
    value =
      Bits::makePackedFieldGet(value, *field, curr->signed_, *getModule());
    replaceCurrent(builder.makeSequence(
      builder.makeDrop(builder.makeRefAs(RefAsNonNull, curr->ref)), value));
    changed = true;
  }

  void doWalkFunction(Function* func) {
    WalkerPass<PostWalker<FunctionOptimizer>>::doWalkFunction(func);

    // If we changed anything, we need to update parent types as types may have
    // changed.
    if (changed) {
      ReFinalize().walkFunctionInModule(func, getModule());
    }
  }

private:
  PCVStructValuesMap& infos;

  bool changed = false;
};

struct PCVScanner
  : public StructUtils::StructScanner<PossibleConstantValues, PCVScanner> {
  std::unique_ptr<Pass> create() override {
    return std::make_unique<PCVScanner>(
      functionNewInfos, functionSetGetInfos, functionCopyInfos);
  }

  PCVScanner(PCVFunctionStructValuesMap& functionNewInfos,
             PCVFunctionStructValuesMap& functionSetInfos,
             BoolFunctionStructValuesMap& functionCopyInfos)
    : StructUtils::StructScanner<PossibleConstantValues, PCVScanner>(
        functionNewInfos, functionSetInfos),
      functionCopyInfos(functionCopyInfos) {}

  void noteExpression(Expression* expr,
                      HeapType type,
                      Index index,
                      PossibleConstantValues& info) {
    info.note(expr, *getModule());
  }

  void noteDefault(Type fieldType,
                   HeapType type,
                   Index index,
                   PossibleConstantValues& info) {
    info.note(Literal::makeZero(fieldType));
  }

  void noteCopy(HeapType type, Index index, PossibleConstantValues& info) {
    // Note copies, as they must be considered later. See the comment on the
    // propagation of values below.
    functionCopyInfos[getFunction()][type][index] = true;
  }

  void noteRead(HeapType type, Index index, PossibleConstantValues& info) {
    // Reads do not interest us.
  }

  BoolFunctionStructValuesMap& functionCopyInfos;
};

struct ConstantFieldPropagation : public Pass {
  // Only modifies struct.get operations.
  bool requiresNonNullableLocalFixups() override { return false; }

  void run(Module* module) override {
    if (!module->features.hasGC()) {
      return;
    }

    // Find and analyze all writes inside each function.
    PCVFunctionStructValuesMap functionNewInfos(*module),
      functionSetInfos(*module);
    BoolFunctionStructValuesMap functionCopyInfos(*module);
    PCVScanner scanner(functionNewInfos, functionSetInfos, functionCopyInfos);
    auto* runner = getPassRunner();
    scanner.run(runner, module);
    scanner.runOnModuleCode(runner, module);

    // Combine the data from the functions.
    PCVStructValuesMap combinedNewInfos, combinedSetInfos;
    functionNewInfos.combineInto(combinedNewInfos);
    functionSetInfos.combineInto(combinedSetInfos);
    BoolStructValuesMap combinedCopyInfos;
    functionCopyInfos.combineInto(combinedCopyInfos);

    SubTypes subTypes(*module);

    // Handle subtyping. |combinedInfo| so far contains data that represents
    // each struct.new and struct.set's operation on the struct type used in
    // that instruction. That is, if we do a struct.set to type T, the value was
    // noted for type T. But our actual goal is to answer questions about
    // struct.gets. Specifically, when later we see:
    //
    //  (struct.get $A x (REF-1))
    //
    // Then we want to be aware of all the relevant struct.sets, that is, the
    // sets that can write data that this get reads. Given a set
    //
    //  (struct.set $B x (REF-2) (..value..))
    //
    // then
    //
    //  1. If $B is a subtype of $A, it is relevant: the get might read from a
    //     struct of type $B (i.e., REF-1 and REF-2 might be identical, and both
    //     be a struct of type $B).
    //  2. If $B is a supertype of $A that still has the field x then it may
    //     also be relevant: since $A is a subtype of $B, the set may write to a
    //     struct of type $A (and again, REF-1 and REF-2 may be identical).
    //
    // Thus, if either $A <: $B or $B <: $A then we must consider the get and
    // set to be relevant to each other. To make our later lookups for gets
    // efficient, we therefore propagate information about the possible values
    // in each field to both subtypes and supertypes.
    //
    // struct.new on the other hand knows exactly what type is being written to,
    // and so given a get of $A and a new of $B, the new is relevant for the get
    // iff $A is a subtype of $B, so we only need to propagate in one direction
    // there, to supertypes.
    //
    // An exception to the above are copies. If a field is copied then even
    // struct.new information cannot be assumed to be precise:
    //
    //   // A :> B :> C
    //   ..
    //   new B(20);
    //   ..
    //   A1->f0 = A2->f0; // Either of these might refer to an A, B, or C.
    //   ..
    //   foo(A->f0);      // These can contain 20,
    //   foo(C->f0);      // if the copy read from B.
    //
    // To handle that, copied fields are treated like struct.set ones (by
    // copying the struct.new data to struct.set). Note that we must propagate
    // copying to subtypes first, as in the example above the struct.new values
    // of subtypes must be taken into account (that is, A or a subtype is being
    // copied, so we want to do the same thing for B and C as well as A, since
    // a copy of A means it could be a copy of B or C).
    StructUtils::TypeHierarchyPropagator<Bool> boolPropagator(subTypes);
    boolPropagator.propagateToSubTypes(combinedCopyInfos);
    for (auto& [type, copied] : combinedCopyInfos) {
      for (Index i = 0; i < copied.size(); i++) {
        if (copied[i]) {
          combinedSetInfos[type][i].combine(combinedNewInfos[type][i]);
        }
      }
    }

    StructUtils::TypeHierarchyPropagator<PossibleConstantValues> propagator(
      subTypes);
    propagator.propagateToSuperTypes(combinedNewInfos);
    propagator.propagateToSuperAndSubTypes(combinedSetInfos);

    // Combine both sources of information to the final information that gets
    // care about.
    PCVStructValuesMap combinedInfos = std::move(combinedNewInfos);
    combinedSetInfos.combineInto(combinedInfos);

    // Optimize.
    // TODO: Skip this if we cannot optimize anything
    FunctionOptimizer(combinedInfos).run(runner, module);

    // TODO: Actually remove the field from the type, where possible? That might
    //       be best in another pass.
  }
};

} // anonymous namespace

Pass* createConstantFieldPropagationPass() {
  return new ConstantFieldPropagation();
}

} // namespace wasm
