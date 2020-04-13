import os

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
        # output should not be trivially tiny
        self.assertGreater(len(lines), 5)
        return '\n'.join(filtered_lines)

    def run_fuzzer(self, args=[]):
        fuzz_opt = os.path.join(shared.options.binaryen_root, 'scripts', 'fuzz_opt.py')
        output = shared.run_process(['python3', fuzz_opt] + args, capture_output=True).stdout
        input_dat = os.path.join(shared.options.binaryen_root, 'out', 'test', 'input.dat')
        with open(input_dat, 'rb') as f:
            data = f.read()
        return (self.remove_timing(output), data)

    def test_determinism(self):
        first_out, first_data = self.run_fuzzer(['42'])
        self.assertIn('checking a single given seed 42', first_out)
        self.assertIn('(finished running seed 42 without error)', first_out)
        second_out, second_data = self.run_fuzzer(['1337'])
        third_out, third_data = self.run_fuzzer(['42'])
        # running with the same ID produces the same output
        self.assertEqual(first_out, third_out)
        self.assertEqual(first_data, third_data)
        # running with a different ID should not produce the same output same
        # (barring a cosmic coincidence)
        self.assertNotEqual(first_out, second_out)
        self.assertNotEqual(first_data, second_data)
