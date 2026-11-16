import os
import subprocess
import tempfile

from scripts.test import shared

from . import utils


class DWARFTest(utils.BinaryenTestCase):
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
