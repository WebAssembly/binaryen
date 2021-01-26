import os
import subprocess

from scripts.test import shared
from . import utils


class DWARFTest(utils.BinaryenTestCase):
    def test_no_crash(self):
        # run dwarf processing on some interesting large files, too big to be
        # worth putting in passes where the text output would be massive. We
        # just check that no assertion are hit.
        path = self.input_path('dwarf')
        for name in os.listdir(path):
            args = [os.path.join(path, name)] + \
                   ['-g', '--dwarfdump', '--roundtrip', '--dwarfdump']
            shared.run_process(shared.WASM_OPT + args, capture_output=True)

    def test_dwarf_incompatibility(self):
        warning = 'not fully compatible with DWARF'
        path = self.input_path(os.path.join('dwarf', 'cubescript.wasm'))
        args = [path, '-g']
        # flatten warns
        err = shared.run_process(shared.WASM_OPT + args + ['--flatten'], stderr=subprocess.PIPE).stderr
        self.assertIn(warning, err)
        # safe passes do not
        err = shared.run_process(shared.WASM_OPT + args + ['--metrics'], stderr=subprocess.PIPE).stderr
        self.assertNotIn(warning, err)
