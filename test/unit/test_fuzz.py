import os
import time

from scripts.test import shared
from . import utils


class FuzzTest(utils.BinaryenTestCase):
    def remove_timing(self, output):
        # one of the lines has timing info which is nondeterministic, something
        # like
        #
        # ITERATION: 1 seed: 42 size: 4302 (mean: 4302.0) speed: 5102.559610705596 iters/sec,  0.0 wasm_bytes/sec
        lines = output.splitlines()
        filtered_lines = [line for line in lines if 'ITERATION' not in line]
        # there should be one such line
        self.assertEqual(len(filtered_lines), len(lines) - 1)
        return '\n'.join(filtered_lines)

    def run_fuzzer(self, args=[]):
        fuzz_opt = os.path.join(shared.options.binaryen_root, 'scripts', 'fuzz_opt.py')
        output = shared.run_process(['python3', fuzz_opt] + args, capture_output=True).stdout
        return self.remove_timing(output)

    def test_deterministic(self):
        # running with the same ID produces the same output
        ID = '42'
        output = self.run_fuzzer([ID])
        self.assertIn('(finished running seed 42 without error)', output)
        # by default we use the time to pick the random seed; make sure we don't
        # notice a second's difference when given the same ID
        time.sleep(2)
        second_output = self.run_fuzzer([ID])
        self.assertEqual(output, second_output)

    def test_nondeterministic(self):
        # running with a different ID produces different output (unless some
        # cosmic coincidence happens, but that's unlikely even if we run this
        # until the heat death of the universe)
        output = self.run_fuzzer(['42'])
        second_output = self.run_fuzzer(['1337'])
        self.assertNotEqual(output, second_output)
