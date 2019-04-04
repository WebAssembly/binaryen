import os
import unittest
from scripts.test.shared import WASM_OPT, run_process, options


class FeatureValidationTest(unittest.TestCase):
  def check_feature(self, module, error, flag):
    p = run_process(WASM_OPT + ['--mvp-features', '--print'],
                    input=module, check=False, capture_output=True)
    self.assertIn(error, p.stderr)
    self.assertIn('Fatal: error in validating input', p.stderr)
    self.assertNotEqual(p.returncode, 0)
    p = run_process(WASM_OPT + ['--mvp-features', flag, '--print'],
                    input=module, check=False, capture_output=True)
    self.assertEqual(p.returncode, 0)

  def check_simd(self, module, error):
    self.check_feature(module, error, '--enable-simd')

  def check_sign_ext(self, module, error):
    self.check_feature(module, error, '--enable-sign-ext')

  def test_v128_signature(self):
    module = '''
    (module
     (func $foo (param $0 v128) (result v128)
      (local.get $0)
     )
    )
    '''
    self.check_simd(module, 'all used types should be allowed')

  def test_v128_global(self):
    module = '''
    (module
     (global $foo (mut v128) (v128.const i32x4 0 0 0 0))
    )
    '''
    self.check_simd(module, 'all used types should be allowed')

  def test_v128_local(self):
    module = '''
    (module
     (func $foo
      (local v128)
     )
    )
    '''
    self.check_simd(module, 'all used types should be allowed')

  def test_simd_const(self):
    module = '''
    (module
     (func $foo
      (drop (v128.const i32x4 0 0 0 0))
     )
    )
    '''
    self.check_simd(module, 'all used features should be allowed')

  def test_simd_load(self):
    module = '''
    (module
     (memory 1 1)
     (func $foo
      (drop (v128.load (i32.const 0)))
     )
    )
    '''
    self.check_simd(module, 'SIMD operation (SIMD is disabled)')

  def test_simd_splat(self):
    module = '''
    (module
     (func $foo
      (drop (i32x4.splat (i32.const 0)))
     )
    )
    '''
    self.check_simd(module, 'all used features should be allowed')

  def test_sign_ext(self):
    module = '''
    (module
     (func $foo
      (drop (i32.extend8_s (i32.const 7)))
     )
    )
    '''
    self.check_sign_ext(module, 'all used features should be allowed')


class TargetFeaturesSectionTest(unittest.TestCase):
  def disassemble(self, filename):
    path = os.path.join(options.binaryen_test, 'unit', 'input', filename)
    p = run_process(WASM_OPT + ['--print', '-o', os.devnull, path], check=False,
                    capture_output=True)
    self.assertEqual(p.returncode, 0)
    self.assertEqual(p.stderr, '')
    return p.stdout

  def test_atomics(self):
    module = self.disassemble('atomics_target_feature.wasm')
    self.assertIn('i32.atomic.rmw.add', module)

  def test_bulk_memory(self):
    module = self.disassemble('bulkmem_target_feature.wasm')
    self.assertIn('memory.copy', module)

  def test_nontrapping_fptoint(self):
    module = self.disassemble('truncsat_target_feature.wasm')
    self.assertIn('i32.trunc_sat_f32_u', module)

  def test_sign_ext(self):
    module = self.disassemble('signext_target_feature.wasm')
    self.assertIn('i32.extend8_s', module)

  def test_simd(self):
    module = self.disassemble('simd_target_feature.wasm')
    self.assertIn('i32x4.splat', module)

  def test_incompatible_features(self):
    path = os.path.join(options.binaryen_test, 'unit', 'input',
                        'signext_target_feature.wasm')
    p = run_process(
        WASM_OPT + ['--print', '-mvp', '--enable-simd', '-o', os.devnull, path],
        check=False, capture_output=True
    )
    self.assertNotEqual(p.returncode, 0)
    self.assertIn('Fatal: module uses features not explicitly specified, ' +
                  'use --detect-features to resolve',
                  p.stderr)

  def test_incompatible_features_forced(self):
    path = os.path.join(options.binaryen_test, 'unit', 'input',
                        'signext_target_feature.wasm')
    p = run_process(
        WASM_OPT + ['--print', '--detect-features', '-mvp', '--enable-simd',
                    '-o', os.devnull, path],
        check=False, capture_output=True
    )
    self.assertNotEqual(p.returncode, 0)
    self.assertIn('all used features should be allowed', p.stderr)

  def test_explicit_detect_features(self):
    path = os.path.join(options.binaryen_test, 'unit', 'input',
                        'signext_target_feature.wasm')
    p = run_process(
        WASM_OPT + ['--print', '-mvp', '--detect-features',
                    '-o', os.devnull, path],
        check=False, capture_output=True
    )
    self.assertEqual(p.returncode, 0)
    self.assertEqual(p.stderr, '')
