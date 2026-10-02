import os
import re
import subprocess
import tempfile

from scripts.test import shared

from . import utils


def uleb(value):
    result = bytearray()
    while value >= 128:
        result.append((value & 127) | 128)
        value >>= 7
    result.append(value)
    return bytes(result)


def with_line_table(wasm, program):
    prologue = bytes.fromhex('010101fb0e0d000101010100000001000001')
    prologue += b'\0test.c\0\0\0\0\0'
    table = b'\x04\0' + len(prologue).to_bytes(4, 'little') + prologue + program
    for name, contents in {
        '.debug_abbrev': bytes.fromhex('0111001017000000'),
        '.debug_info': bytes.fromhex('0c000000040000000000040100000000'),
        '.debug_line': len(table).to_bytes(4, 'little') + table,
    }.items():
        name = name.encode()
        payload = uleb(len(name)) + name + contents
        wasm += b'\0' + uleb(len(payload)) + payload
    return wasm


def line_rows(path):
    dump = shared.run_process(shared.WASM_OPT + [path, '--dwarfdump'],
                              capture_output=True).stdout
    return [(int(addr, 16), int(line), int(col), int(file), int(isa),
             int(discriminator), flags.split())
            for addr, line, col, file, isa, discriminator, flags in re.findall(
                r'^\s*0x([0-9a-f]+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)([^\n]*)',
                dump.split('.debug_line contents:', 1)[1], re.MULTILINE)]


class DWARFTest(utils.BinaryenTestCase):
    def test_line_program_encoding(self):
        # Padded i32.const shifts later addresses back one byte on writing.
        wasm = bytes.fromhex('0061736d010000000105016000017f03020100'
                             '070501016600000a0a01080041810041026a0b')
        program = bytes.fromhex('000502030000000309')
        # Repeat discriminator 300 explicitly on the first two rows, then
        # leave it unset. Row markers must not carry over to later rows.
        program += b'\0\x03\x04' + uleb(300) + b'\x07\x0a\x01\x02\x03'
        program += b'\0\x03\x04' + uleb(300) + b'\x01\x02\x02\x01'
        program += bytes.fromhex('0201030a0b010201000101')
        with tempfile.TemporaryDirectory() as temp_dir:
            input_file = os.path.join(temp_dir, 'input.wasm')
            output_file = os.path.join(temp_dir, 'output.wasm')
            with open(input_file, 'wb') as f:
                f.write(with_line_table(wasm, program))
            for source in (input_file, output_file):
                shared.run_process(shared.WASM_OPT +
                                   [source, '-g', '-o', output_file])
                rows = line_rows(output_file)
                self.assertEqual([row[:2] for row in rows],
                                 [(3, 10), (5, 10), (7, 10), (8, 20), (9, 20)])
                self.assertEqual([row[5] for row in rows], [300, 300, 0, 0, 0])
                self.assertEqual([row[6] for row in rows], [
                    ['is_stmt', 'basic_block', 'prologue_end'], ['is_stmt'],
                    ['is_stmt'], ['is_stmt', 'epilogue_begin'],
                    ['is_stmt', 'end_sequence'],
                ])
            dump = shared.run_process(shared.WASM_OPT + [output_file, '--dwarfdump'],
                                      capture_output=True).stdout
            self.assertEqual(dump.count('DW_LNE_set_address'), 1)
            advances = re.findall(r'^0x[0-9a-f]+: 02 DW_LNS_advance_pc', dump, re.MULTILINE)
            self.assertEqual(len(advances), 4)

    def test_line_zero_roundtrip(self):
        def custom_section(name, contents):
            name = name.encode()
            payload = bytes([len(name)]) + name + contents
            self.assertLess(len(payload), 128)
            return bytes([0, len(payload)]) + payload

        # Padded i32.const encoding moves the second constant from offset 6
        # to 5. Its line-zero row must move with it, not inherit line 5.
        wasm = bytes.fromhex('0061736d010000000105016000017f03020100'
                             '070501016600000a0a01080041810041026a0b')
        abbrev = bytes.fromhex('0111001017000000')
        info = bytes.fromhex('0c000000040000000000040100000000')
        prologue = bytes.fromhex('010101fb0e0d000101010100000001000001')
        prologue += b'\0test.c\0\0\0\0\0'

        for dead_address in (0, 0xffffffff, 0xfffffffe):
            for lines in ((5, 0, 9, 0), (0, 0, 0, 0)):
                with self.subTest(dead_address=dead_address, lines=lines):
                    # Later offsets in a dead sequence must not be remapped
                    # onto live code, even when its first row has line zero.
                    program = bytes.fromhex('000502')
                    program += dead_address.to_bytes(4, 'little')
                    program += bytes.fromhex('037f010203030501000101')
                    program += bytes.fromhex('00050203000000')
                    previous_address, previous_line = 3, 1
                    for i, (address, line) in enumerate(zip((3, 6, 8, 10), lines, strict=True)):
                        if i:
                            program += bytes([2, address - previous_address])
                        # These line deltas fit in one signed LEB128 byte.
                        program += bytes([3, (line - previous_line) & 0x7f])
                        program += bytes.fromhex('000101') if i == 3 else b'\x01'
                        previous_address, previous_line = address, line
                    table = b'\x04\0' + len(prologue).to_bytes(4, 'little')
                    table += prologue + program
                    sections = {'.debug_abbrev': abbrev, '.debug_info': info,
                                '.debug_line': len(table).to_bytes(4, 'little') + table}
                    input_wasm = wasm
                    for name, contents in sections.items():
                        input_wasm += custom_section(name, contents)

                    with tempfile.TemporaryDirectory() as temp_dir:
                        input_file = os.path.join(temp_dir, 'input.wasm')
                        output_file = os.path.join(temp_dir, 'output.wasm')
                        with open(input_file, 'wb') as f:
                            f.write(input_wasm)
                        for source in (input_file, output_file):
                            shared.run_process(shared.WASM_OPT +
                                               [source, '-g', '-o', output_file])
                            dump = shared.run_process(shared.WASM_OPT +
                                                      [output_file, '--dwarfdump'],
                                                      capture_output=True).stdout
                            rows = re.findall(r'^\s*0x([0-9a-f]+)\s+(\d+)\s+',
                                              dump.split('.debug_line contents:', 1)[1],
                                              re.MULTILINE)
                            self.assertEqual([(int(addr, 16), int(line))
                                              for addr, line in rows],
                                             list(zip((3, 5, 7, 9), lines, strict=True)))
                            self.assertEqual(dump.count('DW_LNE_end_sequence'), 1)

    def test_overlapping_inline_siblings(self):
        # Make the outer lexical block valid and move one inlined call onto
        # its sibling's range. Both siblings must become unavailable: keeping
        # either one would assign its variables to the other's instructions.
        path = os.path.join(shared.options.binaryen_test, 'passes',
                            'class_with_dwarf_noprint.wasm')
        with open(path, 'rb') as f:
            wasm = f.read()
        replacements = (
            ('26000000fcffffff', '260000005f000000'),
            ('4000000019000000', '6100000009000000'),
        )
        for old, new in replacements:
            old_bytes = bytes.fromhex(old)
            self.assertEqual(wasm.count(old_bytes), 1)
            wasm = wasm.replace(old_bytes, bytes.fromhex(new))

        with tempfile.TemporaryDirectory() as temp_dir:
            input_file = os.path.join(temp_dir, 'input.wasm')
            output_file = os.path.join(temp_dir, 'output.wasm')
            with open(input_file, 'wb') as f:
                f.write(wasm)
            shared.run_process(shared.WASM_OPT +
                               [input_file, '--roundtrip', '-g',
                                '-o', output_file])
            dump = shared.run_process(shared.WASM_OPT +
                                      [output_file, '--dwarfdump'],
                                      capture_output=True).stdout
            first = dump.split('0x0000015e:', 1)[1].split('0x00000179:', 1)[0]
            second = dump.split('0x00000179:', 1)[1].split('0x00000189:', 1)[0]
            ranges_line = next(line for line in first.splitlines()
                               if 'DW_AT_ranges' in line)
            self.assertTrue(ranges_line.endswith(')'))
            empty_offset = ranges_line.rsplit('(0x', 1)[1].split(')', 1)[0]
            ranges = dump.split('.debug_ranges contents:', 1)[1]
            self.assertIn(f'{empty_offset} <End of list>', ranges)
            self.assertIn('DW_AT_low_pc [DW_FORM_addr]\t'
                          '(0x00000000ffffffff)', second)

    def test_zero_start_range_offset(self):
        # A zero start with a nonzero end is a valid offset from the current
        # .debug_ranges base, not a tombstone or end-of-list marker. Replace
        # the fixture's unmapped (0, 1) entry with a contiguous mapped range.
        path = os.path.join(shared.options.binaryen_test, 'passes',
                            'class_with_dwarf_noprint.wasm')
        with open(path, 'rb') as f:
            wasm = f.read()
        old_ranges = bytes.fromhex('00000000010000005b00000064000000')
        new_ranges = bytes.fromhex('000000005b0000005b00000064000000')
        self.assertEqual(wasm.count(old_ranges), 1)
        wasm = wasm.replace(old_ranges, new_ranges)

        with tempfile.TemporaryDirectory() as temp_dir:
            input_file = os.path.join(temp_dir, 'input.wasm')
            output_file = os.path.join(temp_dir, 'output.wasm')
            with open(input_file, 'wb') as f:
                f.write(wasm)
            shared.run_process(shared.WASM_OPT +
                               [input_file, '--roundtrip', '-g',
                                '-o', output_file])
            dump = shared.run_process(shared.WASM_OPT +
                                      [output_file, '--dwarfdump'],
                                      capture_output=True).stdout
            ranges = dump.split('.debug_ranges contents:', 1)[1]
            self.assertRegex(
                '\n'.join(ranges.splitlines()),
                r'(?m)^00000000 00000000 (?!00000000)[0-9a-f]{8}$')

    def test_tombstone_roundtrip(self):
        def custom_section(name, contents):
            name = name.encode()
            payload = bytes([len(name)]) + name + contents
            self.assertLess(len(payload), 128)
            return bytes([0, len(payload)]) + payload

        # A minimal DWARF v4 unit whose compile unit and subprogram both use
        # the all-ones dead-address sentinel for DW_AT_low_pc.
        sections = {
            '.debug_abbrev': '011101030e110112060000022e0011011206030e000000',
            '.debug_info': ('22000000040000000000040100000000ffffffff'
                            '0300000002ffffffff030000000f00000000'),
            '.debug_str': '746573742d636c616e672e63707000666f6f00',
        }
        wasm = bytes.fromhex('0061736d01000000')
        for name, contents in sections.items():
            wasm += custom_section(name, bytes.fromhex(contents))

        with tempfile.TemporaryDirectory() as temp_dir:
            input_file = os.path.join(temp_dir, 'input.wasm')
            output_file = os.path.join(temp_dir, 'output.wasm')
            with open(input_file, 'wb') as f:
                f.write(wasm)
            shared.run_process(shared.WASM_OPT +
                               [input_file, '--roundtrip', '-g',
                                '-o', output_file])
            dump = shared.run_process(shared.WASM_OPT +
                                      [output_file, '--dwarfdump'],
                                      capture_output=True).stdout
            self.assertEqual(dump.count('0x00000000ffffffff'), 2)

    def test_missing_start_with_mapped_end(self):
        # The unused subprogram starts at zero (no location mapping). Point its
        # relative high_pc at the end of the preceding live subprogram. The
        # surviving end must not make the missing start look like a live scope.
        path = os.path.join(shared.options.binaryen_test, 'passes',
                            'ignore_missing_func_dwarf.wasm')
        with open(path, 'rb') as f:
            wasm = f.read()
        old_pair = bytes.fromhex('000000005a000000')
        self.assertEqual(wasm.count(old_pair), 1)
        wasm = wasm.replace(old_pair, bytes.fromhex('000000005f000000'))

        with tempfile.TemporaryDirectory() as temp_dir:
            input_file = os.path.join(temp_dir, 'input.wasm')
            output_file = os.path.join(temp_dir, 'output.wasm')
            with open(input_file, 'wb') as f:
                f.write(wasm)
            shared.run_process(shared.WASM_OPT +
                               [input_file, '--roundtrip', '-g',
                                '-o', output_file])
            dump = shared.run_process(shared.WASM_OPT +
                                      [output_file, '--dwarfdump'],
                                      capture_output=True).stdout
            unused = next(part for part in dump.split('DW_TAG_subprogram')
                          if '"unused"' in part)
            self.assertIn('DW_AT_low_pc [DW_FORM_addr]\t'
                          '(0x00000000ffffffff)', unused)

    def test_memory64_range_list_fallback(self):
        # This fixture is a two-function wasm64 module with a DWARF v4 CU and
        # .debug_ranges, compiled using clang --target=wasm64-unknown-unknown
        # -O1 -g. The vendored emitter still writes 4-byte range entries, so
        # range-list repair must not append an invalid 8-byte-CU offset.
        input_file = self.input_path('dwarf/memory64_ranges.wasm')
        with tempfile.TemporaryDirectory() as temp_dir:
            output_file = os.path.join(temp_dir, 'output.wasm')
            shared.run_process(shared.WASM_OPT +
                               [input_file, '--roundtrip', '-g',
                                '-o', output_file])
            dump = shared.run_process(shared.WASM_OPT +
                                      [output_file, '--dwarfdump'],
                                      capture_output=True).stdout
            self.assertIn('DW_AT_ranges [DW_FORM_sec_offset]\t(0x00000000',
                          dump)

    def test_no_crash(self):
        # run dwarf processing on some interesting large files, too big to be
        # worth putting in passes where the text output would be massive. We
        # just check that no assertion are hit.
        path = self.input_path('dwarf')
        for name in os.listdir(path):
            if not name.endswith('.wasm'):
                continue
            args = [os.path.join(path, name)] + \
                   ['-g', '--dwarfdump', '--roundtrip', '--dwarfdump']
            shared.run_process(shared.WASM_OPT + args, capture_output=True)

    def test_dwarf_incompatibility(self):
        warning = 'not fully compatible with DWARF'
        path = self.input_path(os.path.join('dwarf', 'cubescript.wasm'))
        args = [path, '-g']
        # flatten warns
        err = shared.run_process(shared.WASM_OPT + args + ['--flatten'], stderr=subprocess.PIPE).stderr
        self.assertIn(warning, err)
        # safe passes do not
        err = shared.run_process(shared.WASM_OPT + args + ['--metrics'], stderr=subprocess.PIPE).stderr
        self.assertNotIn(warning, err)

    def test_strip_dwarf_and_opts(self):
        # some optimizations are disabled when DWARF is present (as they would
        # destroy it). we scan the wasm to see if there is any DWARF when
        # making the decision whether to run them. this test checks that we also
        # check if --strip* is being run, which would remove the DWARF anyhow
        path = self.input_path(os.path.join('dwarf', 'cubescript.wasm'))
        # strip the DWARF, then run all the opts to check as much as possible
        args = [path, '--strip-dwarf', '-Oz']
        # run it normally, without -g. in this case no DWARF will be preserved
        # in a trivial way
        shared.run_process(shared.WASM_OPT + args + ['-o', 'a.wasm'])
        # run it with -g. in this case we need to be clever as described above,
        # and see --strip-dwarf removes the need for DWARF
        shared.run_process(shared.WASM_OPT + args + ['-o', 'b.wasm', '-g'])
        # run again on the last output without -g, as we don't want the names
        # section to skew the results
        shared.run_process(shared.WASM_OPT + ['b.wasm', '-o', 'c.wasm'])
        # compare the sizes. there might be a tiny difference in size to to
        # minor roundtrip changes, so ignore up to a tiny %
        a_size = os.path.getsize('a.wasm')
        c_size = os.path.getsize('c.wasm')
        self.assertLess((100 * abs(a_size - c_size)) / c_size, 1)
