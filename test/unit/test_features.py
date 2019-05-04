import os
from scripts.test.shared import WASM_OPT, run_process
from utils import BinaryenTestCase


class FeatureValidationTest(BinaryenTestCase):
  def check_feature(self, module, error, flag):
    p = run_process(WASM_OPT + ['--mvp-features', '--print', '-o', os.devnull],
                    input=module, check=False, capture_output=True)
    self.assertIn(error, p.stderr)
    self.assertIn('Fatal: error in validating input', p.stderr)
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

  def check_exception_handling(self, module, error):
    self.check_feature(module, error, '--enable-exception-handling')

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

  def test_bulk_mem_inst(self):
    module = '''
    (module
     (memory 1 1)
     (func $foo
      (memory.copy (i32.const 0) (i32.const 8) (i32.const 8))
     )
    )
    '''
    self.check_bulk_mem(module,
                        'Bulk memory operation (bulk memory is disabled')

  def test_bulk_mem_segment(self):
    module = '''
    (module
     (memory 256 256)
     (data passive "42")
    )
    '''
    self.check_bulk_mem(module, 'nonzero segment flags (bulk memory is disabled)')


class TargetFeaturesSectionTest(BinaryenTestCase):
  def test_atomics(self):
    filename = 'atomics_target_feature.wasm'
    self.roundtrip(filename)
    self.check_features(filename, ['threads'])
    self.assertIn('i32.atomic.rmw.add', self.disassemble(filename))

  def test_bulk_memory(self):
    filename = 'bulkmem_target_feature.wasm'
    self.roundtrip(filename)
    self.check_features(filename, ['bulk-memory'])
    self.assertIn('memory.copy', self.disassemble(filename))

  def test_nontrapping_fptoint(self):
    filename = 'truncsat_target_feature.wasm'
    self.roundtrip(filename)
    self.check_features(filename, ['nontrapping-float-to-int'])
    self.assertIn('i32.trunc_sat_f32_u', self.disassemble(filename))

  def test_sign_ext(self):
    filename = 'signext_target_feature.wasm'
    self.roundtrip(filename)
    self.check_features(filename, ['sign-ext'])
    self.assertIn('i32.extend8_s', self.disassemble(filename))

  def test_simd(self):
    filename = 'simd_target_feature.wasm'
    self.roundtrip(filename)
    self.check_features(filename, ['simd'])
    self.assertIn('i32x4.splat', self.disassemble(filename))

  def test_incompatible_features(self):
    path = self.input_path('signext_target_feature.wasm')
    p = run_process(
        WASM_OPT + ['--print', '--enable-simd', '-o', os.devnull, path],
        check=False, capture_output=True
    )
    self.assertNotEqual(p.returncode, 0)
    self.assertIn('Fatal: module features do not match specified features. ' +
                  'Use --detect-features to resolve.',
                  p.stderr)

  def test_incompatible_features_forced(self):
    path = self.input_path('signext_target_feature.wasm')
    p = run_process(
        WASM_OPT + ['--print', '--detect-features', '-mvp', '--enable-simd',
                    '-o', os.devnull, path],
        check=False, capture_output=True
    )
    self.assertNotEqual(p.returncode, 0)
    self.assertIn('all used features should be allowed', p.stderr)

  def test_explicit_detect_features(self):
    self.check_features('signext_target_feature.wasm', ['sign-ext', 'simd'],
                        opts=['-mvp', '--detect-features', '--enable-simd'])
