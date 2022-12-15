import os
import re
import subprocess
from scripts.test import shared
from . import utils


class PassesTest(utils.BinaryenTestCase):
    # Given some arguments, return the passes that were run.
    def get_passes_run(self, args):
        os.environ['BINARYEN_PASS_DEBUG'] = '1'
        try:
            hello_wat = self.input_path('hello_world.wat')
            log = shared.run_process(shared.WASM_OPT + [hello_wat] + args,
                                     stderr=subprocess.PIPE).stderr
            print(log)
            passes = re.findall(r'running pass: ([\w-]+)\.\.\.', log)
            return passes
        finally:
            del os.environ['BINARYEN_PASS_DEBUG']

    def test_O2(self):
        args = ['-O2', '-all']
        for nominal in ['--nominal', False]:
            for closed_world in ['--closed-world', False]:
                curr_args = args[:]
                if nominal:
                    curr_args.append(nominal)
                if closed_world:
                    curr_args.append(closed_world)
                passes = self.get_passes_run(curr_args)

                # dce always runs
                self.assertIn('dce', passes)

                # some passes only run in closed world
                CLOSED_WORLD_PASSES = [
                    'type-refining',
                    'signature-pruning',
                    'signature-refining',
                    'gto',
                    'cfp',
                    'gsi',
                ]
                for pass_ in CLOSED_WORLD_PASSES:
                    if closed_world:
                        self.assertIn(pass_, passes)
                    else:
                        self.assertNotIn(pass_, passes)

    def test_O3_O1(self):
        # When we run something like -O3 -O1 we should run -O3 followed by -O1
        # (and not -O1 -O1, which would be the case if the last commandline
        # argument set a global opt level flag that was then used by all
        # invocations of the full opt pipeline).

        # A pass that runs in -O3 but not -O1
        PASS_IN_O3_ONLY = 'precompute-propagate'

        # That pass is run in -O3 and -O3 -O1 etc. but not -O1 or -O1 -O1
        self.assertIn(PASS_IN_O3_ONLY, self.get_passes_run(['-O3']))
        self.assertIn(PASS_IN_O3_ONLY, self.get_passes_run(['-O3', '-O1']))
        self.assertIn(PASS_IN_O3_ONLY, self.get_passes_run(['-O1', '-O3']))
        self.assertIn(PASS_IN_O3_ONLY, self.get_passes_run(['-O3', '-O3']))

        self.assertNotIn(PASS_IN_O3_ONLY, self.get_passes_run(['-O1']))
        self.assertNotIn(PASS_IN_O3_ONLY, self.get_passes_run(['-O1', '-O1']))
