import unittest
from scripts.test.shared import WASM_OPT, run_process


class FeatureValidationTest(unittest.TestCase):
  def test_simd_type(self):
    module = """
    (module
     (func $foo (param $0 v128) (result v128)
      (local.get $0)
     )
    )
    """
    p = run_process(WASM_OPT + ['--mvp-features', '--print'],
                    input=module, check=False, capture_output=True)
    self.assertIn("all used types should be allowed", p.stderr)
    self.assertIn("Fatal: error in validating input", p.stderr)
    self.assertNotEqual(p.returncode, 0)
