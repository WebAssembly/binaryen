from scripts.test import shared
from . import utils


class EmscriptenFinalizeTest(utils.BinaryenTestCase):
    def do_output_test(self, args):
        # without any output file specified, don't error, don't write the wasm
        p = shared.run_process(shared.WASM_EMSCRIPTEN_FINALIZE + [
            self.input_path('empty_lld.wat'), '--global-base=1024'
        ] + args, capture_output=True)
        return p.stdout

    def test_no_output(self):
        stdout = self.do_output_test([])
        # module is not present
        self.assertNotIn('(module', stdout)

    def test_text_output(self):
        stdout = self.do_output_test(['-S'])
        # module is present
        self.assertIn('(module', stdout)
