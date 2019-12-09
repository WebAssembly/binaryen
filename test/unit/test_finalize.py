import os

from scripts.test import shared
from . import utils


class EmscriptenFinalizeTest(utils.BinaryenTestCase):
    def test_em_asm_mangled_string(self):
        input_dir = os.path.dirname(__file__)
        p = shared.run_process(shared.WASM_EMSCRIPTEN_FINALIZE + [
            os.path.join(input_dir, 'input', 'em_asm_mangled_string.wat'), '-o', os.devnull, '--global-base=1024'
        ], check=False, capture_output=True)
        self.assertNotEqual(p.returncode, 0)
        self.assertIn('Fatal: local.get of unknown in arg0 of call to emscripten_asm_const_int (used by EM_ASM* macros) in function main.', p.stderr)
        self.assertIn('This might be caused by aggressive compiler transformations. Consider using EM_JS instead.', p.stderr)
