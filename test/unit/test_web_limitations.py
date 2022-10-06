import os

from scripts.test import shared
from . import utils


class WebLimitations(utils.BinaryenTestCase):
    def test_many_params(self):
        """Test that we warn on large numbers of parameters, which Web VMs
        disallow."""

        params = '(param i32) ' * 1001
        module = '''
        (module
         (func $foo %s
         )
        )
        ''' % params
        p = shared.run_process(shared.WASM_OPT + ['-o', os.devnull],
                               input=module, capture_output=True)
        self.assertIn('Some VMs may not accept this binary because it has a large number of parameters in function foo.',
                      p.stderr)
