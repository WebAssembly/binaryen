import os
import shutil
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


def read_uleb(data, pos):
    value, shift = 0, 0
    while True:
        byte = data[pos]
        pos += 1
        value |= (byte & 127) << shift
        if byte < 128:
            return value, pos
        shift += 7


def word(value):
    return value.to_bytes(4, 'little')


def sections(wasm):
    result = {}
    pos = 8
    while pos < len(wasm):
        kind = wasm[pos]
        size, pos = read_uleb(wasm, pos + 1)
        end = pos + size
        if kind == 0:
            length, pos = read_uleb(wasm, pos)
            result[wasm[pos:pos + length].decode()] = wasm[pos + length:end]
        else:
            result[kind] = wasm[pos:end]
        pos = end
    return result


def custom(name, contents):
    name = name.encode()
    payload = uleb(len(name)) + name + contents
    return b'\0' + uleb(len(payload)) + payload


def local(index):
    return b'\xed\0' + uleb(index) + b'\x9f'


class DWARFLocalsTest(utils.BinaryenTestCase):
    def verify_dwarf(self, path):
        # Keep the structural assertions runnable without an LLVM installation,
        # and also check the complete output when the independent verifier exists.
        verifier = shutil.which('llvm-dwarfdump')
        if verifier:
            shared.run_process([verifier, '--verify', path])

    def fixture(self, path, count, extra=()):
        # All locals survive; the last local is the most frequent. A final
        # unused local must become unavailable, not silently become local 0.
        module = '(module (import "env" "touch" (func $touch (param i32) (result i32)))'
        module += '(func (export "run") (param $p i32) (result i32)'
        module += ' (local i32)' * (count + 1)
        for i in range(1, count + 1):
            module += f' (local.set {i} (call $touch (i32.const {i})))'
            module += f' (drop (local.get {i}))'
        module += f' (drop (local.get {count}))' * 3
        module += ' (local.get $p)))'
        shared.run_process(shared.WASM_OPT + ['-o', path], input=module)
        with open(path, 'rb') as f:
            wasm = f.read()
        code = sections(wasm)[10]
        _, pos = read_uleb(code, 0)
        size, start = read_uleb(code, pos)
        end = start + size

        # DWARF 4: CU, subprogram, inline variable, list variable, base type.
        abbrev = bytes.fromhex(
            '0111010000'
            '022e010308110112060000'
            '0334000308021849130000'
            '0434000308021749130000'
            '05240003083e0b0b0b000000')
        info = bytearray(b'\x01\x02run\0' + word(start) + word(end - start))
        locations = bytearray()
        refs = []
        expected = {}
        expressions = [('p', local(0), local(0))]
        expressions += [(f'v{i}', local(i), local(1 if i == count else i + 1))
                        for i in range(1, count + 1)]
        expressions += [('dead', local(count + 1), b'')]
        expressions += list(extra)
        for name, expression, result in expressions:
            for kind in (3, 4):
                full_name = f'{name}_{kind}'
                info += bytes([kind]) + full_name.encode() + b'\0'
                if kind == 3:
                    info += uleb(len(expression)) + expression
                else:
                    info += word(len(locations))
                    locations += word(0xffffffff) + word(0)
                    locations += word(start) + word(end)
                    locations += len(expression).to_bytes(2, 'little') + expression
                    locations += bytes(8)
                refs.append(len(info))
                info += bytes(4)
                expected[full_name] = result
        info += b'\0'  # end subprogram
        type_offset = 11 + len(info)
        info += b'\x05int\0\x05\x04\0'
        for pos in refs:
            info[pos:pos + 4] = word(type_offset)
        unit = b'\x04\0' + word(0) + b'\x04' + info
        wasm += custom('.debug_abbrev', abbrev)
        wasm += custom('.debug_info', word(len(unit)) + unit)
        wasm += custom('.debug_loc', locations)
        with open(path, 'wb') as f:
            f.write(wasm)
        return expected

    def check_variables(self, path, expected):
        with open(path, 'rb') as f:
            parts = sections(f.read())
        info, locs = parts['.debug_info'], parts.get('.debug_loc', b'')
        start = 0
        while start < len(info):
            end = start + int.from_bytes(info[start:start + 4], 'little') + 4
            self.check_unit(info[start:end], locs, expected)
            start = end
        self.assertEqual(start, len(info))

    def check_unit(self, info, locs, expected):
        pos = 12 if info[4:6] == b'\x05\0' else 11
        found = {}
        references = []
        type_offset = None
        while pos < len(info):
            offset = pos
            kind, pos = read_uleb(info, pos)
            if kind in {0, 1}:
                continue
            end = info.index(0, pos)
            name = info[pos:end].decode()
            pos = end + 1
            if kind == 2:
                pos += 8
                continue
            if kind == 5:
                self.assertEqual(name, 'int')
                type_offset = offset
                pos += 2
                continue
            if kind == 3:
                size, pos = read_uleb(info, pos)
                expression = info[pos:pos + size]
                pos += size
            else:
                self.assertEqual(kind, 4)
                loc = int.from_bytes(info[pos:pos + 4], 'little')
                pos += 4
                self.assertEqual(locs[loc:loc + 4], word(0xffffffff))
                while locs[loc:loc + 4] == word(0xffffffff):
                    loc += 8
                self.assertLessEqual(loc + 10, len(locs))
                size = int.from_bytes(locs[loc + 8:loc + 10], 'little')
                expression = locs[loc + 10:loc + 10 + size]
                self.assertEqual(len(expression), size)
                self.assertEqual(locs[loc + 10 + size:loc + 18 + size], bytes(8))
            found[name] = expression
            references.append(int.from_bytes(info[pos:pos + 4], 'little'))
            pos += 4
        self.assertEqual(found, expected)
        self.assertTrue(all(ref == type_offset for ref in references))

    def test_reorder_local_locations(self):
        for count in (2, 130):
            for options in ([], ['--generate-stack-ir']):
                with self.subTest(count=count, options=options), \
                        tempfile.TemporaryDirectory() as directory:
                    path = os.path.join(directory, 'input.wasm')
                    out = os.path.join(directory, 'output.wasm')
                    expected = self.fixture(path, count)
                    # Repeat the pass in memory, then read and write the output
                    # again. Neither may apply the permutation twice.
                    for source in (path, out):
                        shared.run_process(shared.WASM_OPT +
                                           [source, '-g', '--reorder-locals',
                                            '--reorder-locals', '-o', out] + options)
                        self.check_variables(out, expected)

    def test_expression_operands(self):
        def nested(expr):
            return b'\xf3' + uleb(len(expr)) + expr

        # 127 -> 128 grows by one byte. Test pieces, entry values and branch
        # displacements, while not treating a literal 0xed byte as an opcode.
        old, new = local(127), local(128)
        extras = [
            ('pieces', old + b'\x93\x04' + local(130) + b'\x93\x04',
             new + b'\x93\x04' + local(1) + b'\x93\x04'),
            ('entry', nested(old), nested(new)),
            ('branch', b'\x30\x28' + len(old).to_bytes(2, 'little') + old + b'\x96',
             b'\x30\x28' + len(new).to_bytes(2, 'little') + new + b'\x96'),
            ('constant', b'\x9e\x04\xed\0\x7f\x9f', b'\x9e\x04\xed\0\x7f\x9f'),
            ('global', b'\xed\x01\x7f\x9f', b'\xed\x01\x7f\x9f'),
            ('global32', b'\xed\x03\x7f\0\0\0\x9f', b'\xed\x03\x7f\0\0\0\x9f'),
            ('stack', b'\xed\x02\x7f\x9f', b'\xed\x02\x7f\x9f'),
        ]
        with tempfile.TemporaryDirectory() as directory:
            path = os.path.join(directory, 'input.wasm')
            out = os.path.join(directory, 'output.wasm')
            expected = self.fixture(path, 130, extras)
            shared.run_process(shared.WASM_OPT +
                               [path, '-g', '--reorder-locals', '-o', out])
            self.check_variables(out, expected)

    def test_optimized_out_locals(self):
        with tempfile.TemporaryDirectory() as directory:
            path = os.path.join(directory, 'input.wasm')
            out = os.path.join(directory, 'output.wasm')
            expected = self.fixture(path, 2)
            # O1 removes unused sets but keeps the imported calls. Only the
            # parameter still has a location after ReorderLocals drops vars.
            expected = {name: value if name.startswith('p_') else b''
                        for name, value in expected.items()}
            shared.run_process(shared.WASM_OPT + [path, '-g', '-O1', '-o', out])
            self.check_variables(out, expected)

    def test_reorder_across_coalescing(self):
        with tempfile.TemporaryDirectory() as directory:
            path = os.path.join(directory, 'input.wasm')
            out = os.path.join(directory, 'output.wasm')
            expected = self.fixture(path, 130)
            expected = {name: value if name.startswith(('p_', 'dead_')) else local(1)
                        for name, value in expected.items()}
            # Asyncify runs coalescing internally even when DWARF is present.
            # A later permutation must compose with that smaller local space.
            shared.run_process(shared.WASM_OPT +
                               [path, '-g', '--reorder-locals', '--coalesce-locals',
                                '--reorder-locals', '-o', out])
            self.check_variables(out, expected)

    def test_multiple_units_and_public_types(self):
        with tempfile.TemporaryDirectory() as directory:
            path = os.path.join(directory, 'input.wasm')
            out = os.path.join(directory, 'output.wasm')
            expected = self.fixture(path, 130)
            with open(path, 'rb') as f:
                wasm = f.read()
            parts = sections(wasm)
            info = parts['.debug_info']
            second = len(info)
            type_offset = info.index(b'\x05int\0')
            pub = b'\x02\0' + word(second) + word(len(info))
            pub += word(type_offset) + b'int\0' + bytes(4)
            # Two CUs share the location lists but have CU-relative type
            # references. Shrinking inline expressions moves both CUs' DIEs.
            wasm = wasm.replace(custom('.debug_info', info),
                                custom('.debug_info', info + info))
            wasm += custom('.debug_pubtypes', word(len(pub)) + pub)
            with open(path, 'wb') as f:
                f.write(wasm)
            shared.run_process(shared.WASM_OPT +
                               [path, '-g', '--reorder-locals', '-o', out])
            self.check_variables(out, expected)
            with open(out, 'rb') as f:
                parts = sections(f.read())
            info, pub = parts['.debug_info'], parts['.debug_pubtypes']
            second = int.from_bytes(info[:4], 'little') + 4
            self.assertEqual(int.from_bytes(pub[6:10], 'little'), second)
            self.assertEqual(int.from_bytes(pub[10:14], 'little'), len(info) - second)
            target = int.from_bytes(pub[14:18], 'little') + second
            self.assertEqual(info[target:target + 5], b'\x05int\0')

    def test_short_forms_grow(self):
        for block_length, ref_width in ((42, 4), (8, 1)):
            with self.subTest(block_length=block_length, ref_width=ref_width), \
                    tempfile.TemporaryDirectory() as directory:
                path = os.path.join(directory, 'input.wasm')
                out = os.path.join(directory, 'output.wasm')
                self.fixture(path, 130)
                with open(path, 'rb') as f:
                    wasm = f.read()
                parts = sections(wasm)
                old = (local(127) + b'\x93\x04') * block_length
                new = (local(128) + b'\x93\x04') * block_length
                # Preserve the CU/subprogram headers, then use one variable.
                prefix = parts['.debug_info'][11:25]
                name = 'v'
                if ref_width == 1:
                    # Position the type at 255, so growing the location also
                    # forces its one-byte DIE reference to widen.
                    name *= 255 - (11 + len(prefix) + 1 + 1 + 1 + len(old) + 1 + 1)
                info = bytearray(prefix + b'\x03' + name.encode() + b'\0')
                info += bytes([len(old)]) + old
                ref = len(info)
                info += bytes(ref_width) + b'\0'
                target = 11 + len(info)
                info += b'\x05int\0\x05\x04\0'
                info[ref:ref + ref_width] = target.to_bytes(ref_width, 'little')
                if ref_width == 1:
                    self.assertEqual(target, 255)
                unit = b'\x04\0' + word(0) + b'\x04' + info
                abbrev = parts['.debug_abbrev'].replace(
                    b'\x02\x18\x49\x13', b'\x02\x0a\x49' + bytes([0x11 if ref_width == 1 else 0x13]))
                for section, contents in (
                        ('.debug_info', word(len(unit)) + unit),
                        ('.debug_abbrev', abbrev), ('.debug_loc', b'')):
                    wasm = wasm.replace(custom(section, parts[section]), custom(section, contents))
                with open(path, 'wb') as f:
                    f.write(wasm)
                shared.run_process(shared.WASM_OPT +
                                   [path, '-g', '--reorder-locals', '-o', out])
                self.check_variables(out, {name: new})

    def test_legacy_location_forms(self):
        with tempfile.TemporaryDirectory() as directory:
            path = os.path.join(directory, 'input.wasm')
            out = os.path.join(directory, 'output.wasm')
            expected = self.fixture(path, 130)
            with open(path, 'rb') as f:
                wasm = f.read()
            parts = sections(wasm)
            info = parts['.debug_info']
            info = info[:4] + b'\x03\0' + info[6:]
            # Before DWARF 4, location lists use data4 instead of sec_offset,
            # and inline expressions use block rather than exprloc.
            abbrev = parts['.debug_abbrev'].replace(b'\x02\x18', b'\x02\x09')
            abbrev = abbrev.replace(b'\x02\x17', b'\x02\x06')
            for section, contents in (('.debug_info', info), ('.debug_abbrev', abbrev)):
                wasm = wasm.replace(custom(section, parts[section]), custom(section, contents))
            with open(path, 'wb') as f:
                f.write(wasm)
            shared.run_process(shared.WASM_OPT +
                               [path, '-g', '--reorder-locals', '-o', out])
            self.check_variables(out, expected)

    def test_location_list_suffix(self):
        with tempfile.TemporaryDirectory() as directory:
            path = os.path.join(directory, 'input.wasm')
            out = os.path.join(directory, 'output.wasm')
            expected = self.fixture(path, 130, [('head', local(130), local(1)),
                                                ('suffix', local(130), local(1))])
            with open(path, 'rb') as f:
                wasm = f.read()
            parts = sections(wasm)
            info = bytearray(parts['.debug_info'])
            field = info.index(b'suffix_4\0') + len(b'suffix_4\0')
            offset = int.from_bytes(info[field:field + 4], 'little')
            # A list reference can start at an interior entry. Prepend a base
            # entry and refer past it, keeping an explicit base at that suffix.
            # Earlier lists change size, so preserving the old offset is wrong.
            info[field:field + 4] = word(offset + 8)
            head = info.index(b'head_4\0') + len(b'head_4\0')
            info[head:head + 4] = word(offset)
            locs = parts['.debug_loc']
            locs = locs[:offset] + word(0xffffffff) + word(0) + locs[offset:]
            for section, contents in (('.debug_info', info), ('.debug_loc', locs)):
                wasm = wasm.replace(custom(section, parts[section]), custom(section, contents))
            with open(path, 'wb') as f:
                f.write(wasm)
            self.verify_dwarf(path)
            shared.run_process(shared.WASM_OPT + [path, '-g', '--reorder-locals', '-o', out])
            self.check_variables(out, expected)
            self.verify_dwarf(out)

    def test_expression_references(self):
        expressions = {
            'implicit_pointer': lambda _t, v: b'\xa0' + word(v) + b'\0',
            'convert': lambda t, _v: b'\x10\x2a\xa8' + uleb(t) + b'\x9f',
            'reinterpret': lambda t, _v: b'\x10\x2a\xa8' + uleb(t) + b'\xa9' + uleb(t) + b'\x9f',
            'const_type': lambda t, _v: b'\xa4' + uleb(t) + b'\x04\x2a\0\0\0\x9f',
            'regval_type': lambda t, _v: b'\xa5\0' + uleb(t) + b'\x9f',
            'deref_type': lambda t, _v: b'\x30\xa6\x04' + uleb(t) + b'\x9f',
            'xderef_type': lambda t, _v: b'\x30\x30\xa7\x04' + uleb(t) + b'\x9f',
            'call2': lambda _t, v: b'\x98' + v.to_bytes(2, 'little'),
            'call4': lambda _t, v: b'\x99' + word(v),
            'call_ref': lambda _t, v: b'\x9a' + word(v),
            # Zero is the generic type, not a DIE reference.
            'generic_type': lambda _t, _v: b'\x30\xa8\0\x9f',
        }
        for name, expression in expressions.items():
            with self.subTest(expression=name), tempfile.TemporaryDirectory() as directory:
                path = os.path.join(directory, 'input.wasm')
                out = os.path.join(directory, 'output.wasm')
                self.fixture(path, 130)
                with open(path, 'rb') as f:
                    wasm = f.read()
                parts = sections(wasm)
                info = bytearray(parts['.debug_info'][11:25])
                refs = []

                def variable(name, value):
                    info.extend(b'\x03' + name.encode() + b'\0' + uleb(len(value)) + value)
                    refs.append(len(info))
                    info.extend(bytes(4))

                variable('grow', local(127))
                target = 12 + len(info)
                variable('target', local(0))
                prefix = len(info)
                variable('other', expression(1, target))
                info += b'\0'
                type_offset = 12 + len(info)
                self.assertLess(type_offset + 1, 128)
                # Replace the one-byte type placeholder without changing layout.
                info[prefix:] = (b'\x03other\0' + uleb(len(expression(type_offset, target))) +
                                 expression(type_offset, target) + word(type_offset) + b'\0')
                info += b'\x05int\0\x05\x04\0'
                for ref in refs:
                    info[ref:ref + 4] = word(type_offset)
                unit = b'\x05\0\x01\x04' + word(0) + info
                wasm = wasm.replace(custom('.debug_info', parts['.debug_info']),
                                    custom('.debug_info', word(len(unit)) + unit))
                wasm = wasm.replace(custom('.debug_loc', parts['.debug_loc']), b'')
                with open(path, 'wb') as f:
                    f.write(wasm)
                # LLVM's external decoder does not yet support all typed ops;
                # the structural/operand assertions below still cover them.
                verify = name not in {'const_type', 'deref_type', 'xderef_type', 'reinterpret'}
                if verify:
                    self.verify_dwarf(path)
                shared.run_process(shared.WASM_OPT + [path, '-g', '--reorder-locals', '-o', out])
                self.check_variables(out, {'grow': local(128), 'target': local(0),
                                           'other': expression(type_offset + 1, target + 1)})
                if verify:
                    self.verify_dwarf(out)
