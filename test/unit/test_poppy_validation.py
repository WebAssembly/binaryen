import os

from scripts.test import shared
from . import utils


class PoppyValidationTest(utils.BinaryenTestCase):
    def check_invalid(self, module, error):
        p = shared.run_process(shared.WASM_OPT +
                               ['--experimental-poppy', '--print', '-o', os.devnull],
                               input=module, check=False, capture_output=True)
        self.assertIn(error, p.stderr)
        self.assertIn('Fatal: error validating input', p.stderr)
        self.assertNotEqual(p.returncode, 0)

    def check_valid(self, module):
        p = shared.run_process(shared.WASM_OPT +
                               ['--experimental-poppy', '--print', '-o', os.devnull],
                               input=module, check=False, capture_output=True)
        self.assertEqual(p.stderr, "")
        self.assertEqual(p.returncode, 0)

    def test_top_level_pop(self):
        module = '''
        (module
          (func $foo (result i32)
            (block (result i32)
              (i32.const 0)
              (pop i32)
            )
          )
        )
        '''
        self.check_invalid(module, "Unexpected top-level pop in block")

    def test_top_level_pop_fixed(self):
        module = '''
        (module
          (func $foo (result i32)
            (block (result i32)
              (i32.const 0)
            )
          )
        )
        '''
        self.check_valid(module)

    def test_incompatible_type(self):
        module = '''
        (module
          (func $foo (result i32)
            (f32.const 42)
            (i32.const 42)
            (i32.add
              (pop i32)
              (pop i32)
            )
          )
        )
        '''
        self.check_invalid(module, "block element has incompatible type")
        self.check_invalid(module, "required: (i32 i32), available: (f32 i32)")

    def test_incorrect_pop_type(self):
        module = '''
        (module
          (func $foo (result i32)
            (i32.const 42)
            (i32.const 42)
            (i32.add
              (pop i32)
              (pop f32)
            )
          )
        )
        '''
        self.check_invalid(module, "binary child types must be equal")

    def test_incompatible_type_fixed(self):
        module = '''
        (module
          (func $foo (result i32)
            (i32.const 42)
            (i32.const 42)
            (i32.add
              (pop i32)
              (pop i32)
            )
          )
        )
        '''
        self.check_valid(module)

    def test_incorrect_block_type(self):
        module = '''
        (module
          (func $foo (result i32)
            (f32.const 42)
            (nop)
          )
        )
        '''
        self.check_invalid(module, "block contents should satisfy block type")

    def test_nonblock_body(self):
        module = '''
        (module
          (func $foo (result f32)
            (f32.const 42)
          )
        )
        '''
        self.check_invalid(module, "Function body must be a block")

    def test_nonpop_if_condition(self):
        module = '''
        (module
          (func $foo
            (nop)
            (i32.const 1)
            (if
              (i32.const 42)
              (block)
            )
          )
        )
        '''
        self.check_invalid(module, "Expected condition to be a Pop")

    def test_nonblock_if_true(self):
        module = '''
        (module
          (func $foo
            (nop)
            (i32.const 1)
            (if
              (pop i32)
              (nop)
            )
          )
        )
        '''
        self.check_invalid(module, "Expected control flow child to be a block")

    def test_nonblock_if_false(self):
        module = '''
        (module
          (func $foo
            (nop)
            (i32.const 1)
            (if
              (pop i32)
              (block)
              (nop)
            )
          )
        )
        '''
        self.check_invalid(module, "Expected control flow child to be a block")

    def test_nonblock_if_fixed(self):
        module = '''
        (module
          (func $foo
            (nop)
            (i32.const 1)
            (if
              (pop i32)
              (block)
              (block)
            )
          )
        )
        '''
        self.check_valid(module)

    def test_nonblock_loop_body(self):
        module = '''
        (module
          (func $foo
            (nop)
            (loop
              (nop)
            )
          )
        )
        '''
        self.check_invalid(module, "Expected control flow child to be a block")

    def test_nonpop_child(self):
        module = '''
        (module
          (func $foo (result i32)
            (i32.const 42)
            (i32.const 5)
            (i32.add
              (pop i32)
              (i32.const -1)
            )
          )
        )
        '''
        self.check_invalid(module, "Unexpected non-Pop child")
