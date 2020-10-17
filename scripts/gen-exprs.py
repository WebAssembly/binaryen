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

import datetime
import os
import subprocess
import sys

import test.shared as shared


# Support definitions

class ExpressionChild: pass

class Field(ExpressionChild):
    type_name = None
    allocator = False

    def __init__(self, init=None):
        self.init = init

    def render(self, name):
        type_name = self.type_name or self.__class__.__name__
        value = f' = {self.init}' if self.init else ''
        return f'{type_name} {name}{value};'

class Name(Field):
    pass

class Bool(Field):
    type_name = 'bool'

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

class AtomicRMWOp(Field):
    pass

class SIMDExtractOp(Field):
    pass

class SIMDReplaceOp(Field):
    pass

class SIMDShuffleMask(Field):
    type_name = 'std::array<uint8_t, 16>'

class SIMDTernaryOp(Field):
    pass

class SIMDShiftOp(Field):
    pass

class SIMDLoadOp(Field):
    pass

class Literal(Field):
    pass

class UnaryOp(Field):
    pass

class BinaryOp(Field):
    pass

class ArenaVector(Field):
    allocator = True

    def __init__(self, of, *kwargs):
        self.type_name = f'ArenaVector<{of}>'
        super(ArenaVector, self).__init__(*kwargs)

class Child(Field):
    type_name = 'Expression*'

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

    default_finalize = Method('', 'void')

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
        name = self.__name__
        fields = self.get_fields()
        rendered_fields = [field.render(key) for key, field in fields.items()]
        fields_text = join_nested_lines(rendered_fields)
        methods = self.get_methods()
        # render a default finalize if none has been specified
        if 'finalize' not in methods:
            methods['finalize'] = self.default_finalize
        rendered_methods = [method.render(key) for key, method in methods.items()]
        methods_text = join_nested_lines(rendered_methods)
        constructor_body = self.__constructor_body__
        if constructor_body:
            constructor_body = ' ' + constructor_body + ' '

        # if one of the fields allocates, then we can only emit one constructor,
        # that uses the MixedArena. otherwise we emit one without as well (and
        # the one with the MixedArena doesn't use it)
        has_allocator = False
        for field in fields.values():
            if field.allocator:
                has_allocator = True
        if not has_allocator:
            constructors = [
                '%(name)s() {%(constructor_body)s}' % locals(),
                '%(name)s(MixedArena& allocator) : %(name)s() {}' % locals()
            ]
        else:
            field_constructors = []
            for key, field in fields.items():
                if field.allocator:
                    field_constructors.append(f'{key}(allocator)')
            field_constructors_text = ', '.join(field_constructors)
            constructors = [
                '%(name)s(MixedArena& allocator) : %(field_constructors_text)s {%(constructor_body)s}' % locals()
            ]
        constructors_text = join_nested_lines(constructors)

        text = '''\
class %(name)s : public SpecificExpression<Expression::%(name)sId> {
public:
  %(constructors_text)s
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

class Switch(Expression):
    __constructor_body__ = 'type = Type::unreachable;'

    targets = ArenaVector('Name')
    default_ = Name()
    condition = Child()
    value = Child(init='nullptr')

class Call(Expression):
    operands = ExpressionList()
    target = Name()
    isReturn = Bool(init='false');

class CallIndirect(Expression):
    sig = Signature()
    operands = ExpressionList()
    target = Child()
    isReturn = Bool(init='false');

class LocalGet(Expression):
    index = Index()

class LocalSet(Expression):
    index = Index()
    value = Child()

    isTee = Method('', 'bool', const=True)
    makeTee = Method('Type type', 'void');
    makeSet = Method('', 'void');

class GlobalGet(Expression):
    name = Name()

class GlobalSet(Expression):
    name = Name()
    value = Child()

class Load(Expression):
    bytes = uint8_t()
    signed_ = Bool()
    offset = Address()
    align = Address()
    isAtomic = Bool()
    ptr = Child()

    # type must be set during creation, cannot be inferred

class Store(Expression):
    bytes = uint8_t()
    offset = Address()
    align = Address()
    isAtomic = Bool()
    ptr = Child()
    value = Child()
    valueType = Type()

class AtomicRMW(Expression):
    op = AtomicRMWOp()
    bytes = uint8_t()
    offset = Address()
    ptr = Child()
    value = Child()

class AtomicCmpxchg(Expression):
    bytes = uint8_t()
    offset = Address()
    ptr = Child()
    expected = Child()
    replacement = Child()

class AtomicWait(Expression):
    offset = Address()
    ptr = Child()
    expected = Child()
    timeout = Child()
    expectedType = Type()

class AtomicNotify(Expression):
    offset = Address()
    ptr = Child()
    notifyCount = Child()

class AtomicFence(Expression):
    '''
    Current wasm threads only supports sequentialy consistent atomics, but
    other orderings may be added in the future. This field is reserved for
    that, and currently set to 0.
    '''
    order = uint8_t()

class SIMDExtract(Expression):
    op = SIMDExtractOp()
    vec = Child()
    index = uint8_t()

class SIMDReplace(Expression):
    op = SIMDReplaceOp()
    vec = Child()
    index = uint8_t()
    value = Child()

class SIMDShuffle(Expression):
    left = Child()
    right = Child()
    mask = SIMDShuffleMask()
 

class SIMDTernary(Expression):
    op = SIMDTernaryOp()
    a = Child()
    b = Child()
    c = Child()

class SIMDShift(Expression):
    op = SIMDShiftOp()
    vec = Child()
    shift = Child()

class SIMDLoad(Expression):
    op = SIMDLoadOp()
    offset = Address()
    align = Address()
    ptr = Child()

    getMemBytes = Method('', 'Index');

class MemoryInit(Expression):
    segment = Index()
    dest = Child()
    offset = Child()
    size = Child()

class DataDrop(Expression):
    segment = Index()

class MemoryCopy(Expression):
    dest = Child()
    source = Child()
    size = Child()

class MemoryFill(Expression):
    dest = Child()
    value = Child()
    size = Child()

class Const(Expression):
    value = Literal()

    set = Method('Literal value_', 'Const*');

class Unary(Expression):
    op = UnaryOp()
    value = Child()

    isRelational = Method('', 'bool')

class Binary(Expression):
    op = BinaryOp()
    left = Child()
    right = Child()

    '''
    the type is always the type of the operands,
    except for relationals
    '''
    isRelational = Method('', 'bool')

class Select(Expression):
    ifTrue = Child()
    ifFalse = Child()
    condition = Child()

    finalize = Method(('', 'Type type_'), 'void')

class Drop(Expression):
    value = Child()

class Return(Expression):
    __constructor_body__ = 'type = Type::unreachable;'

    value = Child(init='nullptr')

class MemorySize(Expression):
    __constructor_body__ = 'type = Type::i32;'

    ptrType = Type(init='Type::i32')

    make64 = Method('', 'void');

class MemoryGrow(Expression):
    delta = Child(init='nullptr')
    ptrType = Type(init='Type::i32')

    make64 = Method('', 'void');

class Unreachable(Expression):
    __constructor_body__ = 'type = Type::unreachable;'

'''
Represents a pop of a value that arrives as an implicit argument to the
current block. Currently used in exception handling.
'''
class Pop(Expression):
    pass

class RefNull(Expression):
    finalize = Method(('', 'HeapType heapType', 'Type type'), 'void')

class RefIsNull(Expression):
    value = Child()

class RefFunc(Expression):
    func = Name()

class RefEq(Expression):
    left = Child()
    right = Child()

class Try(Expression):
    body = Child()
    catchBody = Child()

    finalize = Method(('', 'Type type_'), 'void')

class Throw(Expression):
    event = Name()
    operands = ExpressionList()

class Rethrow(Expression):
    exnref = Child()

class BrOnExn(Expression):
    __constructor_body__ = 'type = Type::unreachable;'

    name = Name()
    event = Name()
    exnref = Child()
    '''
    This is duplicate info of param types stored in Event, but this is required
    for us to know the type of the value sent to the target block.
    '''
    sent = Type()

class TupleMake(Expression):
    operands = ExpressionList()

class TupleExtract(Expression):
    tuple = Child()
    index = Index()

class I31New(Expression):
    value = Child()

class I31Get(Expression):
    i31 = Child()
    signed_ = Bool()

class RefTest(Expression):
    pass

class RefCast(Expression):
    pass

class BrOnCast(Expression):
    pass

class RttCanon(Expression):
    pass

class RttSub(Expression):
    pass

class StructNew(Expression):
    pass

class StructGet(Expression):
    pass

class StructSet(Expression):
    pass

class ArrayNew(Expression):
    pass

class ArrayGet(Expression):
    pass

class ArraySet(Expression):
    pass

class ArrayLen(Expression):
    pass


# Boilerplate


COPYRIGHT = f'''\
/*
 * Copyright {datetime.datetime.now().year} WebAssembly Community Group participants
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
// This is an AUTOGENERATED file, even though it looks human-readable! Do not
// edit it by hand, instead edit what it is generated from. You can and should
// treat it like human-written code in all other ways, though, like reviewing
// it in a PR, etc.
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


def clang_format(text):
    read, write = os.pipe()
    os.write(write, bytes(text, 'ascii'))
    os.close(write)
    return subprocess.check_output(['clang-format'], stdin=read, universal_newlines=True)


def write_if_changed(text, target, what):
    # only write the file if something changed, so that we don't cause any
    # unnecessary build system rebuilding
    with open(target) as f:
        existing = f.read()

    if text != existing:
        with open(target, 'w') as f:
            print(f'writing updated {what}')
            f.write(text)
    else:
        print(f'{what} did not change')

def generate_defs():
    target = shared.in_binaryen('src', 'wasm-expressions.generated.h')
    rendered = COPYRIGHT + '\n' + NOTICE
    exprs = get_expressions()
    for expr in exprs:
        rendered += expr.render()
    rendered = clang_format(rendered)
    write_if_changed(rendered, target, 'expression definitions')


def main():
    if sys.version_info.major != 3:
        import datetime
        print("It's " + str(datetime.datetime.now().year) + "! Use Python 3!")
        sys.exit(1)
    generate_defs()


if __name__ == "__main__":
    main()
