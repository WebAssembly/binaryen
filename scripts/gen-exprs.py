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
    allocator = False

    def __init__(self, init=None):
        self.init = init

    def render(self, name):
        typename = self.__class__.__name__
        if hasattr(self, 'typename'):
            typename = self.typename
        value = f' = {self.init}' if self.init else ''
        return f'{typename} {name}{value};'

class Name(Field):
    pass

class Bool(Field):
    pass

class Signature(Field):
    pass

class Index(Field):
    pass

class Address(Field):
    pass

class Type(Field):
    pass

class ExpressionList(Field):
    allocator = True

class uint8_t(Field):
    pass

class ArenaVector(Field):
    allocator = True

    def __init__(self, of):
        self.of = of

    def render(self, name):
        return f'ArenaVector<{self.of}> {name};'

class Child(Field):
    typename = 'Expression*'

class Method:
    def __init__(self, paramses, result, const=False):
        self.paramses = paramses
        if type(self.paramses) is str:
            self.paramses = [self.paramses]
        self.result = result
        self.const = const

    def render(self, name):
        extra = ''
        if self.const:
            extra += ' const'
        ret = [f'{self.result} {name}({params}){extra};' for params in self.paramses]
        return join_nested_lines(ret)

class Expression:
    __constructor_body__ = ''

    @classmethod
    def get_fields(self):
        fields = {}
        for key, value in self.__dict__.items():
            if is_subclass_of(value.__class__, Field):
                fields[key] = value
        return fields

    @classmethod
    def get_methods(self):
        methods = {}
        for key, value in self.__dict__.items():
            if value.__class__ == Method:
                methods[key] = value
        return methods

    @classmethod
    def render(self):
        fields = self.get_fields()
        rendered_fields = [field.render(key) for key, field in fields.items()]
        fields_text = join_nested_lines(rendered_fields)
        methods = self.get_methods()
        rendered_methods = [method.render(key) for key, method in methods.items()]
        methods_text = join_nested_lines(rendered_methods)
        constructor_body = self.__constructor_body__
        if constructor_body:
            constructor_body = ' ' + constructor_body + ' '
        # call other constructors - of the non-allocator version, and also
        name = self.__name__
        sub_ctors = [name + '()']
        # fields that allocate need to receive the allocator as a parameter
        for key, field in fields.items():
            if field.allocator:
                sub_ctors.append(f'{key}(allocator)')
        sub_ctors_text = ', '.join(sub_ctors)
        text = '''\
class %(name)s : public SpecificExpression<Expression::%(name)sId> {
  %(name)s() {%(constructor_body)s}
  %(name)s(MixedArena& allocator) : %(sub_ctors_text)s {}
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

class Call(Expression):
    operands = ExpressionList()
    target = Name()
    isReturn = Bool(init='false');

    finalize = Method('', 'void')

class CallIndirect(Expression):
    sig = Signature()
    operands = ExpressionList()
    target = Child()
    isReturn = Bool(init='false');

    finalize = Method('', 'void')

class LocalGet(Expression):
    index = Index()

class LocalSet(Expression):
    index = Index()
    value = Child()

    finalize = Method('', 'void')
    isTee = Method('', 'bool', const=True)
    makeTee = Method('Type type', 'void');
    makeSet = Method('', 'void');

class GlobalGet(Expression):
    name = Name()

class GlobalSet(Expression):
    name = Name()
    value = Child()

    finalize = Method('', 'void')

class Load(Expression):
    bytes = uint8_t()
    signed_ = Bool()
    offset = Address()
    align = Address()
    isAtomic = Bool()
    ptr = Child();

    # type must be set during creation, cannot be inferred
    finalize = Method('', 'void')

class Store(Expression):
    bytes = uint8_t()
    offset = Address()
    align = Address()
    isAtomic = Bool()
    ptr = Child();
    value = Child()
    valueType = Type()

    finalize = Method('', 'void')

'''
class AtomicRMW(Expression):
  AtomicRMW() = default;
  AtomicRMW(MixedArena& allocator) : AtomicRMW() {}

  AtomicRMWOp op;
    bytes = uint8_t()
    offset = Address()
    ptr = Child();
    value = Child()

    finalize = Method('', 'void')

class AtomicCmpxchg(Expression):
  AtomicCmpxchg() = default;
  AtomicCmpxchg(MixedArena& allocator) : AtomicCmpxchg() {}

    bytes = uint8_t()
    offset = Address()
    ptr = Child();
  Expression* expected;
  Expression* replacement;

    finalize = Method('', 'void')

class AtomicWait(Expression):
  AtomicWait() = default;
  AtomicWait(MixedArena& allocator) : AtomicWait() {}

    offset = Address()
    ptr = Child();
  Expression* expected;
  Expression* timeout;
  Type expectedType;

    finalize = Method('', 'void')

class AtomicNotify(Expression):
  AtomicNotify() = default;
  AtomicNotify(MixedArena& allocator) : AtomicNotify() {}

    offset = Address()
    ptr = Child();
  Expression* notifyCount;

    finalize = Method('', 'void')

class AtomicFence(Expression):
  AtomicFence() = default;
  AtomicFence(MixedArena& allocator) : AtomicFence() {}

  Current wasm threads only supports sequentialy consistent atomics, but
  other orderings may be added in the future. This field is reserved for
  that, and currently set to 0.
  uint8_t order = 0;

    finalize = Method('', 'void')

class SIMDExtract(Expression):
  SIMDExtract() = default;
  SIMDExtract(MixedArena& allocator) : SIMDExtract() {}

  SIMDExtractOp op;
  Expression* vec;
  uint8_t index;

    finalize = Method('', 'void')

class SIMDReplace(Expression):
  SIMDReplace() = default;
  SIMDReplace(MixedArena& allocator) : SIMDReplace() {}

  SIMDReplaceOp op;
  Expression* vec;
  uint8_t index;
    value = Child()

    finalize = Method('', 'void')

class SIMDShuffle(Expression):
  SIMDShuffle() = default;
  SIMDShuffle(MixedArena& allocator) : SIMDShuffle() {}

  Expression* left;
  Expression* right;
  std::array<uint8_t, 16> mask;

    finalize = Method('', 'void')

class SIMDTernary(Expression):
  SIMDTernary() = default;
  SIMDTernary(MixedArena& allocator) : SIMDTernary() {}

  SIMDTernaryOp op;
  Expression* a;
  Expression* b;
  Expression* c;

    finalize = Method('', 'void')

class SIMDShift(Expression):
  SIMDShift() = default;
  SIMDShift(MixedArena& allocator) : SIMDShift() {}

  SIMDShiftOp op;
  Expression* vec;
  Expression* shift;

    finalize = Method('', 'void')

class SIMDLoad(Expression):
  SIMDLoad() = default;
  SIMDLoad(MixedArena& allocator) {}

  SIMDLoadOp op;
    offset = Address()
    align = Address()
    ptr = Child();

  Index getMemBytes();
    finalize = Method('', 'void')

class MemoryInit(Expression):
  MemoryInit() = default;
  MemoryInit(MixedArena& allocator) : MemoryInit() {}

  Index segment;
  Expression* dest;
  Expression* offset;
  Expression* size;

    finalize = Method('', 'void')

class DataDrop(Expression):
  DataDrop() = default;
  DataDrop(MixedArena& allocator) : DataDrop() {}

  Index segment;

    finalize = Method('', 'void')

class MemoryCopy(Expression):
  MemoryCopy() = default;
  MemoryCopy(MixedArena& allocator) : MemoryCopy() {}

  Expression* dest;
  Expression* source;
  Expression* size;

    finalize = Method('', 'void')

class MemoryFill(Expression):
  MemoryFill() = default;
  MemoryFill(MixedArena& allocator) : MemoryFill() {}

  Expression* dest;
    value = Child()
  Expression* size;

    finalize = Method('', 'void')

class Const(Expression):
  Const() = default;
  Const(MixedArena& allocator) {}

  Literal value;

  Const* set(Literal value_);

    finalize = Method('', 'void')

class Unary(Expression):
  Unary() = default;
  Unary(MixedArena& allocator) {}

  UnaryOp op;
    value = Child()

  bool isRelational();

    finalize = Method('', 'void')

class Binary(Expression):
  Binary() = default;
  Binary(MixedArena& allocator) {}

  BinaryOp op;
  Expression* left;
  Expression* right;

  the type is always the type of the operands,
  except for relationals

  bool isRelational();

    finalize = Method('', 'void')

class Select(Expression):
  Select() = default;
  Select(MixedArena& allocator) {}

  Expression* ifTrue;
  Expression* ifFalse;
  Expression* condition;

    finalize = Method('', 'void')
  void finalize(Type type_);

class Drop(Expression):
  Drop() = default;
  Drop(MixedArena& allocator) {}

    value = Child()

    finalize = Method('', 'void')

class Return(Expression):
  Return() { type = Type::unreachable; }
  Return(MixedArena& allocator) : Return() {}

  Expression* value = nullptr;

class MemorySize(Expression):
  MemorySize() { type = Type::i32; }
  MemorySize(MixedArena& allocator) : MemorySize() {}

  Type ptrType = Type::i32;

  void make64();
    finalize = Method('', 'void')

class MemoryGrow(Expression):
  MemoryGrow() { type = Type::i32; }
  MemoryGrow(MixedArena& allocator) : MemoryGrow() {}

  Expression* delta = nullptr;
  Type ptrType = Type::i32;

  void make64();
    finalize = Method('', 'void')

class Unreachable(Expression):
  Unreachable() { type = Type::unreachable; }
  Unreachable(MixedArena& allocator) : Unreachable() {}

Represents a pop of a value that arrives as an implicit argument to the
current block. Currently used in exception handling.
class Pop(Expression):
  Pop() = default;
  Pop(MixedArena& allocator) {}

class RefNull(Expression):
  RefNull() = default;
  RefNull(MixedArena& allocator) {}

    finalize = Method('', 'void')
  void finalize(HeapType heapType);
  void finalize(Type type);

class RefIsNull(Expression):
  RefIsNull(MixedArena& allocator) {}

    value = Child()

    finalize = Method('', 'void')

class RefFunc(Expression):
  RefFunc(MixedArena& allocator) {}

  Name func;

    finalize = Method('', 'void')

class RefEq(Expression):
  RefEq(MixedArena& allocator) {}

  Expression* left;
  Expression* right;

    finalize = Method('', 'void')

class Try(Expression):
  Try(MixedArena& allocator) {}

  Expression* body;
  Expression* catchBody;

    finalize = Method('', 'void')
  void finalize(Type type_);

class Throw(Expression):
  Throw(MixedArena& allocator) : operands(allocator) {}

  Name event;
    operands = ExpressionList()

    finalize = Method('', 'void')

class Rethrow(Expression):
  Rethrow(MixedArena& allocator) {}

  Expression* exnref;

    finalize = Method('', 'void')

class BrOnExn(Expression):
  BrOnExn() { type = Type::unreachable; }
  BrOnExn(MixedArena& allocator) : BrOnExn() {}

    name = Name()
  Name event;
  Expression* exnref;
  This is duplicate info of param types stored in Event, but this is required
  for us to know the type of the value sent to the target block.
  Type sent;

    finalize = Method('', 'void')

class TupleMake(Expression):
  TupleMake(MixedArena& allocator) : operands(allocator) {}

    operands = ExpressionList()

    finalize = Method('', 'void')

class TupleExtract(Expression):
  TupleExtract(MixedArena& allocator) {}

  Expression* tuple;
    index = Index()

    finalize = Method('', 'void')

class I31New(Expression):
  I31New(MixedArena& allocator) {}

    value = Child()

    finalize = Method('', 'void')

class I31Get(Expression):
  I31Get(MixedArena& allocator) {}

  Expression* i31;
    signed_ = Bool()

    finalize = Method('', 'void')

class RefTest(Expression):
  RefTest(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): ref.test"); }

class RefCast(Expression):
  RefCast(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): ref.cast"); }

class BrOnCast(Expression):
  BrOnCast(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): br_on_cast"); }

class RttCanon(Expression):
  RttCanon(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): rtt.canon"); }

class RttSub(Expression):
  RttSub(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): rtt.sub"); }

class StructNew(Expression):
  StructNew(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): struct.new"); }

class StructGet(Expression):
  StructGet(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): struct.get"); }

class StructSet(Expression):
  StructSet(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): struct.set"); }

class ArrayNew(Expression):
  ArrayNew(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): array.new"); }

class ArrayGet(Expression):
  ArrayGet(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): array.get"); }

class ArraySet(Expression):
  ArraySet(MixedArena& allocator) {}

  void finalize() { WASM_UNREACHABLE("TODO (gc): array.set"); }

class ArrayLen(Expression):
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
