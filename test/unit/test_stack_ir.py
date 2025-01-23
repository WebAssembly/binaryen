import os
from scripts.test import shared
from . import utils


class StackIRTest(utils.BinaryenTestCase):
    # test that stack IR opts make a difference.
    def test_stack_ir_opts(self):
        path = self.input_path('stack_ir.wat')
        shared_args = shared.WASM_OPT + [path, '--print-stack-ir']
        # optimize level 2 will only run some of the stack IR opts. level 3 does
        # noticeably more.
        nonopt = shared.run_process(shared_args + ['-o', 'nonopt.wasm', '--optimize-level=2'], capture_output=True).stdout
        yesopt = shared.run_process(shared_args + ['-o', 'yesopt.wasm', '--optimize-level=3'], capture_output=True).stdout
        # see a difference in the printed stack IR (the optimizations let us
        # remove a pair of local.set/get)
        self.assertNotEqual(yesopt, nonopt)
        self.assertLess(len(yesopt), len(nonopt))
        # see a difference in the actual emitted wasm binary.
        yesopt_size = os.path.getsize('yesopt.wasm')
        nonopt_size = os.path.getsize('nonopt.wasm')
        self.assertLess(yesopt_size, nonopt_size)
