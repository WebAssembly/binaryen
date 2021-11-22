import subprocess
from scripts.test import shared
from . import utils


class InitialFuzzTest(utils.BinaryenTestCase):
    def test_empty_initial(self):
        # generate fuzz from random data
        data = self.input_path('random_data.txt')
        a = shared.run_process(shared.WASM_OPT + ['-ttf', '--print', data],
                               stdout=subprocess.PIPE).stdout

        # generate fuzz from random data with initial empty wasm
        empty_wasm = self.input_path('empty.wasm')
        b = shared.run_process(
            shared.WASM_OPT + ['-ttf', '--print', data,
                               '--initial-fuzz=' + empty_wasm],
            stdout=subprocess.PIPE).stdout

        # an empty initial wasm causes no changes
        self.assertEqual(a, b)

    def test_small_initial(self):
        data = self.input_path('random_data.txt')
        hello_wat = self.input_path('hello_world.wat')
        out = shared.run_process(shared.WASM_OPT + ['-ttf', '--print', data,
                                 '--initial-fuzz=' + hello_wat],
                                 stdout=subprocess.PIPE).stdout

        # the function should be there (perhaps with modified contents - don't
        # check that)
        self.assertIn('(export "add" (func $add))', out)

        # there should be other fuzz contents added as well
        self.assertGreater(out.count('(export '), 1)
