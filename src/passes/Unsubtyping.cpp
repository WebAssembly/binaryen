/*
 * Copyright 2023 WebAssembly Community Group participants
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

#include <unordered_map>

#include "ir/branch-utils.h"
#include "ir/subtypes.h"
#include "ir/type-updating.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-traversal.h"
#include "wasm-type.h"
#include "wasm.h"

namespace wasm {

namespace {

struct Unsubtyping
  : WalkerPass<PostWalker<Unsubtyping, OverriddenVisitor<Unsubtyping>>> {

  // The original type depths, as computed by SubTypes.
  std::unordered_map<HeapType, Index> typeDepths;

  // The new set of supertype relations.
  std::unordered_map<HeapType, HeapType> supertypes;

  // The set of subtypes that need to have their type definitions analyzed to
  // transitively find other subtype relations they depend on. We add to it
  // every time we find a new subtype relationship we need to keep.
  std::unordered_set<HeapType> worklist;

  // Map from cast source types to their destinations.
  std::unordered_map<HeapType, std::unordered_set<HeapType>> castTypes;

  void run(Module* wasm) override {
    if (!wasm->features.hasGC()) {
      return;
    }
    typeDepths = SubTypes(*wasm).getMaxDepths();
    analyzePublicTypes(*wasm);
    walkModule(wasm);
    analyzeTransitiveDependencies();
    optimizeTypes(*wasm);
    // Cast types may be refinable if their source and target types are no
    // longer related. TODO: Experiment with running this only after checking
    // whether it is necessary.
    ReFinalize().run(getPassRunner(), wasm);
  }

  void noteSubtype(HeapType sub, HeapType super) {
    if (sub == super || sub.isBottom() || super.isBottom()) {
      return;
    }

    auto [it, inserted] = supertypes.insert({sub, super});
    if (inserted) {
      worklist.insert(sub);
      // TODO: Incrementally check all subtypes (inclusive) of sub against super
      // and all its supertypes if we have already analyzed casts.
      return;
    }
    // We already had a recorded supertype. The new supertype might be deeper,
    // shallower, or identical to the old supertype.
    auto oldSuper = it->second;
    if (super == oldSuper) {
      return;
    }
    if (typeDepths[super] < typeDepths[oldSuper]) {
      // sub <: super <: oldSuper
      it->second = super;
      worklist.insert(sub);
      // TODO: Incrementally check all subtypes (inclusive) of sub against super
      // if we have already analyzed casts.
      noteSubtype(super, oldSuper);
    } else {
      // sub <: oldSuper <: super
      noteSubtype(oldSuper, super);
    }
  }

  void noteSubtype(Type sub, Type super) {
    if (sub.isTuple()) {
      assert(super.isTuple() && sub.size() == super.size());
      for (size_t i = 0, size = sub.size(); i < size; ++i) {
        noteSubtype(sub[i], super[i]);
      }
      return;
    }
    if (!sub.isRef() || !super.isRef()) {
      return;
    }
    noteSubtype(sub.getHeapType(), super.getHeapType());
  }

  void noteCast(HeapType src, HeapType dest) {
    if (src == dest || dest.isBottom()) {
      return;
    }
    assert(HeapType::isSubType(dest, src));
    castTypes[src].insert(dest);
  }

  void noteCast(Type src, Type dest) {
    assert(!src.isTuple() && !dest.isTuple());
    if (src == Type::unreachable) {
      return;
    }
    assert(src.isRef() && dest.isRef());
    noteCast(src.getHeapType(), dest.getHeapType());
  }

  void analyzePublicTypes(Module& wasm) {
    for (auto type : ModuleUtils::getPublicHeapTypes(wasm)) {
      if (auto super = type.getSuperType()) {
        noteSubtype(type, *super);
      }
    }
  }

  void analyzeTransitiveDependencies() {
    // Subtype relationships that we are keeping might depend on other subtype
    // relationships that we are not yet planning to keep. Transitively find all
    // the relationships we need to keep all our type definitions valid.
    while (!worklist.empty()) {
      while (!worklist.empty()) {
        auto it = worklist.begin();
        auto type = *it;
        worklist.erase(it);
        auto super = supertypes.at(type);
        if (super.isBasic()) {
          continue;
        }

        if (type.isStruct()) {
          const auto& fields = type.getStruct().fields;
          const auto& superFields = super.getStruct().fields;
          for (size_t i = 0, size = superFields.size(); i < size; ++i) {
            if (fields[i].mutable_ == Immutable) {
              noteSubtype(fields[i].type, superFields[i].type);
            }
          }
        } else if (type.isArray()) {
          auto elem = type.getArray().element;
          if (elem.mutable_ == Immutable) {
            noteSubtype(elem.type, super.getArray().element.type);
          }
        } else {
          assert(type.isSignature());
          auto sig = type.getSignature();
          auto superSig = super.getSignature();
          noteSubtype(superSig.params, sig.params);
          noteSubtype(sig.results, superSig.results);
        }
      }

      // TODO: This is expensive. Analyze casts incrementally after we
      // initially analyze them.
      analyzeCasts();
    }
  }

  void analyzeCasts() {
    // For each cast (src, dest) pair, any type that remains a subtype of src
    // (meaning its values can inhabit locations typed src) and that was
    // originally a subtype of dest (meaning its values would have passed the
    // cast) should remain a subtype of dest so that its values continue to pass
    // the cast.
    //
    // For every type, walk up its new supertype chain to find cast sources and
    // compare against their associated cast destinations.
    for (auto& [type, _] : typeDepths) {
      for (auto superIt = supertypes.find(type); superIt != supertypes.end();
           superIt = supertypes.find(superIt->second)) {
        auto super = superIt->second;
        auto destsIt = castTypes.find(super);
        if (destsIt == castTypes.end()) {
          continue;
        }
        for (auto dest : destsIt->second) {
          if (HeapType::isSubType(type, dest)) {
            noteSubtype(type, dest);
          }
        }
      }
    }
  }

  void optimizeTypes(Module& wasm) {
    struct Rewriter : GlobalTypeRewriter {
      Unsubtyping& parent;
      Rewriter(Unsubtyping& parent, Module& wasm)
        : GlobalTypeRewriter(wasm), parent(parent) {}
      std::optional<HeapType> getSuperType(HeapType type) override {
        if (auto it = parent.supertypes.find(type);
            it != parent.supertypes.end() && !it->second.isBasic()) {
          return it->second;
        }
        return std::nullopt;
      }
    };
    Rewriter(*this, wasm).update();
  }

  void visitFunction(Function* func) {
    if (func->body) {
      noteSubtype(func->body->type, func->getResults());
    }
  }
  void visitGlobal(Global* global) {
    if (global->init) {
      noteSubtype(global->init->type, global->type);
    }
  }
  void visitElementSegment(ElementSegment* seg) {
    if (seg->offset) {
      noteSubtype(seg->type, getModule()->getTable(seg->table)->type);
    }
    for (auto init : seg->data) {
      noteSubtype(init->type, seg->type);
    }
  }
  void visitNop(Nop* curr) {}
  void visitBlock(Block* curr) {
    if (curr->name) {
      BranchUtils::BranchSeeker seeker(curr->name);
      Expression* expr = curr;
      seeker.walk(expr);
      for (auto type : seeker.types) {
        noteSubtype(type, curr->type);
      }
    }
    if (!curr->list.empty()) {
      noteSubtype(curr->list.back()->type, curr->type);
    }
  }
  void visitIf(If* curr) {
    if (curr->ifFalse) {
      noteSubtype(curr->ifTrue->type, curr->type);
      noteSubtype(curr->ifFalse->type, curr->type);
    }
  }
  void visitLoop(Loop* curr) {
    // TODO: Once we support value-carrying branches to loops, consider those
    // branches here.
    noteSubtype(curr->body->type, curr->type);
  }
  void visitBreak(Break* curr) {
    // Accounted for at the branch target.
  }
  void visitSwitch(Switch* curr) {
    // Accounted for at the branch target.
  }
  template<typename T> void handleCall(T* curr, Signature sig) {
    assert(curr->operands.size() == sig.params.size());
    for (size_t i = 0, size = sig.params.size(); i < size; ++i) {
      noteSubtype(curr->operands[i]->type, sig.params[i]);
    }
    if (curr->isReturn) {
      noteSubtype(sig.results, getFunction()->getResults());
    }
  }
  void visitCall(Call* curr) {
    handleCall(curr, getModule()->getFunction(curr->target)->getSig());
  }
  void visitCallIndirect(CallIndirect* curr) {
    handleCall(curr, curr->heapType.getSignature());
    auto* table = getModule()->getTable(curr->table);
    auto tableType = table->type.getHeapType();
    if (HeapType::isSubType(tableType, curr->heapType)) {
      // Unlike other casts, where cast targets are always subtypes of cast
      // sources, call_indirect target types may be supertypes of their source
      // table types. In this case, the cast will always succeed, but only if we
      // keep the types related.
      noteSubtype(tableType, curr->heapType);
    } else if (HeapType::isSubType(curr->heapType, tableType)) {
      noteCast(table->type.getHeapType(), curr->heapType);
    } else {
      // The types are unrelated and the cast will fail. We can keep the types
      // unrelated.
    }
  }
  void visitLocalGet(LocalGet* curr) {}
  void visitLocalSet(LocalSet* curr) {
    noteSubtype(curr->value->type, getFunction()->getLocalType(curr->index));
  }
  void visitGlobalGet(GlobalGet* curr) {}
  void visitGlobalSet(GlobalSet* curr) {
    noteSubtype(curr->value->type, getModule()->getGlobal(curr->name)->type);
  }
  void visitLoad(Load* curr) {}
  void visitStore(Store* curr) {}
  void visitAtomicRMW(AtomicRMW* curr) {}
  void visitAtomicCmpxchg(AtomicCmpxchg* curr) {}
  void visitAtomicWait(AtomicWait* curr) {}
  void visitAtomicNotify(AtomicNotify* curr) {}
  void visitAtomicFence(AtomicFence* curr) {}
  void visitSIMDExtract(SIMDExtract* curr) {}
  void visitSIMDReplace(SIMDReplace* curr) {}
  void visitSIMDShuffle(SIMDShuffle* curr) {}
  void visitSIMDTernary(SIMDTernary* curr) {}
  void visitSIMDShift(SIMDShift* curr) {}
  void visitSIMDLoad(SIMDLoad* curr) {}
  void visitSIMDLoadStoreLane(SIMDLoadStoreLane* curr) {}
  void visitMemoryInit(MemoryInit* curr) {}
  void visitDataDrop(DataDrop* curr) {}
  void visitMemoryCopy(MemoryCopy* curr) {}
  void visitMemoryFill(MemoryFill* curr) {}
  void visitConst(Const* curr) {}
  void visitUnary(Unary* curr) {}
  void visitBinary(Binary* curr) {}
  void visitSelect(Select* curr) {
    noteSubtype(curr->ifTrue->type, curr->type);
    noteSubtype(curr->ifFalse->type, curr->type);
  }
  void visitDrop(Drop* curr) {}
  void visitReturn(Return* curr) {
    if (curr->value) {
      noteSubtype(curr->value->type, getFunction()->getResults());
    }
  }
  void visitMemorySize(MemorySize* curr) {}
  void visitMemoryGrow(MemoryGrow* curr) {}
  void visitUnreachable(Unreachable* curr) {}
  void visitPop(Pop* curr) {}
  void visitRefNull(RefNull* curr) {}
  void visitRefIsNull(RefIsNull* curr) {}
  void visitRefFunc(RefFunc* curr) {}
  void visitRefEq(RefEq* curr) {}
  void visitTableGet(TableGet* curr) {}
  void visitTableSet(TableSet* curr) {
    noteSubtype(curr->value->type, getModule()->getTable(curr->table)->type);
  }
  void visitTableSize(TableSize* curr) {}
  void visitTableGrow(TableGrow* curr) {}
  void visitTableFill(TableFill* curr) {
    noteSubtype(curr->value->type, getModule()->getTable(curr->table)->type);
  }
  void visitTry(Try* curr) {
    noteSubtype(curr->body->type, curr->type);
    for (auto* body : curr->catchBodies) {
      noteSubtype(body->type, curr->type);
    }
  }
  void visitThrow(Throw* curr) {
    Type params = getModule()->getTag(curr->tag)->sig.params;
    assert(params.size() == curr->operands.size());
    for (size_t i = 0, size = curr->operands.size(); i < size; ++i) {
      noteSubtype(curr->operands[i]->type, params[i]);
    }
  }
  void visitRethrow(Rethrow* curr) {}
  void visitTupleMake(TupleMake* curr) {}
  void visitTupleExtract(TupleExtract* curr) {}
  void visitRefI31(RefI31* curr) {}
  void visitI31Get(I31Get* curr) {}
  void visitCallRef(CallRef* curr) {
    if (!curr->target->type.isSignature()) {
      return;
    }
    handleCall(curr, curr->target->type.getHeapType().getSignature());
  }
  void visitRefTest(RefTest* curr) {
    noteCast(curr->ref->type, curr->castType);
  }
  void visitRefCast(RefCast* curr) { noteCast(curr->ref->type, curr->type); }
  void visitBrOn(BrOn* curr) {
    // Subtyping accounted for at the branch target.
    if (curr->op == BrOnCast || curr->op == BrOnCastFail) {
      noteCast(curr->ref->type, curr->castType);
    }
  }
  void visitStructNew(StructNew* curr) {
    if (!curr->type.isStruct() || curr->isWithDefault()) {
      return;
    }
    const auto& fields = curr->type.getHeapType().getStruct().fields;
    assert(fields.size() == curr->operands.size());
    for (size_t i = 0, size = fields.size(); i < size; ++i) {
      noteSubtype(curr->operands[i]->type, fields[i].type);
    }
  }
  void visitStructGet(StructGet* curr) {}
  void visitStructSet(StructSet* curr) {
    if (!curr->ref->type.isStruct()) {
      return;
    }
    const auto& fields = curr->ref->type.getHeapType().getStruct().fields;
    noteSubtype(curr->value->type, fields[curr->index].type);
  }
  void visitArrayNew(ArrayNew* curr) {
    if (!curr->type.isArray() || curr->isWithDefault()) {
      return;
    }
    auto array = curr->type.getHeapType().getArray();
    noteSubtype(curr->init->type, array.element.type);
  }
  void visitArrayNewData(ArrayNewData* curr) {}
  void visitArrayNewElem(ArrayNewElem* curr) {
    if (!curr->type.isArray()) {
      return;
    }
    auto array = curr->type.getHeapType().getArray();
    auto* seg = getModule()->getElementSegment(curr->segment);
    noteSubtype(seg->type, array.element.type);
  }
  void visitArrayNewFixed(ArrayNewFixed* curr) {
    if (!curr->type.isArray()) {
      return;
    }
    auto array = curr->type.getHeapType().getArray();
    for (auto* value : curr->values) {
      noteSubtype(value->type, array.element.type);
    }
  }
  void visitArrayGet(ArrayGet* curr) {}
  void visitArraySet(ArraySet* curr) {
    if (!curr->ref->type.isArray()) {
      return;
    }
    auto array = curr->ref->type.getHeapType().getArray();
    noteSubtype(curr->value->type, array.element.type);
  }
  void visitArrayLen(ArrayLen* curr) {}
  void visitArrayCopy(ArrayCopy* curr) {
    if (!curr->srcRef->type.isArray() || !curr->destRef->type.isArray()) {
      return;
    }
    auto src = curr->srcRef->type.getHeapType().getArray();
    auto dest = curr->destRef->type.getHeapType().getArray();
    noteSubtype(src.element.type, dest.element.type);
  }
  void visitArrayFill(ArrayFill* curr) {
    if (!curr->ref->type.isArray()) {
      return;
    }
    auto array = curr->ref->type.getHeapType().getArray();
    noteSubtype(curr->value->type, array.element.type);
  }
  void visitArrayInitData(ArrayInitData* curr) {}
  void visitArrayInitElem(ArrayInitElem* curr) {
    if (!curr->ref->type.isArray()) {
      return;
    }
    auto array = curr->ref->type.getHeapType().getArray();
    auto* seg = getModule()->getElementSegment(curr->segment);
    noteSubtype(seg->type, array.element.type);
  }
  void visitRefAs(RefAs* curr) {}
  void visitStringNew(StringNew* curr) {}
  void visitStringConst(StringConst* curr) {}
  void visitStringMeasure(StringMeasure* curr) {}
  void visitStringEncode(StringEncode* curr) {}
  void visitStringConcat(StringConcat* curr) {}
  void visitStringEq(StringEq* curr) {}
  void visitStringAs(StringAs* curr) {}
  void visitStringWTF8Advance(StringWTF8Advance* curr) {}
  void visitStringWTF16Get(StringWTF16Get* curr) {}
  void visitStringIterNext(StringIterNext* curr) {}
  void visitStringIterMove(StringIterMove* curr) {}
  void visitStringSliceWTF(StringSliceWTF* curr) {}
  void visitStringSliceIter(StringSliceIter* curr) {}
};

} // anonymous namespace

Pass* createUnsubtypingPass() { return new Unsubtyping(); }

} // namespace wasm
