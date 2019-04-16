import unittest
from scripts.test.shared import WASM_OPT, run_process
from utils import roundtrip, input_path


class DataCountTest(unittest.TestCase):
  def test_datacount(self):
    roundtrip(self, 'bulkmem_data.wasm')

  def test_bad_datacount(self):
    path = input_path('bulkmem_bad_datacount.wasm')
    p = run_process(WASM_OPT + ['-g', '-o', '-', path], check=False,
                    capture_output=True)
    self.assertNotEqual(p.returncode, 0)
    self.assertIn('Number of segments does not agree with DataCount section',
                  p.stderr)
