import os

from scripts.test import shared
from . import utils

"""Test that MemoryPacking correctly respects the web limitations by not
generating more than 100K data segments"""


class MemoryPackingTest(utils.BinaryenTestCase):
    def test_large_segment(self):
        data = '"' + (('A' + ('\\00' * 9)) * 100001) + '"'
        module = '''
        (module
         (memory 256 256)
         (data (i32.const 0) %s)
        )
        ''' % data
        opts = ['--memory-packing', '--disable-bulk-memory', '--print',
                '-o', os.devnull]
        p = shared.run_process(shared.WASM_OPT + opts, input=module,
                               check=False, capture_output=True)
        output = [
            '(data (i32.const 999970) "A")',
            '(data (i32.const 999980) "A")',
            '(data (i32.const 999990) "A' + ('\\00' * 9) + 'A")'
        ]
        self.assertEqual(p.returncode, 0)
        for line in output:
            self.assertIn(line, p.stdout)

    def test_large_segment_unmergeable(self):
        data = '\n'.join('(data (i32.const %i) "A")' % i for i in range(100001))
        module = '(module (memory 256 256) %s)' % data
        opts = ['--memory-packing', '--enable-bulk-memory', '--print',
                '-o', os.devnull]
        p = shared.run_process(shared.WASM_OPT + opts, input=module,
                               check=False, capture_output=True)
        self.assertEqual(p.returncode, 0)
        self.assertIn('Some VMs may not accept this binary', p.stderr)
        self.assertIn('Run the limit-segments pass to merge segments.', p.stderr)
