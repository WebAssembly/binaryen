from scripts.test import shared
from . import utils


class DataCountTest(utils.BinaryenTestCase):
    def test_datacount(self):
        self.roundtrip('bulkmem_data.wasm')

    def test_bad_datacount(self):
        path = self.input_path('bulkmem_bad_datacount.wasm')
        p = shared.run_process(shared.WASM_OPT + ['-g', '-o', '-', path],
                               check=False, capture_output=True)
        self.assertNotEqual(p.returncode, 0)
        self.assertIn('Number of segments does not agree with DataCount section',
                      p.stderr)
