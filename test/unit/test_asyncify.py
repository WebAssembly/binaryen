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
            if shared.NODEJS:
                shared.run_process([shared.NODEJS, self.input_path('asyncify.js')])

        test(['-g'])
        test([])
        test(['-O1'])
        test(['--optimize-level=1'])
        test(['-O3'])
        test(['-Os', '-g'])

    def test_asyncify_pure_wasm(self):
        def test(input_file):
            shared.run_process(shared.WASM_OPT + [input_file, '--asyncify', '-o', 'a.wasm'])
            shared.run_process(shared.WASM_DIS + ['a.wasm', '-o', 'a.wat'])
            output = shared.run_process(shared.WASM_SHELL + ['a.wat'], capture_output=True).stdout
            with open(self.input_path('asyncify-pure.txt'), 'r') as f:
                self.assert_equal_ignoring_line_endings(f.read(), output)

        # test wat input
        wat = self.input_path('asyncify-pure.wat')
        test(wat)

        # test wasm input
        shared.run_process(shared.WASM_AS + [wat, '-o', 'a.wasm'])
        test('a.wasm')

    def test_asyncify_list_bad(self):
        for arg, warning in [
            ('--pass-arg=asyncify-removelist@nonexistent', 'nonexistent'),
            ('--pass-arg=asyncify-onlylist@nonexistent', 'nonexistent'),
            ('--pass-arg=asyncify-removelist@main', None),
            ('--pass-arg=asyncify-onlylist@main', None),
            ('--pass-arg=asyncify-removelist@m*n', None),
            ('--pass-arg=asyncify-onlylist@m*n', None),
            ('--pass-arg=asyncify-onlylist@main*', None),
            ('--pass-arg=asyncify-onlylist@*main', None),
            ('--pass-arg=asyncify-removelist@non*existent', 'non*existent'),
            ('--pass-arg=asyncify-onlylist@non*existent', 'non*existent'),
            ('--pass-arg=asyncify-onlylist@DOS_ReadFile(unsigned short, unsigned char*, unsigned short*, bool)', None),
        ]:
            print(arg, warning)
            err = shared.run_process(shared.WASM_OPT + ['-q', self.input_path('asyncify-pure.wat'), '--asyncify', arg], stdout=subprocess.PIPE, stderr=subprocess.PIPE).stderr.strip()
            if warning:
                self.assertIn('warning', err)
                self.assertIn(warning, err)
            else:
                self.assertNotIn('warning', err)

    def test_asyncify_onlylist_and_other(self):
        def test(list_name):
            args = shared.WASM_OPT + [self.input_path('asyncify-pure.wat'),
                                      '--asyncify',
                                      '--pass-arg=asyncify-onlylist@main',
                                      '--pass-arg=asyncify-%slist@main' % list_name]
            proc = shared.run_process(args, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, check=False)
            self.assertNotEqual(proc.returncode, 0, 'must error on using both lists at once')
            self.assertIn('It makes no sense to use both an asyncify only-list together with another list', proc.stdout)

        test('remove')
        test('add')

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
