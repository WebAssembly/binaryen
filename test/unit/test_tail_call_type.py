from scripts.test.shared import WASM_OPT, run_process
from .utils import BinaryenTestCase
import os


class TailCallTypeTest(BinaryenTestCase):
    def test_return_call(self):
        module = '''
    (module
     (func $foo (result f32)
      (return_call $bar)
     )
     (func $bar (result i32)
      (i32.const 1)
     )
    )
'''
        p = run_process(WASM_OPT + ['--enable-tail-call', '-o', os.devnull],
                        input=module, check=False, capture_output=True)
        self.assertNotEqual(p.returncode, 0)
        self.assertIn(
            'return_call callee return type must match caller return type',
            p.stderr)

    def test_return_call_indirect(self):
        module = '''
    (module
     (type $T (func (result i32)))
     (table $0 1 1 funcref)
     (func $foo (result f32)
      (return_call_indirect (type $T)
       (i32.const 0)
      )
     )
    )
'''
        p = run_process(WASM_OPT + ['--enable-tail-call', '-o', os.devnull],
                        input=module, check=False, capture_output=True)
        self.assertNotEqual(p.returncode, 0)
        self.assertIn(
            'return_call_indirect callee return type must match caller return type',
            p.stderr)
