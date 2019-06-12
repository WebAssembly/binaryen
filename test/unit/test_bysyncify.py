from scripts.test.shared import WASM_OPT, NODEJS, run_process
from utils import BinaryenTestCase


class BysyncifyTest(BinaryenTestCase):
  def test_bysyncify(self):
    run_process(WASM_OPT + [self.input_path('bysyncify.wast'), '--bysyncify', '-o', 'a.wasm', '-g'])
    run_process([NODEJS, self.input_path('bysyncify.js')])
