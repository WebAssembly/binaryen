from scripts.test.shared import WASM_EMSCRIPTEN_FINALIZE, run_process
from .utils import BinaryenTestCase
import os


class EmscriptenFinalizeTest(BinaryenTestCase):
    def test_em_asm_mangled_string(self):
        input_dir = os.path.dirname(__file__)
        p = run_process(WASM_EMSCRIPTEN_FINALIZE + [
            os.path.join(input_dir, 'input', 'em_asm_mangled_string.wast'), '-o', os.devnull, '--global-base=1024'
        ], check=False, capture_output=True)
        self.assertNotEqual(p.returncode, 0)
        self.assertIn('Fatal: local.get of unknown in arg0 of call to $emscripten_asm_const_int (used by EM_ASM* macros) in function $main.', p.stderr)
        self.assertIn('This might be caused by aggressive compiler transformations. Consider using EM_JS instead.', p.stderr)
