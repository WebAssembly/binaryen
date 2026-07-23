from scripts.test import shared

from . import utils


class CompactImportsTest(utils.BinaryenTestCase):
    def get_binary(self, wat_str, flags=[]):
        cmd = shared.WASM_OPT + ['--print-features', '-o', '-'] + flags
        p = shared.run_process(
            cmd, input=wat_str, check=True, capture_output=True, decode_output=False,
        )
        return p.stdout.encode('latin1') if isinstance(p.stdout, str) else p.stdout

    def test_shared_all_encoding(self):
        wat = '''(module
            (type $sig (func (param i32) (result i32)))
            (import "env" "f1" (func (type $sig)))
            (import "env" "f2" (func (type $sig)))
        )'''
        wasm_bytes = self.get_binary(wat, ['--enable-compact-imports'])
        # 0x7E is CompactImportsSharedAll
        self.assertIn(b'\x03env\x00\x7e', wasm_bytes)

    def test_shared_module_encoding(self):
        wat = '''(module
            (type $sig1 (func (param i32) (result i32)))
            (type $sig2 (func (param f64) (result f64)))
            (import "env" "f1" (func (type $sig1)))
            (import "env" "f2" (func (type $sig2)))
        )'''
        wasm_bytes = self.get_binary(wat, ['--enable-compact-imports'])
        # 0x7F is CompactImportsSharedModule
        self.assertIn(b'\x03env\x00\x7f', wasm_bytes)

    def test_disabled_compact_imports(self):
        wat = '''(module
            (type $sig (func (param i32) (result i32)))
            (import "env" "f1" (func (type $sig)))
            (import "env" "f2" (func (type $sig)))
        )'''
        wasm_bytes = self.get_binary(wat, ['--disable-compact-imports'])
        self.assertNotIn(b'\x03env\x00\x7e', wasm_bytes)
        self.assertNotIn(b'\x03env\x00\x7f', wasm_bytes)
        self.assertIn(b'\x03env\x02f1', wasm_bytes)
        self.assertIn(b'\x03env\x02f2', wasm_bytes)

    def test_mixed_import_patterns(self):
        wat = '''(module
            (type $sig1 (func (param i32) (result i32)))
            (type $sig2 (func (param f64) (result f64)))
            ;; Run 1: SharedAll for "env"
            (import "env" "f1" (func (type $sig1)))
            (import "env" "f2" (func (type $sig1)))
            ;; Run 2: SharedModule for "math" (different types)
            (import "math" "sin" (func (type $sig1)))
            (import "math" "sqrt" (func (type $sig2)))
            ;; Run 3: Single import for "single"
            (import "single" "m1" (memory 1 2))
        )'''
        wasm_bytes = self.get_binary(wat, ['--enable-compact-imports'])
        self.assertIn(b'\x03env\x00\x7e', wasm_bytes)
        self.assertIn(b'\x04math\x00\x7f', wasm_bytes)
        self.assertIn(b'\x06single\x02m1', wasm_bytes)

    def test_identical_imports_size_reduction(self):
        imports = '\n'.join(['(import "env" "f" (func (type $sig)))'] * 1000)
        wat = f'''(module
            (type $sig (func (param i32) (result i32)))
            {imports}
        )'''
        with_compact = self.get_binary(wat, ['--enable-compact-imports'])
        without_compact = self.get_binary(wat, ['--disable-compact-imports'])
        self.assertEqual(len(with_compact), 2098)
        self.assertEqual(len(without_compact), 8064)
