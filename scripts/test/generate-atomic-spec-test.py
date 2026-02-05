import itertools
import math
from collections.abc import Iterator
from dataclasses import dataclass
from enum import Enum

from relaxed_atomic_execution_tests import acqrel_execution_tests

# Workaround for python <3.10, escape characters can't appear in f-strings.
# Although we require 3.10 in some places, the formatter complains without this.
newline = "\n"

backslash = "\\"

FUNC_NAME = "$test-all-ops"


def indent(s):
    return "\n".join(f"  {line}" if line else "" for line in s.split("\n"))


class ValueType(Enum):
    i32 = 32
    i64 = 64


class Ordering(Enum):
    seqcst = 0
    acqrel = 1


@dataclass
class Template:
    op: str
    value_type: object
    args: int
    should_drop: bool
    bin: bytes = b""


templates = [
    Template(op="i32.atomic.load", value_type=ValueType.i32, args=1, should_drop=True, bin=b"\xfe\x10"),
    Template(op="i64.atomic.load", value_type=ValueType.i64, args=1, should_drop=True, bin=b"\xfe\x11"),
    Template(op="i32.atomic.load8_u", value_type=ValueType.i64, args=1, should_drop=True, bin=b"\xfe\x12"),
    Template(op="i32.atomic.load16_u", value_type=ValueType.i64, args=1, should_drop=True, bin=b"\xfe\x13"),
    Template(op="i64.atomic.load8_u", value_type=ValueType.i64, args=1, should_drop=True, bin=b"\xfe\x14"),
    Template(op="i64.atomic.load16_u", value_type=ValueType.i64, args=1, should_drop=True, bin=b"\xfe\x15"),
    Template(op="i64.atomic.load32_u", value_type=ValueType.i64, args=1, should_drop=True, bin=b"\xfe\x16"),
    Template(op="i32.atomic.store", value_type=ValueType.i32, args=2, should_drop=False, bin=b"\xfe\x17"),
    Template(op="i64.atomic.store", value_type=ValueType.i64, args=2, should_drop=False, bin=b"\xfe\x18"),
    Template(op="i32.atomic.store8", value_type=ValueType.i32, args=2, should_drop=False, bin=b"\xfe\x19"),
    Template(op="i32.atomic.store16", value_type=ValueType.i32, args=2, should_drop=False, bin=b"\xfe\x1a"),
    Template(op="i64.atomic.store8", value_type=ValueType.i64, args=2, should_drop=False, bin=b"\xfe\x1b"),
    Template(op="i64.atomic.store16", value_type=ValueType.i64, args=2, should_drop=False, bin=b"\xfe\x1c"),
    Template(op="i64.atomic.store32", value_type=ValueType.i64, args=2, should_drop=False, bin=b"\xfe\x1d"),
    Template(op="i32.atomic.rmw.add", value_type=ValueType.i32, args=2, should_drop=True, bin=b"\xfe\x1e"),
    Template(op="i64.atomic.rmw.add", value_type=ValueType.i64, args=2, should_drop=True, bin=b"\xfe\x1f"),
    Template(op="i32.atomic.rmw8.add_u", value_type=ValueType.i32, args=2, should_drop=True, bin=b"\xfe\x20"),
    Template(op="i32.atomic.rmw16.add_u", value_type=ValueType.i32, args=2, should_drop=True, bin=b"\xfe\x21"),
    Template(op="i64.atomic.rmw8.add_u", value_type=ValueType.i64, args=2, should_drop=True, bin=b"\xfe\x22"),
    Template(op="i64.atomic.rmw16.add_u", value_type=ValueType.i64, args=2, should_drop=True, bin=b"\xfe\x23"),
    Template(op="i64.atomic.rmw32.add_u", value_type=ValueType.i64, args=2, should_drop=True, bin=b"\xfe\x24"),
    Template(op="i32.atomic.rmw.sub", value_type=ValueType.i32, args=2, should_drop=True, bin=b"\xfe\x25"),
    Template(op="i64.atomic.rmw.sub", value_type=ValueType.i64, args=2, should_drop=True, bin=b"\xfe\x26"),
    Template(op="i32.atomic.rmw8.sub_u", value_type=ValueType.i32, args=2, should_drop=True, bin=b"\xfe\x27"),
    Template(op="i32.atomic.rmw16.sub_u", value_type=ValueType.i32, args=2, should_drop=True, bin=b"\xfe\x28"),
    Template(op="i64.atomic.rmw8.sub_u", value_type=ValueType.i64, args=2, should_drop=True, bin=b"\xfe\x29"),
    Template(op="i64.atomic.rmw16.sub_u", value_type=ValueType.i64, args=2, should_drop=True, bin=b"\xfe\x2a"),
    Template(op="i64.atomic.rmw32.sub_u", value_type=ValueType.i64, args=2, should_drop=True, bin=b"\xfe\x2b"),
    Template(op="i32.atomic.rmw.and", value_type=ValueType.i32, args=2, should_drop=True, bin=b"\xfe\x2c"),
    Template(op="i64.atomic.rmw.and", value_type=ValueType.i64, args=2, should_drop=True, bin=b"\xfe\x2d"),
    Template(op="i32.atomic.rmw8.and_u", value_type=ValueType.i32, args=2, should_drop=True, bin=b"\xfe\x2e"),
    Template(op="i32.atomic.rmw16.and_u", value_type=ValueType.i32, args=2, should_drop=True, bin=b"\xfe\x2f"),
    Template(op="i64.atomic.rmw8.and_u", value_type=ValueType.i64, args=2, should_drop=True, bin=b"\xfe\x30"),
    Template(op="i64.atomic.rmw16.and_u", value_type=ValueType.i64, args=2, should_drop=True, bin=b"\xfe\x31"),
    Template(op="i64.atomic.rmw32.and_u", value_type=ValueType.i64, args=2, should_drop=True, bin=b"\xfe\x32"),
    Template(op="i32.atomic.rmw.or", value_type=ValueType.i32, args=2, should_drop=True, bin=b"\xfe\x33"),
    Template(op="i64.atomic.rmw.or", value_type=ValueType.i64, args=2, should_drop=True, bin=b"\xfe\x34"),
    Template(op="i32.atomic.rmw8.or_u", value_type=ValueType.i32, args=2, should_drop=True, bin=b"\xfe\x35"),
    Template(op="i32.atomic.rmw16.or_u", value_type=ValueType.i32, args=2, should_drop=True, bin=b"\xfe\x36"),
    Template(op="i64.atomic.rmw8.or_u", value_type=ValueType.i64, args=2, should_drop=True, bin=b"\xfe\x37"),
    Template(op="i64.atomic.rmw16.or_u", value_type=ValueType.i64, args=2, should_drop=True, bin=b"\xfe\x38"),
    Template(op="i64.atomic.rmw32.or_u", value_type=ValueType.i64, args=2, should_drop=True, bin=b"\xfe\x39"),
    Template(op="i32.atomic.rmw.xor", value_type=ValueType.i32, args=2, should_drop=True, bin=b"\xfe\x3a"),
    Template(op="i64.atomic.rmw.xor", value_type=ValueType.i64, args=2, should_drop=True, bin=b"\xfe\x3b"),
    Template(op="i32.atomic.rmw8.xor_u", value_type=ValueType.i32, args=2, should_drop=True, bin=b"\xfe\x3c"),
    Template(op="i32.atomic.rmw16.xor_u", value_type=ValueType.i32, args=2, should_drop=True, bin=b"\xfe\x3d"),
    Template(op="i64.atomic.rmw8.xor_u", value_type=ValueType.i64, args=2, should_drop=True, bin=b"\xfe\x3e"),
    Template(op="i64.atomic.rmw16.xor_u", value_type=ValueType.i64, args=2, should_drop=True, bin=b"\xfe\x3f"),
    Template(op="i64.atomic.rmw32.xor_u", value_type=ValueType.i64, args=2, should_drop=True, bin=b"\xfe\x40"),
    Template(op="i32.atomic.rmw.xchg", value_type=ValueType.i32, args=2, should_drop=True, bin=b"\xfe\x41"),
    Template(op="i64.atomic.rmw.xchg", value_type=ValueType.i64, args=2, should_drop=True, bin=b"\xfe\x42"),
    Template(op="i32.atomic.rmw8.xchg_u", value_type=ValueType.i32, args=2, should_drop=True, bin=b"\xfe\x43"),
    Template(op="i32.atomic.rmw16.xchg_u", value_type=ValueType.i32, args=2, should_drop=True, bin=b"\xfe\x44"),
    Template(op="i64.atomic.rmw8.xchg_u", value_type=ValueType.i64, args=2, should_drop=True, bin=b"\xfe\x45"),
    Template(op="i64.atomic.rmw16.xchg_u", value_type=ValueType.i64, args=2, should_drop=True, bin=b"\xfe\x46"),
    Template(op="i64.atomic.rmw32.xchg_u", value_type=ValueType.i64, args=2, should_drop=True, bin=b"\xfe\x47"),
    Template(op="i32.atomic.rmw.cmpxchg", value_type=ValueType.i32, args=3, should_drop=True, bin=b"\xfe\x48"),
    Template(op="i64.atomic.rmw.cmpxchg", value_type=ValueType.i64, args=3, should_drop=True, bin=b"\xfe\x49"),
    Template(op="i32.atomic.rmw8.cmpxchg_u", value_type=ValueType.i32, args=3, should_drop=True, bin=b"\xfe\x4a"),
    Template(op="i32.atomic.rmw16.cmpxchg_u", value_type=ValueType.i32, args=3, should_drop=True, bin=b"\xfe\x4b"),
    Template(op="i64.atomic.rmw8.cmpxchg_u", value_type=ValueType.i64, args=3, should_drop=True, bin=b"\xfe\x4c"),
    Template(op="i64.atomic.rmw16.cmpxchg_u", value_type=ValueType.i64, args=3, should_drop=True, bin=b"\xfe\x4d"),
    Template(op="i64.atomic.rmw32.cmpxchg_u", value_type=ValueType.i64, args=3, should_drop=True, bin=b"\xfe\x4e"),
]


def all_combinations() -> Iterator[(Template, (int, ValueType), Ordering)]:
    """Yield tuples covering all possible combinations of atomic memory operations.
    (template, (idx, memory_ptr_type), ordering)
    where idx is a memory index or None representing an implicit 0 index
      and memory_ptr_type is i32 or i64 based on the memory being indexed
      and ordering is an `Ordering` enum or None representing an implicit seqcst ordering.
    """

    # See the memory section defined in `binary_test`
    memories = [(None, ValueType.i32), (0, ValueType.i32), (1, ValueType.i64)]

    return itertools.product(templates, memories, [None, Ordering.acqrel, Ordering.seqcst])


def statement(template, mem_idx: int | None, mem_ptr_type: ValueType, ordering: Ordering | None):
    """Return a statement exercising the op in `template` e.g. (i32.atomic.store 1 acqrel (i64.const 42) (i32.const 42))"""
    memargs = []
    if mem_idx is not None:
        memargs.append(str(mem_idx))
    if ordering is not None:
        memargs.append(ordering.name)

    memarg_str = " ".join(memargs) + " " if memargs else ""

    # The first argument (the memory location) must match the memory that we're indexing. Other arguments match the op (e.g. i32 for i32.atomic.load).
    args = [f"({mem_ptr_type.name}.const 0)"] + [f"({template.value_type.name}.const 42)" for _ in range(template.args - 1)]

    op_str = "(" + "".join([template.op, " ", memarg_str, " ".join(args)]) + ")"
    if not template.should_drop:
        return op_str
    return f"(drop {op_str})"


def func():
    """Return a func exercising all ops in `templates` e.g.
      (func $test-all-ops
        (drop (i32.atomic.load (i32.const 42)))
        (drop (i32.atomic.load acqrel (i32.const 42)))
        ...
      )
    """
    return f''';; Memory index must come before memory ordering if present.
;; Both immediates are optional; an ommitted memory ordering will be treated as seqcst.
(func $test-all-ops
{indent(newline.join(statement(template, mem_idx, mem_ptr_type, ordering) for template, (mem_idx, mem_ptr_type), ordering in all_combinations()))}
)'''


def text_test():
    """Return a (module ...) that exercises all ops in `templates`."""
    return f'''(module
  (memory i32 1 1)
  (memory i64 1 1)

{indent(func())}
)'''


def invalid_text_test():
    return '''(assert_invalid (module
  (memory 1 1 shared)

  (func $i32load (drop (i32.load acqrel (i32.const 51))))
) "Can't set memory ordering for non-atomic i32.load")'''


def bin_to_str(bin: bytes) -> str:
    """Return binary formatted for .wast format e.g. \00\61\73\6d\01\00\00\00"""
    return ''.join(f'{backslash}{byte:02x}' for byte in bin)


# (i64.const 0)
I64CONST = b"\x42\x00"


# (i32.const 0)
I32CONST = b"\x41\x00"


def bin_statement_lines(template: Template, mem_idx: int, mem_ptr_type: ValueType, ordering: Ordering) -> Iterator[(bytes, str)]:
    """Yield (b, comment) where `b` is a part of the statement using `template`, and `comment` explains that part, e.g.
        (b"\xfe\x11", "i64.atomic.load")
    The entire iterator represents a complete expression using the `template`. e.g.
        (drop (i32.atomic.load (i32.const 42)))
    """
    arg_one_bin = I64CONST if mem_ptr_type == ValueType.i64 else I32CONST
    yield arg_one_bin, f"({mem_ptr_type.name}.const 0)"
    for _ in range(template.args - 1):
        const = I64CONST if template.value_type == ValueType.i64 else I32CONST
        yield const, f"({template.value_type.name}.const 51)"

    yield template.bin, template.op

    has_ordering = ordering is not None
    has_mem_idx = mem_idx is not None
    raw_alignment = int(math.log2(mem_ptr_type.value // 8))
    alignment = raw_alignment | (has_ordering << 5) | (has_mem_idx << 6)
    comment = f"Alignment of {raw_alignment}" \
              f'{" with bit 5 set indicating that an ordering immediate follows" if has_ordering else ""}' \
              f'{" and" if has_ordering and has_mem_idx else ""}' \
              f'{" with bit 6 set indicating that a memory index immediate follows" if has_mem_idx else ""}'

    yield int.to_bytes(alignment), comment

    if has_mem_idx:
        yield int.to_bytes(mem_idx), "memory index"

    if has_ordering:
        ordering_num = ordering.value
        if "rmw" in template.op:
            ordering_num |= ordering_num << 4

        yield int.to_bytes(ordering_num), f"{ordering.name} memory ordering"

    yield b"\x00", "offset"

    if template.should_drop:
        yield b"\x1a", "drop"


def bin_statement(template: Template, mem_idx: int, mem_ptr_type: ValueType, ordering: Ordering) -> (bytes, str):
    """Return (b, s) where `b` is the binary exercising an instruction, e.g.
        (drop (i32.atomic.load (i32.const 42)))
       and `s` is a str containing the binary along with comments explaining it, e.g.
        "\41\33" ;; (i32.const 51)
        "\fe\10" ;; i32.atomic.load
        "\42" ;; Alignment of 2 with bit 6 set indicating that a memory index immediate follows
        "\00" ;; memory index
        "\00" ;; offset
        "\1a" ;; drop
    """

    bins = []
    strs = []

    for bin, comment in bin_statement_lines(template, mem_idx, mem_ptr_type, ordering):
        bins.append(bin)
        strs.append(f'"{bin_to_str(bin)}" ;; {comment}')

    return b"".join(bins), "\n".join(strs)


def to_unsigned_leb(num: int) -> bytearray:
    ret = bytearray()

    if num == 0:
        ret.append(0)
        return ret

    rem = num
    while (num := rem) > 0:
        rem = num >> 7
        ret.append((num & 0x7F) | (bool(rem) << 7))

    return ret


def binary_func_body():
    statement_strs = []
    statement_bins = []

    for template, (mem_idx, mem_ptr_type), ordering in all_combinations():
        bin, s = bin_statement(template, mem_idx, mem_ptr_type, ordering)
        statement_bins.append(bin)
        statement_strs.append(s)

    # plus two with \0b function end byte and local decl count (0)
    func_body_size = sum(map(len, statement_bins)) + 2
    section_size = (
        func_body_size +  # function body bytes
        len(to_unsigned_leb(func_body_size)) +  # LEB encoding of function body size
        1)  # Function count byte (0)
    code_section_strs = \
        [rf'"\0a{bin_to_str(to_unsigned_leb(section_size))}\01" ;; Code section' "\n"
         rf'"{bin_to_str(to_unsigned_leb(func_body_size))}\00" ;; func {FUNC_NAME}'] + \
        list(map(indent, statement_strs)) + \
        [r'  "\0b" ;; end']

    return "\n\n".join(code_section_strs) + "\n"


def module_binary(str: str):
    return f'''(module binary
{indent(str)})'''


def binary_test():
    header = fr'''"\00asm\01\00\00\00" ;; Wasm header
"\01\04\01" ;; Type section
  "\60\00\00" ;; {FUNC_NAME} type
"\03\02\01\00" ;; Function section
"\05\07\02" ;; Memory section
  "\01\01\01" ;; (memory i32 1 1)
  "\05\01\01" ;; (memory i64 1 1)'''
    return module_binary(header + "\n" + binary_func_body())


def main():
    print(";; Generated by scripts/test/generate-atomic-spec-test.py. Do not edit manually.")
    print()
    print(text_test())
    print()
    print(invalid_text_test())
    print()
    print(binary_test())
    print()
    print(acqrel_execution_tests)


if __name__ == "__main__":
    main()
