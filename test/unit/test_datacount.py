from scripts.test.shared import WASM_OPT, run_process
from utils import BinaryenTestCase


class DataCountTest(BinaryenTestCase):
  def test_datacount(self):
    self.roundtrip('bulkmem_data.wasm')

  def test_bad_datacount(self):
    path = self.input_path('bulkmem_bad_datacount.wasm')
    p = run_process(WASM_OPT + ['-g', '-o', '-', path], check=False,
                    capture_output=True)
    self.assertNotEqual(p.returncode, 0)
    self.assertIn('Number of segments does not agree with DataCount section',
                  p.stderr)
