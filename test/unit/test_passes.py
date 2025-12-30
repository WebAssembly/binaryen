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
            passes = re.findall(r'running pass: ([\w-]+)\.\.\.', log)
            return passes
        finally:
            del os.environ['BINARYEN_PASS_DEBUG']

    def test_O2(self):
        args = ['-O2', '-all']
        for closed_world in ['--closed-world', False]:
            curr_args = args[:]
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
            ]
            for pass_ in CLOSED_WORLD_PASSES:
                if closed_world:
                    self.assertIn(pass_, passes)
                else:
                    self.assertNotIn(pass_, passes)

            # some passes run in open world too
            OPEN_WORLD_PASSES = [
                'gsi',
            ]
            for pass_ in OPEN_WORLD_PASSES:
                self.assertIn(pass_, passes)

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

    def test_string_builtins(self):
        # When we enable string builtins, we lift early and lower late, and
        # only do each once even if there are multiple -O2 operations.
        passes = self.get_passes_run(['-O2', '-O2', '-all'])
        self.assertEqual(passes.count('string-lifting'), 1)
        self.assertEqual(passes.count('string-lowering-magic-imports'), 1)

        # Other passes appear twice, when -O2 is repeated
        self.assertEqual(passes.count('directize'), 2)

        # Without the feature, we do not lift or lower.
        passes = self.get_passes_run(['-O2', '-O2', '-all', '--disable-string-builtins'])
        self.assertEqual(passes.count('string-lifting'), 0)
        self.assertEqual(passes.count('string-lowering-magic-imports'), 0)
