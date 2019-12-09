import subprocess

from scripts.test import shared
from . import utils


class WarningsText(utils.BinaryenTestCase):
    def test_warn_on_no_passes(self):
        err = shared.run_process(shared.WASM_OPT + [self.input_path('asyncify-pure.wat'), '-o', 'a.wasm'], stderr=subprocess.PIPE).stderr
        self.assertIn('warning: no passes specified, not doing any work', err)

    def test_warn_on_no_output(self):
        err = shared.run_process(shared.WASM_OPT + [self.input_path('asyncify-pure.wat'), '-O1'], stderr=subprocess.PIPE).stderr
        self.assertIn('warning: no output file specified, not emitting output', err)

    def test_quiet_suppresses_warnings(self):
        err = shared.run_process(shared.WASM_OPT + [self.input_path('asyncify-pure.wat'), '-q'], stderr=subprocess.PIPE).stderr
        self.assertNotIn('warning', err)
