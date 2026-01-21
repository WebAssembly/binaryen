import itertools
from dataclasses import dataclass

# Workaround for python <3.10, escape characters can't appear in f-strings.
# Although we require 3.10 in some places, the formatter complains without this.
newline = "\n"

backslash = '\\'


def indent(s):
    return "\n".join(f"  {line}" if line else "" for line in s.split("\n"))


# skips None for convenience
def instruction(*args):
    return f"({' '.join(arg for arg in args if arg is not None)})"


def atomic_instruction(op, memid, immediate, /, *args, drop):
    if drop:
        return f"(drop {instruction(op, memid, immediate, *args)})"
    return instruction(op, memid, immediate, *args)


all_ops = [
    ("i32.atomic.load", "(i32.const 51)", True),
    ("i32.atomic.store", "(i32.const 51) (i32.const 51)", False),
]


def func(memid, immediate, ops=all_ops):
    return f'''(func ${immediate if immediate is not None else "no_immediate"}{"_with_memid" if memid is not None else "_without_memid"}
{indent(newline.join(atomic_instruction(op, memid, immediate, arg, drop=should_drop) for op, arg, should_drop in ops))}
)'''


def module(*statements):
    return f'''(module
{newline.join(map(indent, statements))}
)'''


def module_binary(bin):
    return f'''(module binary "{''.join(f'{backslash}{byte:02x}' for byte in bin)}")'''


def assert_invalid(module, reason):
    return f'''(assert_invalid {module} "{reason}")'''


def text_test():
    # Declare two memories so we have control over whether the memory immediate is printed
    # A memory immediate of 0 is allowed to be omitted.
    return module(
        "(memory 1 1 shared)",
        "(memory 1 1 shared)",
        "",
        "\n\n".join([f'{func(memid, ordering)}' for memid in [None, "1"] for ordering in [None, "acqrel", "seqcst"]]))


def to_unsigned_leb(num):
    ret = bytearray()

    if num == 0:
        ret = bytearray()
        ret.append(0)
        return ret
    ret = bytearray()
    while num > 0:
        rem = num >> 7
        ret.append((num & 0x7F) | (bool(rem) << 7))

        num = rem
    return ret


def bin_to_str(bin):
    return ''.join(f'{backslash}{byte:02x}' for byte in bin)


@dataclass
class statement:
    bin: bytes
    text: str


@dataclass
class function:
    body: [statement]
    memidx: bytes
    ordering: bytes


def normalize_spaces(s):
    return " ".join(s.split())


def binary_line(bin):
    return f'"{bin_to_str(bin)}"\n'


def binary_test_example():
    return r'''(module binary
  "\00asm\01\00\00\00" ;; header + version
  "\01\05\01\60\00\01\7f\03\02\01\00\05\05\01\03\17\80\02" ;; other sections
  "\0a\0c\01" ;; code section
    "\0a\00" ;; func size + decl count
    "\41\33" ;; i32.const 51
    "\fe\10" ;; i32.atomic.load
    "\62" ;; 2 | (1<<5) | (1<<6):  Alignment of 2 (32-bit load), with bit 5 set indicating that the next byte is a memory ordering
    "\00" ;; memory index
    "\01" ;; acqrel ordering
    "\00" ;; offset
    "\0b" ;; end
)'''


def binary_tests():

    func_statements = [
        [b"\x41\x33\xfe\x10%(align)s%(memidx)s%(ordering)s\x00\x1a", "(drop (i32.atomic.load %(memidx)s %(ordering)s (i32.const 51)))"],
        # TODO 0b ends the function
        [b"\x41\x33\x41\x33\xfe\x17%(align)s%(memidx)s%(ordering)s\x00", "(i32.atomic.store %(memidx)s %(ordering)s (i32.const 51) (i32.const 51))"],
    ]

    # Each function ends with 0x0b. Add it to the last statement for simplicity.
    func_statements[-1][0] += b'\x0b'

    funcs: [function] = []
    for memidx, ordering in itertools.product([b'', b'\x01'], [b'', b'\x00', b'\x01']):
        func = function([], memidx, ordering)
        for bin_statement, str_statement in func_statements:
            align = 2 | (bool(memidx) << 5) | (bool(ordering) << 6)
            s = statement(
                bin=bin_statement % {b'align': int.to_bytes(align), b'ordering': ordering, b'memidx': memidx},
                text=normalize_spaces(str_statement % {'ordering': ["seqcst", "acqrel"][ordering[0]] if ordering else '', 'memidx': "1" if memidx else ""}))

            func.body.append(s)
        funcs.append(func)

    # +1 for each function since we didn't count the local count byte yet, and +1 overall for the function count
    section_size = sum(len(statement.bin) + 1 for func in funcs for statement in func.body) + 1
    code_section = bytearray(b"\x0a") + to_unsigned_leb(section_size) + to_unsigned_leb(len(funcs))

    '''(module
        (memory 1 1 shared)
        (memory 1 1 shared)
       )
    '''
    module = b"\x00\x61\x73\x6d\x01\x00\x00\x00\x01\x04\01\x60\x00\x00\x03\x07\06\x00\x00\x00\x00\x00\x00\x05\07\x02\x03\x01\x01\x03\x01\x01"

    str_builder = [binary_line(module), f'"{bin_to_str(code_section)}" ;; code section\n']

    for func in funcs:
        bin_size = sum(len(statement.bin) for statement in func.body)
        # body size plus 1 byte for the number of locals (0)
        func_bytes = to_unsigned_leb(bin_size + 1)
        # number of locals, none in our case
        func_bytes.append(0x00)
        str_builder.append(f'"{bin_to_str(func_bytes)}" ;; func\n')
        for stmt in func.body:
            str_builder.append(f'"{bin_to_str(stmt.bin)}" ;; {stmt.text}\n')

    return f"(module binary\n{indent(''.join(str_builder))})"


def failing_test(instruction, arg, /, memidx, drop):
    """Module assertion that sets a memory ordering immediate for a non-atomic instruction"""

    func = f"(func ${''.join(filter(str.isalnum, instruction))} {atomic_instruction(instruction, memidx, 'acqrel', arg, drop=drop)})"
    return assert_invalid(module("(memory 1 1 shared)", "", func), f"Can't set memory ordering for non-atomic {instruction}")


def drop_atomic(instruction):
    first, atomic, last = instruction.partition(".atomic")
    return first + last


def failing_tests():
    op, arg, should_drop = all_ops[0]
    op = drop_atomic(op)

    return failing_test(op, arg, memidx=None, drop=should_drop)


def main():
    print(text_test())
    print()
    print(binary_test_example())
    print()
    print(binary_tests())
    print()
    print(failing_tests())
    print()


if __name__ == "__main__":
    main()
