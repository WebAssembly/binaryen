from scripts.test.shared import WASM_OPT, run_process
from utils import BinaryenTestCase
import os


class ParsingErrorTest(BinaryenTestCase):
  def test_parsing_error_msg(self):
    module = '''
    (module
     (func $foo
      (abc)
     )
    )
    '''
    p = run_process(WASM_OPT + ['--print', '-o', os.devnull], input=module,
                    check=False, capture_output=True)
    self.assertNotEqual(p.returncode, 0)
    self.assertIn("parse exception: abc (at 4:6)", p.stderr)
