import os
import subprocess
import tempfile

from scripts.test.shared import WASM_OPT, WASM_DIS, WASM_SHELL, NODEJS, run_process
from .utils import BinaryenTestCase


class WarningsText(BinaryenTestCase):
    def test_warn_on_no_passes(self):
        err = run_process(WASM_OPT + [self.input_path('asyncify-pure.wast'), '-o', 'a.wasm'], stderr=subprocess.PIPE).stderr
        self.assertIn('warning: no passes specified, not doing any work', err)

    def test_warn_on_no_output(self):
        err = run_process(WASM_OPT + [self.input_path('asyncify-pure.wast'), '-O1'], stderr=subprocess.PIPE).stderr
        self.assertIn('warning: no output file specified, not emitting output', err)

    def test_quiet_suppresses_warnings(self):
        err = run_process(WASM_OPT + [self.input_path('asyncify-pure.wast')], stderr=subprocess.PIPE).stderr
        self.assertNotIn('warning', err)
