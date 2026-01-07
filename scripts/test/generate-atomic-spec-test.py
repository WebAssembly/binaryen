import subprocess
import sys
import tempfile
from argparse import ArgumentParser
from collections.abc import Iterator
from pathlib import Path

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


def generate_atomic_spec_test():
    # Declare two memories so we have control over whether the memory immediate is printed
    # A memory immediate of 0 is allowed to be omitted.
    return module(
        "(memory 1 1 shared)",
        "(memory 1 1 shared)",
        "",
        "\n\n".join([f'{func(memid, ordering)}' for memid in [None, "1"] for ordering in [None, "acqrel", "seqcst"]]))


def to_binary(wasm_as, wat: str) -> bytes:
    with tempfile.NamedTemporaryFile(mode="w+") as input, tempfile.NamedTemporaryFile(mode="rb") as output:
        input.write(wat)
        input.seek(0)

        proc = subprocess.run([wasm_as, "--enable-multimemory", "--enable-threads", "--enable-relaxed-atomics", input.name, "-o", output.name], capture_output=True)
        try:
            proc.check_returncode()
        except Exception:
            print(proc.stderr.decode('utf-8'), end="", file=sys.stderr)
            raise

        return output.read()


def findall(bytes, byte):
    ix = -1
    while ((ix := bytes.find(byte, ix + 1)) != -1):
        yield ix


def read_unsigned_leb(bytes, start):
    """Returns (bytes read, value)"""
    ret = 0
    for i, byte in enumerate(bytes[start:]):
        ret |= (byte & ~(1 << 7)) << (7 * i)
        if not byte & (1 << 7):
            return i + 1, ret
    raise ValueError("Unexpected end of input, continuation bit was set for the last byte.")


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


def unsigned_leb_add(bytes: bytearray, start, add) -> int:
    """Returns number of bytes added"""
    l, decoded = read_unsigned_leb(bytes, start)
    added = to_unsigned_leb(decoded + add)

    bytes[start:start + l] = added[:l]

    if len(added) > l:
        for i, b in enumerate(added[l:], start=l):
            bytes.insert(i, b)

    return len(added) - l


def unsigned_leb_subtract(bytes, start, sub):
    l, decoded = read_unsigned_leb(bytes, start)
    subbed = to_unsigned_leb(decoded - sub)

    bytes[start:start + len(subbed)] = subbed

    diff = l - len(subbed)
    for _ in range(diff):
        bytes.pop(start + len(subbed))

    return -diff


def iterate_sections(bytes) -> Iterator[bytearray]:
    bytes = bytes.removeprefix(b"\00asm\01\00\00\00")
    start = 0
    while True:
        read, size = read_unsigned_leb(bytes, start + 1)

        # section op + section size + body
        yield bytearray(bytes[start:start + 1 + read + size])
        start += 1 + read + size
        if start > len(bytes):
            raise ValueError("not expected", start, len(bytes))
        elif start == len(bytes):
            return


def iterate_functions(bytes) -> Iterator[bytearray]:
    read, size = read_unsigned_leb(bytes, 1)
    read2, size2 = read_unsigned_leb(bytes, 1 + read)
    section_body = bytes[1 + read + read2:]

    start = 0
    while True:
        read, size = read_unsigned_leb(section_body, start)
        yield bytearray(section_body[start:start + read + size])
        start += read + size
        if start > len(section_body):
            raise ValueError("not expected", start, len(section_body))
        elif start == len(section_body):
            return


def binary_tests(b: bytes) -> bytes:
    updated_tests = [b"\00asm\01\00\00\00"]

    for section in iterate_sections(b):
        if section[0] != 0x0a:
            updated_tests.append(section)
            continue

        bytes_read, size = read_unsigned_leb(section, 1)
        _, func_count = read_unsigned_leb(section, 1 + bytes_read)

        updated_code_section = bytearray()
        updated_code_section.append(0x0a)
        updated_code_section += to_unsigned_leb(size)

        updated_code_section += to_unsigned_leb(func_count)

        section_bytes_added = 0
        for i, func in enumerate(iterate_functions(section)):
            # TODO: this is wrong if the function size is 0xfe
            ix = func.find(0xfe)
            if ix == -1:
                raise ValueError("Didn't find atomic operation")
            if i not in (2, 5):
                updated_code_section += func
                continue
            if func[ix + 2] & (1 << 5):
                raise ValueError("Memory immediate was already set.")
            func_bytes_added = 0
            for i in findall(func, 0xfe):
                func[i + 2] |= (1 << 5)

                # ordering comes after mem idx
                has_mem_idx = bool(func[i + 2] & (1 << 6))
                func.insert(i + 3 + has_mem_idx, 0x00)

                func_bytes_added += 1

            # adding to the func byte size might have added a byte
            section_bytes_added += unsigned_leb_add(func, 0, func_bytes_added)
            section_bytes_added += func_bytes_added

            updated_code_section += func

        _ = unsigned_leb_add(updated_code_section, 1, section_bytes_added)
        updated_tests.append(updated_code_section)

    return b''.join(updated_tests)


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
    parser = ArgumentParser()
    parser.add_argument("--wasm-as", default=Path("bin/wasm-as"), type=Path)

    args = parser.parse_args()

    wat = generate_atomic_spec_test()
    bin = binary_tests(to_binary(args.wasm_as, wat))

    print(wat)
    print(module_binary(bin))
    print()
    print(failing_tests())
    print()


if __name__ == "__main__":
    main()
