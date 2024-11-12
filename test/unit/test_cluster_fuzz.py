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

