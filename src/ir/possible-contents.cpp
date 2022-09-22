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

#include <optional>
#include <variant>

#include "ir/branch-utils.h"
#include "ir/eh-utils.h"
#include "ir/module-utils.h"
#include "ir/possible-contents.h"
#include "wasm.h"

#ifdef POSSIBLE_CONTENTS_INSERT_ORDERED
// Use an insert-ordered set for easier debugging with deterministic queue
// ordering.
#include "support/insert_ordered.h"
#endif

namespace std {

std::ostream& operator<<(std::ostream& stream,
                         const wasm::PossibleContents& contents) {
  contents.dump(stream);
  return stream;
}

} // namespace std

namespace wasm {

void PossibleContents::combine(const PossibleContents& other) {
  auto type = getType();
  auto otherType = other.getType();
  // First handle the trivial cases of them being equal, or one of them is
  // None or Many.
  if (*this == other) {
    // Nulls are a special case, since they compare equal even if their type is
    // different. We would like to make this function symmetric, that is, that
    // combine(a, b) == combine(b, a) (otherwise, things can be odd and we could
    // get nondeterminism in the flow analysis which does not have a
    // determinstic order). To fix that, pick the LUB.
    if (isNull()) {
      assert(other.isNull());
      auto lub = HeapType::getLeastUpperBound(type.getHeapType(),
                                              otherType.getHeapType());
      if (!lub) {
        // TODO: Remove this workaround once we have bottom types to assign to
        // null literals.
        value = Many();
        return;
      }
      value = Literal::makeNull(*lub);
    }
    return;
  }
  if (other.isNone()) {
    return;
  }
  if (isNone()) {
    value = other.value;
    return;
  }
  if (isMany()) {
    return;
  }
  if (other.isMany()) {
    value = Many();
    return;
  }

  if (!type.isRef() || !otherType.isRef()) {
    // At least one is not a reference. The only possibility left for a useful
    // combination here is if they have the same type (since we've already ruled
    // out the case of them being equal). If they have the same type then
    // neither is a reference and we can emit an exact type (since subtyping is
    // not relevant for non-references.
    if (type == otherType) {
      value = ExactType(type);
    } else {
      value = Many();
    }
    return;
  }

  // Special handling for references from here.

  // Nulls are always equal to each other, even if their types differ.
  if (isNull() || other.isNull()) {
    // Only one of them can be null here, since we already checked if *this ==
    // other, which would have been true had both been null.
    assert(!isNull() || !other.isNull());
    // If only one is a null, but the other's type is known exactly, then the
    // combination is to add nullability (if the type is *not* known exactly,
    // like for a global, then we cannot do anything useful here).
    if (!isNull() && hasExactType()) {
      value = ExactType(Type(type.getHeapType(), Nullable));
      return;
    } else if (!other.isNull() && other.hasExactType()) {
      value = ExactType(Type(otherType.getHeapType(), Nullable));
      return;
    }
  }

  if (hasExactType() && other.hasExactType() &&
      type.getHeapType() == otherType.getHeapType()) {
    // We know the types here exactly, and even the heap types match, but
    // there is some other difference that prevents them from being 100%
    // identical (for example, one might be an ExactType and the other a
    // Literal; or both might be ExactTypes and only one might be nullable).
    // In these cases we can emit a proper ExactType here, adding nullability
    // if we need to.
    value = ExactType(Type(
      type.getHeapType(),
      type.isNullable() || otherType.isNullable() ? Nullable : NonNullable));
    return;
  }

  // Nothing else possible combines in an interesting way; emit a Many.
  value = Many();
}

namespace {

// We are going to do a very large flow operation, potentially, as we create
// a Location for every interesting part in the entire wasm, and some of those
// places will have lots of links (like a struct field may link out to every
// single struct.get of that type), so we must make the data structures here
// as efficient as possible. Towards that goal, we work with location
// *indexes* where possible, which are small (32 bits) and do not require any
// complex hashing when we use them in sets or maps.
//
// Note that we do not use indexes everywhere, since the initial analysis is
// done in parallel, and we do not have a fixed indexing of locations yet. When
// we merge the parallel data we create that indexing, and use indexes from then
// on.
using LocationIndex = uint32_t;

#ifndef NDEBUG
// Assert on not having duplicates in a vector.
template<typename T> void disallowDuplicates(const T& targets) {
#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
  std::unordered_set<LocationIndex> uniqueTargets;
  for (const auto& target : targets) {
    uniqueTargets.insert(target);
  }
  assert(uniqueTargets.size() == targets.size());
#endif
}
#endif

// A link indicates a flow of content from one location to another. For
// example, if we do a local.get and return that value from a function, then
// we have a link from a LocalLocation to a ResultLocation.
template<typename T> struct Link {
  T from;
  T to;

  bool operator==(const Link<T>& other) const {
    return from == other.from && to == other.to;
  }
};

using LocationLink = Link<Location>;
using IndexLink = Link<LocationIndex>;

} // anonymous namespace

} // namespace wasm

namespace std {

template<> struct hash<wasm::LocationLink> {
  size_t operator()(const wasm::LocationLink& loc) const {
    return std::hash<std::pair<wasm::Location, wasm::Location>>{}(
      {loc.from, loc.to});
  }
};

template<> struct hash<wasm::IndexLink> {
  size_t operator()(const wasm::IndexLink& loc) const {
    return std::hash<std::pair<wasm::LocationIndex, wasm::LocationIndex>>{}(
      {loc.from, loc.to});
  }
};

} // namespace std

namespace wasm {

namespace {

// The data we gather from each function, as we process them in parallel. Later
// this will be merged into a single big graph.
struct CollectedFuncInfo {
  // All the links we found in this function. Rarely are there duplicates
  // in this list (say when writing to the same global location from another
  // global location), and we do not try to deduplicate here, just store them in
  // a plain array for now, which is faster (later, when we merge all the info
  // from the functions, we need to deduplicate anyhow).
  std::vector<LocationLink> links;

  // All the roots of the graph, that is, places that begin by containing some
  // particular content. That includes i32.const, ref.func, struct.new, etc. All
  // possible contents in the rest of the graph flow from such places.
  //
  // The vector here is of the location of the root and then its contents.
  std::vector<std::pair<Location, PossibleContents>> roots;

  // In some cases we need to know the parent of the expression. Consider this:
  //
  //  (struct.set $A k
  //    (local.get $ref)
  //    (local.get $value)
  //  )
  //
  // Imagine that the first local.get, for $ref, receives a new value. That can
  // affect where the struct.set sends values: if previously that local.get had
  // no possible contents, and now it does, then we have DataLocations to
  // update. Likewise, when the second local.get is updated we must do the same,
  // but again which DataLocations we update depends on the ref passed to the
  // struct.set. To handle such things, we set add a childParent link, and then
  // when we update the child we can find the parent and handle any special
  // behavior we need there.
  std::unordered_map<Expression*, Expression*> childParents;
};

// Walk the wasm and find all the links we need to care about, and the locations
// and roots related to them. This builds up a CollectedFuncInfo data structure.
// After all InfoCollectors run, those data structures will be merged and the
// main flow will begin.
struct InfoCollector
  : public PostWalker<InfoCollector, OverriddenVisitor<InfoCollector>> {
  CollectedFuncInfo& info;

  InfoCollector(CollectedFuncInfo& info) : info(info) {}

  // Check if a type is relevant for us. If not, we can ignore it entirely.
  bool isRelevant(Type type) {
    if (type == Type::unreachable || type == Type::none) {
      return false;
    }
    if (type.isTuple()) {
      for (auto t : type) {
        if (isRelevant(t)) {
          return true;
        }
      }
    }
    if (type.isRef() && getTypeSystem() != TypeSystem::Nominal &&
        getTypeSystem() != TypeSystem::Isorecursive) {
      // We need explicit supers in the SubTyping helper class. Without that,
      // cannot handle refs, and consider them irrelevant.
      return false;
    }
    return true;
  }

  bool isRelevant(Signature sig) {
    return isRelevant(sig.params) || isRelevant(sig.results);
  }

  bool isRelevant(Expression* curr) { return curr && isRelevant(curr->type); }

  template<typename T> bool isRelevant(const T& vec) {
    for (auto* expr : vec) {
      if (isRelevant(expr->type)) {
        return true;
      }
    }
    return false;
  }

  // Each visit*() call is responsible for connecting the children of a node to
  // that node. Responsibility for connecting the node's output to anywhere
  // else (another expression or the function itself, if we are at the top
  // level) is the responsibility of the outside.

  void visitBlock(Block* curr) {
    if (curr->list.empty()) {
      return;
    }

    // Values sent to breaks to this block must be received here.
    handleBreakTarget(curr);

    // The final item in the block can flow a value to here as well.
    receiveChildValue(curr->list.back(), curr);
  }
  void visitIf(If* curr) {
    // Each arm may flow out a value.
    receiveChildValue(curr->ifTrue, curr);
    receiveChildValue(curr->ifFalse, curr);
  }
  void visitLoop(Loop* curr) { receiveChildValue(curr->body, curr); }
  void visitBreak(Break* curr) {
    // Connect the value (if present) to the break target.
    handleBreakValue(curr);

    // The value may also flow through in a br_if (the type will indicate that,
    // which receiveChildValue will notice).
    receiveChildValue(curr->value, curr);
  }
  void visitSwitch(Switch* curr) { handleBreakValue(curr); }
  void visitLoad(Load* curr) {
    // We could infer the exact type here, but as no subtyping is possible, it
    // would have no benefit, so just add a generic root (which will be "Many").
    // See the comment on the ContentOracle class.
    addRoot(curr);
  }
  void visitStore(Store* curr) {}
  void visitAtomicRMW(AtomicRMW* curr) { addRoot(curr); }
  void visitAtomicCmpxchg(AtomicCmpxchg* curr) { addRoot(curr); }
  void visitAtomicWait(AtomicWait* curr) { addRoot(curr); }
  void visitAtomicNotify(AtomicNotify* curr) { addRoot(curr); }
  void visitAtomicFence(AtomicFence* curr) {}
  void visitSIMDExtract(SIMDExtract* curr) { addRoot(curr); }
  void visitSIMDReplace(SIMDReplace* curr) { addRoot(curr); }
  void visitSIMDShuffle(SIMDShuffle* curr) { addRoot(curr); }
  void visitSIMDTernary(SIMDTernary* curr) { addRoot(curr); }
  void visitSIMDShift(SIMDShift* curr) { addRoot(curr); }
  void visitSIMDLoad(SIMDLoad* curr) { addRoot(curr); }
  void visitSIMDLoadStoreLane(SIMDLoadStoreLane* curr) { addRoot(curr); }
  void visitMemoryInit(MemoryInit* curr) {}
  void visitDataDrop(DataDrop* curr) {}
  void visitMemoryCopy(MemoryCopy* curr) {}
  void visitMemoryFill(MemoryFill* curr) {}
  void visitConst(Const* curr) {
    addRoot(curr, PossibleContents::literal(curr->value));
  }
  void visitUnary(Unary* curr) {
    // We could optimize cases like this using interpreter integration: if the
    // input is a Literal, we could interpret the Literal result. However, if
    // the input is a literal then the GUFA pass will emit a Const there, and
    // the Precompute pass can use that later to interpret a result. That is,
    // the input we need here, a constant, is already something GUFA can emit as
    // an output. As a result, integrating the interpreter here would perhaps
    // make compilation require fewer steps, but it wouldn't let us optimize
    // more than we could before.
    addRoot(curr);
  }
  void visitBinary(Binary* curr) { addRoot(curr); }
  void visitSelect(Select* curr) {
    receiveChildValue(curr->ifTrue, curr);
    receiveChildValue(curr->ifFalse, curr);
  }
  void visitDrop(Drop* curr) {}
  void visitMemorySize(MemorySize* curr) { addRoot(curr); }
  void visitMemoryGrow(MemoryGrow* curr) { addRoot(curr); }
  void visitRefNull(RefNull* curr) {
    addRoot(
      curr,
      PossibleContents::literal(Literal::makeNull(curr->type.getHeapType())));
  }
  void visitRefIs(RefIs* curr) {
    // TODO: Optimize when possible. For example, if we can infer an exact type
    //       here which allows us to know the result then we should do so. This
    //       is unlike the case in visitUnary, above: the information that lets
    //       us optimize *cannot* be written into Binaryen IR (unlike a Literal)
    //       so using it during this pass allows us to optimize new things.
    addRoot(curr);
  }
  void visitRefFunc(RefFunc* curr) {
    addRoot(
      curr,
      PossibleContents::literal(Literal(curr->func, curr->type.getHeapType())));
  }
  void visitRefEq(RefEq* curr) {
    // TODO: optimize when possible (e.g. when both sides must contain the same
    //       global, or if we infer exact types that are different then the
    //       result must be 0)
    addRoot(curr);
  }
  void visitTableGet(TableGet* curr) {
    addRoot(curr);
  }
  void visitTableSet(TableSet* curr) {}
  void visitTableSize(TableSize* curr) { addRoot(curr); }
  void visitTableGrow(TableGrow* curr) { addRoot(curr); }

  void visitNop(Nop* curr) {}
  void visitUnreachable(Unreachable* curr) {}

#ifndef NDEBUG
  // For now we only handle pops in a catch body, see visitTry(). To check for
  // errors, use counter of the pops we handled and all the pops; those sums
  // must agree at the end, or else we've seen something we can't handle.
  Index totalPops = 0;
  Index handledPops = 0;
#endif

  void visitPop(Pop* curr) {
#ifndef NDEBUG
    totalPops++;
#endif
  }
  void visitI31New(I31New* curr) {
    // TODO: optimize like struct references
    addRoot(curr);
  }
  void visitI31Get(I31Get* curr) {
    // TODO: optimize like struct references
    addRoot(curr);
  }

  void visitRefCast(RefCast* curr) {
    // We will handle this in a special way later during the flow, as ref.cast
    // only allows valid values to flow through.
    addChildParentLink(curr->ref, curr);
  }
  void visitRefTest(RefTest* curr) {
    // We will handle this similarly to RefCast.
    addChildParentLink(curr->ref, curr);
  }
  void visitBrOn(BrOn* curr) {
    // TODO: optimize when possible
    handleBreakValue(curr);
    receiveChildValue(curr->ref, curr);
  }
  void visitRefAs(RefAs* curr) {
    // TODO: optimize when possible: like RefCast, not all values flow through.
    receiveChildValue(curr->value, curr);
  }

  // Locals read and write to their index.
  // TODO: we could use a LocalGraph for SSA-like precision
  void visitLocalGet(LocalGet* curr) {
    if (isRelevant(curr->type)) {
      for (Index i = 0; i < curr->type.size(); i++) {
        info.links.push_back({LocalLocation{getFunction(), curr->index, i},
                              ExpressionLocation{curr, i}});
      }
    }
  }
  void visitLocalSet(LocalSet* curr) {
    if (!isRelevant(curr->value->type)) {
      return;
    }
    for (Index i = 0; i < curr->value->type.size(); i++) {
      info.links.push_back({ExpressionLocation{curr->value, i},
                            LocalLocation{getFunction(), curr->index, i}});
    }

    // Tees also flow out the value (receiveChildValue will see if this is a tee
    // based on the type, automatically).
    receiveChildValue(curr->value, curr);
  }

  // Globals read and write from their location.
  void visitGlobalGet(GlobalGet* curr) {
    if (isRelevant(curr->type)) {
      // FIXME: we allow tuples in globals, so GlobalLocation needs a tupleIndex
      //        and we should loop here.
      assert(!curr->type.isTuple());
      info.links.push_back(
        {GlobalLocation{curr->name}, ExpressionLocation{curr, 0}});
    }
  }
  void visitGlobalSet(GlobalSet* curr) {
    if (isRelevant(curr->value->type)) {
      info.links.push_back(
        {ExpressionLocation{curr->value, 0}, GlobalLocation{curr->name}});
    }
  }

  // Iterates over a list of children and adds links to parameters and results
  // as needed. The param/result functions receive the index and create the
  // proper location for it.
  template<typename T>
  void handleCall(T* curr,
                  std::function<Location(Index)> makeParamLocation,
                  std::function<Location(Index)> makeResultLocation) {
    Index i = 0;
    for (auto* operand : curr->operands) {
      if (isRelevant(operand->type)) {
        info.links.push_back(
          {ExpressionLocation{operand, 0}, makeParamLocation(i)});
      }
      i++;
    }

    // Add results, if anything flows out.
    for (Index i = 0; i < curr->type.size(); i++) {
      if (isRelevant(curr->type[i])) {
        info.links.push_back(
          {makeResultLocation(i), ExpressionLocation{curr, i}});
      }
    }

    // If this is a return call then send the result to the function return as
    // well.
    if (curr->isReturn) {
      auto results = getFunction()->getResults();
      for (Index i = 0; i < results.size(); i++) {
        auto result = results[i];
        if (isRelevant(result)) {
          info.links.push_back(
            {makeResultLocation(i), ResultLocation{getFunction(), i}});
        }
      }
    }
  }

  // Calls send values to params in their possible targets, and receive
  // results.

  template<typename T> void handleDirectCall(T* curr, Name targetName) {
    auto* target = getModule()->getFunction(targetName);
    handleCall(
      curr,
      [&](Index i) {
        return LocalLocation{target, i, 0};
      },
      [&](Index i) {
        return ResultLocation{target, i};
      });
  }
  template<typename T> void handleIndirectCall(T* curr, HeapType targetType) {
    handleCall(
      curr,
      [&](Index i) {
        return SignatureParamLocation{targetType, i};
      },
      [&](Index i) {
        return SignatureResultLocation{targetType, i};
      });
  }
  template<typename T> void handleIndirectCall(T* curr, Type targetType) {
    // If the type is unreachable, nothing can be called (and there is no heap
    // type to get).
    if (targetType != Type::unreachable) {
      handleIndirectCall(curr, targetType.getHeapType());
    }
  }

  void visitCall(Call* curr) {
    Name targetName;
    if (!Intrinsics(*getModule()).isCallWithoutEffects(curr)) {
      // This is just a normal call.
      handleDirectCall(curr, curr->target);
      return;
    }
    // A call-without-effects receives a function reference and calls it, the
    // same as a CallRef. When we have a flag for non-closed-world, we should
    // handle this automatically by the reference flowing out to an import,
    // which is what binaryen intrinsics look like. For now, to support use
    // cases of a closed world but that also use this intrinsic, handle the
    // intrinsic specifically here. (Without that, the closed world assumption
    // makes us ignore the function ref that flows to an import, so we are not
    // aware that it is actually called.)
    auto* target = curr->operands.back();
    if (auto* refFunc = target->dynCast<RefFunc>()) {
      // We can see exactly where this goes.
      handleDirectCall(curr, refFunc->func);
    } else {
      // We can't see where this goes. We must be pessimistic and assume it
      // can call anything of the proper type, the same as a CallRef. (We could
      // look at the possible contents of |target| during the flow, but that
      // would require special logic like we have for RefCast etc., and the
      // intrinsics will be lowered away anyhow, so just running after that is
      // a workaround.)
      handleIndirectCall(curr, target->type);
    }
  }
  void visitCallIndirect(CallIndirect* curr) {
    // TODO: the table identity could also be used here
    // TODO: optimize the call target like CallRef
    handleIndirectCall(curr, curr->heapType);
  }
  void visitCallRef(CallRef* curr) {
    // TODO: Optimize like RefCast etc.: the values reaching us depend on the
    //       possible values of |target| (which might be nothing, or might be a
    //       constant function).
    handleIndirectCall(curr, curr->target->type);
  }

  // Creates a location for a null of a particular type and adds a root for it.
  // Such roots are where the default value of an i32 local comes from, or the
  // value in a ref.null.
  Location getNullLocation(Type type) {
    auto location = NullLocation{type};
    addRoot(location, PossibleContents::literal(Literal::makeZero(type)));
    return location;
  }

  // Iterates over a list of children and adds links from them. The target of
  // those link is created using a function that is passed in, which receives
  // the index of the child.
  void linkChildList(ExpressionList& operands,
                     std::function<Location(Index)> makeTarget) {
    Index i = 0;
    for (auto* operand : operands) {
      // This helper is not used from places that allow a tuple (hence we can
      // hardcode the index 0 a few lines down).
      assert(!operand->type.isTuple());

      if (isRelevant(operand->type)) {
        info.links.push_back({ExpressionLocation{operand, 0}, makeTarget(i)});
      }
      i++;
    }
  }

  void visitStructNew(StructNew* curr) {
    if (curr->type == Type::unreachable) {
      return;
    }
    auto type = curr->type.getHeapType();
    if (curr->isWithDefault()) {
      // Link the default values to the struct's fields.
      auto& fields = type.getStruct().fields;
      for (Index i = 0; i < fields.size(); i++) {
        info.links.push_back(
          {getNullLocation(fields[i].type), DataLocation{type, i}});
      }
    } else {
      // Link the operands to the struct's fields.
      linkChildList(curr->operands, [&](Index i) {
        return DataLocation{type, i};
      });
    }
    addRoot(curr, PossibleContents::exactType(curr->type));
  }
  void visitArrayNew(ArrayNew* curr) {
    if (curr->type == Type::unreachable) {
      return;
    }
    auto type = curr->type.getHeapType();
    if (curr->init) {
      info.links.push_back(
        {ExpressionLocation{curr->init, 0}, DataLocation{type, 0}});
    } else {
      info.links.push_back(
        {getNullLocation(type.getArray().element.type), DataLocation{type, 0}});
    }
    addRoot(curr, PossibleContents::exactType(curr->type));
  }
  void visitArrayInit(ArrayInit* curr) {
    if (curr->type == Type::unreachable) {
      return;
    }
    if (!curr->values.empty()) {
      auto type = curr->type.getHeapType();
      linkChildList(curr->values, [&](Index i) {
        // The index i is ignored, as we do not track indexes in Arrays -
        // everything is modeled as if at index 0.
        return DataLocation{type, 0};
      });
    }
    addRoot(curr, PossibleContents::exactType(curr->type));
  }

  // Struct operations access the struct fields' locations.
  void visitStructGet(StructGet* curr) {
    if (!isRelevant(curr->ref)) {
      // If references are irrelevant then we will ignore them, and we won't
      // have information about this struct.get's reference, which means we
      // won't have information to compute relevant values for this struct.get.
      // Instead, just mark this as an unknown value (root).
      addRoot(curr);
      return;
    }
    // The struct.get will receive different values depending on the contents
    // in the reference, so mark us as the parent of the ref, and we will
    // handle all of this in a special way during the flow. Note that we do
    // not even create a DataLocation here; anything that we need will be
    // added during the flow.
    addChildParentLink(curr->ref, curr);
  }
  void visitStructSet(StructSet* curr) {
    if (curr->ref->type == Type::unreachable) {
      return;
    }
    // See comment on visitStructGet. Here we also connect the value.
    addChildParentLink(curr->ref, curr);
    addChildParentLink(curr->value, curr);
  }
  // Array operations access the array's location, parallel to how structs work.
  void visitArrayGet(ArrayGet* curr) {
    if (!isRelevant(curr->ref)) {
      addRoot(curr);
      return;
    }
    addChildParentLink(curr->ref, curr);
  }
  void visitArraySet(ArraySet* curr) {
    if (curr->ref->type == Type::unreachable) {
      return;
    }
    addChildParentLink(curr->ref, curr);
    addChildParentLink(curr->value, curr);
  }

  void visitArrayLen(ArrayLen* curr) {
    // TODO: optimize when possible (perhaps we can infer a Literal for the
    //       length)
    addRoot(curr);
  }
  void visitArrayCopy(ArrayCopy* curr) {
    if (curr->type == Type::unreachable) {
      return;
    }
    // Our flow handling of GC data is not simple: we have special code for each
    // read and write instruction. Therefore, to avoid adding special code for
    // ArrayCopy, model it as a combination of an ArrayRead and ArrayWrite, by
    // just emitting fake expressions for those. The fake expressions are not
    // part of the main IR, which is potentially confusing during debugging,
    // however, which is a downside.
    Builder builder(*getModule());
    auto* get = builder.makeArrayGet(curr->srcRef, curr->srcIndex);
    visitArrayGet(get);
    auto* set = builder.makeArraySet(curr->destRef, curr->destIndex, get);
    visitArraySet(set);
  }

  void visitStringNew(StringNew* curr) {
    if (curr->type == Type::unreachable) {
      return;
    }
    addRoot(curr, PossibleContents::exactType(curr->type));
  }
  void visitStringConst(StringConst* curr) {
    addRoot(curr, PossibleContents::exactType(curr->type));
  }
  void visitStringMeasure(StringMeasure* curr) {
    // TODO: optimize when possible
    addRoot(curr);
  }
  void visitStringEncode(StringEncode* curr) {
    // TODO: optimize when possible
    addRoot(curr);
  }
  void visitStringConcat(StringConcat* curr) {
    // TODO: optimize when possible
    addRoot(curr);
  }
  void visitStringEq(StringEq* curr) {
    // TODO: optimize when possible
    addRoot(curr);
  }
  void visitStringAs(StringAs* curr) {
    // TODO: optimize when possible
    addRoot(curr);
  }
  void visitStringWTF8Advance(StringWTF8Advance* curr) {
    // TODO: optimize when possible
    addRoot(curr);
  }
  void visitStringWTF16Get(StringWTF16Get* curr) {
    // TODO: optimize when possible
    addRoot(curr);
  }
  void visitStringIterNext(StringIterNext* curr) {
    // TODO: optimize when possible
    addRoot(curr);
  }
  void visitStringIterMove(StringIterMove* curr) {
    // TODO: optimize when possible
    addRoot(curr);
  }
  void visitStringSliceWTF(StringSliceWTF* curr) {
    // TODO: optimize when possible
    addRoot(curr);
  }
  void visitStringSliceIter(StringSliceIter* curr) {
    // TODO: optimize when possible
    addRoot(curr);
  }

  // TODO: Model which throws can go to which catches. For now, anything thrown
  //       is sent to the location of that tag, and any catch of that tag can
  //       read them.
  void visitTry(Try* curr) {
    receiveChildValue(curr->body, curr);
    for (auto* catchBody : curr->catchBodies) {
      receiveChildValue(catchBody, curr);
    }

    auto numTags = curr->catchTags.size();
    for (Index tagIndex = 0; tagIndex < numTags; tagIndex++) {
      auto tag = curr->catchTags[tagIndex];
      auto* body = curr->catchBodies[tagIndex];

      auto params = getModule()->getTag(tag)->sig.params;
      if (params.size() == 0) {
        continue;
      }

      // Find the pop of the tag's contents. The body must start with such a
      // pop, which might be of a tuple.
      auto* pop = EHUtils::findPop(body);
      // There must be a pop since we checked earlier if it was an empty tag,
      // and would not reach here.
      assert(pop);
      assert(pop->type.size() == params.size());
      for (Index i = 0; i < params.size(); i++) {
        if (isRelevant(params[i])) {
          info.links.push_back(
            {TagLocation{tag, i}, ExpressionLocation{pop, i}});
        }
      }

#ifndef NDEBUG
      // This pop was in the position we can handle, note that (see visitPop
      // for details).
      handledPops++;
#endif
    }
  }
  void visitThrow(Throw* curr) {
    auto& operands = curr->operands;
    if (!isRelevant(operands)) {
      return;
    }

    auto tag = curr->tag;
    for (Index i = 0; i < curr->operands.size(); i++) {
      info.links.push_back(
        {ExpressionLocation{operands[i], 0}, TagLocation{tag, i}});
    }
  }
  void visitRethrow(Rethrow* curr) {}

  void visitTupleMake(TupleMake* curr) {
    if (isRelevant(curr->type)) {
      for (Index i = 0; i < curr->operands.size(); i++) {
        info.links.push_back({ExpressionLocation{curr->operands[i], 0},
                              ExpressionLocation{curr, i}});
      }
    }
  }
  void visitTupleExtract(TupleExtract* curr) {
    if (isRelevant(curr->type)) {
      info.links.push_back({ExpressionLocation{curr->tuple, curr->index},
                            ExpressionLocation{curr, 0}});
    }
  }

  // Adds a result to the current function, such as from a return or the value
  // that flows out.
  void addResult(Expression* value) {
    if (value && isRelevant(value->type)) {
      for (Index i = 0; i < value->type.size(); i++) {
        info.links.push_back(
          {ExpressionLocation{value, i}, ResultLocation{getFunction(), i}});
      }
    }
  }

  void visitReturn(Return* curr) { addResult(curr->value); }

  void visitFunction(Function* curr) {
    // Vars have an initial value.
    for (Index i = 0; i < curr->getNumLocals(); i++) {
      if (curr->isVar(i)) {
        Index j = 0;
        for (auto t : curr->getLocalType(i)) {
          if (t.isDefaultable()) {
            info.links.push_back(
              {getNullLocation(t), LocalLocation{curr, i, j}});
          }
          j++;
        }
      }
    }

    // Functions with a result can flow a value out from their body.
    addResult(curr->body);

    // See visitPop().
    assert(handledPops == totalPops);
  }

  // Helpers

  // Handles the value sent in a break instruction. Does not handle anything
  // else like the condition etc.
  void handleBreakValue(Expression* curr) {
    BranchUtils::operateOnScopeNameUsesAndSentValues(
      curr, [&](Name target, Expression* value) {
        if (value && isRelevant(value->type)) {
          for (Index i = 0; i < value->type.size(); i++) {
            // Breaks send the contents of the break value to the branch target
            // that the break goes to.
            info.links.push_back(
              {ExpressionLocation{value, i},
               BreakTargetLocation{getFunction(), target, i}});
          }
        }
      });
  }

  // Handles receiving values from breaks at the target (as in a block).
  void handleBreakTarget(Expression* curr) {
    if (isRelevant(curr->type)) {
      BranchUtils::operateOnScopeNameDefs(curr, [&](Name target) {
        for (Index i = 0; i < curr->type.size(); i++) {
          info.links.push_back({BreakTargetLocation{getFunction(), target, i},
                                ExpressionLocation{curr, i}});
        }
      });
    }
  }

  // Connect a child's value to the parent, that is, all content in the child is
  // now considered possible in the parent as well.
  void receiveChildValue(Expression* child, Expression* parent) {
    if (isRelevant(parent) && isRelevant(child)) {
      // The tuple sizes must match (or, if not a tuple, the size should be 1 in
      // both cases).
      assert(child->type.size() == parent->type.size());
      for (Index i = 0; i < child->type.size(); i++) {
        info.links.push_back(
          {ExpressionLocation{child, i}, ExpressionLocation{parent, i}});
      }
    }
  }

  // See the comment on CollectedFuncInfo::childParents.
  void addChildParentLink(Expression* child, Expression* parent) {
    if (isRelevant(child->type)) {
      info.childParents[child] = parent;
    }
  }

  // Adds a root, if the expression is relevant. If the value is not specified,
  // mark the root as containing Many (which is the common case, so avoid
  // verbose code).
  void addRoot(Expression* curr,
               PossibleContents contents = PossibleContents::many()) {
    if (isRelevant(curr)) {
      addRoot(ExpressionLocation{curr, 0}, contents);
    }
  }

  // As above, but given an arbitrary location and not just an expression.
  void addRoot(Location loc,
               PossibleContents contents = PossibleContents::many()) {
    info.roots.emplace_back(loc, contents);
  }
};

// Main logic for building data for the flow analysis and then performing that
// analysis.
struct Flower {
  Module& wasm;

  Flower(Module& wasm);

  // Each LocationIndex will have one LocationInfo that contains the relevant
  // information we need for each location.
  struct LocationInfo {
    // The location at this index.
    Location location;

    // The possible contents in that location.
    PossibleContents contents;

    // A list of the target locations to which this location sends content.
    // TODO: benchmark SmallVector<1> here, as commonly there may be a single
    //       target (an expression has one parent)
    std::vector<LocationIndex> targets;

    LocationInfo(Location location) : location(location) {}
  };

  // Maps location indexes to the info stored there, as just described above.
  std::vector<LocationInfo> locations;

  // Reverse mapping of locations to their indexes.
  std::unordered_map<Location, LocationIndex> locationIndexes;

  const Location& getLocation(LocationIndex index) {
    assert(index < locations.size());
    return locations[index].location;
  }

  PossibleContents& getContents(LocationIndex index) {
    assert(index < locations.size());
    return locations[index].contents;
  }

private:
  std::vector<LocationIndex>& getTargets(LocationIndex index) {
    assert(index < locations.size());
    return locations[index].targets;
  }

  // Convert the data into the efficient LocationIndex form we will use during
  // the flow analysis. This method returns the index of a location, allocating
  // one if this is the first time we see it.
  LocationIndex getIndex(const Location& location) {
    auto iter = locationIndexes.find(location);
    if (iter != locationIndexes.end()) {
      return iter->second;
    }

    // Allocate a new index here.
    size_t index = locations.size();
#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
    std::cout << "  new index " << index << " for ";
    dump(location);
#endif
    if (index >= std::numeric_limits<LocationIndex>::max()) {
      // 32 bits should be enough since each location takes at least one byte
      // in the binary, and we don't have 4GB wasm binaries yet... do we?
      Fatal() << "Too many locations for 32 bits";
    }
    locations.emplace_back(location);
    locationIndexes[location] = index;

    return index;
  }

  bool hasIndex(const Location& location) {
    return locationIndexes.find(location) != locationIndexes.end();
  }

  IndexLink getIndexes(const LocationLink& link) {
    return {getIndex(link.from), getIndex(link.to)};
  }

  // See the comment on CollectedFuncInfo::childParents. This is the merged info
  // from all the functions and the global scope.
  std::unordered_map<LocationIndex, LocationIndex> childParents;

  // The work remaining to do during the flow: locations that we need to flow
  // content from, after new content reached them.
  //
  // Using a set here is efficient as multiple updates may arrive to a location
  // before we get to processing it.
  //
  // The items here could be {location, newContents}, but it is more efficient
  // to have already written the new contents to the main data structure. That
  // avoids larger data here, and also, updating the contents as early as
  // possible is helpful as anything reading them meanwhile (before we get to
  // their work item in the queue) will see the newer value, possibly avoiding
  // flowing an old value that would later be overwritten.
#ifdef POSSIBLE_CONTENTS_INSERT_ORDERED
  InsertOrderedSet<LocationIndex> workQueue;
#else
  std::unordered_set<LocationIndex> workQueue;
#endif

  // All existing links in the graph. We keep this to know when a link we want
  // to add is new or not.
  std::unordered_set<IndexLink> links;

  // Update a location with new contents that are added to everything already
  // present there. If the update changes the contents at that location (if
  // there was anything new) then we also need to flow from there, which we will
  // do by adding the location to the work queue, and eventually flowAfterUpdate
  // will be called on this location.
  //
  // Returns whether it is worth sending new contents to this location in the
  // future. If we return false, the sending location never needs to do that
  // ever again.
  bool updateContents(LocationIndex locationIndex,
                      PossibleContents newContents);

  // Slow helper that converts a Location to a LocationIndex. This should be
  // avoided. TODO: remove the remaining uses of this.
  bool updateContents(const Location& location,
                      const PossibleContents& newContents) {
    return updateContents(getIndex(location), newContents);
  }

  // Flow contents from a location where a change occurred. This sends the new
  // contents to all the normal targets of this location (using
  // flowToTargetsAfterUpdate), and also handles special cases of flow after.
  void flowAfterUpdate(LocationIndex locationIndex);

  // Internal part of flowAfterUpdate that handles sending new values to the
  // given location index's normal targets (that is, the ones listed in the
  // |targets| vector).
  void flowToTargetsAfterUpdate(LocationIndex locationIndex,
                                const PossibleContents& contents);

  // Add a new connection while the flow is happening. If the link already
  // exists it is not added.
  void connectDuringFlow(Location from, Location to);

  // Contents sent to a global location can be filtered in a special way during
  // the flow, which is handled in this helper.
  void filterGlobalContents(PossibleContents& contents,
                            const GlobalLocation& globalLoc);

  // Reads from GC data: a struct.get or array.get. This is given the type of
  // the read operation, the field that is read on that type, the known contents
  // in the reference the read receives, and the read instruction itself. We
  // compute where we need to read from based on the type and the ref contents
  // and get that data, adding new links in the graph as needed.
  void readFromData(HeapType declaredHeapType,
                    Index fieldIndex,
                    const PossibleContents& refContents,
                    Expression* read);

  // Similar to readFromData, but does a write for a struct.set or array.set.
  void writeToData(Expression* ref, Expression* value, Index fieldIndex);

  // Special handling for RefCast during the flow: RefCast only admits valid
  // values to flow through it.
  void flowRefCast(const PossibleContents& contents, RefCast* cast);

  // The possible contents may allow us to infer an outcome, like with RefCast.
  void flowRefTest(const PossibleContents& contents, RefTest* test);

  // We will need subtypes during the flow, so compute them once ahead of time.
  std::unique_ptr<SubTypes> subTypes;

#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
  // Dump out a location for debug purposes.
  void dump(Location location);
#endif
};

Flower::Flower(Module& wasm) : wasm(wasm) {
#ifdef POSSIBLE_CONTENTS_DEBUG
  std::cout << "parallel phase\n";
#endif

  // First, collect information from each function.
  ModuleUtils::ParallelFunctionAnalysis<CollectedFuncInfo> analysis(
    wasm, [&](Function* func, CollectedFuncInfo& info) {
      InfoCollector finder(info);

      if (func->imported()) {
        // Imports return unknown values.
        for (Index i = 0; i < func->getResults().size(); i++) {
          finder.addRoot(ResultLocation{func, i}, PossibleContents::many());
        }
        return;
      }

      finder.walkFunctionInModule(func, &wasm);
    });

#ifdef POSSIBLE_CONTENTS_DEBUG
  std::cout << "single phase\n";
#endif

  // Also walk the global module code (for simplicity, also add it to the
  // function map, using a "function" key of nullptr).
  auto& globalInfo = analysis.map[nullptr];
  InfoCollector finder(globalInfo);
  finder.walkModuleCode(&wasm);

  // Connect global init values (which we've just processed, as part of the
  // module code) to the globals they initialize.
  for (auto& global : wasm.globals) {
    if (global->imported()) {
      // Imports are unknown values.
      finder.addRoot(GlobalLocation{global->name}, PossibleContents::many());
      continue;
    }
    auto* init = global->init;
    if (finder.isRelevant(init->type)) {
      globalInfo.links.push_back(
        {ExpressionLocation{init, 0}, GlobalLocation{global->name}});
    }
  }

  // Merge the function information into a single large graph that represents
  // the entire program all at once, indexing and deduplicating everything as we
  // go.

#ifdef POSSIBLE_CONTENTS_DEBUG
  std::cout << "merging+indexing phase\n";
#endif

  // The merged roots. (Note that all other forms of merged data are declared at
  // the class level, since we need them during the flow, but the roots are only
  // needed to start the flow, so we can declare them here.)
  std::unordered_map<Location, PossibleContents> roots;

  for (auto& [func, info] : analysis.map) {
    for (auto& link : info.links) {
      links.insert(getIndexes(link));
    }
    for (auto& [root, value] : info.roots) {
      roots[root] = value;

      // Ensure an index even for a root with no links to it - everything needs
      // an index.
      getIndex(root);
    }
    for (auto [child, parent] : info.childParents) {
      // In practice we do not have any childParent connections with a tuple;
      // assert on that just to be safe.
      assert(!child->type.isTuple());
      childParents[getIndex(ExpressionLocation{child, 0})] =
        getIndex(ExpressionLocation{parent, 0});
    }
  }

  // We no longer need the function-level info.
  analysis.map.clear();

#ifdef POSSIBLE_CONTENTS_DEBUG
  std::cout << "external phase\n";
#endif

  // Parameters of exported functions are roots, since exports can have callers
  // that we can't see, so anything might arrive there.
  auto calledFromOutside = [&](Name funcName) {
    auto* func = wasm.getFunction(funcName);
    for (Index i = 0; i < func->getParams().size(); i++) {
      roots[LocalLocation{func, i, 0}] = PossibleContents::many();
    }
  };

  for (auto& ex : wasm.exports) {
    if (ex->kind == ExternalKind::Function) {
      calledFromOutside(ex->value);
    } else if (ex->kind == ExternalKind::Table) {
      // If any table is exported, assume any function in any table (including
      // other tables) can be called from the outside.
      // TODO: This could be more precise about which tables are exported and
      //       which are not: perhaps one table is exported but we can optimize
      //       the functions in another table, which is not exported. However,
      //       it is simpler to treat them all the same, and this handles the
      //       common case of no tables being exported at all.
      // TODO: This does not handle table.get/table.set, or call_ref, for which
      //       we'd need to see which references are used and which escape etc.
      //       For now, assume a closed world for such such advanced use cases /
      //       assume this pass won't be run in them anyhow.
      // TODO: do this only once if multiple tables are exported
      for (auto& elementSegment : wasm.elementSegments) {
        for (auto* curr : elementSegment->data) {
          if (auto* refFunc = curr->dynCast<RefFunc>()) {
            calledFromOutside(refFunc->func);
          }
        }
      }
    } else if (ex->kind == ExternalKind::Global) {
      // Exported mutable globals are roots, since the outside may write any
      // value to them.
      auto name = ex->value;
      if (wasm.getGlobal(name)->mutable_) {
        roots[GlobalLocation{name}] = PossibleContents::many();
      }
    }
  }

#ifdef POSSIBLE_CONTENTS_DEBUG
  std::cout << "func phase\n";
#endif

  // Connect function parameters to their signature, so that any indirect call
  // of that signature will reach them.
  // TODO: find which functions are even taken by reference
  for (auto& func : wasm.functions) {
    for (Index i = 0; i < func->getParams().size(); i++) {
      links.insert(getIndexes({SignatureParamLocation{func->type, i},
                               LocalLocation{func.get(), i, 0}}));
    }
    for (Index i = 0; i < func->getResults().size(); i++) {
      links.insert(getIndexes({ResultLocation{func.get(), i},
                               SignatureResultLocation{func->type, i}}));
    }
  }

#ifdef POSSIBLE_CONTENTS_DEBUG
  std::cout << "struct phase\n";
#endif

  if (getTypeSystem() == TypeSystem::Nominal ||
      getTypeSystem() == TypeSystem::Isorecursive) {
    subTypes = std::make_unique<SubTypes>(wasm);
  }

#ifdef POSSIBLE_CONTENTS_DEBUG
  std::cout << "Link-targets phase\n";
#endif

  // Add all links to the targets vectors of the source locations, which we will
  // use during the flow.
  for (auto& link : links) {
    getTargets(link.from).push_back(link.to);
  }

#ifndef NDEBUG
  // Each vector of targets (which is a vector for efficiency) must have no
  // duplicates.
  for (auto& info : locations) {
    disallowDuplicates(info.targets);
  }
#endif

#ifdef POSSIBLE_CONTENTS_DEBUG
  std::cout << "roots phase\n";
#endif

  // Set up the roots, which are the starting state for the flow analysis: send
  // their initial content to them to start the flow.
  for (const auto& [location, value] : roots) {
#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
    std::cout << "  init root\n";
    dump(location);
    value.dump(std::cout, &wasm);
    std::cout << '\n';
#endif

    updateContents(location, value);
  }

#ifdef POSSIBLE_CONTENTS_DEBUG
  std::cout << "flow phase\n";
  size_t iters = 0;
#endif

  // Flow the data while there is still stuff flowing.
  while (!workQueue.empty()) {
#ifdef POSSIBLE_CONTENTS_DEBUG
    iters++;
    if ((iters & 255) == 0) {
      std::cout << iters++ << " iters, work left: " << workQueue.size() << '\n';
    }
#endif

    auto iter = workQueue.begin();
    auto locationIndex = *iter;
    workQueue.erase(iter);

    flowAfterUpdate(locationIndex);
  }

  // TODO: Add analysis and retrieval logic for fields of immutable globals,
  //       including multiple levels of depth (necessary for itables in j2wasm).
}

bool Flower::updateContents(LocationIndex locationIndex,
                            PossibleContents newContents) {
  auto& contents = getContents(locationIndex);
  auto oldContents = contents;

#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
  std::cout << "updateContents\n";
  dump(getLocation(locationIndex));
  contents.dump(std::cout, &wasm);
  std::cout << "\n with new contents \n";
  newContents.dump(std::cout, &wasm);
  std::cout << '\n';
#endif

  contents.combine(newContents);

  if (contents.isNone()) {
    // There is still nothing here. There is nothing more to do here but to
    // return that it is worth sending more.
    return true;
  }

  // It is not worth sending any more to this location if we are now in the
  // worst possible case, as no future value could cause any change.
  //
  // Many is always the worst possible case. An exact type of a non-reference is
  // also the worst case, since subtyping is not relevant there, and so if we
  // know only the type then we already know nothing beyond what the type in the
  // wasm tells us (and from there we can only go to Many).
  bool worthSendingMore = !contents.isMany();
  if (!contents.getType().isRef() && contents.isExactType()) {
    worthSendingMore = false;
  }

  // Check if anything changed. Note that we check not just the content but
  // also its type. That handles the case of nulls, that compare equal even if
  // their type differs. We want to keep flowing if the type can change, so that
  // we always end up with a deterministic result no matter in what order the
  // flow happens (the final result will be the LUB of all the types of nulls
  // that can arrive).
  if (contents == oldContents && contents.getType() == oldContents.getType()) {
    // Nothing actually changed, so just return.
    return worthSendingMore;
  }

  // Handle special cases: Some locations can only contain certain contents, so
  // filter accordingly.
  if (auto* globalLoc =
        std::get_if<GlobalLocation>(&getLocation(locationIndex))) {
    filterGlobalContents(contents, *globalLoc);
    if (contents == oldContents &&
        contents.getType() == oldContents.getType()) {
      // Nothing actually changed after filtering, so just return.
      return worthSendingMore;
    }
  }

#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
  std::cout << "  updateContents has something new\n";
  contents.dump(std::cout, &wasm);
  std::cout << '\n';
#endif

  // Add a work item if there isn't already.
  workQueue.insert(locationIndex);

  return worthSendingMore;
}

void Flower::flowAfterUpdate(LocationIndex locationIndex) {
  const auto location = getLocation(locationIndex);
  auto& contents = getContents(locationIndex);

  // We are called after a change at a location. A change means that some
  // content has arrived, since we never send empty values around. Assert on
  // that.
  assert(!contents.isNone());

#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
  std::cout << "\nflowAfterUpdate to:\n";
  dump(location);
  std::cout << "  arriving:\n";
  contents.dump(std::cout, &wasm);
  std::cout << '\n';
#endif

  // Flow the contents to the normal targets of this location.
  flowToTargetsAfterUpdate(locationIndex, contents);

  // We are mostly done, except for handling interesting/special cases in the
  // flow, additional operations that we need to do aside from sending the new
  // contents to the normal (statically linked) targets.

  if (auto* exprLoc = std::get_if<ExpressionLocation>(&location)) {
    auto iter = childParents.find(locationIndex);
    if (iter == childParents.end()) {
      return;
    }

    // This is indeed one of the special cases where it is the child of a
    // parent, and we need to do some special handling because of that child-
    // parent connection.
    auto* child = exprLoc->expr;
    WASM_UNUSED(child);
    auto parentIndex = iter->second;
    auto* parent = std::get<ExpressionLocation>(getLocation(parentIndex)).expr;

#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
    std::cout << "  special, parent:\n" << *parent << '\n';
#endif

    if (auto* get = parent->dynCast<StructGet>()) {
      // |child| is the reference child of a struct.get.
      assert(get->ref == child);
      readFromData(get->ref->type.getHeapType(), get->index, contents, get);
    } else if (auto* set = parent->dynCast<StructSet>()) {
      // |child| is either the reference or the value child of a struct.set.
      assert(set->ref == child || set->value == child);
      writeToData(set->ref, set->value, set->index);
    } else if (auto* get = parent->dynCast<ArrayGet>()) {
      assert(get->ref == child);
      readFromData(get->ref->type.getHeapType(), 0, contents, get);
    } else if (auto* set = parent->dynCast<ArraySet>()) {
      assert(set->ref == child || set->value == child);
      writeToData(set->ref, set->value, 0);
    } else if (auto* cast = parent->dynCast<RefCast>()) {
      assert(cast->ref == child);
      flowRefCast(contents, cast);
    } else if (auto* test = parent->dynCast<RefTest>()) {
      assert(test->ref == child);
      flowRefTest(contents, test);
    } else {
      // TODO: ref.test and all other casts can be optimized (see the cast
      //       helper code used in OptimizeInstructions and RemoveUnusedBrs)
      WASM_UNREACHABLE("bad childParents content");
    }
  }
}

void Flower::flowToTargetsAfterUpdate(LocationIndex locationIndex,
                                      const PossibleContents& contents) {
  // Send the new contents to all the targets of this location. As we do so,
  // prune any targets that we do not need to bother sending content to in the
  // future, to save space and work later.
  auto& targets = getTargets(locationIndex);
  targets.erase(std::remove_if(targets.begin(),
                               targets.end(),
                               [&](LocationIndex targetIndex) {
#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
                                 std::cout << "  send to target\n";
                                 dump(getLocation(targetIndex));
#endif
                                 return !updateContents(targetIndex, contents);
                               }),
                targets.end());

  if (contents.isMany()) {
    // We contain Many, and just called updateContents on our targets to send
    // that value to them. We'll never need to send anything from here ever
    // again, since we sent the worst case possible already, so we can just
    // clear our targets vector. But we should have already removed all the
    // targets in the above remove_if operation, since they should have all
    // notified us that we do not need to send them any more updates.
    assert(targets.empty());
  }
}

void Flower::connectDuringFlow(Location from, Location to) {
  auto newLink = LocationLink{from, to};
  auto newIndexLink = getIndexes(newLink);
  if (links.count(newIndexLink) == 0) {
    // This is a new link. Add it to the known links.
    links.insert(newIndexLink);

    // Add it to the |targets| vector.
    auto& targets = getTargets(newIndexLink.from);
    targets.push_back(newIndexLink.to);
#ifndef NDEBUG
    disallowDuplicates(targets);
#endif

    // In addition to adding the link, which will ensure new contents appearing
    // later will be sent along, we also update with the current contents.
    updateContents(to, getContents(getIndex(from)));
  }
}

void Flower::filterGlobalContents(PossibleContents& contents,
                                  const GlobalLocation& globalLoc) {
  auto* global = wasm.getGlobal(globalLoc.name);
  if (global->mutable_ == Immutable) {
    // This is an immutable global. We never need to consider this value as
    // "Many", since in the worst case we can just use the immutable value. That
    // is, we can always replace this value with (global.get $name) which will
    // get the right value. Likewise, using the immutable global value is often
    // better than an exact type, but TODO: we could note both an exact type
    // *and* that something is equal to a global, in some cases.
    if (contents.isMany() || contents.isExactType()) {
      contents = PossibleContents::global(global->name, global->type);

      // TODO: We could do better here, to set global->init->type instead of
      //       global->type, or even the contents.getType() - either of those
      //       may be more refined. But other passes will handle that in
      //       general (by refining the global's type).

#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
      std::cout << "  setting immglobal to ImmutableGlobal\n";
      contents.dump(std::cout, &wasm);
      std::cout << '\n';
#endif
    }
  }
}

void Flower::readFromData(HeapType declaredHeapType,
                          Index fieldIndex,
                          const PossibleContents& refContents,
                          Expression* read) {
  // The data that a struct.get reads depends on two things: the reference that
  // we read from, and the relevant DataLocations. The reference determines
  // which DataLocations are relevant: if it is an ExactType then we have a
  // single DataLocation to read from, the one type that can be read from there.
  // Otherwise, we might read from any subtype, and so all their DataLocations
  // are relevant.
  //
  // What can be confusing is that the information about the reference is also
  // inferred during the flow. That is, we use our current information about the
  // reference to decide what to do here. But the flow is not finished yet!
  // To keep things valid, we must therefore react to changes in either the
  // reference - when we see that more types might be read from here - or the
  // DataLocations - when new things are written to the data we can read from.
  // Specifically, at every point in time we want to preserve the property that
  // we've read from all relevant types based on the current reference, and
  // we've read the very latest possible contents from those types. And then
  // since we preserve that property til the end of the flow, it is also valid
  // then. At the end of the flow, the current reference's contents are the
  // final and correct contents for that location, which means we've ended up
  // with the proper result: the struct.get reads everything it should.
  //
  // To implement what was just described, we call this function when the
  // reference is updated. This function will then set up connections in the
  // graph so that updates to the relevant DataLocations will reach us in the
  // future.

  if (refContents.isNull() || refContents.isNone()) {
    // Nothing is read here.
    return;
  }

  if (refContents.isLiteral()) {
    // The only reference literals we have are nulls (handled above) and
    // ref.func. ref.func will trap in struct|array.get, so nothing will be read
    // here (when we finish optimizing all instructions like BrOn then
    // ref.funcs should get filtered out before arriving here TODO).
    assert(refContents.getType().isFunction());
    return;
  }

#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
  std::cout << "    add special reads\n";
#endif

  if (refContents.isExactType()) {
    // Add a single link to the exact location the reference points to.
    connectDuringFlow(
      DataLocation{refContents.getType().getHeapType(), fieldIndex},
      ExpressionLocation{read, 0});
  } else {
    // Otherwise, this is a cone: the declared type of the reference, or any
    // subtype of that, regardless of whether the content is a Many or a Global
    // or anything else.
    // TODO: The Global case may have a different cone type than the heapType,
    //       which we could use here.
    // TODO: A Global may refer to an immutable global, which we can read the
    //       field from potentially (reading it from the struct.new/array.new
    //       in the definition of it, if it is not imported; or, we could track
    //       the contents of immutable fields of allocated objects, and not just
    //       represent them as ExactType).
    //       See the test TODO with text "We optimize some of this, but stop at
    //       reading from the immutable global"
    assert(refContents.isMany() || refContents.isGlobal());

    // We create a ConeReadLocation for the canonical cone of this type, to
    // avoid bloating the graph, see comment on ConeReadLocation().
    // TODO: A cone with no subtypes needs no canonical location, just
    //       add one direct link here.
    auto coneReadLocation = ConeReadLocation{declaredHeapType, fieldIndex};
    if (!hasIndex(coneReadLocation)) {
      // This is the first time we use this location, so create the links for it
      // in the graph.
      for (auto type : subTypes->getAllSubTypes(declaredHeapType)) {
        connectDuringFlow(DataLocation{type, fieldIndex}, coneReadLocation);
      }

      // TODO: if the old contents here were an exact type then we have an old
      //       link here that we could remove as it is redundant (the cone
      //       contains the exact type among the others). But removing links
      //       is not efficient, so maybe not worth it.
    }

    // Link to the canonical location.
    connectDuringFlow(coneReadLocation, ExpressionLocation{read, 0});
  }
}

void Flower::writeToData(Expression* ref, Expression* value, Index fieldIndex) {
#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
  std::cout << "    add special writes\n";
#endif

  // We could set up links here as we do for reads, but as we get to this code
  // in any case, we can just flow the values forward directly. This avoids
  // adding any links (edges) to the graph (and edges are what we want to avoid
  // adding, as there can be a quadratic number of them). In other words, we'll
  // loop over the places we need to send info to, which we can figure out in a
  // simple way, and by doing so we avoid materializing edges into the graph.
  //
  // Note that this is different from readFromData, above, which does add edges
  // to the graph (and works hard to add as few as possible, see the "canonical
  // cone reads" logic). The difference is because readFromData must "subscribe"
  // to get notifications from the relevant DataLocations. But when writing that
  // is not a problem: whenever a change happens in the reference or the value
  // of a struct.set then this function will get called, and those are the only
  // things we care about. And we can then just compute the values we are
  // sending (based on the current contents of the reference and the value), and
  // where we should send them to, and do that right here. (And as commented in
  // readFromData, that is guaranteed to give us the right result in the end: at
  // every point in time we send the right data, so when the flow is finished
  // we've sent information based on the final and correct information about our
  // reference and value.)

  auto refContents = getContents(getIndex(ExpressionLocation{ref, 0}));
  auto valueContents = getContents(getIndex(ExpressionLocation{value, 0}));
  if (refContents.isNone() || refContents.isNull()) {
    return;
  }
  if (refContents.hasExactType()) {
    // Update the one possible type here.
    auto heapLoc =
      DataLocation{refContents.getType().getHeapType(), fieldIndex};
    updateContents(heapLoc, valueContents);
  } else {
    assert(refContents.isMany() || refContents.isGlobal());

    // Update all possible subtypes here.
    auto type = ref->type.getHeapType();
    for (auto subType : subTypes->getAllSubTypes(type)) {
      auto heapLoc = DataLocation{subType, fieldIndex};
      updateContents(heapLoc, valueContents);
    }
  }
}

void Flower::flowRefCast(const PossibleContents& contents, RefCast* cast) {
  // RefCast only allows valid values to go through: nulls and things of the
  // cast type. Filter anything else out.
  PossibleContents filtered;
  if (contents.isMany()) {
    // Just pass the Many through.
    // TODO: we could emit a cone type here when we get one, instead of
    //       emitting a Many in any of these code paths
    filtered = contents;
  } else {
    bool isSubType =
      HeapType::isSubType(contents.getType().getHeapType(), cast->intendedType);
    if (isSubType) {
      // The contents are not Many, but their heap type is a subtype of the
      // intended type, so we'll pass that through. Note that we pass the entire
      // contents here, which includes nullability, but that is fine, it would
      // just overlap with the code below that handles nulls (that is, the code
      // below only makes a difference when the heap type is *not* a subtype but
      // the type is nullable).
      // TODO: When we get cone types, we could filter the cone here.
      filtered.combine(contents);
    }
    bool mayBeNull = contents.getType().isNullable();
    if (mayBeNull) {
      // A null is possible, so pass that along.
      filtered.combine(
        PossibleContents::literal(Literal::makeNull(cast->intendedType)));
    }
  }
  if (!filtered.isNone()) {
#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
    std::cout << "    ref.cast passing through\n";
    filtered.dump(std::cout);
    std::cout << '\n';
#endif
    updateContents(ExpressionLocation{cast, 0}, filtered);
  }
}

void Flower::flowRefTest(const PossibleContents& contents, RefTest* test) {
  PossibleContents filtered;
  if (contents.isMany()) {
    // Just pass the Many through.
    filtered = contents;
  } else {
    // RefTest returns 1 iff the input is not null and is also a subtype.
    bool isSubType =
      HeapType::isSubType(contents.getType().getHeapType(), test->intendedType);
    bool mayBeNull = contents.getType().isNullable();
    if (!isSubType) {
      filtered = PossibleContents::literal(Literal(int32_t(0)));
    } else if (!mayBeNull) {
      filtered = PossibleContents::literal(Literal(int32_t(1)));
    } else {
      filtered = PossibleContents::many();
    }
  }
#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
  std::cout << "    ref.test passing through\n";
  filtered.dump(std::cout);
  std::cout << '\n';
#endif
  updateContents(ExpressionLocation{test, 0}, filtered);
}

#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
void Flower::dump(Location location) {
  if (auto* loc = std::get_if<ExpressionLocation>(&location)) {
    std::cout << "  exprloc \n" << *loc->expr << '\n';
  } else if (auto* loc = std::get_if<DataLocation>(&location)) {
    std::cout << "  dataloc ";
    if (wasm.typeNames.count(loc->type)) {
      std::cout << '$' << wasm.typeNames[loc->type].name;
    } else {
      std::cout << loc->type << '\n';
    }
    std::cout << " : " << loc->index << '\n';
  } else if (auto* loc = std::get_if<TagLocation>(&location)) {
    std::cout << "  tagloc " << loc->tag << '\n';
  } else if (auto* loc = std::get_if<LocalLocation>(&location)) {
    std::cout << "  localloc " << loc->func->name << " : " << loc->index
              << " tupleIndex " << loc->tupleIndex << '\n';
  } else if (auto* loc = std::get_if<ResultLocation>(&location)) {
    std::cout << "  resultloc " << loc->func->name << " : " << loc->index
              << '\n';
  } else if (auto* loc = std::get_if<GlobalLocation>(&location)) {
    std::cout << "  globalloc " << loc->name << '\n';
  } else if (auto* loc = std::get_if<BreakTargetLocation>(&location)) {
    std::cout << "  branchloc " << loc->func->name << " : " << loc->target
              << " tupleIndex " << loc->tupleIndex << '\n';
  } else if (auto* loc = std::get_if<SignatureParamLocation>(&location)) {
    WASM_UNUSED(loc);
    std::cout << "  sigparamloc " << '\n';
  } else if (auto* loc = std::get_if<SignatureResultLocation>(&location)) {
    WASM_UNUSED(loc);
    std::cout << "  sigresultloc " << '\n';
  } else if (auto* loc = std::get_if<NullLocation>(&location)) {
    std::cout << "  Nullloc " << loc->type << '\n';
  } else if (auto* loc = std::get_if<UniqueLocation>(&location)) {
    std::cout << "  Specialloc " << loc->index << '\n';
  } else {
    std::cout << "  (other)\n";
  }
}
#endif

} // anonymous namespace

void ContentOracle::analyze() {
  Flower flower(wasm);
  for (LocationIndex i = 0; i < flower.locations.size(); i++) {
    locationContents[flower.getLocation(i)] = flower.getContents(i);
  }
}

} // namespace wasm
