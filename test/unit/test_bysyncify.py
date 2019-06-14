import os

from scripts.test.shared import WASM_OPT, NODEJS, run_process
from utils import BinaryenTestCase


class BysyncifyTest(BinaryenTestCase):
  def test_bysyncify(self):
    def test(args):
      print(args)
      run_process(WASM_OPT + args + [self.input_path('bysyncify.wast'), '--bysyncify', '-o', 'a.wasm'])
      print('  file size: %d' % os.path.getsize('a.wasm'))
      run_process([NODEJS, self.input_path('bysyncify.js')])

    test(['-g'])
    test([])
    test(['-O1'])
    test(['--optimize-level=1'])
    test(['-O3'])
    test(['-Os', '-g'])
