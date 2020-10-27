/*
* Copyright 2020 WebAssembly Community Group participants
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

// Implements a switch on an expression class ID, and has a case for each id
// in which it runs delegates on the fields and immediates. All the delegates
// are optional, so you can just provide what you want, and no code will be
// emitted for the others.
//
// Child pointers are emitted in reverse order (which is convenient for walking
// by pushing them to a stack first).

// Emits code at the start of the case for a class.
#ifndef DELEGATE_START
#define DELEGATE_START(id)
#endif

// Emits code at the endof the case for a class.
#ifndef DELEGATE_END
#define DELEGATE_END(id)
#endif

// Emits code to handle a child pointer.
#ifndef DELEGATE_FIELD_CHILD
#define DELEGATE_FIELD_CHILD(id, name)
#endif

// Emits code to handle an optional child pointer (if this is not defined, then
// DELEGATE_FIELD_CHILD is called on it).
#ifndef DELEGATE_FIELD_OPTIONAL_CHILD
#define DELEGATE_FIELD_OPTIONAL_CHILD(id, name) DELEGATE_FIELD_CHILD(id, name)
#endif

// Emits code to handle a list of child pointers.
#ifndef DELEGATE_FIELD_CHILD_LIST
#define DELEGATE_FIELD_CHILD_LIST(id, name)
#endif

// Emits code to handle an integer value (bool, enum, Index, int32, or int64).
#ifndef DELEGATE_FIELD_INT
#define DELEGATE_FIELD_INT(id, name)
#endif

// Emits code to handle an array of integer values (like a SIMD mask).
#ifndef DELEGATE_FIELD_INT_ARRAY
#define DELEGATE_FIELD_INT_ARRAY(id, name)
#endif

// Emits code to handle a name (like a call target).
#ifndef DELEGATE_FIELD_NAME
#define DELEGATE_FIELD_NAME(id, name)
#endif

// Emits code to handle a scope name (like a br target).
#ifndef DELEGATE_FIELD_SCOPE_NAME
#define DELEGATE_FIELD_SCOPE_NAME(id, name)
#endif

// Emits code to handle a list of scope name (like a switch's targets).
#ifndef DELEGATE_FIELD_SCOPE_NAME_LIST
#define DELEGATE_FIELD_SCOPE_NAME_LIST(id, name)
#endif

// Emits code to handle a
#ifndef DELEGATE_FIELD_SIGNATURE
#define DELEGATE_FIELD_SIGNATURE(id, name)
#endif

// Emits code to handle a type.
#ifndef DELEGATE_FIELD_TYPE
#define DELEGATE_FIELD_TYPE(id, name)
#endif

// Emits code to handle an address.
#ifndef DELEGATE_FIELD_ADDRESS
#define DELEGATE_FIELD_ADDRESS(id, name)
#endif

switch (DELEGATE_ID) {
  case Expression::Id::InvalidId:
  case Expression::Id::NumExpressionIds: {
    WASM_UNREACHABLE("unexpected expression type");
  }
  case Expression::Id::BlockId: {
    DELEGATE_START(Block);
    DELEGATE_FIELD_CHILD_LIST(Block, list);
    DELEGATE_FIELD_SCOPE_NAME(Block, name);
    DELEGATE_END(Block);
    break;
  }
  case Expression::Id::IfId: {
    DELEGATE_START(If);
    DELEGATE_FIELD_OPTIONAL_CHILD(If, ifFalse);
    DELEGATE_FIELD_CHILD(If, ifTrue);
    DELEGATE_FIELD_CHILD(If, condition);
    DELEGATE_END();
    break;
  }
  case Expression::Id::LoopId: {
    DELEGATE_START(Loop);
    DELEGATE_FIELD_CHILD(Loop, body);
    DELEGATE_FIELD_SCOPE_NAME(Loop, name);
    DELEGATE_END();
    break;
  }
  case Expression::Id::BreakId: {
    DELEGATE_START(Break);
    DELEGATE_FIELD_OPTIONAL_CHILD(Break, condition);
    DELEGATE_FIELD_OPTIONAL_CHILD(Break, value);
    DELEGATE_FIELD_SCOPE_NAME(Break, name);
    DELEGATE_END();
    break;
  }
  case Expression::Id::SwitchId: {
    DELEGATE_START(Switch);
    DELEGATE_FIELD_CHILD(Switch, condition);
    DELEGATE_FIELD_OPTIONAL_CHILD(Switch, value);
    DELEGATE_FIELD_SCOPE_NAME(Switch, default_);
    DELEGATE_FIELD_SCOPE_NAME_LIST(Switch, default_);
    DELEGATE_END();
    break;
  }
  case Expression::Id::CallId: {
    DELEGATE_START(Call);
    DELEGATE_FIELD_CHILD_LIST(Call, operands);
    DELEGATE_FIELD_NAME(Call, target);
    DELEGATE_FIELD_INT(Call, isReturn);
    DELEGATE_END();
    break;
  }
  case Expression::Id::CallIndirectId: {
    DELEGATE_START(CallIndirect);
    DELEGATE_FIELD_CHILD(CallIndirect, target);
    DELEGATE_FIELD_CHILD_LIST(CallIndirect, operands);
    DELEGATE_FIELD_SIGNATURE(CallIndirect, sig);
    DELEGATE_FIELD_INT(CallIndirect, isReturn);
    DELEGATE_END();
    break;
  }
  case Expression::Id::LocalGetId: {
    // TODO: optimize leaves with a direct call?
    DELEGATE_START(LocalGet);
    DELEGATE_FIELD_INT(LocalGet, index);
    DELEGATE_END();
    break;
  }
  case Expression::Id::LocalSetId: {
    DELEGATE_START(LocalSet);
    DELEGATE_FIELD_CHILD(LocalSet, value);
    DELEGATE_FIELD_INT(LocalSet, index);
    DELEGATE_END();
    break;
  }
  case Expression::Id::GlobalGetId: {
    DELEGATE_START(GlobalGet);
    DELEGATE_FIELD_INT(GlobalGet, name);
    DELEGATE_END();
    break;
  }
  case Expression::Id::GlobalSetId: {
    DELEGATE_START(GlobalSet);
    DELEGATE_FIELD_CHILD(GlobalSet, value);
    DELEGATE_FIELD_INT(GlobalSet, name);
    DELEGATE_END();
    break;
  }
  case Expression::Id::LoadId: {
    DELEGATE_START(Load);
    DELEGATE_FIELD_CHILD(Load, ptr);
      DELEGATE_FIELD_INT(Load, bytes);
        DELEGATE_FIELD_INT(, signed_);
      }
      DELEGATE_FIELD_ADDRESS(, offset);
      DELEGATE_FIELD_ADDRESS(, align);
      DELEGATE_FIELD_INT(, isAtomic);
    DELEGATE_END();
    break;
  }
  case Expression::Id::StoreId: {
    DELEGATE_START(Store);
    DELEGATE_FIELD_CHILD(Store, value);
    DELEGATE_FIELD_CHILD(Store, ptr);
      DELEGATE_FIELD_INT(Store, bytes);
      DELEGATE_FIELD_ADDRESS(, offset);
      DELEGATE_FIELD_ADDRESS(, align);
      DELEGATE_FIELD_INT(, isAtomic);
      DELEGATE_FIELD_TYPE(, valueType);
    DELEGATE_END();
    break;
  }
  case Expression::Id::AtomicRMWId: {
    DELEGATE_START(AtomicRMW);
    DELEGATE_FIELD_CHILD(AtomicRMW, value);
    DELEGATE_FIELD_CHILD(AtomicRMW, ptr);
      DELEGATE_FIELD_INT(, op);
      DELEGATE_FIELD_INT(AtomicRMW, bytes);
      DELEGATE_FIELD_ADDRESS(, offset);
    DELEGATE_END();
    break;
  }
  case Expression::Id::AtomicCmpxchgId: {
    DELEGATE_START(AtomicCmpxchg);
    DELEGATE_FIELD_CHILD(AtomicCmpxchg, replacement);
    DELEGATE_FIELD_CHILD(AtomicCmpxchg, expected);
    DELEGATE_FIELD_CHILD(AtomicCmpxchg, ptr);
      DELEGATE_FIELD_INT(AtomicCmpxchg, bytes);
      DELEGATE_FIELD_ADDRESS(, offset);
    DELEGATE_END();
    break;
  }
  case Expression::Id::AtomicWaitId: {
    DELEGATE_START(AtomicWait);
    DELEGATE_FIELD_CHILD(AtomicWait, timeout);
    DELEGATE_FIELD_CHILD(AtomicWait, expected);
    DELEGATE_FIELD_CHILD(AtomicWait, ptr);
      DELEGATE_FIELD_ADDRESS(, offset);
      DELEGATE_FIELD_TYPE(, expectedType);
    DELEGATE_END();
    break;
  }
  case Expression::Id::AtomicNotifyId: {
    DELEGATE_START(AtomicNotify);
    DELEGATE_FIELD_CHILD(AtomicNotify, notifyCount);
    DELEGATE_FIELD_CHILD(AtomicNotify, ptr);
      DELEGATE_FIELD_ADDRESS(, offset);
    DELEGATE_END();
    break;
  }
  case Expression::Id::AtomicFenceId: {
    DELEGATE_START(AtomicFence);
    DELEGATE_FIELD_INT(AtomicFence, order);
    DELEGATE_END();
    break;
  }
  case Expression::Id::SIMDExtractId: {
    DELEGATE_START(SIMDExtract);
    DELEGATE_FIELD_CHILD(SIMDExtract, vec);
      DELEGATE_FIELD_INT(, op);
      DELEGATE_FIELD_INT(, index);
    DELEGATE_END();
    break;
  }
  case Expression::Id::SIMDReplaceId: {
    DELEGATE_START(SIMDReplace);
    DELEGATE_FIELD_CHILD(SIMDReplace, value);
    DELEGATE_FIELD_CHILD(SIMDReplace, vec);
      DELEGATE_FIELD_INT(, op);
      DELEGATE_FIELD_INT(, index);
    DELEGATE_END();
    break;
  }
  case Expression::Id::SIMDShuffleId: {
    DELEGATE_START(SIMDShuffle);
    DELEGATE_FIELD_CHILD(SIMDShuffle, right);
    DELEGATE_FIELD_CHILD(SIMDShuffle, left);
    DELEGATE_FIELD_INT_ARRAY(SIMDShuffle, mask);
    DELEGATE_END();
    break;
  }
  case Expression::Id::SIMDTernaryId: {
    DELEGATE_START(SIMDTernary);
    DELEGATE_FIELD_CHILD(SIMDTernary, c);
    DELEGATE_FIELD_CHILD(SIMDTernary, b);
    DELEGATE_FIELD_CHILD(SIMDTernary, a);
    DELEGATE_FIELD_INT(SIMDTernary, op);
    DELEGATE_END();
    break;
  }
  case Expression::Id::SIMDShiftId: {
    DELEGATE_START(SIMDShift);
    DELEGATE_FIELD_CHILD(SIMDShift, shift);
    DELEGATE_FIELD_CHILD(SIMDShift, vec);
    DELEGATE_FIELD_INT(SIMDShift, op);
    DELEGATE_END();
    break;
  }
  case Expression::Id::SIMDLoadId: {
    DELEGATE_START(SIMDLoad);
    DELEGATE_FIELD_CHILD(SIMDLoad, ptr);
      DELEGATE_FIELD_INT(, op);
      DELEGATE_FIELD_ADDRESS(, offset);
      DELEGATE_FIELD_ADDRESS(, align);
    DELEGATE_END();
    break;
  }
  case Expression::Id::SIMDLoadStoreLaneId: {
    DELEGATE_START(SIMDLoadStoreLane);
    DELEGATE_FIELD_CHILD(SIMDLoadStoreLane, vec);
    DELEGATE_FIELD_CHILD(SIMDLoadStoreLane, ptr);
      DELEGATE_FIELD_INT(, op);
      DELEGATE_FIELD_ADDRESS(, offset);
      DELEGATE_FIELD_ADDRESS(, align);
      DELEGATE_FIELD_INT(, index);
    DELEGATE_END();
    break;
  }
  case Expression::Id::MemoryInitId: {
    DELEGATE_START(MemoryInit);
    DELEGATE_FIELD_CHILD(MemoryInit, size);
    DELEGATE_FIELD_CHILD(MemoryInit, offset);
    DELEGATE_FIELD_CHILD(MemoryInit, dest);
      visitor.visitIndex(curr->segment);
    DELEGATE_END();
    break;
  }
  case Expression::Id::DataDropId: {
    DELEGATE_START(DataDrop);
    DELEGATE_FIELD_INT(DataDrop, curr->segment);
    DELEGATE_END();
    break;
  }
  case Expression::Id::MemoryCopyId: {
    DELEGATE_START(MemoryCopy);
    DELEGATE_FIELD_CHILD(MemoryCopy, size);
    DELEGATE_FIELD_CHILD(MemoryCopy, source);
    DELEGATE_FIELD_CHILD(MemoryCopy, dest);
    DELEGATE_END();
    break;
  }
  case Expression::Id::MemoryFillId: {
    DELEGATE_START(MemoryFill);
    DELEGATE_FIELD_CHILD(MemoryFill, size);
    DELEGATE_FIELD_CHILD(MemoryFill, value);
    DELEGATE_FIELD_CHILD(MemoryFill, dest);
    DELEGATE_END();
    break;
  }
  case Expression::Id::ConstId: {
    DELEGATE_START(Const);
    DELEGATE_FIELD_LITERAL(Const, value);
    DELEGATE_END();
    break;
  }
  case Expression::Id::UnaryId: {
    DELEGATE_START(Unary);
    DELEGATE_FIELD_CHILD(Unary, value);
    DELEGATE_FIELD_INT(Unary, op);
    DELEGATE_END();
    break;
  }
  case Expression::Id::BinaryId: {
    DELEGATE_START(Binary);
    DELEGATE_FIELD_CHILD(Binary, right);
    DELEGATE_FIELD_CHILD(Binary, left);
    DELEGATE_FIELD_INT(Binary, op);
    DELEGATE_END();
    break;
  }
  case Expression::Id::SelectId: {
    DELEGATE_START(Select);
    DELEGATE_FIELD_CHILD(Select, condition);
    DELEGATE_FIELD_CHILD(Select, ifFalse);
    DELEGATE_FIELD_CHILD(Select, ifTrue);
    DELEGATE_END();
    break;
  }
  case Expression::Id::DropId: {
    DELEGATE_START(Drop);
    DELEGATE_FIELD_CHILD(Drop, value);
    DELEGATE_END();
    break;
  }
  case Expression::Id::ReturnId: {
    DELEGATE_START(Return);
    DELEGATE_FIELD_OPTIONAL_CHILD(Return, value);
    DELEGATE_END();
    break;
  }
  case Expression::Id::MemorySizeId:
    DELEGATE_START(MemorySize);
    DELEGATE_END();
    break;
  case Expression::Id::MemoryGrowId:
    DELEGATE_START(MemoryGrow);
    DELEGATE_FIELD_CHILD(MemoryGrow, delta);
    DELEGATE_END();
    break;
  case Expression::Id::RefNullId: {
    DELEGATE_START(RefNull);
    DELEGATE_FIELD_TYPE(RefNull, curr->type);
    DELEGATE_END();
    break;
  }
  case Expression::Id::RefIsNullId: {
    DELEGATE_START(RefIsNull);
    DELEGATE_FIELD_CHILD(RefIsNull, value);
    DELEGATE_END();
    break;
  }
  case Expression::Id::RefFuncId: {
    DELEGATE_START(RefFunc);
    DELEGATE_FIELD_NAME(RefFunc, curr->func);
    DELEGATE_END();
    break;
  }
  case Expression::Id::RefEqId: {
    DELEGATE_START(RefEq);
    DELEGATE_FIELD_CHILD(RefEq, right);
    DELEGATE_FIELD_CHILD(RefEq, left);
    DELEGATE_END();
    break;
  }
  case Expression::Id::TryId: {
    DELEGATE_START(Try);
    DELEGATE_FIELD_CHILD(Try, catchBody);
    DELEGATE_FIELD_CHILD(Try, body);
    DELEGATE_END();
    break;
  }
  case Expression::Id::ThrowId: {
    DELEGATE_START(Throw);
    DELEGATE_FIELD_CHILD_LIST(Throw, operands);
    DELEGATE_FIELD_INT(Throw, curr->event);
    DELEGATE_END();
    break;
  }
  case Expression::Id::RethrowId: {
    DELEGATE_START(Rethrow);
    DELEGATE_FIELD_CHILD(Rethrow, exnref);
    DELEGATE_END();
    break;
  }
  case Expression::Id::BrOnExnId: {
    DELEGATE_START(BrOnExn);
    DELEGATE_FIELD_CHILD(BrOnExn, exnref);
      visitor.visitScopeName(curr->name);
      visitor.visitNonScopeName(curr->event);
    DELEGATE_END();
    break;
  }
  case Expression::Id::NopId: {
    DELEGATE_START(Nop);
    DELEGATE_END();
    break;
  }
  case Expression::Id::UnreachableId: {
    DELEGATE_START(Unreachable);
    DELEGATE_END();
    break;
  }
  case Expression::Id::PopId: {
    DELEGATE_START(Pop);
    DELEGATE_END();
    break;
  }
  case Expression::Id::TupleMakeId: {
    DELEGATE_START(TupleMake);
    DELEGATE_FIELD_CHILD_LIST(Tuple, operands);
    DELEGATE_END();
    break;
  }
  case Expression::Id::TupleExtractId: {
    DELEGATE_START(TupleExtract);
    DELEGATE_FIELD_CHILD(TupleExtract, tuple);
      visitor.visitIndex(curr->index);
    DELEGATE_END();
    break;
  }
  case Expression::Id::I31NewId: {
    DELEGATE_START(I31New);
    DELEGATE_FIELD_CHILD(I31New, value);
    DELEGATE_END();
    break;
  }
  case Expression::Id::I31GetId: {
    DELEGATE_START(I31Get);
    DELEGATE_FIELD_CHILD(I31Get, i31);
    DELEGATE_FIELD_INT(I31Get, signed_);
    DELEGATE_END();
    break;
  }
  case Expression::Id::RefTestId:
    DELEGATE_START(RefTest);
    WASM_UNREACHABLE("TODO (gc): ref.test");
    DELEGATE_END();
    break;
  case Expression::Id::RefCastId:
    DELEGATE_START(RefCast);
    WASM_UNREACHABLE("TODO (gc): ref.cast");
    DELEGATE_END();
    break;
  case Expression::Id::BrOnCastId:
    DELEGATE_START(BrOnCast);
    WASM_UNREACHABLE("TODO (gc): br_on_cast");
    DELEGATE_END();
    break;
  case Expression::Id::RttCanonId:
    DELEGATE_START(RttCanon);
    WASM_UNREACHABLE("TODO (gc): rtt.canon");
    DELEGATE_END();
    break;
  case Expression::Id::RttSubId:
    DELEGATE_START(RttSub);
    WASM_UNREACHABLE("TODO (gc): rtt.sub");
    DELEGATE_END();
    break;
  case Expression::Id::StructNewId:
    DELEGATE_START(StructNew);
    WASM_UNREACHABLE("TODO (gc): struct.new");
    DELEGATE_END();
    break;
  case Expression::Id::StructGetId:
    DELEGATE_START(StructGet);
    WASM_UNREACHABLE("TODO (gc): struct.get");
    DELEGATE_END();
    break;
  case Expression::Id::StructSetId:
    DELEGATE_START(StructSet);
    WASM_UNREACHABLE("TODO (gc): struct.set");
    DELEGATE_END();
    break;
  case Expression::Id::ArrayNewId:
    DELEGATE_START(ArrayNew);
    WASM_UNREACHABLE("TODO (gc): array.new");
    DELEGATE_END();
    break;
  case Expression::Id::ArrayGetId:
    DELEGATE_START(ArrayGet);
    WASM_UNREACHABLE("TODO (gc): array.get");
    DELEGATE_END();
    break;
  case Expression::Id::ArraySetId:
    DELEGATE_START(ArraySet);
    WASM_UNREACHABLE("TODO (gc): array.set");
    DELEGATE_END();
    break;
  case Expression::Id::ArrayLenId:
    DELEGATE_START(ArrayLen);
    WASM_UNREACHABLE("TODO (gc): array.len");
    DELEGATE_END();
    break;
}

