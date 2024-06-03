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

  // We receive the propagated infos, that is, info about field types in a form
  // that takes into account subtypes for quick computation, and also the raw
  // subtyping and new infos (information about struct.news).
  std::unique_ptr<Pass> create() override {
    return std::make_unique<FunctionOptimizer>(
      propagatedInfos, subTypes, rawNewInfos);
  }

  FunctionOptimizer(const PCVStructValuesMap& propagatedInfos,
                    const SubTypes& subTypes,
                    const PCVStructValuesMap& rawNewInfos)
    : propagatedInfos(propagatedInfos), subTypes(subTypes),
      rawNewInfos(rawNewInfos) {}

  void visitStructGet(StructGet* curr) {
    auto type = curr->ref->type;
    if (type == Type::unreachable) {
      return;
    }
    auto heapType = type.getHeapType();
    if (!heapType.isStruct()) {
      return;
    }

    Builder builder(*getModule());

    // Find the info for this field, and see if we can optimize. First, see if
    // there is any information for this heap type at all. If there isn't, it is
    // as if nothing was ever noted for that field.
    PossibleConstantValues info;
    assert(!info.hasNoted());
    auto iter = propagatedInfos.find(heapType);
    if (iter != propagatedInfos.end()) {
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

    // If the value is not a constant, then it is unknown and we must give up
    // on simply applying a constant. However, we can try to use subtyping.
    if (!info.isConstant()) {
      optimizeUsingSubTyping(curr);
      return;
    }

    // We can do this! Replace the get with a trap on a null reference using a
    // ref.as_non_null (we need to trap as the get would have done so), plus the
    // constant value. (Leave it to further optimizations to get rid of the
    // ref.)
    auto* value = makeExpression(info, heapType, curr);
    replaceCurrent(builder.makeSequence(
      builder.makeDrop(builder.makeRefAs(RefAsNonNull, curr->ref)), value));
    changed = true;
  }

  // Given information about a constant value, and the struct type and StructGet
  // that reads it, create an expression for that value.
  Expression* makeExpression(const PossibleConstantValues& info,
                             HeapType type,
                             StructGet* curr) {
    auto* value = info.makeExpression(*getModule());
    auto field = GCTypeUtils::getField(type, curr->index);
    assert(field);
    value =
      Bits::makePackedFieldGet(value, *field, curr->signed_, *getModule());
    return value;
  }

  // If a field has more than one possible value based on our propagation of
  // subtype values, we can try to look at subtypes in a more sophisticated
  // manner. For example, consider types A :> B1, B2 (B1, B2 are sibling
  // subtypes of A). If we have a struct.get of A, and B1 and B2 have different
  // values for the field, then we do not have one possible value as we look for
  // above. But imagine that A is never constructed - it is an abstract type -
  // and the field is immutable and constant in each of B1 and B2, such as for
  // example a vtable often is (as instances of a class always get the same
  // vtable, in several toolchains). Then we can replace the struct.get with
  // this:
  //
  //  (select
  //    (global.get $B1$vtable)
  //    (global.get $B2$vtable)
  //    (ref.test $B1 (..ref..))
  //  )
  //
  // That is, we need to differentiate between the two types in order to pick
  // between two values, and we can do that with a ref.test. By itself this is
  // likely not faster than just doing a struct.get, but imagine that the parent
  // of the select is an itable call (another get, and then a call_ref): then
  // having a select here allows us to further optimize all the way down into a
  // ref.test that picks between two *direct* calls.
  void optimizeUsingSubTyping(StructGet* curr) {
    auto refType = curr->ref->type;
    auto refHeapType = refType.getHeapType();

    // The field must be immutable.
    if (GCTypeUtils::getField(refType, curr->index)->mutable_ == Mutable) {
      return;
    }

    // We seek two possible values, and we track which types each use.
    PossibleConstantValues values[2];
    // TODO: SmallVector
    std::vector<HeapType> valueTypes[2];

    auto fail = false;
    auto handleType = [&](HeapType type, Index depth) {
      if (fail) {
        // TODO: Add a mechanism to halt the iteration in the middle.
        return;
      }

      auto iter = rawNewInfos.find(type);
      if (iter == rawNewInfos.end()) {
        // This type has no struct.news, so we can ignore it: it is abstract.
        return;
      }

      auto value = iter->second[curr->index];
      if (!value.isConstant()) {
        // The value here is not constant, so give up entirely.
        fail = true;
        return;
      }

      // Consider the constant value compared to previous ones.
      for (Index i = 0; i < 2; i++) {
        if (!values[i].hasNoted()) {
          // There is nothing in this slot: place this value there.
          values[i] = value;
          valueTypes[i].push_back(type);
          break;
        }
        if (values[i] == value) {
          // This value is the same as a previous one. Note the type.
          valueTypes[i].push_back(type);
          break;
        }
        // Otherwise, this value is different than values[i], which is fine:
        // we can add it as the second value in the next loop iteration - at
        // least, we can do that if there is another iteration: If it's already
        // the last, we've failed to find only two values.
        if (i == 1) {
          fail = true;
          return;
        }
      }
    };
    subTypes.iterSubTypes(refHeapType, handleType);

    if (fail) {
      return;
    }

    if (!values[1].hasNoted()) {
      // We did not see two constant values (we might have seen just one, or
      // even no constant values at all).
      return;
    }
    // If we notes in index 1, we must have in 0, and also we must have types
    // for both.
    assert(values[0].hasNoted());
    assert(!valueTypes[0].empty() && !valueTypes[1].empty());

    // We have exactly two values to pick between. We can pick between those
    // values using a single ref.test if the two sets of types are actually
    // disjoint. In general we could compute the LUB of each set and see if it
    // overlaps with the other, but for efficiency we only want to do this
    // optimization if the type we test on is closed/final: ref.test on a final
    // type is very fast and in constant time, and anything else is risky. Given
    // that, we can simply see if one of the sets contains a single type that is
    // final.
    // TODO: Consider adding a variation on this pass that uses non-final types.
    auto isProperTestType = [&](Index index) -> std::optional<HeapType> {
      auto& types = valueTypes[index];
      if (types.size() == 1) {
        auto type = types[0];
        // Do not test finality using isOpen(), as that may only be applied late
        // in the optimization pipeline. We are in closed-world here, so just
        // see if there are subtypes if practice (if not, this can be marked as
        // final later, and we assume optimistically that it will).
        if (subTypes.getImmediateSubTypes(type).empty()) {
          return type;
        }
      }
      return {};
    };

    Index testIndex = -1;
    HeapType testType;
    for (Index i = 0; i < 2; i++) {
      if (auto test = isProperTestType(i)) {
        testType = *test;
        testIndex = i;
        break;
      }
    }
    if (testIndex == Index(-1)) {
      // We failed to find a simple way to separate the types.
      return;
    }

    // Success! We can replace the struct.get with a select over the two values
    // (and a trap on null) with the proper ref.test.
    Builder builder(*getModule());
    auto* nnRef = builder.makeRefAs(RefAsNonNull, curr->ref);
    replaceCurrent(builder.makeSelect(
      builder.makeRefTest(nnRef, Type(testType, NonNullable)),
      makeExpression(values[testIndex], refHeapType, curr),
      makeExpression(values[1 - testIndex], refHeapType, curr)));
    changed = true;
  }

#if 0
  void visitRefTest(RefTest* curr) {
    // When we see
    //
    //  (ref.test TYPE
    //    (struct.get
    //      (REF)))     ;; the type of this is |refHeapType| below.
    //
    // then we may be able to fold them together. Imagine that we read a vtable
    // from a class and ref.test it, then if there is a 1:1 relationship between
    // vtables and classes then we could have simply tested the class itself and
    // saved the struct.get. (We actually do not need a 1:1 isomorphism here, in
    // fact: all we need is to that a ref.test can be done that separates the
    // two groups in the same way; but for now we handle the simple case TODO)
    auto* get = curr->ref->dynCast<StructGet>();
    if (!get) {
      return;
    }
    auto* ref = get->ref;
    if (!ref->type.isRef()) {
      return;
    }
    auto refHeapType = ref->type.getHeapType();
    if (!refHeapType.isStruct()) {
      return;
    }

    auto testType = curr->type;

    // Go through the reference's subtypes. Each of them must have an item in
    // the relevant field that must pass or must fail the test. Otherwise, the
    // test might pass or fail, which means the reference's type is not enough
    // to know the outcome of the test.
    std::unordered_set<HeapType> passing, failing;
    auto fail = false;

    subTypes.iterSubTypes(refHeapType, [&](HeapType type, Index depth) {
      auto iter = rawNewInfos.find(type);
      if (iter == rawNewInfos.end()) {
        // This type has no struct.news, so we can ignore it: it is abstract.
        return;
      }

      // XXX we don't need a constant value here...
      auto value = iter->second[get->index];
      if (!value.isConstant()) {
        // The value here is not constant, so give up entirely.
        fail = true;
        return;
      }

      auto valueType = value.getType();
      if (Type::isSubType(valueType, testType)) {
        passing.insert(type);
      } else if (!Type::isSubType(testType, valueType)) {
        failing.insert(type);
      } else {
        // This could pass or fail, so give up.
        fail = true;
      }
    });

    if (fail) {
      return;
    }

    // Each reference type possibility has an entry in the field that must or
    // must not pass the test. We also need there to be a test that
    // differentiates the set of those passing from the one of those failing.
    // TODO: Also do not regress finality: if the current test is over a type
    // with no subtypes, we need the same here to keep performance.
    auto considerTest = [&](const std::unordered_set<HeapType>& a, const std::unordered_set<HeapType>& b) -> std::optional<HeapType> {
      // Given two sets a and b, see if we can test between them using the lub
      // of a. We can do no better than the lub, as it is the minimal type that
      // accepts the entire set a.
      if (a.empty()) {
        // We can test using an impossible type.
        return Type(HeapType::none, NonNullable);
      }
      std::optional<HeapType> lub;
      for (auto type : a) {
        if (!lub) {
          lub = a;
        } else {
          auto currLUB = HeapType::getLeastUpperBound(*lub, type);
          // The current LUB must exist as these are all subtypes of the ref.
          assert(currLUB);
          lub = *currLUB;
        }
      }
      for (auto type : b) {
        if (HeapType::isSubType(type, *lub)) {
          // We failed to separate the sets.
          return {};
        }
      }
      // Success!
      return *lub;
    };

    // TODO: add RefAsNonNull as the struct.get would trap. Also justifies NN
    // below.
    if (auto testType = considerTest(passing, failing)) {
      curr->ref = get->ref;
      curr->type = Type(*testType, NonNullable);
    } else if (auto testType = considerTest(failing, passing)) {
      // We can optimize if we test on this and reverse the output. We are
      // removing a struct.get and adding an i32.eqz, so this is still great.
      Builder builder(*getModule());
      curr->ref = get->ref;
      curr->type = Type(*testType, NonNullable);
      replaceCurrent(builder.makeUnary(EqZInt32, curr));
    }
  }
#endif

  void doWalkFunction(Function* func) {
    WalkerPass<PostWalker<FunctionOptimizer>>::doWalkFunction(func);

    // If we changed anything, we need to update parent types as types may have
    // changed.
    if (changed) {
      ReFinalize().walkFunctionInModule(func, getModule());
    }
  }

private:
  const PCVStructValuesMap& propagatedInfos;
  const SubTypes& subTypes;
  const PCVStructValuesMap& rawNewInfos;

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

    // Prepare data we will need later.
    auto rawNewInfos = combinedNewInfos;
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
    FunctionOptimizer(combinedInfos, subTypes, rawNewInfos).run(runner, module);
  }
};

} // anonymous namespace

Pass* createConstantFieldPropagationPass() {
  return new ConstantFieldPropagation();
}

} // namespace wasm
