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

    def test_strip_dwarf_and_opts(self):
        # some optimizations are disabled when DWARF is present (as they would
        # destroy it). we scan the wasm to see if there is any DWARF when
        # making the decision whether to run them. this test checks that we also
        # check if --strip* is being run, which would remove the DWARF anyhow
        path = self.input_path(os.path.join('dwarf', 'cubescript.wasm'))
        # strip the DWARF, then run all the opts to check as much as possible
        args = [path, '--strip-dwarf', '-Oz']
        # run it normally, without -g. in this case no DWARF will be preserved
        # in a trivial way
        shared.run_process(shared.WASM_OPT + args + ['-o', 'a.wasm'])
        # run it with -g. in this case we need to be clever as described above,
        # and see --strip-dwarf removes the need for DWARF
        shared.run_process(shared.WASM_OPT + args + ['-o', 'b.wasm', '-g'])
        # run again on the last output without -g, as we don't want the names
        # section to skew the results
        shared.run_process(shared.WASM_OPT + ['b.wasm', '-o', 'c.wasm'])
        # compare the sizes. there might be a tiny difference in size to to
        # minor roundtrip changes, so ignore up to a tiny %
        a_size = os.path.getsize('a.wasm')
        c_size = os.path.getsize('c.wasm')
        self.assertLess((100 * abs(a_size - c_size)) / c_size, 1)
