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

"""
Define wasm expressions, and autogenerate code for them.

The goal is to define expression structure in a single place, and emit all the
necessary boilerplate code using this tool, instead of doing so manually. This
can avoid unnecessary work, reduce the chance for bugs, and also allows us to
emit code that runs faster.

In theory templates, macros, or some other method could be used in the
language itself. However, we want more power than those things allow.

This emits partially-formatted code, and runs clang-format to polish it.

The output files are all in the source tree, with ".generated." in their name.

The CMake build system in Binaryen will always run this tool when building, but
it is pretty fast, and it will not write to the output files if it has no actual
changes to make (so the timestamps will not be misleading).

If you are adding a new expression class to Binaryen, you probably need to just
add to the "Specific expression definitions" section below.
"""

import datetime
import os
import subprocess

import test.shared as shared


#######################
# Support definitions
#######################


class ExpressionChild:
    """Something that resides on an Expression."""


class Field(ExpressionChild):
    """A field on an expression, such as an immediate or a child subexpression.

    These are rendered using the class name as the type, in most cases,
    allowing you to just define a class and use it.
    """

    # A possible override for the name. This is necessary if the name is not a
    # valid Python name, for example.
    type_name = None

    # Whether this needs to receive an allocator in its constructor, which is
    # the case for fields that allocate (like arrays).
    allocator = False

    def __init__(self, init=None, relevant_if=None):
        # An initial value.
        self.init = init

        # If set, a function to call to check if this property is in use (for
        # example, a load's sign does not matter if it is a floating-point
        # operation).
        self.relevant_if = relevant_if


class Name(Field):
    """A string name. Interned in Binaryen, so very efficient.

    For a scope name, see ScopeNameDef and ScopeNameUse.
    """


class ScopeNameDef(Field):
    """A string name that defines a new scope (like in a Block or Loop)."""

    type_name = 'Name'


class ScopeNameUse(Field):
    """A string name that refers to a scope (like in a Break)."""

    type_name = 'Name'


class ScopeNameUseVector(Field):
    """A vector of ScopeNameUses."""

    type_name = 'ArenaVector<Name>'

    allocator = True


class Bool(Field):
    """A boolean."""

    type_name = 'bool'


class Signature(Field):
    """A function signature consisting of input and output types."""


class Index(Field):
    """A number representing an index (e.g. function) in the wasm file."""


class Address(Field):
    """A number representing an address or an offset in linear memory."""


class Type(Field):
    """An IR type."""


class uint8_t(Field):
    """A uint_8 immediate."""


class Literal(Field):
    """A constant literal value."""


class UnaryOp(Field):
    """A unary opcode."""


class BinaryOp(Field):
    """A binary opcode."""


class Child(Field):
    """A child expression."""

    type_name = 'Expression*'


class ChildList(Field):
    """A list of child expressions."""

    type_name = 'ExpressionList'

    allocator = True


class AtomicRMWOp(Field):
    """An atomic RMW opcode."""


class SIMDExtractOp(Field):
    """A SIMD Extract opcode."""


class SIMDReplaceOp(Field):
    """A SIMD Replace opcode."""


class SIMDShuffleMask(Field):
    """An SIMD shuffle mask."""

    type_name = 'std::array<uint8_t, 16>'


class SIMDTernaryOp(Field):
    """A SIMD ternary opcode."""


class SIMDShiftOp(Field):
    """A SIMD shift opcode."""


class SIMDLoadOp(Field):
    """A SIMD load opcode."""


class Expression:
    """Core class from which all expressions inherit."""

    # Optional content to place in the constructor body.
    __constructor_body__ = ''

    @classmethod
    def get_fields(self):
        """Get a map of field name => field."""
        fields = {}
        for key, value in self.__dict__.items():
            if is_subclass_of(value.__class__, Field):
                fields[key] = value
        return fields

    @classmethod
    def get_methods(self):
        """Get a map of method name => method."""
        return getattr(self, 'methods', [])


###################################
# Specific expression definitions
###################################


class Nop(Expression):
    pass


class Block(Expression):
    name = ScopeNameDef()
    list = ChildList()

    """
    finalize has three overloads:

    void ();

    set the type purely based on its contents. this scans the block, so it is
    not fast.

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
    """
    methods = [
        'void finalize();',
        'void finalize(Type type_);',
        'void finalize(Type type_, bool hasBreak);',
    ]


class If(Expression):
    condition = Child()
    ifTrue = Child()
    ifFalse = Child(init='nullptr')

    """
    finalize has two overloads:

    void ();

    set the type purely based on its contents.

    void finalize(Type type_);

    set the type given you know its type, which is the case when parsing
    s-expression or binary, as explicit types are given. the only additional
    work this does is to set the type to unreachable in the cases that is
    needed.
    """
    methods = [
        'void finalize();',
        'void finalize(Type type_);',
    ]


class Loop(Expression):
    name = ScopeNameDef()
    body = Child()

    """
    Similar to If, see above.
    """
    methods = [
        'void finalize();',
        'void finalize(Type type_);',
    ]


class Break(Expression):
    __constructor_body__ = 'type = Type::unreachable;'

    name = ScopeNameUse()
    value = Child(init='nullptr')
    condition = Child(init='nullptr')


class Switch(Expression):
    __constructor_body__ = 'type = Type::unreachable;'

    targets = ScopeNameUseVector()
    default_ = ScopeNameUse()
    condition = Child()
    value = Child(init='nullptr')


class Call(Expression):
    operands = ChildList()
    target = Name()
    isReturn = Bool(init='false')


class CallIndirect(Expression):
    sig = Signature()
    operands = ChildList()
    target = Child()
    isReturn = Bool(init='false')


class LocalGet(Expression):
    index = Index()


class LocalSet(Expression):
    index = Index()
    value = Child()

    methods = [
        'bool isTee() const;',
        'void makeTee(Type type);',
        'void makeSet();',
    ]


class GlobalGet(Expression):
    name = Name()


class GlobalSet(Expression):
    name = Name()
    value = Child()


class Load(Expression):
    """
    Note: the type must be set during creation, it cannot be inferred from the
    immediates.
    """

    bytes = uint8_t()
    signed_ = Bool(relevant_if='LoadUtils::isSignRelevant')
    offset = Address()
    align = Address()
    isAtomic = Bool()
    ptr = Child()


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
    """
    Current wasm threads only supports sequentialy consistent atomics, but
    other orderings may be added in the future. This field is reserved for
    that, and currently set to 0.
    """
    order = uint8_t(init='0')


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

    methods = ['Index getMemBytes();']


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

    methods = ['Const* set(Literal value_);']


class Unary(Expression):
    op = UnaryOp()
    value = Child()

    methods = ['bool isRelational();']


class Binary(Expression):
    op = BinaryOp()
    left = Child()
    right = Child()

    """
    The type is always the type of the operands, except for relational
    operations, which return an i32.
    """
    methods = ['bool isRelational();']


class Select(Expression):
    ifTrue = Child()
    ifFalse = Child()
    condition = Child()

    methods = [
        'void finalize();',
        'void finalize(Type type_);',
    ]


class Drop(Expression):
    value = Child()


class Return(Expression):
    __constructor_body__ = 'type = Type::unreachable;'

    value = Child(init='nullptr')


class MemorySize(Expression):
    __constructor_body__ = 'type = Type::i32;'

    ptrType = Type(init='Type::i32')

    methods = ['void make64();']


class MemoryGrow(Expression):
    delta = Child(init='nullptr')
    ptrType = Type(init='Type::i32')

    methods = ['void make64();']


class Unreachable(Expression):
    __constructor_body__ = 'type = Type::unreachable;'


class Pop(Expression):
    """
    Represents a pop of a value that arrives as an implicit argument to the
    current block. Currently used in exception handling.
    """


class RefNull(Expression):
    methods = [
        'void finalize();',
        'void finalize(HeapType heapType);',
        'void finalize(Type type);',
    ]


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

    methods = [
        'void finalize();',
        'void finalize(Type type_);',
    ]


class Throw(Expression):
    event = Name()
    operands = ChildList()


class Rethrow(Expression):
    exnref = Child()


class BrOnExn(Expression):
    __constructor_body__ = 'type = Type::unreachable;'

    name = ScopeNameUse()
    event = Name()
    exnref = Child()

    """
    This is duplicate info of param types stored in Event, but this is required
    for us to know the type of the value sent to the target block.
    """
    sent = Type()


class TupleMake(Expression):
    operands = ChildList()


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


###############
# Boilerplate
###############


COPYRIGHT = f"""\
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
"""

NOTICE = f"""\
//=============================================================================
// This is an AUTOGENERATED file, even though it looks human-readable! Do not
// edit it by hand, instead edit the generator, {os.path.basename(__file__)}
//
// You can and should treat it like human-written code in all other ways,
// though, like reviewing it in a PR, etc.
//=============================================================================
"""

BOILERPLATE = COPYRIGHT + '\n' + NOTICE


##############
# Processing
##############


def is_subclass_of(x, y):
    """Whether x is a subclass of y."""

    return y in getattr(x, '__bases__', {})


def is_instance(x, cls):
    """Whether x is an instance of cls."""

    return x.__class__ == cls


def get_expressions():
    """Get all the expression classes defined in this file."""

    ret = []

    all_globals = dict(globals())

    for key in all_globals:
        value = all_globals[key]
        if is_subclass_of(value, Expression):
            ret.append(value)

    return ret


def join_nested_lines(lines):
    """Join some lines with the default nesting indentation."""

    return '\n  '.join(lines)


def compact_text(text):
    """Remove unnecessary whitespace noise."""

    while True:
        compacted = text.replace('\n  \n', '\n')
        if compacted == text:
            return text
        text = compacted


clang_format_exe = shared.which('clang-format-9') or shared.which('clang-format')


def clang_format(text):
    read, write = os.pipe()
    os.write(write, bytes(text, 'ascii'))
    os.close(write)
    return subprocess.check_output([clang_format_exe], stdin=read, universal_newlines=True)


def write_result(text, target, what):
    """Add boilerplate and emit the result, if it changed or didn't exist."""

    text = BOILERPLATE + '\n' + text
    text = clang_format(text)

    # only write the file if something changed, so that we don't cause any
    # unnecessary build system rebuilding
    existing = None
    if os.path.exists(target):
        with open(target) as f:
            existing = f.read()

    if text != existing:
        with open(target, 'w') as f:
            print(f'[gen-exprs] writing updated {what}')
            f.write(text)
    else:
        print(f'[gen-exprs] {what} did not change')


#############
# Renderers
#############


class ExpressionDefinitionRenderer:
    """Renders the header definition of an expression."""

    def render_field(self, name, field):
        type_name = field.type_name or field.__class__.__name__
        value = f' = {field.init}' if field.init else ''
        return f'{type_name} {name}{value};'

    def render(self, cls):
        name = cls.__name__

        # Render the fields.
        fields = cls.get_fields()
        rendered_fields = [self.render_field(key, field) for key, field in fields.items()]
        fields_text = join_nested_lines(rendered_fields)

        # Render the methods.
        methods = cls.get_methods()
        # render a default finalize if none has been specified
        default_finalize = 'void finalize();'
        if default_finalize not in methods:
            methods.append(default_finalize)
        methods_text = join_nested_lines(methods)

        # Render the constructor(s).
        constructor_body = cls.__constructor_body__
        if constructor_body:
            constructor_body = ' ' + constructor_body + ' '
        # If one of the fields allocates, then we can only emit one constructor,
        # that uses the MixedArena. Otherwise we emit one without as well (and
        # the one with the MixedArena doesn't use it).
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

        # Combine it all to emit the final rendered definition.
        text = """\
class %(name)s : public SpecificExpression<Expression::%(name)sId> {
public:
  %(constructors_text)s
  %(fields_text)s
  %(methods_text)s
};
""" % locals()
        text = compact_text(text)
        return text


class ExpressionComparisonRenderer:
    """Renders code to compare expressions."""

    def render(self, cls):
        name = cls.__name__
        operations = []

        # Compare the fields.
        fields = cls.get_fields()
        for key, field in fields.items():
            if is_instance(field, Child):
                # Push the children to be checked later. Note that it is ok to
                # do this even if they are null (valid for an optional child,
                # like a Return's value), as the main logic will check that.
                # TODO: would a check for null here be faster, avoiding even
                #       pushing such children?
                operations.append(f'leftStack.push_back(castLeft->{key});')
                operations.append(f'rightStack.push_back(castRight->{key});')
            elif is_instance(field, ChildList):
                operations.append('if (castLeft->%(key)s.size() != castRight->%(key)s.size()) { return false; }' % locals())
                operations.append('for (auto* child : castLeft->%(key)s) { leftStack.push_back(child); }' % locals())
                operations.append('for (auto* child : castRight->%(key)s) { rightStack.push_back(child); }' % locals())
            elif is_instance(field, ScopeNameDef):
                # Blocks and Loops define names, so mark the names as equal
                # on both sides.
                operations.append('if (castLeft->%(key)s.is() != castRight->%(key)s.is()) { return false; }' % locals())
                operations.append(f'rightNames[castLeft->{key}] = castRight->{key};')
            elif is_instance(field, ScopeNameUse):
                operations.append('if (!compareNames(castLeft->%(key)s, castRight->%(key)s)) { return false; }' % locals())
            elif is_instance(field, ScopeNameUseVector):
                operations.append('''\
if (castLeft->%(key)s.size() != castRight->%(key)s.size()) {
  return false;
}
for (Index i = 0; i < castLeft->%(key)s.size(); i++) {
  if (!compareNames(castLeft->%(key)s[i], castRight->%(key)s[i])) {
    return false;
  }
}''' % locals())
            else:
                check = 'if (castLeft->%(key)s != castRight->%(key)s) { return false; }' % locals()
                if field.relevant_if:
                    relevant_if = field.relevant_if
                    check = 'if (%(relevant_if)s(castLeft)) { %(check)s }' % locals()
                operations.append(check)

        if len(operations) > 0:
            operations = [
                f'auto* castLeft = left->cast<{name}>();',
                f'auto* castRight = right->cast<{name}>();'
            ] + operations

        operations_text = join_nested_lines(operations)

        # Combine it all to emit the final rendered code.
        text = """\
case Expression::%(name)sId: {
  %(operations_text)s
  break;
}
""" % locals()
        text = compact_text(text)
        return text


########
# Main
########


def generate_expression_definitions():
    target = shared.in_binaryen('src', 'wasm-expressions.generated.h')
    rendered = ''
    for expr in get_expressions():
        rendered += ExpressionDefinitionRenderer().render(expr)
    write_result(rendered, target, 'expression definitions')


def generate_comparisons():
    target = shared.in_binaryen('src', 'ir', 'compare-expressions.generated.h')
    rendered = ''
    for expr in get_expressions():
        rendered += ExpressionComparisonRenderer().render(expr)
    write_result(rendered, target, 'expression comparisons')


def main():
    generate_expression_definitions()
    generate_comparisons()


if __name__ == "__main__":
    main()
