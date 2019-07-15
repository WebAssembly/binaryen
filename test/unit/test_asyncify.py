import os

from scripts.test.shared import WASM_OPT, WASM_DIS, WASM_SHELL, NODEJS, run_process
from utils import BinaryenTestCase


class AsyncifyTest(BinaryenTestCase):
  def test_asyncify_js(self):
    def test(args):
      print(args)
      run_process(WASM_OPT + args + [self.input_path('asyncify-sleep.wast'), '--asyncify', '-o', 'a.wasm'])
      run_process(WASM_OPT + args + [self.input_path('asyncify-coroutine.wast'), '--asyncify', '-o', 'b.wasm'])
      run_process(WASM_OPT + args + [self.input_path('asyncify-stackOverflow.wast'), '--asyncify', '-o', 'c.wasm'])
      print('  file size: %d' % os.path.getsize('a.wasm'))
      run_process([NODEJS, self.input_path('asyncify.js')])

    test(['-g'])
    test([])
    test(['-O1'])
    test(['--optimize-level=1'])
    test(['-O3'])
    test(['-Os', '-g'])

  def test_asyncify_pure_wasm(self):
    run_process(WASM_OPT + [self.input_path('asyncify-pure.wast'), '--asyncify', '-o', 'a.wasm'])
    run_process(WASM_DIS + ['a.wasm', '-o', 'a.wast'])
    output = run_process(WASM_SHELL + ['a.wast'], capture_output=True).stdout
    with open(self.input_path('asyncify-pure.txt')) as f:
      self.assertEqual(f.read(), output)
