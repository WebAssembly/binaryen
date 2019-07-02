import os

from scripts.test.shared import WASM_OPT, WASM_DIS, WASM_SHELL, NODEJS, run_process
from utils import BinaryenTestCase


class BysyncifyTest(BinaryenTestCase):
  def test_bysyncify_js(self):
    def test(args):
      print(args)
      run_process(WASM_OPT + args + [self.input_path('bysyncify-sleep.wast'), '--bysyncify', '-o', 'a.wasm'])
      run_process(WASM_OPT + args + [self.input_path('bysyncify-coroutine.wast'), '--bysyncify', '-o', 'b.wasm'])
      run_process(WASM_OPT + args + [self.input_path('bysyncify-stackOverflow.wast'), '--bysyncify', '-o', 'c.wasm'])
      print('  file size: %d' % os.path.getsize('a.wasm'))
      run_process([NODEJS, self.input_path('bysyncify.js')])

    test(['-g'])
    test([])
    test(['-O1'])
    test(['--optimize-level=1'])
    test(['-O3'])
    test(['-Os', '-g'])

  def test_bysyncify_pure_wasm(self):
    run_process(WASM_OPT + [self.input_path('bysyncify-pure.wast'), '--bysyncify', '-o', 'a.wasm'])
    run_process(WASM_DIS + ['a.wasm', '-o', 'a.wast'])
    output = run_process(WASM_SHELL + ['a.wast'], capture_output=True).stdout
    with open(self.input_path('bysyncify-pure.txt')) as f:
      self.assertEqual(f.read(), output)
