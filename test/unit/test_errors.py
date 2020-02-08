import os

from scripts.test import shared
from . import utils


class ErrorsTest(utils.BinaryenTestCase):
    def test_parsing_error_msg(self):
        module = '''
(module
  (func $foo
    (abc)
  )
)
'''
        p = shared.run_process(shared.WASM_OPT + ['--print', '-o', os.devnull],
                               input=module, check=False, capture_output=True)
        self.assertNotEqual(p.returncode, 0)
        self.assertIn("parse exception: abc (at 4:4)", p.stderr)

    def test_validation_error_msg(self):
        def test(args=[], extra_expected=None):
            module = '''
(module
  (memory (shared 10 20))
)
'''
            p = shared.run_process(shared.WASM_OPT + ['-o', os.devnull] + args,
                                   input=module, check=False, capture_output=True)
            self.assertNotEqual(p.returncode, 0)
            self.assertIn('memory is shared, but atomics are disabled', p.stderr)
            if extra_expected:
                self.assertIn(extra_expected, p.stdout)

        test()
        # when the user asks to print the module, we print it even if it is
        # invalid, for debugging (otherwise, an invalid module would not reach
        # the stage of runnning passes, and print is a pass, so nothing would
        # be printed)
        test(['--print'], '(module')

