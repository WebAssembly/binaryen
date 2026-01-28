import enum
import itertools
from collections.abc import Iterator
from dataclasses import dataclass
from enum import Enum

# Workaround for python <3.10, escape characters can't appear in f-strings.
# Although we require 3.10 in some places, the formatter complains without this.
newline = "\n"

backslash = "\\"

FUNC_NAME = "$test-all-ops"


def indent(s):
    return "\n".join(f"  {line}" if line else "" for line in s.split("\n"))


class ValueType(Enum):
    i32 = enum.auto()
    i64 = enum.auto()


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
    Template(op="i32.atomic.store", value_type=ValueType.i32, args=2, should_drop=False, bin=b"\xfe\x17"),
    Template(op="i64.atomic.store", value_type=ValueType.i64, args=2, should_drop=False, bin=b"\xfe\x18"),
]


def all_combinations():
    return itertools.product(templates, [None, 0, 1], [None, Ordering.acqrel, Ordering.seqcst])


def statement(template, mem_idx: int | None, ordering: Ordering | None):
    """Return a statement exercising the op in `template` e.g. (i32.atomic.store 1 acqrel (i64.const 42) (i32.const 42))"""
    memargs = []
    if mem_idx is not None:
        memargs.append(str(mem_idx))
    if ordering is not None:
        memargs.append(ordering.name)

    memarg_str = " ".join(memargs) + " " if memargs else ""
    idx_type = ValueType.i64 if mem_idx == 1 else ValueType.i32 if mem_idx == 0 else ValueType.i32

    # The first argument (the memory location) must match the memory that we're indexing. Other arguments match the op (e.g. i32 for i32.atomic.load).
    args = [f"({idx_type.name}.const 42)"] + [f"({template.value_type.name}.const 42)" for _ in range(template.args - 1)]

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
{indent(newline.join(statement(template, mem_idx, ordering) for template, mem_idx, ordering in all_combinations()))}
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


# (i64.const 51)
I64CONST = b"\x42\x33"


# (i32.const 51)
I32CONST = b"\x41\x33"


def bin_statement_lines(template, mem_idx: int, ordering: Ordering) -> Iterator[(bytes, str)]:
    """Yield (b, comment) where `b` is a part of the statement using `template`, and `comment` explains that part, e.g.
        (b"\xfe\x11", "i64.atomic.load")
    The entire iterator represents a complete expression using the `template`. e.g.
        (drop (i32.atomic.load (i32.const 42)))
    """
    index_type = ValueType.i64 if mem_idx == 1 else ValueType.i32
    arg_one_bin = I64CONST if index_type == ValueType.i64 else I32CONST
    yield arg_one_bin, f"({index_type.name}.const 51)"
    for _ in range(template.args - 1):
        const = I64CONST if template.value_type == ValueType.i64 else I32CONST
        yield const, f"({template.value_type.name}.const 51)"

    yield template.bin, template.op

    has_ordering = ordering is not None
    has_mem_idx = mem_idx is not None
    alignment = 2 | (has_ordering << 5) | (has_mem_idx << 6)
    comment = "Alignment of 2" \
              f'{" with bit 5 set indicating that an ordering immediate follows" if has_ordering else ""}' \
              f'{" and" if has_ordering and has_mem_idx else ""}' \
              f'{" with bit 6 set indicating that a memory index immediate follows" if has_mem_idx else ""}'

    yield int.to_bytes(alignment), comment

    if has_mem_idx:
        yield int.to_bytes(mem_idx), "memory index"

    if has_ordering:
        yield int.to_bytes(ordering.value), f"{ordering.name} memory ordering"

    yield b"\x00", "offset"

    if template.should_drop:
        yield b"\x1a", "drop"


def bin_statement(template, mem_idx, ordering):
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

    for bin, comment in bin_statement_lines(template, mem_idx, ordering):
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

    for template, mem_idx, ordering in all_combinations():
        bin, s = bin_statement(template, mem_idx, ordering)
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


if __name__ == "__main__":
    main()
