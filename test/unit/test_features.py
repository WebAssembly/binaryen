import os
import unittest
from scripts.test.shared import WASM_OPT, run_process


class FeatureValidationTest(unittest.TestCase):
  def check_feature(self, module, error, flag):
    p = run_process(WASM_OPT + ['--mvp-features', '--print', '-o', os.devnull],
                    input=module, check=False, capture_output=True)
    self.assertIn(error, p.stderr)
    self.assertIn("Fatal: error in validating input", p.stderr)
    self.assertNotEqual(p.returncode, 0)
    p = run_process(WASM_OPT + ['--mvp-features', flag, '--print',
                                '-o', os.devnull],
                    input=module, check=False, capture_output=True)
    self.assertEqual(p.returncode, 0)

  def check_simd(self, module, error):
    self.check_feature(module, error, '--enable-simd')

  def check_sign_ext(self, module, error):
    self.check_feature(module, error, '--enable-sign-ext')

  def check_bulk_mem(self, module, error):
    self.check_feature(module, error, '--enable-bulk-memory')

  def test_v128_signature(self):
    module = """
    (module
     (func $foo (param $0 v128) (result v128)
      (local.get $0)
     )
    )
    """
    self.check_simd(module, "all used types should be allowed")

  def test_v128_global(self):
    module = """
    (module
     (global $foo (mut v128) (v128.const i32x4 0 0 0 0))
    )
    """
    self.check_simd(module, "all used types should be allowed")

  def test_v128_local(self):
    module = """
    (module
     (func $foo
      (local v128)
     )
    )
    """
    self.check_simd(module, "all used types should be allowed")

  def test_simd_const(self):
    module = """
    (module
     (func $foo
      (drop (v128.const i32x4 0 0 0 0))
     )
    )
    """
    self.check_simd(module, "all used features should be allowed")

  def test_simd_load(self):
    module = """
    (module
     (func $foo
      (drop (v128.load (i32.const 0)))
     )
    )
    """
    self.check_simd(module, "SIMD operation (SIMD is disabled)")

  def test_simd_splat(self):
    module = """
    (module
     (func $foo
      (drop (i32x4.splat (i32.const 0)))
     )
    )
    """
    self.check_simd(module, "all used features should be allowed")

  def test_sign_ext(self):
    module = """
    (module
     (func $foo
      (drop (i32.extend8_s (i32.const 7)))
     )
    )
    """
    self.check_sign_ext(module, "all used features should be allowed")

  def test_bulk_mem_inst(self):
    module = """
    (module
     (func $foo
      (memory.copy (i32.const 0) (i32.const 8) (i32.const 8))
     )
    )
    """
    self.check_bulk_mem(module,
                        "Bulk memory operation (bulk memory is disabled")

  def test_bulk_mem_segment(self):
    module = """
    (module
     (memory 256 256)
     (data passive "42")
    )
    """
    self.check_bulk_mem(module, "nonzero segment flags (bulk memory is disabled)")
