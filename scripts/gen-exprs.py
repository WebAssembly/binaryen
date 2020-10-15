#!/usr/bin/env python3
#
# Copyright 2020 WebAssembly Community Group participants
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import sys

import test.shared as shared


# Support definitions

class Name: pass
class ExpressionList: pass

class Method:
    def __init__(self, signatures):
        self.signatures = signatures


class Expression: pass


# Specific expression definitions

class Nop(Expression):
    pass

class Block(Expression):
    name = Name()
    list = ExpressionList()

    '''
        finalize has three overloads:

        () set the type purely based on its contents. this
           scans the block, so it is not fast.

        (Type) sets the type given you know its type, which is the case when parsing
        s-expression or binary, as explicit types are given. the only additional
        work this does is to set the type to unreachable in the cases that is
        needed (which may require scanning the block)

        (Type type_, bool hasBreak) set the type given you know its type, and you know if there is a break to
        this block. this avoids the need to scan the contents of the block in the
        case that it might be unreachable, so it is recommended if you already know
        the type and breakability anyhow.
    '''
    finalize = Method(('', 'Type type_', 'Type type_, bool hasBreak'))



'''
};

class If : public SpecificExpression<Expression::IfId> {
public:
  If() : ifFalse(nullptr) {}
  If(MixedArena& allocator) : If() {}

  Expression* condition;
  Expression* ifTrue;
  Expression* ifFalse;

  set the type given you know its type, which is the case when parsing
  s-expression or binary, as explicit types are given. the only additional
  work this does is to set the type to unreachable in the cases that is
  needed.
  void finalize(Type type_);

  set the type purely based on its contents.
  void finalize();
};

class Loop : public SpecificExpression<Expression::LoopId> {
public:
  Loop() = default;
  Loop(MixedArena& allocator) {}

  Name name;
  Expression* body;

  set the type given you know its type, which is the case when parsing
  s-expression or binary, as explicit types are given. the only additional
  work this does is to set the type to unreachable in the cases that is
  needed.
  void finalize(Type type_);

  set the type purely based on its contents.
  void finalize();
};

class Break : public SpecificExpression<Expression::BreakId> {
public:
  Break() : value(nullptr), condition(nullptr) {}
  Break(MixedArena& allocator) : Break() { type = Type::unreachable; }

  Name name;
  Expression* value;
  Expression* condition;

  void finalize();
};

class Switch : public SpecificExpression<Expression::SwitchId> {
public:
  Switch(MixedArena& allocator) : targets(allocator) {
    type = Type::unreachable;
  }

  ArenaVector<Name> targets;
  Name default_;
  Expression* condition = nullptr;
  Expression* value = nullptr;

  void finalize();
};

class Call : public SpecificExpression<Expression::CallId> {
public:
  Call(MixedArena& allocator) : operands(allocator) {}

  ExpressionList operands;
  Name target;
  bool isReturn = false;

  void finalize();
};

class CallIndirect : public SpecificExpression<Expression::CallIndirectId> {
public:
  CallIndirect(MixedArena& allocator) : operands(allocator) {}
  Signature sig;
  ExpressionList operands;
  Expression* target;
  bool isReturn = false;

  void finalize();
};

class LocalGet : public SpecificExpression<Expression::LocalGetId> {
public:
  LocalGet() = default;
  LocalGet(MixedArena& allocator) {}

  Index index;
};

class LocalSet : public SpecificExpression<Expression::LocalSetId> {
public:
  LocalSet() = default;
  LocalSet(MixedArena& allocator) {}

  void finalize();

  Index index;
  Expression* value;

  bool isTee() const;
  void makeTee(Type type);
  void makeSet();
};

class GlobalGet : public SpecificExpression<Expression::GlobalGetId> {
public:
  GlobalGet() = default;
  GlobalGet(MixedArena& allocator) {}

  Name name;
};

class GlobalSet : public SpecificExpression<Expression::GlobalSetId> {
public:
  GlobalSet() = default;
  GlobalSet(MixedArena& allocator) {}

  Name name;
  Expression* value;

  void finalize();
};

class Load : public SpecificExpression<Expression::LoadId> {
public:
  Load() = default;
  Load(MixedArena& allocator) {}

  uint8_t bytes;
  bool signed_;
  Address offset;
  Address align;
  bool isAtomic;
  Expression* ptr;

  type must be set during creation, cannot be inferred

  void finalize();
};

class Store : public SpecificExpression<Expression::StoreId> {
public:
  Store() = default;
  Store(MixedArena& allocator) : Store() {}

  uint8_t bytes;
  Address offset;
  Address align;
  bool isAtomic;
  Expression* ptr;
  Expression* value;
  Type valueType;

  void finalize();
};

class AtomicRMW : public SpecificExpression<Expression::AtomicRMWId> {
public:
  AtomicRMW() = default;
  AtomicRMW(MixedArena& allocator) : AtomicRMW() {}

  AtomicRMWOp op;
  uint8_t bytes;
  Address offset;
  Expression* ptr;
  Expression* value;

  void finalize();
};

class AtomicCmpxchg : public SpecificExpression<Expression::AtomicCmpxchgId> {
public:
  AtomicCmpxchg() = default;
  AtomicCmpxchg(MixedArena& allocator) : AtomicCmpxchg() {}

  uint8_t bytes;
  Address offset;
  Expression* ptr;
  Expression* expected;
  Expression* replacement;

  void finalize();
};

class AtomicWait : public SpecificExpression<Expression::AtomicWaitId> {
public:
  AtomicWait() = default;
  AtomicWait(MixedArena& allocator) : AtomicWait() {}

  Address offset;
  Expression* ptr;
  Expression* expected;
  Expression* timeout;
  Type expectedType;

  void finalize();
};

class AtomicNotify : public SpecificExpression<Expression::AtomicNotifyId> {
public:
  AtomicNotify() = default;
  AtomicNotify(MixedArena& allocator) : AtomicNotify() {}

  Address offset;
  Expression* ptr;
  Expression* notifyCount;

  void finalize();
};

class AtomicFence : public SpecificExpression<Expression::AtomicFenceId> {
public:
  AtomicFence() = default;
  AtomicFence(MixedArena& allocator) : AtomicFence() {}

  Current wasm threads only supports sequentialy consistent atomics, but
  other orderings may be added in the future. This field is reserved for
  that, and currently set to 0.
  uint8_t order = 0;

  void finalize();
};

class SIMDExtract : public SpecificExpression<Expression::SIMDExtractId> {
public:
  SIMDExtract() = default;
  SIMDExtract(MixedArena& allocator) : SIMDExtract() {}

  SIMDExtractOp op;
  Expression* vec;
  uint8_t index;

  void finalize();
};

class SIMDReplace : public SpecificExpression<Expression::SIMDReplaceId> {
public:
  SIMDReplace() = default;
  SIMDReplace(MixedArena& allocator) : SIMDReplace() {}

  SIMDReplaceOp op;
  Expression* vec;
  uint8_t index;
  Expression* value;

  void finalize();
};

class SIMDShuffle : public SpecificExpression<Expression::SIMDShuffleId> {
public:
  SIMDShuffle() = default;
  SIMDShuffle(MixedArena& allocator) : SIMDShuffle() {}

  Expression* left;
  Expression* right;
  std::array<uint8_t, 16> mask;

  void finalize();
};

class SIMDTernary : public SpecificExpression<Expression::SIMDTernaryId> {
public:
  SIMDTernary() = default;
  SIMDTernary(MixedArena& allocator) : SIMDTernary() {}

  SIMDTernaryOp op;
  Expression* a;
  Expression* b;
  Expression* c;

  void finalize();
};

class SIMDShift : public SpecificExpression<Expression::SIMDShiftId> {
public:
  SIMDShift() = default;
  SIMDShift(MixedArena& allocator) : SIMDShift() {}

  SIMDShiftOp op;
  Expression* vec;
  Expression* shift;

  void finalize();
};

class SIMDLoad : public SpecificExpression<Expression::SIMDLoadId> {
public:
  SIMDLoad() = default;
  SIMDLoad(MixedArena& allocator) {}

  SIMDLoadOp op;
  Address offset;
  Address align;
  Expression* ptr;

  Index getMemBytes();
  void finalize();
};

class MemoryInit : public SpecificExpression<Expression::MemoryInitId> {
public:
  MemoryInit() = default;
  MemoryInit(MixedArena& allocator) : MemoryInit() {}

  Index segment;
  Expression* dest;
  Expression* offset;
  Expression* size;

  void finalize();
};

class DataDrop : public SpecificExpression<Expression::DataDropId> {
public:
  DataDrop() = default;
  DataDrop(MixedArena& allocator) : DataDrop() {}

  Index segment;

  void finalize();
};

class MemoryCopy : public SpecificExpression<Expression::MemoryCopyId> {
public:
  MemoryCopy() = default;
  MemoryCopy(MixedArena& allocator) : MemoryCopy() {}

  Expression* dest;
  Expression* source;
  Expression* size;

  void finalize();
};

class MemoryFill : public SpecificExpression<Expression::MemoryFillId> {
public:
  MemoryFill() = default;
  MemoryFill(MixedArena& allocator) : MemoryFill() {}

  Expression* dest;
  Expression* value;
  Expression* size;

  void finalize();
};

class Const : public SpecificExpression<Expression::ConstId> {
public:
  Const() = default;
  Const(MixedArena& allocator) {}

  Literal value;

  Const* set(Literal value_);

  void finalize();
};

class Unary : public SpecificExpression<Expression::UnaryId> {
public:
  Unary() = default;
  Unary(MixedArena& allocator) {}

  UnaryOp op;
  Expression* value;

  bool isRelational();

  void finalize();
};

class Binary : public SpecificExpression<Expression::BinaryId> {
public:
  Binary() = default;
  Binary(MixedArena& allocator) {}

  BinaryOp op;
  Expression* left;
  Expression* right;

  the type is always the type of the operands,
  except for relationals

  bool isRelational();

  void finalize();
};

class Select : public SpecificExpression<Expression::SelectId> {
public:
  Select() = default;
  Select(MixedArena& allocator) {}

  Expression* ifTrue;
  Expression* ifFalse;
  Expression* condition;

  void finalize();
  void finalize(Type type_);
};

class Drop : public SpecificExpression<Expression::DropId> {
public:
  Drop() = default;
  Drop(MixedArena& allocator) {}

  Expression* value;

  void finalize();
};

class Return : public SpecificExpression<Expression::ReturnId> {
public:
  Return() { type = Type::unreachable; }
  Return(MixedArena& allocator) : Return() {}

  Expression* value = nullptr;
};

class MemorySize : public SpecificExpression<Expression::MemorySizeId> {
public:
  MemorySize() { type = Type::i32; }
  MemorySize(MixedArena& allocator) : MemorySize() {}

  Type ptrType = Type::i32;

  void make64();
  void finalize();
};

class MemoryGrow : public SpecificExpression<Expression::MemoryGrowId> {
public:
  MemoryGrow() { type = Type::i32; }
  MemoryGrow(MixedArena& allocator) : MemoryGrow() {}

  Expression* delta = nullptr;
  Type ptrType = Type::i32;

  void make64();
  void finalize();
};

class Unreachable : public SpecificExpression<Expression::UnreachableId> {
public:
  Unreachable() { type = Type::unreachable; }
  Unreachable(MixedArena& allocator) : Unreachable() {}
};

Represents a pop of a value that arrives as an implicit argument to the
current block. Currently used in exception handling.
class Pop : public SpecificExpression<Expression::PopId> {
public:
  Pop() = default;
  Pop(MixedArena& allocator) {}
};

class RefNull : public SpecificExpression<Expression::RefNullId> {
public:
  RefNull() = default;
  RefNull(MixedArena& allocator) {}

  void finalize();
  void finalize(HeapType heapType);
  void finalize(Type type);
};

class RefIsNull : public SpecificExpression<Expression::RefIsNullId> {
public:
  RefIsNull(MixedArena& allocator) {}

  Expression* value;

  void finalize();
};

class RefFunc : public SpecificExpression<Expression::RefFuncId> {
public:
  RefFunc(MixedArena& allocator) {}

  Name func;

  void finalize();
};

class RefEq : public SpecificExpression<Expression::RefEqId> {
public:
  RefEq(MixedArena& allocator) {}

  Expression* left;
  Expression* right;

  void finalize();
};

class Try : public SpecificExpression<Expression::TryId> {
public:
  Try(MixedArena& allocator) {}

  Expression* body;
  Expression* catchBody;

  void finalize();
  void finalize(Type type_);
};

class Throw : public SpecificExpression<Expression::ThrowId> {
public:
  Throw(MixedArena& allocator) : operands(allocator) {}

  Name event;
  ExpressionList operands;

  void finalize();
};

class Rethrow : public SpecificExpression<Expression::RethrowId> {
public:
  Rethrow(MixedArena& allocator) {}

  Expression* exnref;

  void finalize();
};

class BrOnExn : public SpecificExpression<Expression::BrOnExnId> {
public:
  BrOnExn() { type = Type::unreachable; }
  BrOnExn(MixedArena& allocator) : BrOnExn() {}

  Name name;
  Name event;
  Expression* exnref;
  This is duplicate info of param types stored in Event, but this is required
  for us to know the type of the value sent to the target block.
  Type sent;

  void finalize();
};

class TupleMake : public SpecificExpression<Expression::TupleMakeId> {
public:
  TupleMake(MixedArena& allocator) : operands(allocator) {}

  ExpressionList operands;

  void finalize();
};

class TupleExtract : public SpecificExpression<Expression::TupleExtractId> {
public:
  TupleExtract(MixedArena& allocator) {}

  Expression* tuple;
  Index index;

  void finalize();
};

class I31New : public SpecificExpression<Expression::I31NewId> {
public:
  I31New(MixedArena& allocator) {}

  Expression* value;

  void finalize();
};

class I31Get : public SpecificExpression<Expression::I31GetId> {
public:
  I31Get(MixedArena& allocator) {}

  Expression* i31;
  bool signed_;

  void finalize();
};

class RefTest : public SpecificExpression<Expression::RefTestId> {
public:
  RefTest(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): ref.test"); }
};

class RefCast : public SpecificExpression<Expression::RefCastId> {
public:
  RefCast(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): ref.cast"); }
};

class BrOnCast : public SpecificExpression<Expression::BrOnCastId> {
public:
  BrOnCast(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): br_on_cast"); }
};

class RttCanon : public SpecificExpression<Expression::RttCanonId> {
public:
  RttCanon(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): rtt.canon"); }
};

class RttSub : public SpecificExpression<Expression::RttSubId> {
public:
  RttSub(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): rtt.sub"); }
};

class StructNew : public SpecificExpression<Expression::StructNewId> {
public:
  StructNew(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): struct.new"); }
};

class StructGet : public SpecificExpression<Expression::StructGetId> {
public:
  StructGet(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): struct.get"); }
};

class StructSet : public SpecificExpression<Expression::StructSetId> {
public:
  StructSet(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): struct.set"); }
};

class ArrayNew : public SpecificExpression<Expression::ArrayNewId> {
public:
  ArrayNew(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): array.new"); }
};

class ArrayGet : public SpecificExpression<Expression::ArrayGetId> {
public:
  ArrayGet(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): array.get"); }
};

class ArraySet : public SpecificExpression<Expression::ArraySetId> {
public:
  ArraySet(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): array.set"); }
};

class ArrayLen : public SpecificExpression<Expression::ArrayLenId> {
public:
  ArrayLen(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): array.len"); }
};


'''

COPYRIGHT = '''\
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
'''

NOTICE = '''\
//=============================================================================
This is an AUTOGENERATED file, even though it looks human-readable! Do not
edit it by hand, instead edit what it is generated from. You can and should
treat it like human-written code in all other ways, though, like reviewing
it in a PR, etc.
//=============================================================================
'''


# Processing

def get_expressions():
    ret = []

    all_globals = dict(globals())

    for key in all_globals:
        value = all_globals[key]
        if getattr(value, '__bases__', None) == (Expression,):
            ret.append(value)

    return ret


def generate_defs():
    #target = shared.in_binaryen('src', 'wasm-instructions.generated.h')
    #with open(target, 'w') as out:
    #    out.write(COPYRIGHT + '\n' + NOTICE)

    exprs = get_expressions()
    for expr in exprs:
        print(expr.__name__)
    1/0


def main():
    if sys.version_info.major != 3:
        import datetime
        print("It's " + str(datetime.datetime.now().year) + "! Use Python 3!")
        sys.exit(1)
    generate_defs()


if __name__ == "__main__":
    main()
