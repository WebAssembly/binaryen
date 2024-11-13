import os

from scripts.test import shared
from . import utils


class ClusterFuzz(utils.BinaryenTestCase):
    def do_test_run_py(self, run_py_path):
        # Test that run.py works as expected, when run from a particular place.
        pass

    def test_run_py_in_tree(self):
        1/0
        pass
#        p = shared.run_process(shared.WASM_OPT + ['-o', os.devnull],
#                               input=module, capture_output=True)
#        self.assertIn('Some VMs may not accept this binary because it has a large number of parameters in function foo.',
#                      p.stderr)

# TODO test --fuzz-passes, see that with pass-debug it runs some passes (try 1000 times)
# TODO check the wasm files are not trivial. min functions called? inspect the actual wasm with --metrics? we should see variety there
# TODO test default values (without --output-dir etc., 100 funcs, etc.)
