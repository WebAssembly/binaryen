import os
import subprocess
import tempfile

from scripts.test.shared import WASM_OPT, WASM_DIS, WASM_SHELL, NODEJS, run_process
from .utils import BinaryenTestCase


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
        with open(self.input_path('asyncify-pure.txt'), 'r') as f:
            self.assertEqual(f.read(), output)

    def test_asyncify_list_bad(self):
        for arg, warning in [
            ('--pass-arg=asyncify-blacklist@nonexistent', 'nonexistent'),
            ('--pass-arg=asyncify-whitelist@nonexistent', 'nonexistent'),
            ('--pass-arg=asyncify-blacklist@main', None),
            ('--pass-arg=asyncify-whitelist@main', None),
            ('--pass-arg=asyncify-blacklist@m*n', None),
            ('--pass-arg=asyncify-whitelist@m*n', None),
            ('--pass-arg=asyncify-whitelist@main*', None),
            ('--pass-arg=asyncify-whitelist@*main', None),
            ('--pass-arg=asyncify-blacklist@non*existent', 'non*existent'),
            ('--pass-arg=asyncify-whitelist@non*existent', 'non*existent'),
            ('--pass-arg=asyncify-whitelist@DOS_ReadFile(unsigned short, unsigned char*, unsigned short*, bool)', None),
        ]:
            print(arg, warning)
            err = run_process(WASM_OPT + [self.input_path('asyncify-pure.wast'), '--asyncify', arg], stdout=subprocess.PIPE, stderr=subprocess.PIPE).stderr.strip()
            if warning:
                self.assertIn('warning', err)
                self.assertIn(warning, err)
            else:
                self.assertNotIn('warning', err)

    def test_asyncify_blacklist_and_whitelist(self):
        proc = run_process(WASM_OPT + [self.input_path('asyncify-pure.wast'), '--asyncify', '--pass-arg=asyncify-whitelist@main', '--pass-arg=asyncify-blacklist@main'], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, check=False)
        self.assertNotEqual(proc.returncode, 0, 'must error on using both lists at once')
        self.assertIn('It makes no sense to use both a blacklist and a whitelist with asyncify', proc.stdout)

    def test_asyncify_imports(self):
        def test(args):
            return run_process(WASM_OPT + [self.input_path('asyncify-sleep.wast'), '--asyncify', '--print'] + args, stdout=subprocess.PIPE).stdout

        normal = test(['--pass-arg=asyncify-imports@env.sleep'])
        temp = tempfile.NamedTemporaryFile().name
        with open(temp, 'w') as f:
            f.write('env.sleep')
        response = test(['--pass-arg=asyncify-imports@@%s' % temp])
        self.assertEqual(normal, response)
        without = test(['--pass-arg=asyncify-imports@without.anything'])
        self.assertNotEqual(normal, without)
