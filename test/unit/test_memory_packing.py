import os

from scripts.test import shared

from . import utils

"""Test that MemoryPacking correctly respects the web limitations by not
generating more than 100K data segments"""


class MemoryPackingTest(utils.BinaryenTestCase):
    def test_large_segment(self):
        data = '"' + (('A' + ('\\00' * 9)) * 100001) + '"'
        module = f'''
        (module
         (memory 256 256)
         (data $d (i32.const 0) {data})
        )
        '''
        opts = ['--memory-packing', '--disable-bulk-memory', '--print',
                '-o', os.devnull]
        p = shared.run_process(shared.WASM_OPT + opts, input=module,
                               check=False, capture_output=True)
        output = [
            '(data $d (i32.const 0) "A")',
            '(data $d.1 (i32.const 10) "A")',
            '(data $d.99998 (i32.const 999980) "A")',
            '(data $d.99999 (i32.const 999990) "A' + ('\\00' * 9) + 'A")',
        ]
        self.assertEqual(p.returncode, 0)
        for line in output:
            self.assertIn(line, p.stdout)

    def test_large_segment_unmergeable(self):
        data = '\n'.join(f'(data (i32.const {i}) "A")' for i in range(100001))
        module = f'(module (memory 256 256) {data})'
        opts = ['--memory-packing', '--enable-bulk-memory', '--print',
                '-o', os.devnull]
        p = shared.run_process(shared.WASM_OPT + opts, input=module,
                               check=False, capture_output=True)
        self.assertEqual(p.returncode, 0)
        self.assertIn('Some VMs may not accept this binary', p.stderr)
        self.assertIn('Run the limit-segments pass to merge segments.', p.stderr)

    def test_init_trap_does_not_write(self):
        for address_type in ['i32', 'i64']:
            for dynamic_dest in [False, True]:
                for zero_first in [False, True]:
                    for dest in [65525, 65526]:
                        with self.subTest(address_type=address_type,
                                          dynamic_dest=dynamic_dest,
                                          zero_first=zero_first, dest=dest):
                            zeros = '\\00' * 10
                            data = zeros + 'A' if zero_first else 'A' + zeros
                            ptr = ('(call $dest)' if dynamic_dest else
                                   f'({address_type}.const {dest})')
                            module = f'''
                            (module
                              (memory {address_type} 1)
                              (data $d "{data}")
                              (func $dest (result {address_type})
                                ({address_type}.const {dest}))
                              (func (export "copy")
                                (i32.store8 ({address_type}.const {dest})
                                  (i32.const 42))
                                (memory.init $d {ptr}
                                  (i32.const 0) (i32.const 11)))
                              (func (export "peek") (result i32)
                                (i32.load8_u ({address_type}.const {dest}))))
                            '''
                            p = shared.run_process(
                                shared.WASM_OPT + ['-all', '--memory-packing',
                                                   '--fuzz-exec', '-o', os.devnull],
                                input=module, check=False, capture_output=True)
                            self.assertEqual(p.returncode, 0, p.stdout + p.stderr)
                            expected = 42 if dest == 65526 else (0 if zero_first else 65)
                            self.assertEqual(p.stdout.count(
                                f'note result: peek => {expected}'), 2)
