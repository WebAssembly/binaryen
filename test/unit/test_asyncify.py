import os
import subprocess
import tempfile

from scripts.test import shared
from . import utils


class AsyncifyTest(utils.BinaryenTestCase):
    def test_asyncify_js(self):
        def test(args):
            print(args)
            shared.run_process(shared.WASM_OPT + args + [self.input_path('asyncify-sleep.wat'), '--asyncify', '-o', 'a.wasm'])
            shared.run_process(shared.WASM_OPT + args + [self.input_path('asyncify-coroutine.wat'), '--asyncify', '-o', 'b.wasm'])
            shared.run_process(shared.WASM_OPT + args + [self.input_path('asyncify-stackOverflow.wat'), '--asyncify', '-o', 'c.wasm'])
            print('  file size: %d' % os.path.getsize('a.wasm'))
            shared.run_process([shared.NODEJS, self.input_path('asyncify.js')])

        test(['-g'])
        test([])
        test(['-O1'])
        test(['--optimize-level=1'])
        test(['-O3'])
        test(['-Os', '-g'])

    def test_asyncify_pure_wasm(self):
        shared.run_process(shared.WASM_OPT + [self.input_path('asyncify-pure.wat'), '--asyncify', '-o', 'a.wasm'])
        shared.run_process(shared.WASM_DIS + ['a.wasm', '-o', 'a.wat'])
        output = shared.run_process(shared.WASM_SHELL + ['a.wat'], capture_output=True).stdout
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
            err = shared.run_process(shared.WASM_OPT + ['-q', self.input_path('asyncify-pure.wat'), '--asyncify', arg], stdout=subprocess.PIPE, stderr=subprocess.PIPE).stderr.strip()
            if warning:
                self.assertIn('warning', err)
                self.assertIn(warning, err)
            else:
                self.assertNotIn('warning', err)

    def test_asyncify_blacklist_and_whitelist(self):
        proc = shared.run_process(shared.WASM_OPT + [self.input_path('asyncify-pure.wat'), '--asyncify', '--pass-arg=asyncify-whitelist@main', '--pass-arg=asyncify-blacklist@main'], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, check=False)
        self.assertNotEqual(proc.returncode, 0, 'must error on using both lists at once')
        self.assertIn('It makes no sense to use both a blacklist and a whitelist with asyncify', proc.stdout)

    def test_asyncify_imports(self):
        def test(args):
            return shared.run_process(shared.WASM_OPT + [self.input_path('asyncify-sleep.wat'), '--asyncify', '--print'] + args, stdout=subprocess.PIPE).stdout

        normal = test(['--pass-arg=asyncify-imports@env.sleep'])
        temp = tempfile.NamedTemporaryFile().name
        with open(temp, 'w') as f:
            f.write('env.sleep')
        response = test(['--pass-arg=asyncify-imports@@%s' % temp])
        self.assertEqual(normal, response)
        without = test(['--pass-arg=asyncify-imports@without.anything'])
        self.assertNotEqual(normal, without)
