import os

from scripts.test import shared
from . import utils


class EmscriptenFinalizeTest(utils.BinaryenTestCase):
    def test_em_asm_mangled_string(self):
        p = shared.run_process(shared.WASM_EMSCRIPTEN_FINALIZE + [
            self.input_path('em_asm_mangled_string.wat'), '-o', os.devnull, '--global-base=1024'
        ], check=False, capture_output=True)
        self.assertNotEqual(p.returncode, 0)
        self.assertIn('Fatal: local.get of unknown in arg0 of call to emscripten_asm_const_int (used by EM_ASM* macros) in function main.', p.stderr)
        self.assertIn('This might be caused by aggressive compiler transformations. Consider using EM_JS instead.', p.stderr)

    def do_output_test(self, args):
        # without any output file specified, don't error, don't write the wasm,
        # but do emit metadata
        p = shared.run_process(shared.WASM_EMSCRIPTEN_FINALIZE + [
            self.input_path('empty_lld.wat'), '--global-base=1024'
        ] + args, capture_output=True)
        # metadata is always present
        self.assertIn('{', p.stdout)
        self.assertIn('}', p.stdout)
        return p.stdout

    def test_no_output(self):
        stdout = self.do_output_test([])
        # module is not present
        self.assertNotIn('(module', stdout)

    def test_text_output(self):
        stdout = self.do_output_test(['-S'])
        # module is present
        self.assertIn('(module', stdout)
