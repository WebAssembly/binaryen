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

#ifndef wasm_ir_subtype_exprs_h
#define wasm_ir_subtype_exprs_h

#include "ir/branch-utils.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

//
// Analyze subtyping relationships between expressions. This must CRTP with a
// parent that implements:
//
//  * noteSubType(A, B) indicating A must be a subtype of B
//  * noteCast(A, B) indicating A is cast to B
//
// There must be multiple versions of each of those, supporting A and B being
// either a Type, which indicates a fixed type requirement, or an Expression*,
// indicating a flexible requirement that depends on the type of that
// expression. Specifically:
//
//  * noteSubType(Type, Type) - A constraint not involving expressions at all,
//                              for example, an element segment's type must be
//                              a subtype of the corresponding table's.
//  * noteSubType(HeapType, HeapType) - Ditto, with heap types, for example in a
//                                      CallIndirect.
//  * noteSubType(Type, Expression) - A fixed type must be a subtype of an
//                                    expression's type, for example, in BrOn
//                                    (the declared sent type must be a subtype
//                                    of the block we branch to).
//  * noteSubType(Expression, Type) - An expression's type must be a subtype of
//                                    a fixed type, for example, a Call operand
//                                    must be a subtype of the signature's
//                                    param.
//  * noteSubType(Expression, Expression) - An expression's type must be a
//                                          subtype of anothers, for example,
//                                          a block and its last child.
//
//  * noteCast(HeapType, HeapType) - A fixed type is cast to another, for example,
//                                   in a CallIndirect.
//  * noteCast(Expression, Type) - An expression's type is cast to a fixed type,
//                                 for example, in RefTest.
//  * noteCast(Expression, Expression) - An expression's type is cast to
//                                       another, for example, in RefCast.
//
// Note that noteCast(Type, Type) and noteCast(Type, Expression) never occur and
// do not need to be implemented.
//
// The parent must also inherit from ControlFlowWalker (for findBreakTarget).
//

template<typename Parent>
struct SubtypingDiscoverer : public OverriddenVisitor<Parent> {
  Parent* self() { return (Parent*)this; }

  void visitFunction(Function* func) {
    if (func->body) {
      self()->noteSubtype(func->body, func->getResults());
    }
  }
  void visitGlobal(Global* global) {
    if (global->init) {
      self()->noteSubtype(global->init, global->type);
    }
  }
  void visitElementSegment(ElementSegment* seg) {
    if (seg->offset) {
      self()->noteSubtype(seg->type,
                          self()->getModule()->getTable(seg->table)->type);
    }
    for (auto init : seg->data) {
      self()->noteSubtype(init->type, seg->type);
    }
  }
  void visitNop(Nop* curr) {}
  void visitBlock(Block* curr) {
    if (!curr->list.empty()) {
      self()->noteSubtype(curr->list.back(), curr);
    }
  }
  void visitIf(If* curr) {
    if (curr->ifFalse) {
      self()->noteSubtype(curr->ifTrue, curr);
      self()->noteSubtype(curr->ifFalse, curr);
    }
  }
  void visitLoop(Loop* curr) { self()->noteSubtype(curr->body, curr); }
  void visitBreak(Break* curr) {
    if (curr->value) {
      self()->noteSubtype(curr->value, self()->findBreakTarget(curr->name));
    }
  }
  void visitSwitch(Switch* curr) {
    if (curr->value) {
      for (auto name : BranchUtils::getUniqueTargets(curr)) {
        self()->noteSubtype(curr->value, self()->findBreakTarget(name));
      }
    }
  }
  template<typename T> void handleCall(T* curr, Signature sig) {
    assert(curr->operands.size() == sig.params.size());
    for (size_t i = 0, size = sig.params.size(); i < size; ++i) {
      self()->noteSubtype(curr->operands[i], sig.params[i]);
    }
    if (curr->isReturn) {
      self()->noteSubtype(sig.results, self()->getFunction()->getResults());
    }
  }
  void visitCall(Call* curr) {
    handleCall(curr, self()->getModule()->getFunction(curr->target)->getSig());
  }
  void visitCallIndirect(CallIndirect* curr) {
    handleCall(curr, curr->heapType.getSignature());
    auto* table = self()->getModule()->getTable(curr->table);
    auto tableType = table->type.getHeapType();
    if (HeapType::isSubType(tableType, curr->heapType)) {
      // Unlike other casts, where cast targets are always subtypes of cast
      // sources, call_indirect target types may be supertypes of their source
      // table types. In this case, the cast will always succeed, but only if we
      // keep the types related.
      self()->noteSubtype(tableType, curr->heapType);
    } else if (HeapType::isSubType(curr->heapType, tableType)) {
      self()->noteCast(tableType, curr->heapType);
    } else {
      // The types are unrelated and the cast will fail. We can keep the types
      // unrelated.
    }
  }
  void visitLocalGet(LocalGet* curr) {}
  void visitLocalSet(LocalSet* curr) {
    self()->noteSubtype(curr->value,
                        self()->getFunction()->getLocalType(curr->index));
  }
  void visitGlobalGet(GlobalGet* curr) {}
  void visitGlobalSet(GlobalSet* curr) {
    self()->noteSubtype(curr->value,
                        self()->getModule()->getGlobal(curr->name)->type);
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
    self()->noteSubtype(curr->ifTrue, curr);
    self()->noteSubtype(curr->ifFalse, curr);
  }
  void visitDrop(Drop* curr) {}
  void visitReturn(Return* curr) {
    if (curr->value) {
      self()->noteSubtype(curr->value, self()->getFunction()->getResults());
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
    self()->noteSubtype(curr->value,
                        self()->getModule()->getTable(curr->table)->type);
  }
  void visitTableSize(TableSize* curr) {}
  void visitTableGrow(TableGrow* curr) {}
  void visitTableFill(TableFill* curr) {
    self()->noteSubtype(curr->value,
                        self()->getModule()->getTable(curr->table)->type);
  }
  void visitTableCopy(TableCopy* curr) {
    self()->noteSubtype(self()->getModule()->getTable(curr->sourceTable)->type,
                        self()->getModule()->getTable(curr->destTable)->type);
  }
  void visitTry(Try* curr) {
    self()->noteSubtype(curr->body, curr);
    for (auto* body : curr->catchBodies) {
      self()->noteSubtype(body, curr);
    }
  }
  void visitThrow(Throw* curr) {
    Type params = self()->getModule()->getTag(curr->tag)->sig.params;
    assert(params.size() == curr->operands.size());
    for (size_t i = 0, size = curr->operands.size(); i < size; ++i) {
      self()->noteSubtype(curr->operands[i], params[i]);
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
    self()->noteCast(curr->ref, curr->castType);
  }
  void visitRefCast(RefCast* curr) { self()->noteCast(curr->ref, curr); }
  void visitBrOn(BrOn* curr) {
    if (curr->op == BrOnCast || curr->op == BrOnCastFail) {
      self()->noteCast(curr->ref, curr->castType);
    }
    self()->noteSubtype(curr->getSentType(),
                        self()->findBreakTarget(curr->name));
  }
  void visitStructNew(StructNew* curr) {
    if (!curr->type.isStruct() || curr->isWithDefault()) {
      return;
    }
    const auto& fields = curr->type.getHeapType().getStruct().fields;
    assert(fields.size() == curr->operands.size());
    for (size_t i = 0, size = fields.size(); i < size; ++i) {
      self()->noteSubtype(curr->operands[i], fields[i].type);
    }
  }
  void visitStructGet(StructGet* curr) {}
  void visitStructSet(StructSet* curr) {
    if (!curr->ref->type.isStruct()) {
      return;
    }
    const auto& fields = curr->ref->type.getHeapType().getStruct().fields;
    self()->noteSubtype(curr->value, fields[curr->index].type);
  }
  void visitArrayNew(ArrayNew* curr) {
    if (!curr->type.isArray() || curr->isWithDefault()) {
      return;
    }
    auto array = curr->type.getHeapType().getArray();
    self()->noteSubtype(curr->init, array.element.type);
  }
  void visitArrayNewData(ArrayNewData* curr) {}
  void visitArrayNewElem(ArrayNewElem* curr) {
    if (!curr->type.isArray()) {
      return;
    }
    auto array = curr->type.getHeapType().getArray();
    auto* seg = self()->getModule()->getElementSegment(curr->segment);
    self()->noteSubtype(seg->type, array.element.type);
  }
  void visitArrayNewFixed(ArrayNewFixed* curr) {
    if (!curr->type.isArray()) {
      return;
    }
    auto array = curr->type.getHeapType().getArray();
    for (auto* value : curr->values) {
      self()->noteSubtype(value, array.element.type);
    }
  }
  void visitArrayGet(ArrayGet* curr) {}
  void visitArraySet(ArraySet* curr) {
    if (!curr->ref->type.isArray()) {
      return;
    }
    auto array = curr->ref->type.getHeapType().getArray();
    self()->noteSubtype(curr->value->type, array.element.type);
  }
  void visitArrayLen(ArrayLen* curr) {}
  void visitArrayCopy(ArrayCopy* curr) {
    if (!curr->srcRef->type.isArray() || !curr->destRef->type.isArray()) {
      return;
    }
    auto src = curr->srcRef->type.getHeapType().getArray();
    auto dest = curr->destRef->type.getHeapType().getArray();
    self()->noteSubtype(src.element.type, dest.element.type);
  }
  void visitArrayFill(ArrayFill* curr) {
    if (!curr->ref->type.isArray()) {
      return;
    }
    auto array = curr->ref->type.getHeapType().getArray();
    self()->noteSubtype(curr->value->type, array.element.type);
  }
  void visitArrayInitData(ArrayInitData* curr) {}
  void visitArrayInitElem(ArrayInitElem* curr) {
    if (!curr->ref->type.isArray()) {
      return;
    }
    auto array = curr->ref->type.getHeapType().getArray();
    auto* seg = self()->getModule()->getElementSegment(curr->segment);
    self()->noteSubtype(seg->type, array.element.type);
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

} // namespace wasm

#endif // #define wasm_ir_subtype_exprs_h
