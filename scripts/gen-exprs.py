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

class ExpressionChild: pass

class Field(ExpressionChild):
    def __init__(self, init=None):
        self.init = init

    def render(self, name):
        typename = self.__class__.__name__
        if hasattr(self, 'typename'):
            typename = self.typename
        value = f' = {self.init}' if self.init else ''
        return f'{typename} {name}{value};'

class Name(Field): pass
class ExpressionList(Field): pass
class ArenaVector(Field):
    def __init__(self, of):
        self.of = of

    def render(self, name):
        return f'ArenaVector<{self.of}> {name};'

#    TODO also add constructor on class!
###  Switch(MixedArena& allocator) : targets(allocator) {

class Child(Field):
    typename = 'Expression*'

class Method:
    def __init__(self, paramses, result):
        self.paramses = paramses
        self.result = result

    def render(self, name):
        ret = [f'{self.result} {name}({params});' for params in self.paramses]
        return join_nested_lines(ret)

class Expression:
    __constructor_body__ = ''

    @classmethod
    def render(self):
        name = self.__name__
        fields = []
        methods = []
        for key, value in self.__dict__.items():
            if is_subclass_of(value.__class__, Field):
                fields.append(value.render(key))
            elif value.__class__ == Method:
                methods.append(value.render(key))
        fields_text = join_nested_lines(fields)
        methods_text = join_nested_lines(methods)
        constructor_body = self.__constructor_body__
        if constructor_body:
            constructor_body = ' ' + constructor_body + ' '
        text = '''\
class %(name)s : public SpecificExpression<Expression::%(name)sId> {
public:
  %(name)s() {%(constructor_body)s}
  %(name)s(MixedArena& allocator) : %(name)s() {}
  %(fields_text)s
  %(methods_text)s
};
''' % locals()
        text = compact_text(text)
        return text


###################################
# Specific expression definitions
###################################

class Nop(Expression):
    pass

class Block(Expression):
    name = Name()
    list = ExpressionList()

    '''
        finalize has three overloads:

        void ();

        set the type purely based on its contents. this
        scans the block, so it is not fast.

        void (Type);

        sets the type given you know its type, which is the case when parsing
        s-expression or binary, as explicit types are given. the only additional
        work this does is to set the type to unreachable in the cases that is
        needed (which may require scanning the block)

        void (Type type_, bool hasBreak);

        set the type given you know its type, and you know if there is a break to
        this block. this avoids the need to scan the contents of the block in the
        case that it might be unreachable, so it is recommended if you already know
        the type and breakability anyhow.
    '''
    finalize = Method(('', 'Type type_', 'Type type_, bool hasBreak'), 'void')

class If(Expression):
    condition = Child()
    ifTrue = Child()
    ifFalse = Child(init='nullptr')

    '''
        void finalize(Type type_);

        set the type given you know its type, which is the case when parsing
        s-expression or binary, as explicit types are given. the only additional
        work this does is to set the type to unreachable in the cases that is
        needed.

          finalize = Method('', 'void')

        set the type purely based on its contents.
    '''
    finalize = Method(('Type type_', ''), 'void')

class Loop(Expression):
    name = Name()
    body = Child()

    '''
        set the type given you know its type, which is the case when parsing
        s-expression or binary, as explicit types are given. the only additional
        work this does is to set the type to unreachable in the cases that is
        needed.
        void finalize(Type type_);

        set the type purely based on its contents.
    '''
    finalize = Method(('Type type_', ''), 'void')


class Break(Expression):
    __constructor_body__ = 'type = Type::unreachable;'

    name = Name()
    value = Child(init='nullptr')
    condition = Child(init='nullptr')

    finalize = Method('', 'void')

class Switch(Expression):
    __constructor_body__ = 'type = Type::unreachable;'

    targets = ArenaVector('Name')
    default_ = Name()
    condition = Child()
    value = Child(init='nullptr')

    finalize = Method('', 'void')

'''

class Call : public SpecificExpression<Expression::CallId> {
public:
  Call(MixedArena& allocator) : operands(allocator) {}

  ExpressionList operands;
  Name target;
  bool isReturn = false;

    finalize = Method('', 'void')

class CallIndirect : public SpecificExpression<Expression::CallIndirectId> {
public:
  CallIndirect(MixedArena& allocator) : operands(allocator) {}
  Signature sig;
  ExpressionList operands;
  Expression* target;
  bool isReturn = false;

    finalize = Method('', 'void')

class LocalGet : public SpecificExpression<Expression::LocalGetId> {
public:
  LocalGet() = default;
  LocalGet(MixedArena& allocator) {}

  Index index;

class LocalSet : public SpecificExpression<Expression::LocalSetId> {
public:
  LocalSet() = default;
  LocalSet(MixedArena& allocator) {}

    finalize = Method('', 'void')

  Index index;
  Expression* value;

  bool isTee() const;
  void makeTee(Type type);
  void makeSet();

class GlobalGet : public SpecificExpression<Expression::GlobalGetId> {
public:
  GlobalGet() = default;
  GlobalGet(MixedArena& allocator) {}

  Name name;

class GlobalSet : public SpecificExpression<Expression::GlobalSetId> {
public:
  GlobalSet() = default;
  GlobalSet(MixedArena& allocator) {}

  Name name;
  Expression* value;

    finalize = Method('', 'void')

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

    finalize = Method('', 'void')

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

    finalize = Method('', 'void')

class AtomicRMW : public SpecificExpression<Expression::AtomicRMWId> {
public:
  AtomicRMW() = default;
  AtomicRMW(MixedArena& allocator) : AtomicRMW() {}

  AtomicRMWOp op;
  uint8_t bytes;
  Address offset;
  Expression* ptr;
  Expression* value;

    finalize = Method('', 'void')

class AtomicCmpxchg : public SpecificExpression<Expression::AtomicCmpxchgId> {
public:
  AtomicCmpxchg() = default;
  AtomicCmpxchg(MixedArena& allocator) : AtomicCmpxchg() {}

  uint8_t bytes;
  Address offset;
  Expression* ptr;
  Expression* expected;
  Expression* replacement;

    finalize = Method('', 'void')

class AtomicWait : public SpecificExpression<Expression::AtomicWaitId> {
public:
  AtomicWait() = default;
  AtomicWait(MixedArena& allocator) : AtomicWait() {}

  Address offset;
  Expression* ptr;
  Expression* expected;
  Expression* timeout;
  Type expectedType;

    finalize = Method('', 'void')

class AtomicNotify : public SpecificExpression<Expression::AtomicNotifyId> {
public:
  AtomicNotify() = default;
  AtomicNotify(MixedArena& allocator) : AtomicNotify() {}

  Address offset;
  Expression* ptr;
  Expression* notifyCount;

    finalize = Method('', 'void')

class AtomicFence : public SpecificExpression<Expression::AtomicFenceId> {
public:
  AtomicFence() = default;
  AtomicFence(MixedArena& allocator) : AtomicFence() {}

  Current wasm threads only supports sequentialy consistent atomics, but
  other orderings may be added in the future. This field is reserved for
  that, and currently set to 0.
  uint8_t order = 0;

    finalize = Method('', 'void')

class SIMDExtract : public SpecificExpression<Expression::SIMDExtractId> {
public:
  SIMDExtract() = default;
  SIMDExtract(MixedArena& allocator) : SIMDExtract() {}

  SIMDExtractOp op;
  Expression* vec;
  uint8_t index;

    finalize = Method('', 'void')

class SIMDReplace : public SpecificExpression<Expression::SIMDReplaceId> {
public:
  SIMDReplace() = default;
  SIMDReplace(MixedArena& allocator) : SIMDReplace() {}

  SIMDReplaceOp op;
  Expression* vec;
  uint8_t index;
  Expression* value;

    finalize = Method('', 'void')

class SIMDShuffle : public SpecificExpression<Expression::SIMDShuffleId> {
public:
  SIMDShuffle() = default;
  SIMDShuffle(MixedArena& allocator) : SIMDShuffle() {}

  Expression* left;
  Expression* right;
  std::array<uint8_t, 16> mask;

    finalize = Method('', 'void')

class SIMDTernary : public SpecificExpression<Expression::SIMDTernaryId> {
public:
  SIMDTernary() = default;
  SIMDTernary(MixedArena& allocator) : SIMDTernary() {}

  SIMDTernaryOp op;
  Expression* a;
  Expression* b;
  Expression* c;

    finalize = Method('', 'void')

class SIMDShift : public SpecificExpression<Expression::SIMDShiftId> {
public:
  SIMDShift() = default;
  SIMDShift(MixedArena& allocator) : SIMDShift() {}

  SIMDShiftOp op;
  Expression* vec;
  Expression* shift;

    finalize = Method('', 'void')

class SIMDLoad : public SpecificExpression<Expression::SIMDLoadId> {
public:
  SIMDLoad() = default;
  SIMDLoad(MixedArena& allocator) {}

  SIMDLoadOp op;
  Address offset;
  Address align;
  Expression* ptr;

  Index getMemBytes();
    finalize = Method('', 'void')

class MemoryInit : public SpecificExpression<Expression::MemoryInitId> {
public:
  MemoryInit() = default;
  MemoryInit(MixedArena& allocator) : MemoryInit() {}

  Index segment;
  Expression* dest;
  Expression* offset;
  Expression* size;

    finalize = Method('', 'void')

class DataDrop : public SpecificExpression<Expression::DataDropId> {
public:
  DataDrop() = default;
  DataDrop(MixedArena& allocator) : DataDrop() {}

  Index segment;

    finalize = Method('', 'void')

class MemoryCopy : public SpecificExpression<Expression::MemoryCopyId> {
public:
  MemoryCopy() = default;
  MemoryCopy(MixedArena& allocator) : MemoryCopy() {}

  Expression* dest;
  Expression* source;
  Expression* size;

    finalize = Method('', 'void')

class MemoryFill : public SpecificExpression<Expression::MemoryFillId> {
public:
  MemoryFill() = default;
  MemoryFill(MixedArena& allocator) : MemoryFill() {}

  Expression* dest;
  Expression* value;
  Expression* size;

    finalize = Method('', 'void')

class Const : public SpecificExpression<Expression::ConstId> {
public:
  Const() = default;
  Const(MixedArena& allocator) {}

  Literal value;

  Const* set(Literal value_);

    finalize = Method('', 'void')

class Unary : public SpecificExpression<Expression::UnaryId> {
public:
  Unary() = default;
  Unary(MixedArena& allocator) {}

  UnaryOp op;
  Expression* value;

  bool isRelational();

    finalize = Method('', 'void')

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

    finalize = Method('', 'void')

class Select : public SpecificExpression<Expression::SelectId> {
public:
  Select() = default;
  Select(MixedArena& allocator) {}

  Expression* ifTrue;
  Expression* ifFalse;
  Expression* condition;

    finalize = Method('', 'void')
  void finalize(Type type_);

class Drop : public SpecificExpression<Expression::DropId> {
public:
  Drop() = default;
  Drop(MixedArena& allocator) {}

  Expression* value;

    finalize = Method('', 'void')

class Return : public SpecificExpression<Expression::ReturnId> {
public:
  Return() { type = Type::unreachable; }
  Return(MixedArena& allocator) : Return() {}

  Expression* value = nullptr;

class MemorySize : public SpecificExpression<Expression::MemorySizeId> {
public:
  MemorySize() { type = Type::i32; }
  MemorySize(MixedArena& allocator) : MemorySize() {}

  Type ptrType = Type::i32;

  void make64();
    finalize = Method('', 'void')

class MemoryGrow : public SpecificExpression<Expression::MemoryGrowId> {
public:
  MemoryGrow() { type = Type::i32; }
  MemoryGrow(MixedArena& allocator) : MemoryGrow() {}

  Expression* delta = nullptr;
  Type ptrType = Type::i32;

  void make64();
    finalize = Method('', 'void')

class Unreachable : public SpecificExpression<Expression::UnreachableId> {
public:
  Unreachable() { type = Type::unreachable; }
  Unreachable(MixedArena& allocator) : Unreachable() {}

Represents a pop of a value that arrives as an implicit argument to the
current block. Currently used in exception handling.
class Pop : public SpecificExpression<Expression::PopId> {
public:
  Pop() = default;
  Pop(MixedArena& allocator) {}

class RefNull : public SpecificExpression<Expression::RefNullId> {
public:
  RefNull() = default;
  RefNull(MixedArena& allocator) {}

    finalize = Method('', 'void')
  void finalize(HeapType heapType);
  void finalize(Type type);

class RefIsNull : public SpecificExpression<Expression::RefIsNullId> {
public:
  RefIsNull(MixedArena& allocator) {}

  Expression* value;

    finalize = Method('', 'void')

class RefFunc : public SpecificExpression<Expression::RefFuncId> {
public:
  RefFunc(MixedArena& allocator) {}

  Name func;

    finalize = Method('', 'void')

class RefEq : public SpecificExpression<Expression::RefEqId> {
public:
  RefEq(MixedArena& allocator) {}

  Expression* left;
  Expression* right;

    finalize = Method('', 'void')

class Try : public SpecificExpression<Expression::TryId> {
public:
  Try(MixedArena& allocator) {}

  Expression* body;
  Expression* catchBody;

    finalize = Method('', 'void')
  void finalize(Type type_);

class Throw : public SpecificExpression<Expression::ThrowId> {
public:
  Throw(MixedArena& allocator) : operands(allocator) {}

  Name event;
  ExpressionList operands;

    finalize = Method('', 'void')

class Rethrow : public SpecificExpression<Expression::RethrowId> {
public:
  Rethrow(MixedArena& allocator) {}

  Expression* exnref;

    finalize = Method('', 'void')

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

    finalize = Method('', 'void')

class TupleMake : public SpecificExpression<Expression::TupleMakeId> {
public:
  TupleMake(MixedArena& allocator) : operands(allocator) {}

  ExpressionList operands;

    finalize = Method('', 'void')

class TupleExtract : public SpecificExpression<Expression::TupleExtractId> {
public:
  TupleExtract(MixedArena& allocator) {}

  Expression* tuple;
  Index index;

    finalize = Method('', 'void')

class I31New : public SpecificExpression<Expression::I31NewId> {
public:
  I31New(MixedArena& allocator) {}

  Expression* value;

    finalize = Method('', 'void')

class I31Get : public SpecificExpression<Expression::I31GetId> {
public:
  I31Get(MixedArena& allocator) {}

  Expression* i31;
  bool signed_;

    finalize = Method('', 'void')

class RefTest : public SpecificExpression<Expression::RefTestId> {
public:
  RefTest(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): ref.test"); }

class RefCast : public SpecificExpression<Expression::RefCastId> {
public:
  RefCast(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): ref.cast"); }

class BrOnCast : public SpecificExpression<Expression::BrOnCastId> {
public:
  BrOnCast(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): br_on_cast"); }

class RttCanon : public SpecificExpression<Expression::RttCanonId> {
public:
  RttCanon(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): rtt.canon"); }

class RttSub : public SpecificExpression<Expression::RttSubId> {
public:
  RttSub(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): rtt.sub"); }

class StructNew : public SpecificExpression<Expression::StructNewId> {
public:
  StructNew(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): struct.new"); }

class StructGet : public SpecificExpression<Expression::StructGetId> {
public:
  StructGet(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): struct.get"); }

class StructSet : public SpecificExpression<Expression::StructSetId> {
public:
  StructSet(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): struct.set"); }

class ArrayNew : public SpecificExpression<Expression::ArrayNewId> {
public:
  ArrayNew(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): array.new"); }

class ArrayGet : public SpecificExpression<Expression::ArrayGetId> {
public:
  ArrayGet(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): array.get"); }

class ArraySet : public SpecificExpression<Expression::ArraySetId> {
public:
  ArraySet(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): array.set"); }

class ArrayLen : public SpecificExpression<Expression::ArrayLenId> {
public:
  ArrayLen(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): array.len"); }


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


def is_subclass_of(x, y):
    return getattr(x, '__bases__', None) == (y,)


def get_expressions():
    ret = []

    all_globals = dict(globals())

    for key in all_globals:
        value = all_globals[key]
        if is_subclass_of(value, Expression):
            ret.append(value)

    return ret


def join_nested_lines(lines):
  return '\n  '.join(lines)


def compact_text(text):
    while True:
        compacted = text.replace('\n  \n', '\n')
        if compacted == text:
            return text
        text = compacted


def generate_defs():
    #target = shared.in_binaryen('src', 'wasm-expressions.generated.h')
    #with open(target, 'w') as out:
    #    out.write(COPYRIGHT + '\n' + NOTICE)

    exprs = get_expressions()
    for expr in exprs:
        text = expr.render()
        print(text)
    1/0


def main():
    if sys.version_info.major != 3:
        import datetime
        print("It's " + str(datetime.datetime.now().year) + "! Use Python 3!")
        sys.exit(1)
    generate_defs()


if __name__ == "__main__":
    main()
