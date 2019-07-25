import os, subprocess

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

  def test_asyncify_list_bad(self):
    for arg, warning in [
      ('--pass-arg=asyncify-blacklist@nonexistent', 'nonexistent'),
      ('--pass-arg=asyncify-whitelist@nonexistent', 'nonexistent'),
      ('--pass-arg=asyncify-blacklist@main', None),
      ('--pass-arg=asyncify-whitelist@main', None),
    ]:
      print(arg, warning)
      err = run_process(WASM_OPT + [self.input_path('asyncify-pure.wast'), '--asyncify', arg], stdout=subprocess.PIPE, stderr=subprocess.PIPE).stderr.strip()
      if warning:
        assert 'warning' in err
        assert warning in err, [warning, err]
      else:
        assert 'warning' not in err

  def test_asyncify_blacklist_and_whitelist(self):
    try:
      run_process(WASM_OPT + [self.input_path('asyncify-pure.wast'), '--asyncify', '--pass-arg=asyncify-whitelist@main', '--pass-arg=asyncify-blacklist@main'])
    except:
      return
    raise Exception('unexpected pass')
