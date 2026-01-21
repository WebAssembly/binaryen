import itertools
from dataclasses import astuple, dataclass

# Workaround for python <3.10, escape characters can't appear in f-strings.
# Although we require 3.10 in some places, the formatter complains without this.
newline = "\n"

backslash = '\\'


@dataclass
class instruction_test:
    op: str
    arg: str
    should_drop: bool
    bin: bytes


ALL_OPS = [
    instruction_test("i32.atomic.load", "(i32.const 51)", True, b"\x41\x33\xfe\x10%(align)s%(memidx)s%(ordering)s\x00\x1a"),
    instruction_test("i32.atomic.store", "(i32.const 51) (i32.const 51)", False, b"\x41\x33\x41\x33\xfe\x17%(align)s%(memidx)s%(ordering)s\x00"),
]


def indent(s):
    return "\n".join(f"  {line}" if line else "" for line in s.split("\n"))


def instruction(*args):
    return f"({' '.join(arg for arg in args if arg is not None)})"


def atomic_instruction(op, memid, ordering, /, *args, drop):
    if drop:
        return f"(drop {instruction(op, memid, ordering, *args)})"
    return instruction(op, memid, ordering, *args)


def func(memid, ordering):
    """Return a function testing ALL_OPS e.g.
      (func $acqrel_without_memid
        (drop (i32.atomic.load acqrel (i32.const 51)))
        ...
      )
    """
    return f'''(func ${ordering if ordering is not None else "no_ordering"}{"_with_memid" if memid is not None else "_without_memid"}
{indent(newline.join(atomic_instruction(op, memid, ordering, arg, drop=should_drop) for op, arg, should_drop, _ in map(astuple, ALL_OPS)))}
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
    # Declare two memories so we have control over whether the memory idx is printed
    # A memory idx of 0 is allowed to be omitted.
    return module(
        "(memory 1 1 shared)",
        "(memory 1 1 shared)",
        "",
        "\n\n".join([f'{func(memid, ordering)}' for memid in [None, "1"] for ordering in [None, "acqrel", "seqcst"]]))


def to_unsigned_leb(num):
    ret = bytearray()

    if num == 0:
        ret.append(0)
        return ret
    while num > 0:
        rem = num >> 7
        ret.append((num & 0x7F) | (bool(rem) << 7))

        num = rem
    return ret


def bin_to_str(bin: bytes) -> str:
    """Return binary formatted for .wast format e.g. \00\61\73\6d\01\00\00\00"""
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
    """Return a (module binary ...) testing ALL_OPS"""
    funcs: [function] = []
    for (memidx_bytes, memidx), (ordering_bytes, ordering) in itertools.product([(b'', None), (b'\x01', "1")], [(b'', None), (b'\x00', "seqcst"), (b'\x01', "acqrel")]):
        func = function([], memidx, ordering)
        for test_case in ALL_OPS:
            align = 2 | (bool(ordering_bytes) << 5) | (bool(memidx_bytes) << 6)
            s = statement(
                bin=test_case.bin % {b'align': int.to_bytes(align), b'ordering': ordering_bytes, b'memidx': memidx_bytes},
                text=atomic_instruction(test_case.op, memidx, ordering, test_case.arg, drop=test_case.should_drop))
            func.body.append(s)

        # Functions end with 0x0b.
        func.body[-1].bin += b'\x0b'
        funcs.append(func)

    str_builder = []

    for func in funcs:
        bin_size = sum(len(statement.bin) for statement in func.body)
        # body size plus 1 byte for the number of locals (0)
        func_bytes = to_unsigned_leb(bin_size + 1)
        # number of locals, none in our case
        func_bytes.append(0x00)
        str_builder.append(f'"{bin_to_str(func_bytes)}" ;; func\n')
        for stmt in func.body:
            str_builder.append(f'"{bin_to_str(stmt.bin)}" ;; {stmt.text}\n')

    section_size = (
        # function body size
        sum(len(statement.bin) for func in funcs for statement in func.body) +
        # function count byte
        1 +
        # num locals per function (always 0)
        len(funcs) +
        # each function declares its size, add bytes for the LEB encoding of each function's size
        sum(len(to_unsigned_leb(sum(len(statement.bin) for statement in func.body))) for func in funcs))

    code_section = bytearray(b"\x0a") + to_unsigned_leb(section_size) + to_unsigned_leb(len(funcs))

    '''(module
        (memory 1 1 shared)
        (memory 1 1 shared)
       )
    '''
    module = b"\x00\x61\x73\x6d\x01\x00\x00\x00\x01\x04\01\x60\x00\x00\x03\x07\06\x00\x00\x00\x00\x00\x00\x05\07\x02\x03\x01\x01\x03\x01\x01"

    str_builder = [binary_line(module), f'"{bin_to_str(code_section)}" ;; code section\n'] + str_builder

    return f"(module binary\n{indent(''.join(str_builder))})"


def failing_test(instruction, arg, /, memidx, drop):
    """Module assertion that sets a memory ordering immediate for a non-atomic instruction"""

    func = f"(func ${''.join(filter(str.isalnum, instruction))} {atomic_instruction(instruction, memidx, 'acqrel', arg, drop=drop)})"
    return assert_invalid(module("(memory 1 1 shared)", "", func), f"Can't set memory ordering for non-atomic {instruction}")


def drop_atomic(instruction):
    first, atomic, last = instruction.partition(".atomic")
    return first + last


def failing_tests():
    inst = ALL_OPS[0]
    op = drop_atomic(inst.op)

    return failing_test(op, inst.arg, memidx=None, drop=inst.should_drop)


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
