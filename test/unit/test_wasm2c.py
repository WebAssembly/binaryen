from scripts.test import shared
from . import utils


class Wasm2CTest(utils.BinaryenTestCase):
    def test_wrapper(self):
        # the wrapper C code should only call the hang limit initializer if
        # that is present.
        empty_wasm = self.input_path('empty.wasm')
        args = [empty_wasm, '--emit-wasm2c-wrapper=output.c']
        shared.run_process(shared.WASM_OPT + args)
        with open('output.c') as f:
            normal_output = f.read()
        # running with ttf generates a new wasm for fuzzing, which always
        # includes the hang limit initializer function
        shared.run_process(shared.WASM_OPT + args + ['-ttf'])
        with open('output.c') as f:
            ttf_output = f.read()
        hang_limit_name = 'hangLimitInitializer'
        self.assertIn(hang_limit_name, ttf_output)
        self.assertNotIn(hang_limit_name, normal_output)
