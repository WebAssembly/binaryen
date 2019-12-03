import os

from scripts.test import shared
from . import utils


class ParsingErrorTest(utils.BinaryenTestCase):
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
