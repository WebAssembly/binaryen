import os
from scripts.test import shared
from . import utils


class StackIRTest(utils.BinaryenTestCase):
    # test that stack IR opts make a difference.
    def test_stack_ir_opts(self):
        path = self.input_path('stack_ir.wat')
        opt = shared.run_process(shared.WASM_OPT + [path, '-O', '--generate-stack-ir', '--optimize-stack-ir', '--print-stack-ir', '-o', 'a.wasm'], capture_output=True).stdout
        nonopt = shared.run_process(shared.WASM_OPT + [path, '-O', '--generate-stack-ir', '--print-stack-ir', '-o', 'b.wasm'], capture_output=True).stdout
        # see a difference in the printed stack IR (the optimizations let us
        # remove a pair of local.set/get)
        self.assertNotEqual(opt, nonopt)
        self.assertLess(len(opt), len(nonopt))
        # see a difference in the actual emitted wasm binary.
        opt_size = os.path.getsize('a.wasm')
        nonopt_size = os.path.getsize('b.wasm')
        self.assertLess(opt_size, nonopt_size)
