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
// (The only mandatory thing to define is DELEGATE_ID which is the key for the
// switch.)
//
// You can optionally define DELEGATE_GET_FIELD, which should access the field
// by name. If provided, it will be used where that makes sense. For example, it
// will be used to access a vector of children, calling each one individually
// (see DELEGATE_FIELD_CHILD, DELEGATE_FIELD_CHILD_VECTOR).

// All #defines used here are undefed automatically at the end for you.
//
// Child pointers are emitted in reverse order (which is convenient for walking
// by pushing them to a stack first).

// Emits code at the start of the case for a class.
#ifndef DELEGATE_START
#define DELEGATE_START(id)
#endif

// Emits code at the end of the case for a class.
#ifndef DELEGATE_END
#define DELEGATE_END(id)
#endif

// Emits code to handle a child pointer.
#ifndef DELEGATE_FIELD_CHILD
#error please define DELEGATE_FIELD_CHILD(id, name)
#endif

// Emits code to handle an optional child pointer. If this is not defined, then
// DELEGATE_FIELD_CHILD is called on it.
#ifndef DELEGATE_FIELD_OPTIONAL_CHILD
#define DELEGATE_FIELD_OPTIONAL_CHILD(id, name) DELEGATE_FIELD_CHILD(id, name)
#endif

// Emits code to handle a variable-sized vector of child pointers. If this is
// not defined, and DELEGATE_GET_FIELD is, then DELEGATE_FIELD_CHILD is called
// on
// them.
#ifndef DELEGATE_FIELD_CHILD_VECTOR
#ifdef DELEGATE_GET_FIELD
#define DELEGATE_FIELD_CHILD_VECTOR(id, name)                                  \
  for (Index i = 0; i < (DELEGATE_GET_FIELD(id, name)).size(); i++) {          \
    DELEGATE_FIELD_CHILD(id, name[i]);                                         \
  }
#else
#error please define DELEGATE_FIELD_CHILD_VECTOR(id, name)
#endif
#endif

// Emits code to handle an integer value (bool, enum, Index, int32, or int64).
#ifndef DELEGATE_FIELD_INT
#error please define DELEGATE_FIELD_INT(id, name)
#endif

// Emits code to handle a std::array of fixed size of integer values (like a
// SIMD mask). If this is not defined, and DELEGATE_GET_FIELD is, then
// DELEGATE_FIELD_INT is called on them.
#ifndef DELEGATE_FIELD_INT_ARRAY
#ifdef DELEGATE_GET_FIELD
#define DELEGATE_FIELD_INT_ARRAY(id, name)                                     \
  for (Index i = 0; i < (DELEGATE_GET_FIELD(id, name)).size(); i++) {          \
    DELEGATE_FIELD_INT(id, name[i]);                                           \
  }
#else
#error please define DELEGATE_FIELD_INT_ARRAY(id, name)
#endif
#endif

// Emits code to handle a Literal.
#ifndef DELEGATE_FIELD_LITERAL
#error please define DELEGATE_FIELD_LITERAL(id, name)
#endif

// Emits code to handle a name (like a call target).
#ifndef DELEGATE_FIELD_NAME
#error please define DELEGATE_FIELD_NAME(id, name)
#endif

// Emits code to handle a scope name definition (like a block's name).
#ifndef DELEGATE_FIELD_SCOPE_NAME_DEF
#error please define DELEGATE_FIELD_SCOPE_NAME_DEF(id, name)
#endif

// Emits code to handle a scope name use (like a br's target).
#ifndef DELEGATE_FIELD_SCOPE_NAME_USE
#error please define DELEGATE_FIELD_SCOPE_NAME_USE(id, name)
#endif

// Emits code to handle a variable-sized vector of scope names (like a switch's
// targets). If this is not defined, and DELEGATE_GET_FIELD is, then
// DELEGATE_FIELD_SCOPE_NAME_USE is called on them.
#ifndef DELEGATE_FIELD_SCOPE_NAME_USE_VECTOR
#ifdef DELEGATE_GET_FIELD
#define DELEGATE_FIELD_SCOPE_NAME_USE_VECTOR(id, name)                         \
  for (Index i = 0; i < (DELEGATE_GET_FIELD(id, name)).size(); i++) {          \
    DELEGATE_FIELD_SCOPE_NAME_USE(id, name[i]);                                \
  }
#else
#error please define DELEGATE_FIELD_SCOPE_NAME_USE_VECTOR(id, name)
#endif
#endif

// Emits code to handle a Signature.
#ifndef DELEGATE_FIELD_SIGNATURE
#error please define DELEGATE_FIELD_SIGNATURE(id, name)
#endif

// Emits code to handle a type.
#ifndef DELEGATE_FIELD_TYPE
#error please define DELEGATE_FIELD_TYPE(id, name)
#endif

// Emits code to handle an address.
#ifndef DELEGATE_FIELD_ADDRESS
#error please define DELEGATE_FIELD_ADDRESS(id, name)
#endif

switch (DELEGATE_ID) {
  case Expression::Id::InvalidId:
  case Expression::Id::NumExpressionIds: {
    WASM_UNREACHABLE("unexpected expression type");
  }
  case Expression::Id::BlockId: {
    DELEGATE_START(Block);
    DELEGATE_FIELD_CHILD_VECTOR(Block, list);
    DELEGATE_FIELD_SCOPE_NAME_DEF(Block, name);
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
    DELEGATE_FIELD_SCOPE_NAME_DEF(Loop, name);
    DELEGATE_END();
    break;
  }
  case Expression::Id::BreakId: {
    DELEGATE_START(Break);
    DELEGATE_FIELD_OPTIONAL_CHILD(Break, condition);
    DELEGATE_FIELD_OPTIONAL_CHILD(Break, value);
    DELEGATE_FIELD_SCOPE_NAME_USE(Break, name);
    DELEGATE_END();
    break;
  }
  case Expression::Id::SwitchId: {
    DELEGATE_START(Switch);
    DELEGATE_FIELD_CHILD(Switch, condition);
    DELEGATE_FIELD_OPTIONAL_CHILD(Switch, value);
    DELEGATE_FIELD_SCOPE_NAME_USE(Switch, default_);
    DELEGATE_FIELD_SCOPE_NAME_USE_VECTOR(Switch, targets);
    DELEGATE_END();
    break;
  }
  case Expression::Id::CallId: {
    DELEGATE_START(Call);
    DELEGATE_FIELD_CHILD_VECTOR(Call, operands);
    DELEGATE_FIELD_NAME(Call, target);
    DELEGATE_FIELD_INT(Call, isReturn);
    DELEGATE_END();
    break;
  }
  case Expression::Id::CallIndirectId: {
    DELEGATE_START(CallIndirect);
    DELEGATE_FIELD_CHILD(CallIndirect, target);
    DELEGATE_FIELD_CHILD_VECTOR(CallIndirect, operands);
    DELEGATE_FIELD_SIGNATURE(CallIndirect, sig);
    DELEGATE_FIELD_INT(CallIndirect, isReturn);
    DELEGATE_END();
    break;
  }
  case Expression::Id::LocalGetId: {
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
    DELEGATE_FIELD_INT(Load, signed_);
    DELEGATE_FIELD_ADDRESS(Load, offset);
    DELEGATE_FIELD_ADDRESS(Load, align);
    DELEGATE_FIELD_INT(Load, isAtomic);
    DELEGATE_END();
    break;
  }
  case Expression::Id::StoreId: {
    DELEGATE_START(Store);
    DELEGATE_FIELD_CHILD(Store, value);
    DELEGATE_FIELD_CHILD(Store, ptr);
    DELEGATE_FIELD_INT(Store, bytes);
    DELEGATE_FIELD_ADDRESS(Store, offset);
    DELEGATE_FIELD_ADDRESS(Store, align);
    DELEGATE_FIELD_INT(Store, isAtomic);
    DELEGATE_FIELD_TYPE(Store, valueType);
    DELEGATE_END();
    break;
  }
  case Expression::Id::AtomicRMWId: {
    DELEGATE_START(AtomicRMW);
    DELEGATE_FIELD_CHILD(AtomicRMW, value);
    DELEGATE_FIELD_CHILD(AtomicRMW, ptr);
    DELEGATE_FIELD_INT(AtomicRMW, op);
    DELEGATE_FIELD_INT(AtomicRMW, bytes);
    DELEGATE_FIELD_ADDRESS(AtomicRMW, offset);
    DELEGATE_END();
    break;
  }
  case Expression::Id::AtomicCmpxchgId: {
    DELEGATE_START(AtomicCmpxchg);
    DELEGATE_FIELD_CHILD(AtomicCmpxchg, replacement);
    DELEGATE_FIELD_CHILD(AtomicCmpxchg, expected);
    DELEGATE_FIELD_CHILD(AtomicCmpxchg, ptr);
    DELEGATE_FIELD_INT(AtomicCmpxchg, bytes);
    DELEGATE_FIELD_ADDRESS(AtomicCmpxchg, offset);
    DELEGATE_END();
    break;
  }
  case Expression::Id::AtomicWaitId: {
    DELEGATE_START(AtomicWait);
    DELEGATE_FIELD_CHILD(AtomicWait, timeout);
    DELEGATE_FIELD_CHILD(AtomicWait, expected);
    DELEGATE_FIELD_CHILD(AtomicWait, ptr);
    DELEGATE_FIELD_ADDRESS(AtomicWait, offset);
    DELEGATE_FIELD_TYPE(AtomicWait, expectedType);
    DELEGATE_END();
    break;
  }
  case Expression::Id::AtomicNotifyId: {
    DELEGATE_START(AtomicNotify);
    DELEGATE_FIELD_CHILD(AtomicNotify, notifyCount);
    DELEGATE_FIELD_CHILD(AtomicNotify, ptr);
    DELEGATE_FIELD_ADDRESS(AtomicNotify, offset);
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
    DELEGATE_FIELD_INT(SIMDExtract, op);
    DELEGATE_FIELD_INT(SIMDExtract, index);
    DELEGATE_END();
    break;
  }
  case Expression::Id::SIMDReplaceId: {
    DELEGATE_START(SIMDReplace);
    DELEGATE_FIELD_CHILD(SIMDReplace, value);
    DELEGATE_FIELD_CHILD(SIMDReplace, vec);
    DELEGATE_FIELD_INT(SIMDReplace, op);
    DELEGATE_FIELD_INT(SIMDReplace, index);
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
    DELEGATE_FIELD_INT(SIMDLoad, op);
    DELEGATE_FIELD_ADDRESS(SIMDLoad, offset);
    DELEGATE_FIELD_ADDRESS(SIMDLoad, align);
    DELEGATE_END();
    break;
  }
  case Expression::Id::SIMDLoadStoreLaneId: {
    DELEGATE_START(SIMDLoadStoreLane);
    DELEGATE_FIELD_CHILD(SIMDLoadStoreLane, vec);
    DELEGATE_FIELD_CHILD(SIMDLoadStoreLane, ptr);
    DELEGATE_FIELD_INT(SIMDLoadStoreLane, op);
    DELEGATE_FIELD_ADDRESS(SIMDLoadStoreLane, offset);
    DELEGATE_FIELD_ADDRESS(SIMDLoadStoreLane, align);
    DELEGATE_FIELD_INT(SIMDLoadStoreLane, index);
    DELEGATE_END();
    break;
  }
  case Expression::Id::MemoryInitId: {
    DELEGATE_START(MemoryInit);
    DELEGATE_FIELD_CHILD(MemoryInit, size);
    DELEGATE_FIELD_CHILD(MemoryInit, offset);
    DELEGATE_FIELD_CHILD(MemoryInit, dest);
    DELEGATE_FIELD_INT(MemoryInit, segment);
    DELEGATE_END();
    break;
  }
  case Expression::Id::DataDropId: {
    DELEGATE_START(DataDrop);
    DELEGATE_FIELD_INT(DataDrop, segment);
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
  case Expression::Id::MemorySizeId: {
    DELEGATE_START(MemorySize);
    DELEGATE_END();
    break;
  }
  case Expression::Id::MemoryGrowId: {
    DELEGATE_START(MemoryGrow);
    DELEGATE_FIELD_CHILD(MemoryGrow, delta);
    DELEGATE_END();
    break;
  }
  case Expression::Id::RefNullId: {
    DELEGATE_START(RefNull);
    DELEGATE_FIELD_TYPE(RefNull, type);
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
    DELEGATE_FIELD_NAME(RefFunc, func);
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
    DELEGATE_FIELD_CHILD_VECTOR(Throw, operands);
    DELEGATE_FIELD_NAME(Throw, event);
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
    DELEGATE_FIELD_SCOPE_NAME_USE(BrOnExn, name);
    DELEGATE_FIELD_NAME(BrOnExn, event);
    DELEGATE_FIELD_TYPE(BrOnExn, sent);
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
    DELEGATE_FIELD_CHILD_VECTOR(Tuple, operands);
    DELEGATE_END();
    break;
  }
  case Expression::Id::TupleExtractId: {
    DELEGATE_START(TupleExtract);
    DELEGATE_FIELD_CHILD(TupleExtract, tuple);
    DELEGATE_FIELD_INT(TupleExtract, index);
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
  case Expression::Id::RefTestId: {
    DELEGATE_START(RefTest);
    WASM_UNREACHABLE("TODO (gc): ref.test");
    DELEGATE_END();
    break;
  }
  case Expression::Id::RefCastId: {
    DELEGATE_START(RefCast);
    WASM_UNREACHABLE("TODO (gc): ref.cast");
    DELEGATE_END();
    break;
  }
  case Expression::Id::BrOnCastId: {
    DELEGATE_START(BrOnCast);
    WASM_UNREACHABLE("TODO (gc): br_on_cast");
    DELEGATE_END();
    break;
  }
  case Expression::Id::RttCanonId: {
    DELEGATE_START(RttCanon);
    WASM_UNREACHABLE("TODO (gc): rtt.canon");
    DELEGATE_END();
    break;
  }
  case Expression::Id::RttSubId: {
    DELEGATE_START(RttSub);
    WASM_UNREACHABLE("TODO (gc): rtt.sub");
    DELEGATE_END();
    break;
  }
  case Expression::Id::StructNewId: {
    DELEGATE_START(StructNew);
    WASM_UNREACHABLE("TODO (gc): struct.new");
    DELEGATE_END();
    break;
  }
  case Expression::Id::StructGetId: {
    DELEGATE_START(StructGet);
    WASM_UNREACHABLE("TODO (gc): struct.get");
    DELEGATE_END();
    break;
  }
  case Expression::Id::StructSetId: {
    DELEGATE_START(StructSet);
    WASM_UNREACHABLE("TODO (gc): struct.set");
    DELEGATE_END();
    break;
  }
  case Expression::Id::ArrayNewId: {
    DELEGATE_START(ArrayNew);
    WASM_UNREACHABLE("TODO (gc): array.new");
    DELEGATE_END();
    break;
  }
  case Expression::Id::ArrayGetId: {
    DELEGATE_START(ArrayGet);
    WASM_UNREACHABLE("TODO (gc): array.get");
    DELEGATE_END();
    break;
  }
  case Expression::Id::ArraySetId: {
    DELEGATE_START(ArraySet);
    WASM_UNREACHABLE("TODO (gc): array.set");
    DELEGATE_END();
    break;
  }
  case Expression::Id::ArrayLenId: {
    DELEGATE_START(ArrayLen);
    WASM_UNREACHABLE("TODO (gc): array.len");
    DELEGATE_END();
    break;
  }
}

#undef DELEGATE_ID
#undef DELEGATE_START
#undef DELEGATE_END
#undef DELEGATE_FIELD_CHILD
#undef DELEGATE_FIELD_OPTIONAL_CHILD
#undef DELEGATE_FIELD_CHILD_VECTOR
#undef DELEGATE_FIELD_INT
#undef DELEGATE_FIELD_INT_ARRAY
#undef DELEGATE_FIELD_LITERAL
#undef DELEGATE_FIELD_NAME
#undef DELEGATE_FIELD_SCOPE_NAME_DEF
#undef DELEGATE_FIELD_SCOPE_NAME_USE
#undef DELEGATE_FIELD_SCOPE_NAME_USE_VECTOR
#undef DELEGATE_FIELD_SIGNATURE
#undef DELEGATE_FIELD_TYPE
#undef DELEGATE_FIELD_ADDRESS
