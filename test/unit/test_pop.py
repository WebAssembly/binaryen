import os
from scripts.test.shared import WASM_OPT, run_process
from utils import BinaryenTestCase


class PopValidationTest(BinaryenTestCase):
  def check_ok(self, module):
    p = run_process(WASM_OPT + ['--print', '-o', os.devnull], input=module,
                    check=False, capture_output=True)
    self.assertEqual(p.returncode, 0)

  def check_error(self, module, error):
    p = run_process(WASM_OPT + ['--print', '-o', os.devnull], input=module,
                    check=False, capture_output=True)
    self.assertNotEqual(p.returncode, 0)
    self.assertIn(error, p.stderr)
    self.assertIn('Fatal: error in validating input', p.stderr)

  def test_unary(self):
    module = '''
    (module
     (func $foo (param $0 i32) (result i32)
      (push (local.get $0))
      (i32.eqz (pop))
     )
    )
    '''
    self.check_ok(module)

  def test_nested(self):
    module = '''
    (module
     (func $foo (param $0 i32) (result i32)
      (push (local.get $0))
      (i32.eqz (i32.eqz (pop)))
     )
    )
    '''
    self.check_error(
        module,
        "Pop must be child of block or grandchild of block or push"
    )

  def test_binary_fn(self):
    module = '''
    (module
     (import "env" "bar" (func $bar (param i32 f32)))
     (func $foo (param $0 i32) (param $1 f32)
      (push (local.get $0))
      (push (local.get $1))
      (call $bar (pop) (pop))
     )
    )
    '''
    self.check_ok(module)

  def test_binary_fn_reversed(self):
    module = '''
    (module
     (import "env" "bar" (func $bar (param i32 f32)))
     (func $foo (param $0 i32) (param $1 f32)
      (push (local.get $1))
      (push (local.get $0))
      (call $bar (pop) (pop))
     )
    )
    '''
    self.check_error(module, "call param types must match")

  def test_fn_siblings(self):
    module = '''
    (module
     (import "env" "bar" (func $bar (param i32 i32 i32)))
     (func $foo (param $0 i32)
      (push (local.get $0))
      (push (local.get $0))
      (push (local.get $0))
      (call $bar (pop) (pop) (pop))
     )
    )
    '''
    self.check_ok(module)

  def test_fn_siblings_bad(self):
    module = '''
    (module
     (import "env" "bar" (func $bar (param i32 i32 i32)))
     (func $foo (param $0 i32)
      (push (local.get $0))
      (push (local.get $0))
      (push (local.get $0))
      (call $bar (pop) (local.get $0) (local.get $0))
     )
    )
    '''
    self.check_error(module, "Siblings of pops must be pops")

  def test_fn_siblings_missing_first(self):
    module = '''
    (module
     (import "env" "bar" (func $bar (param i32 i32 i32)))
     (func $foo (param $0 i32)
      (push (local.get $0))
      (push (local.get $0))
      (push (local.get $0))
      (call $bar (local.get $0) (pop) (pop))
     )
    )
    '''
    self.check_error(module, "Siblings of pops must be pops")

  def test_condition(self):
    module = '''
    (module
     (func $foo (param $0 i32)
      (push (local.get $0))
      (if (pop) (block) (block))
     )
    )
    '''
    self.check_ok(module)
