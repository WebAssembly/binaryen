import subprocess

from scripts.test import shared
from . import utils


class ReduceTest(utils.BinaryenTestCase):
    def test_warn_on_no_passes(self):
        # run a reducer command that does nothing, and so ignores the input
        open('do_nothing.py', 'w').close()
        cmd = shared.WASM_REDUCE + [self.input_path('empty.wasm'), '-w', 'w.wasm', '-t', 't.wasm', '--command=python do_nothing.py']
        err = shared.run_process(cmd, check=False, stderr=subprocess.PIPE).stderr
        self.assertIn('Fatal: running the command on the given input gives the same result as when running it on either a trivial valid wasm or a file with nonsense in it. does the script not look at the test file (t.wasm)? (use -f to ignore this check)', err)
