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
// A variation of this pass also uses ref.test to optimize. This is riskier, as
// adding a ref.test means we are adding a non-trivial amount of work, and
// whether it helps overall depends on subsequent optimizations, so we do not do
// it by default. In this variation, if we inferred a field has exactly two
// possible values, and we can differentiate between them using a ref.test, then
// we do
//
//   (struct.get $T x (..ref..))
//     =>
//   (select
//     (..constant1..)
//     (..constant2..)
//     (ref.test $U (..ref..))
//   )
//
// This is valid if, of all the subtypes of $T, those that pass the test have
// constant1 in that field, and those that fail the test have constant2. For
// example, a simple case is where $T has two subtypes, $T is never created
// itself, and each of the two subtypes has a different constant value. (Note
// that we do similar things in e.g. GlobalStructInference, where we turn a
// struct.get into a select, but the risk there is much lower since the
// condition for the select is something like a ref.eq - very cheap - while here
// we emit a ref.test which in general is as expensive as a cast.)
//
// FIXME: This pass assumes a closed world. When we start to allow multi-module
//        wasm GC programs we need to check for type escaping.
//

#include <unordered_set>

#include "ir/bits.h"
#include "ir/gc-type-utils.h"
#include "ir/possible-constant.h"
#include "ir/struct-utils.h"
#include "ir/utils.h"
#include "pass.h"
#include "support/hash.h"
#include "support/small_vector.h"
#include "support/unique_deferring_queue.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

namespace {

// The destination reference type and field index of a copy, as well as whether
// the copy read is signed (in the case of packed fields). This will be used to
// propagate copied values from their sources to destinations in the analysis.
struct CopyInfo {
  HeapType type;
  Exactness exact;
  Index index;
  bool isSigned;

  bool operator==(const CopyInfo& other) const {
    return type == other.type && exact == other.exact && index == other.index &&
           isSigned == other.isSigned;
  }
};

} // anonymous namespace

} // namespace wasm

namespace std {

template<> struct hash<wasm::CopyInfo> {
  size_t operator()(const wasm::CopyInfo& copy) const {
    auto digest = wasm::hash(copy.type);
    wasm::rehash(digest, copy.exact);
    wasm::rehash(digest, copy.index);
    wasm::rehash(digest, copy.isSigned);
    return digest;
  }
};

} // namespace std

namespace wasm {

namespace {

using PCVStructValuesMap = StructUtils::StructValuesMap<PossibleConstantValues>;
using PCVFunctionStructValuesMap =
  StructUtils::FunctionStructValuesMap<PossibleConstantValues>;

using BoolStructValuesMap =
  StructUtils::StructValuesMap<StructUtils::CombinableBool>;
using BoolFunctionStructValuesMap =
  StructUtils::FunctionStructValuesMap<StructUtils::CombinableBool>;

using StructFieldPairs =
  std::unordered_set<std::pair<StructField, StructField>>;

// TODO: Deduplicate with Lattice infrastructure.
template<typename T> struct CombinableSet : std::unordered_set<T> {
  bool combine(const CombinableSet<T>& other) {
    auto originalSize = this->size();
    this->insert(other.begin(), other.end());
    return this->size() != originalSize;
  }
};

// For each field, the set of fields it is copied to.
using CopiesStructValuesMap =
  StructUtils::StructValuesMap<CombinableSet<CopyInfo>>;

using CopiesFunctionStructValuesMap =
  StructUtils::FunctionStructValuesMap<CombinableSet<CopyInfo>>;

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
      propagatedInfos, refTestInfos, subTypes, refTest);
  }

  FunctionOptimizer(const PCVStructValuesMap& propagatedInfos,
                    const PCVStructValuesMap& refTestInfos,
                    const SubTypes& subTypes,
                    bool refTest)
    : propagatedInfos(propagatedInfos), refTestInfos(refTestInfos),
      subTypes(subTypes), refTest(refTest) {}

  template<typename T> std::optional<HeapType> getRelevantHeapType(T* ref) {
    auto type = ref->type;
    if (type == Type::unreachable) {
      return std::nullopt;
    }
    auto heapType = type.getHeapType();
    if (!heapType.isStruct()) {
      return std::nullopt;
    }
    return heapType;
  }

  PossibleConstantValues getInfo(HeapType type, Index index, Exactness exact) {
    if (auto it = propagatedInfos.find({type, exact});
        it != propagatedInfos.end()) {
      // There is information on this type, fetch it.
      return it->second[index];
    }
    return PossibleConstantValues{};
  }

  // Given information about a constant value, and the struct type and
  // StructGet/RMW/Cmpxchg that reads it, create an expression for that value.
  Expression* makeExpression(const PossibleConstantValues& info,
                             HeapType type,
                             Expression* curr) {
    auto* value = info.makeExpression(*getModule());
    if (auto* structGet = curr->dynCast<StructGet>()) {
      auto field = GCTypeUtils::getField(type, structGet->index);
      assert(field);
      // Apply packing, if needed.
      value = Bits::makePackedFieldGet(
        value, *field, structGet->signed_, *getModule());
      // Check if the value makes sense. The analysis below flows values around
      // without considering where they are placed, that is, when we see a
      // parent type can contain a value in a field then we assume a child may
      // as well (which in general it can, e.g., using a reference to the
      // parent, we can write that value to it, but the reference might actually
      // point to a child instance). If we tracked the types of fields then we
      // might avoid flowing values into places they cannot reside, like when a
      // child field is a subtype, and so we could ignore things not refined
      // enough for it (GUFA does a better job at this). For here, just check we
      // do not break validation, and if we do, then we've inferred the only
      // possible value is an impossible one, making the code unreachable.
      if (!Type::isSubType(value->type, field->type)) {
        Builder builder(*getModule());
        value = builder.makeSequence(builder.makeDrop(value),
                                     builder.makeUnreachable());
      }
    }
    return value;
  }

  void visitStructGet(StructGet* curr) {
    optimizeRead(curr, curr->ref, curr->index, curr->order);
  }

  void visitRefGetDesc(RefGetDesc* curr) {
    optimizeRead(curr, curr->ref, StructUtils::DescriptorIndex);

    // RefGetDesc has the interesting property that we can write a value into
    // the field that cannot be read from it: it is valid to write a null, but
    // a null can never be read (it would have trapped on the write). Fix that
    // up as needed to not break validation.
    if (!Type::isSubType(getCurrent()->type, curr->type)) {
      Builder builder(*getModule());
      replaceCurrent(builder.makeRefAs(RefAsNonNull, getCurrent()));
    }
  }

  void optimizeRead(Expression* curr,
                    Expression* ref,
                    Index index,
                    std::optional<MemoryOrder> order = std::nullopt) {
    auto type = getRelevantHeapType(ref);
    if (!type) {
      return;
    }
    auto heapType = *type;

    Builder builder(*getModule());

    // Find the info for this field, and see if we can optimize. First, see if
    // there is any information for this heap type at all. If there isn't, it is
    // as if nothing was ever noted for that field.
    PossibleConstantValues info =
      getInfo(heapType, index, ref->type.getExactness());
    if (!info.hasNoted()) {
      // This field is never written at all. That means that we do not even
      // construct any data of this type, and so it is a logic error to reach
      // this location in the code. (Unless we are in an open-world situation,
      // which we assume we are not in.) Replace this get with a trap. Note that
      // we do not need to care about the nullability of the reference, as if it
      // should have trapped, we are replacing it with another trap, which we
      // allow to reorder (but we do need to care about side effects in the
      // reference, so keep it around). We also do not need to care about
      // synchronization since trapping accesses do not synchronize with other
      // accesses.
      replaceCurrent(
        builder.makeSequence(builder.makeDrop(ref), builder.makeUnreachable()));
      changed = true;
      return;
    }

    if (order && *order != MemoryOrder::Unordered) {
      // The analysis we're basing the optimization on is not precise enough to
      // rule out the field being used to synchronize between a write of the
      // constant value and a subsequent read on another thread. This
      // synchronization is possible even when the write does not change the
      // value of the field. For now, simply avoid optimizing this case.
      // TODO: Track release and acquire operations in the analysis.
      return;
    }

    // If the value is not a constant, then it is unknown and we must give up
    // on simply applying a constant. However, we can try to use a ref.test, if
    // that is allowed.
    if (!info.isConstant()) {
      // Note that if the reference is exact, we never need to use a ref.test
      // because there will not be multiple subtypes to select between.
      if (refTest && !ref->type.isExact()) {
        optimizeUsingRefTest(curr, ref, index);
      }
      return;
    }

    // We can do this! Replace the get with a trap on a null reference using a
    // ref.as_non_null (we need to trap as the get would have done so), plus the
    // constant value. (Leave it to further optimizations to get rid of the
    // ref.)
    auto* value = makeExpression(info, heapType, curr);
    auto* replacement =
      builder.blockify(builder.makeDrop(builder.makeRefAs(RefAsNonNull, ref)));
    replacement->list.push_back(value);
    replacement->type = value->type;
    replaceCurrent(replacement);
    changed = true;
  }

  void optimizeUsingRefTest(Expression* curr, Expression* ref, Index index) {
    auto refType = ref->type;
    auto refHeapType = refType.getHeapType();

    // We seek two possible constant values. For each we track the constant and
    // the types that have that constant. For example, if we have types A, B, C
    // and A and B have 42 in their field, and C has 1337, then we'd have this:
    //
    //  values = [ { 42, [A, B] }, { 1337, [C] } ];
    struct Value {
      PossibleConstantValues constant;
      // Use a SmallVector as we'll only have 2 Values, and so the stack usage
      // here is fixed.
      SmallVector<HeapType, 10> types;

      // Whether this slot is used. If so, |constant| has a value, and |types|
      // is not empty.
      bool used() const {
        if (constant.hasNoted()) {
          assert(!types.empty());
          return true;
        }
        assert(types.empty());
        return false;
      }
    } values[2];

    // Handle one of the subtypes of the relevant type. We check what value it
    // has for the field, and update |values|. If we hit a problem, we mark us
    // as having failed.
    auto fail = false;
    auto handleType = [&](HeapType type, Index depth) {
      if (fail) {
        // TODO: Add a mechanism to halt |iterSubTypes| in the middle, as once
        //       we fail there is no point to further iterating.
        return;
      }

      auto iter = refTestInfos.find({type, Exact});
      if (iter == refTestInfos.end()) {
        // This type has no allocations, so we can ignore it: it is abstract.
        return;
      }

      auto value = iter->second[index];
      if (!value.hasNoted()) {
        // Also abstract and ignorable.
        return;
      }
      if (!value.isConstant()) {
        // The value here is not constant, so give up entirely.
        fail = true;
        return;
      }

      // Consider the constant value compared to previous ones.
      for (Index i = 0; i < 2; i++) {
        if (!values[i].used()) {
          // There is nothing in this slot: place this value there.
          values[i].constant = value;
          values[i].types.push_back(type);
          break;
        }

        // There is something in this slot. If we have the same value, append.
        if (values[i].constant == value) {
          values[i].types.push_back(type);
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

    // We either filled slot 0, or we did not, and if we did not then cannot
    // have filled slot 1 after it.
    assert(values[0].used() || !values[1].used());

    if (!values[1].used()) {
      // We did not see two constant values (we might have seen just one, or
      // even no constant values at all).
      return;
    }

    // We have exactly two values to pick between. We can pick between those
    // values using a single ref.test if the two sets of types are actually
    // disjoint. In general we could compute the LUB of each set and see if it
    // overlaps with the other, but for efficiency we only want to do this
    // optimization if the type we test on is closed/final, since ref.test on a
    // final type can be fairly fast (perhaps constant time). We therefore look
    // if one of the sets of types contains a single type and it is final, and
    // if so then we'll test on it. (However, see a few lines below on how we
    // test for finality.)
    // TODO: Consider adding a variation on this pass that uses non-final types.
    auto isProperTestType = [&](const Value& value) -> std::optional<HeapType> {
      auto& types = value.types;
      if (types.size() != 1) {
        // Too many types.
        return {};
      }

      auto type = types[0];
      // Do not test finality using isOpen(), as that may only be applied late
      // in the optimization pipeline. We are in closed-world here, so just
      // see if there are subtypes in practice (if not, this can be marked as
      // final later, and we assume optimistically that it will).
      if (!subTypes.getImmediateSubTypes(type).empty()) {
        // There are subtypes.
        return {};
      }

      // Success, we can test on this.
      return type;
    };

    // Look for the index in |values| to test on.
    Index testIndex;
    if (auto test = isProperTestType(values[0])) {
      testIndex = 0;
    } else if (auto test = isProperTestType(values[1])) {
      testIndex = 1;
    } else {
      // We failed to find a simple way to separate the types.
      return;
    }

    // Success! We can replace the struct.get with a select over the two values
    // (and a trap on null) with the proper ref.test.
    Builder builder(*getModule());

    auto& testIndexTypes = values[testIndex].types;
    assert(testIndexTypes.size() == 1);
    auto testType = testIndexTypes[0];

    auto* nnRef = builder.makeRefAs(RefAsNonNull, ref);

    replaceCurrent(builder.makeSelect(
      builder.makeRefTest(nnRef, Type(testType, NonNullable)),
      makeExpression(values[testIndex].constant, refHeapType, curr),
      makeExpression(values[1 - testIndex].constant, refHeapType, curr)));

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
  const PCVStructValuesMap& propagatedInfos;
  const PCVStructValuesMap& refTestInfos;
  const SubTypes& subTypes;
  const bool refTest;

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
             CopiesFunctionStructValuesMap& functionCopyInfos)
    : StructUtils::StructScanner<PossibleConstantValues, PCVScanner>(
        functionNewInfos, functionSetInfos),
      functionCopyInfos(functionCopyInfos) {}

  void noteExpression(Expression* expr,
                      HeapType type,
                      Index index,
                      PossibleConstantValues& info) {
    info.note(expr, *getModule());
    // TODO: For descriptors we can ignore nullable values that are written, as
    //       they trap. That is, if one place writes a null and another writes a
    //       global, only the global is readable, and we can optimize there -
    //       the null is not a second value.
  }

  void noteDefault(Type fieldType,
                   HeapType type,
                   Index index,
                   PossibleConstantValues& info) {
    info.note(Literal::makeZero(fieldType));
  }

  void noteCopy(StructGet* get,
                Type dstType,
                Index dstIndex,
                PossibleConstantValues& dstInfo) {
    auto srcType = get->ref->type.getHeapType();
    auto srcExact = get->ref->type.getExactness();
    auto srcIndex = get->index;
    functionCopyInfos[getFunction()][{srcType, srcExact}][srcIndex].insert(
      {dstType.getHeapType(), dstType.getExactness(), dstIndex, get->signed_});
  }

  void noteRead(HeapType type, Index index, PossibleConstantValues& info) {
    // Reads do not interest us.
  }

  void noteRMW(Expression* expr,
               HeapType type,
               Index index,
               PossibleConstantValues& info) {
    // In general RMWs will modify the value of the field, so there is no single
    // constant value. We could in principle try to recognize no-op RMWs like
    // adds of 0, but we leave that for OptimizeInstructions for simplicity.
    info.noteUnknown();
  }

  CopiesFunctionStructValuesMap& functionCopyInfos;
};

struct ConstantFieldPropagation : public Pass {
  // Only modifies struct.get operations.
  bool requiresNonNullableLocalFixups() override { return false; }

  // Whether we are optimizing using ref.test, see above.
  const bool refTest;

  ConstantFieldPropagation(bool refTest) : refTest(refTest) {}

  void run(Module* module) override {
    if (!module->features.hasGC()) {
      return;
    }

    if (!getPassOptions().closedWorld) {
      Fatal() << "CFP requires --closed-world";
    }

    // Find and analyze all writes inside each function.
    PCVFunctionStructValuesMap functionNewInfos(*module),
      functionSetInfos(*module);
    CopiesFunctionStructValuesMap functionCopyInfos(*module);
    PCVScanner scanner(functionNewInfos, functionSetInfos, functionCopyInfos);
    auto* runner = getPassRunner();
    scanner.run(runner, module);
    scanner.runOnModuleCode(runner, module);

    // Combine the data from the functions.
    PCVStructValuesMap combinedSetInfos;
    functionNewInfos.combineInto(combinedSetInfos);
    functionSetInfos.combineInto(combinedSetInfos);
    CopiesStructValuesMap combinedCopyInfos;
    functionCopyInfos.combineInto(combinedCopyInfos);

    // Perform an analysis to compute the readable values for each triple of
    // heap type, exactness, and field index. The readable values are
    // determined by the written values and copies.
    //
    // Whenever we have a write like this:
    //
    //   (struct.set $super x (... ref ...) (... value ...))
    //
    // The dynamic type of the struct we are writing to may be any subtype of
    // the type of the ref. For example, if the ref has type (ref $super),
    // then the write may go to an object of type (ref $super) or (ref $sub).
    // In contrast, if the ref has an exact type, then we know the write
    // cannot go to an object of type (ref $sub), which is not a subtype of
    // (ref (exact $super)). The set of values that may have been written to a
    // field is therefore the join of all the values we observe being written
    // to that field in all supertypes of the written reference. The written
    // values are propagated down to subtypes.
    //
    // Similarly, whenever we have a read like this:
    //
    //   (struct.get $super x (... ref ...))
    //
    // The dynamic type of the struct we are reading from may be any subtype
    // of the type of the ref. The set of values that we might read from a
    // field is therefore the join of all the values that may have been
    // written to that field in all subtypes of the read reference. The read
    // values are propagated up to supertypes.
    //
    // Copies are interesting because they invert the normal dependence of
    // readable values on written values. A copy is a write of a read, so the
    // writable values depends on the readable values. Because of this cyclic
    // dependency, we must iteratively update our knowledge of the written and
    // readable values until we reach a fixed point.
    SubTypes subTypes(*module);
    StructUtils::TypeHierarchyPropagator<PossibleConstantValues> propagator(
      subTypes);

    PCVStructValuesMap written = std::move(combinedSetInfos);
    propagator.propagateToSubTypes(written);
    PCVStructValuesMap readable = written;
    propagator.propagateToSuperTypes(readable);

    // Now apply copies and propagate the new information until we have a
    // fixed point. We could just join the copied values into `written`,
    // propagate all of `written` down again, and recompute `readable`,
    // but that would do more work than necessary since most fields are not
    // going to be involved in copies. We will handle the propagation manually
    // instead.
    //
    // Since the analysis records untruncated values for packed fields, we must
    // be careful to truncate and sign extend copy source values as necessary.
    // We generally don't truncate values based on their destination because
    // that would regress propagation of globals when they are not copied.
    // TODO: Track truncations in the analysis itself to propagate them through
    // copies, even of globals.
    UniqueDeferredQueue<CopyInfo> work;
    auto applyCopiesTo = [&](auto& dsts, const Field& src, const auto& val) {
      for (auto& dst : dsts) {
        auto packed = val;
        packed.packForField(src, dst.isSigned);
        if (written[{dst.type, dst.exact}][dst.index].combine(packed)) {
          work.push(dst);
        }
      }
    };
    auto applyCopiesFrom =
      [&](HeapType src, Exactness exact, Index index, const auto& val) {
        if (auto it = combinedCopyInfos.find({src, exact});
            it != combinedCopyInfos.end()) {
          const auto& srcField = src.getStruct().fields[index];
          applyCopiesTo(it->second[index], srcField, val);
        }
      };
    // For each copy, take the readable values at its source and join them to
    // the written values at its destination. Record the written values that
    // change so we can propagate the new information afterward.
    for (auto& [src, fields] : combinedCopyInfos) {
      auto [srcType, srcExact] = src;
      for (Index srcField = 0; srcField < fields.size(); ++srcField) {
        const auto& field = srcType.getStruct().fields[srcField];
        applyCopiesTo(fields[srcField], field, readable[src][srcField]);
      }
    }
    while (work.size()) {
      // Propagate down from dst in both written and readable, then
      // propagate up from dst in readable only. Whenever we make a change in
      // readable, see if there are copies to apply. If there are copies and
      // they make changes, then we have more propagation work to do later.
      auto dst = work.pop();
      assert(dst.index != StructUtils::DescriptorIndex);
      auto val = written[{dst.type, dst.exact}][dst.index];
      val.packForField(dst.type.getStruct().fields[dst.index]);
      // Make the copied value readable.
      if (readable[{dst.type, dst.exact}][dst.index].combine(val)) {
        applyCopiesFrom(dst.type, dst.exact, dst.index, val);
      }
      if (dst.exact == Inexact) {
        // Propagate down to subtypes.
        written[{dst.type, Exact}][dst.index].combine(val);
        subTypes.iterSubTypes(dst.type, [&](HeapType sub, Index depth) {
          written[{sub, Inexact}][dst.index].combine(val);
          written[{sub, Exact}][dst.index].combine(val);
          if (readable[{sub, Inexact}][dst.index].combine(val)) {
            applyCopiesFrom(sub, Inexact, dst.index, val);
          }
          if (readable[{sub, Exact}][dst.index].combine(val)) {
            applyCopiesFrom(sub, Exact, dst.index, val);
          }
        });
      } else {
        // The copy destination is exact, so there are no subtypes to
        // propagate to, but we do need to propagate up to the inexact type.
        if (readable[{dst.type, Inexact}][dst.index].combine(val)) {
          applyCopiesFrom(dst.type, Inexact, dst.index, val);
        }
      }
      // Propagate up to the supertypes.
      for (auto super = dst.type.getDeclaredSuperType(); super;
           super = super->getDeclaredSuperType()) {
        auto& readableSuperFields = readable[{*super, Inexact}];
        if (dst.index >= readableSuperFields.size()) {
          break;
        }
        if (readableSuperFields[dst.index].combine(val)) {
          applyCopiesFrom(*super, Inexact, dst.index, val);
        }
      }
    }

    // Optimize.
    // TODO: Skip this if we cannot optimize anything.
    FunctionOptimizer(readable, written, subTypes, refTest).run(runner, module);
    return;
  }
};

} // anonymous namespace

Pass* createConstantFieldPropagationPass() {
  return new ConstantFieldPropagation(false);
}

Pass* createConstantFieldPropagationRefTestPass() {
  return new ConstantFieldPropagation(true);
}

} // namespace wasm
