import subprocess

from scripts.test import shared

from . import utils


class PreserveFuzzTest(utils.BinaryenTestCase):
    def test_against_js(self):
        # When --fuzz-against-js is used, the wasm is only going to be fuzzed
        # against JS, so the fuzzer mutates the boundary in valid ways, even if
        # --fuzz-preserve-imports-exports is set.
        #
        # Testing this deterministically is too hard (as the fuzzer evolves, it
        # will handle random data differently, and the test would constantly get
        # out of date). Instead, test randomly, in a way that the chance of a
        # flake is unrealistic.
        size = 10 * 1024
        iters = 1000
        temp_dat = tempfile.NamedTemporaryFile(suffix='.dat')
        initial = self.input_path('fuzz.wat')

        for _ in range(iters):
            # Generate raw random data
            with open(temp_dat.name, 'wb') as f:
                f.write(bytes([random.randint(0, 255) for x in range(size)]))

            # Generate the fuzz testcase from the random data + the initial
            # contents.
            args = ['-ttf', temp_dat.name, '--initial-fuzz=' + initial]
            args += ['--fuzz-preserve-imports-exports', '--fuzz-against-js']
            args += ['--print']
            wat = shared.run_process(shared.WASM_OPT + args,
                                   stdout=subprocess.PIPE).stdout

 
