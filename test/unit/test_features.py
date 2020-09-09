import os

from scripts.test import shared
from . import utils


class FeatureValidationTest(utils.BinaryenTestCase):
    def check_feature(self, module, error, flag, const_flags=[]):
        p = shared.run_process(shared.WASM_OPT +
                               ['--mvp-features', '--print', '-o', os.devnull] +
                               const_flags,
                               input=module, check=False, capture_output=True)
        self.assertIn(error, p.stderr)
        self.assertIn('Fatal: error validating input', p.stderr)
        self.assertNotEqual(p.returncode, 0)
        p = shared.run_process(
            shared.WASM_OPT + ['--mvp-features', '--print', '-o', os.devnull] +
            const_flags + [flag],
            input=module,
            check=False,
            capture_output=True)
        self.assertEqual(p.returncode, 0)

    def check_simd(self, module, error):
        self.check_feature(module, error, '--enable-simd')

    def check_sign_ext(self, module, error):
        self.check_feature(module, error, '--enable-sign-ext')

    def check_bulk_mem(self, module, error):
        self.check_feature(module, error, '--enable-bulk-memory')

    def check_exception_handling(self, module, error):
        # Exception handling implies reference types
        self.check_feature(module, error, '--enable-exception-handling',
                           ['--enable-reference-types'])

    def check_tail_call(self, module, error):
        self.check_feature(module, error, '--enable-tail-call')

    def check_reference_types(self, module, error):
        self.check_feature(module, error, '--enable-reference-types')

    def check_multivalue(self, module, error):
        self.check_feature(module, error, '--enable-multivalue',
                           ['--enable-exception-handling'])

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

    def test_tail_call(self):
        module = '''
        (module
         (func $bar)
         (func $foo
            (return_call $bar)
         )
        )
        '''
        self.check_tail_call(module, 'return_call requires tail calls to be enabled')

    def test_tail_call_indirect(self):
        module = '''
        (module
         (type $T (func))
         (table $0 1 1 funcref)
         (func $foo
            (return_call_indirect (type $T)
             (i32.const 0)
            )
         )
        )
        '''
        self.check_tail_call(module, 'return_call_indirect requires tail calls to be enabled')

    def test_reference_types_externref(self):
        module = '''
        (module
         (import "env" "test1" (func $test1 (param externref) (result externref)))
         (import "env" "test2" (global $test2 externref))
         (export "test1" (func $test1 (param externref) (result externref)))
         (export "test2" (global $test2))
         (func $externref_test (param $0 externref) (result externref)
          (return
           (call $test1
            (local.get $0)
           )
          )
         )
        )
        '''
        self.check_reference_types(module, 'all used types should be allowed')

    def test_exnref_local(self):
        module = '''
        (module
         (func $foo
            (local exnref)
         )
        )
        '''
        self.check_exception_handling(module, 'all used types should be allowed')

    def test_event(self):
        module = '''
        (module
         (event $e (attr 0) (param i32))
         (func $foo
            (throw $e (i32.const 0))
         )
        )
        '''
        self.check_exception_handling(module, 'Module has events')

    def test_multivalue_import(self):
        module = '''
        (module
         (import "env" "foo" (func $foo (result i32 i64)))
        )
        '''
        self.check_multivalue(module, 'Imported multivalue function ' +
                              '(multivalue is not enabled)')

    def test_multivalue_function(self):
        module = '''
        (module
         (func $foo (result i32 i64)
          (tuple.make
           (i32.const 42)
           (i64.const 42)
          )
         )
        )
        '''
        self.check_multivalue(module, 'Multivalue function results ' +
                              '(multivalue is not enabled)')

    def test_multivalue_event(self):
        module = '''
        (module
         (event $foo (attr 0) (param i32 i64))
        )
        '''
        self.check_multivalue(module, 'Multivalue event type ' +
                              '(multivalue is not enabled)')

    def test_multivalue_block(self):
        module = '''
        (module
         (func $foo
          (drop
           (block (result i32 i64)
            (tuple.make
             (i32.const 42)
             (i64.const 42)
            )
           )
          )
         )
        )
        '''
        self.check_multivalue(module, 'Multivalue block type ' +
                              '(multivalue is not enabled)')


class TargetFeaturesSectionTest(utils.BinaryenTestCase):
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

    def test_mutable_globals(self):
        filename = 'mutable_globals_target_feature.wasm'
        self.roundtrip(filename)
        self.check_features(filename, ['mutable-globals'])
        self.assertIn('(import "env" "global-mut" (global $gimport$0 (mut i32)))',
                      self.disassemble(filename))

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

    def test_tailcall(self):
        filename = 'tail_call_target_feature.wasm'
        self.roundtrip(filename)
        self.check_features(filename, ['tail-call'])
        self.assertIn('return_call', self.disassemble(filename))

    def test_reference_types(self):
        filename = 'reference_types_target_feature.wasm'
        self.roundtrip(filename)
        self.check_features(filename, ['reference-types'])
        self.assertIn('externref', self.disassemble(filename))

    def test_exception_handling(self):
        filename = 'exception_handling_target_feature.wasm'
        self.roundtrip(filename)
        self.check_features(filename, ['exception-handling'])
        self.assertIn('throw', self.disassemble(filename))

    def test_anyref(self):
        filename = 'anyref_target_feature.wasm'
        self.roundtrip(filename)
        self.check_features(filename, ['reference-types', 'anyref'])
        self.assertIn('anyref', self.disassemble(filename))

    def test_incompatible_features(self):
        path = self.input_path('signext_target_feature.wasm')
        p = shared.run_process(
            shared.WASM_OPT + ['--print', '--enable-simd', '-o', os.devnull,
                               path],
            check=False, capture_output=True
        )
        self.assertNotEqual(p.returncode, 0)
        self.assertIn('Fatal: module features do not match specified features. ' +
                      'Use --detect-features to resolve.',
                      p.stderr)

    def test_incompatible_features_forced(self):
        path = self.input_path('signext_target_feature.wasm')
        p = shared.run_process(
            shared.WASM_OPT + ['--print', '--detect-features', '-mvp',
                               '--enable-simd', '-o', os.devnull, path],
            check=False, capture_output=True
        )
        self.assertNotEqual(p.returncode, 0)
        self.assertIn('all used features should be allowed', p.stderr)

    def test_explicit_detect_features(self):
        self.check_features('signext_target_feature.wasm', ['simd', 'sign-ext'],
                            opts=['-mvp', '--detect-features', '--enable-simd'])

    def test_emit_all_features(self):
        p = shared.run_process(shared.WASM_OPT +
                               ['--emit-target-features', '-all', '-o', '-'],
                               input="(module)", check=False,
                               capture_output=True, decode_output=False)
        self.assertEqual(p.returncode, 0)
        p2 = shared.run_process(shared.WASM_OPT +
                                ['--print-features', '-o', os.devnull],
                                input=p.stdout, check=False,
                                capture_output=True)
        self.assertEqual(p2.returncode, 0)
        self.assertEqual([
            '--enable-threads',
            '--enable-mutable-globals',
            '--enable-nontrapping-float-to-int',
            '--enable-simd',
            '--enable-bulk-memory',
            '--enable-sign-ext',
            '--enable-exception-handling',
            '--enable-tail-call',
            '--enable-reference-types',
            '--enable-multivalue',
            '--enable-anyref'
        ], p2.stdout.splitlines())
