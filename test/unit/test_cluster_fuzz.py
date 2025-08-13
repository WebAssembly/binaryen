import glob
import os
import platform
import re
import statistics
import subprocess
import sys
import tarfile
import tempfile
import unittest

from scripts.test import shared
from . import utils


def get_build_dir():
    # wasm-opt is in the bin/ dir, and the build dir is one above it,
    # and contains bin/ and lib/.
    return os.path.dirname(os.path.dirname(shared.WASM_OPT[0]))


# Windows is not yet supported.
@unittest.skipIf(platform.system() == 'Windows', "showing class skipping")
class ClusterFuzz(utils.BinaryenTestCase):
    @classmethod
    def setUpClass(cls):
        # Bundle up our ClusterFuzz package, and unbundle it to a directory.
        # Keep the directory alive in a class var.
        cls.temp_dir = tempfile.TemporaryDirectory()
        cls.clusterfuzz_dir = cls.temp_dir.name

        bundle = os.environ.get('BINARYEN_CLUSTER_FUZZ_BUNDLE')
        if bundle:
            print(f'Using existing bundle: {bundle}')
        else:
            print('Making a new bundle')
            bundle = os.path.join(cls.clusterfuzz_dir, 'bundle.tgz')
            cmd = [shared.in_binaryen('scripts', 'bundle_clusterfuzz.py')]
            cmd.append(bundle)
            cmd.append(f'--build-dir={get_build_dir()}')
            shared.run_process(cmd)

        print('Unpacking bundle')
        tar = tarfile.open(bundle, "r:gz")
        tar.extractall(path=cls.clusterfuzz_dir)
        tar.close()

        print('Ready')

    # Test our bundler for ClusterFuzz.
    def test_bundle(self):
        # The bundle should contain certain files:
        # 1. run.py, the main entry point.
        self.assertTrue(os.path.exists(os.path.join(self.clusterfuzz_dir, 'run.py')))
        # 2. scripts/fuzz_shell.js, the js testcase shell
        self.assertTrue(os.path.exists(os.path.join(self.clusterfuzz_dir, 'scripts', 'fuzz_shell.js')))
        # 3. bin/wasm-opt, the wasm-opt binary in a static build
        wasm_opt = os.path.join(self.clusterfuzz_dir, 'bin', 'wasm-opt')
        self.assertTrue(os.path.exists(wasm_opt))

        # See that we can execute the bundled wasm-opt. It should be able to
        # print out its version.
        out = subprocess.check_output([wasm_opt, '--version'], text=True)
        self.assertIn('wasm-opt version ', out)

    # Generate N testcases, using run.py from a temp dir, and outputting to a
    # testcase dir.
    def generate_testcases(self, N, testcase_dir):
        proc = subprocess.run([sys.executable,
                               os.path.join(self.clusterfuzz_dir, 'run.py'),
                               f'--output_dir={testcase_dir}',
                               f'--no_of_files={N}'],
                              text=True,
                              stdout=subprocess.PIPE,
                              stderr=subprocess.PIPE)
        self.assertEqual(proc.returncode, 0)

        # We should have logged the creation of N testcases.
        self.assertEqual(proc.stdout.count('Created testcase:'), N)

        # We should have actually created them.
        for i in range(0, N + 2):
            fuzz_file = os.path.join(testcase_dir, f'fuzz-binaryen-{i}.js')
            flags_file = os.path.join(testcase_dir, f'flags-binaryen-{i}.js')
            # We actually emit the range [1, N], so 0 or N+1 should not exist.
            if i >= 1 and i <= N:
                self.assertTrue(os.path.exists(fuzz_file))
                self.assertTrue(os.path.exists(flags_file))
            else:
                self.assertTrue(not os.path.exists(fuzz_file))
                self.assertTrue(not os.path.exists(flags_file))

        return proc

    # Test the bundled run.py script.
    def test_run_py(self):
        temp_dir = tempfile.TemporaryDirectory()

        N = 10
        proc = self.generate_testcases(N, temp_dir.name)

        # Run.py should report no errors or warnings to stderr, except from
        # those we know are safe (we cannot test this in generate_testcases,
        # because the caller could do something like set BINARYEN_PASS_DEBUG,
        # which generates intentional stderr warnings).
        SAFE_WARNINGS = [
            # When we randomly pick no passes to run, this is shown.
            'warning: no passes specified, not doing any work',
            # MemoryPacking warns on some things.
            'warning: active memory segments have overlap, which prevents some optimizations.',
        ]
        stderr = proc.stderr
        for safe in SAFE_WARNINGS:
            stderr = stderr.replace(safe, '')
        stderr = stderr.strip()
        self.assertEqual(stderr, '')

    def test_fuzz_passes(self):
        # We should see interesting passes being run in run.py. This is *NOT* a
        # deterministic test, since the number of passes run is random (we just
        # let run.py run normally, to simulate the real environment), so flakes
        # are possible here. However, we do the check in a way that the
        # statistical likelihood of a flake is insignificant. Specifically, we
        # just check that we see a different number of passes run in two
        # different invocations, which is enough to prove that we are running
        # different passes each time. And the number of passes is on average
        # over 100 here (10 testcases, and each runs 0-20 passes or so).
        temp_dir = tempfile.TemporaryDirectory()
        N = 10

        # Try many times to see a different number, to make flakes even less
        # likely. In the worst case if there were two possible numbers of
        # passes run, with equal probability, then if we failed 100 iterations
        # every second, we could go for billions of billions of years without a
        # flake. (And, if there are only two numbers with *non*-equal
        # probability then something is very wrong, and we'd like to see
        # errors.)
        seen_num_passes = set()
        for i in range(100):
            os.environ['BINARYEN_PASS_DEBUG'] = '1'
            try:
                proc = self.generate_testcases(N, temp_dir.name)
            finally:
                del os.environ['BINARYEN_PASS_DEBUG']

            num_passes = proc.stderr.count('running pass')
            print(f'num passes: {num_passes}')
            seen_num_passes.add(num_passes)
            if len(seen_num_passes) > 1:
                return
        raise Exception(f'We always only saw {seen_num_passes} passes run')

    def test_file_contents(self):
        # As test_fuzz_passes, this is nondeterministic, but statistically it is
        # almost impossible to get a flake here.
        temp_dir = tempfile.TemporaryDirectory()
        N = 100
        self.generate_testcases(N, temp_dir.name)

        # To check for interesting wasm file contents, we'll note how many
        # struct.news appear (a signal that we are emitting WasmGC, and also a
        # non-trivial number of them), the sizes of the wasm files, and the
        # exports.
        seen_struct_news = []
        seen_sizes = []
        seen_exports = []

        # Second wasm files are also emitted sometimes.
        seen_second_sizes = []

        # The number of struct.news appears in the metrics report like this:
        #
        # StructNew      : 18
        #
        struct_news_regex = re.compile(r'StructNew\s+:\s+(\d+)')

        # The number of exports appears in the metrics report like this:
        #
        # [exports]      : 1
        #
        exports_regex = re.compile(r'\[exports\]\s+:\s+(\d+)')

        for i in range(1, N + 1):
            fuzz_file = os.path.join(temp_dir.name, f'fuzz-binaryen-{i}.js')
            flags_file = os.path.join(temp_dir.name, f'flags-binaryen-{i}.js')

            # The flags file must contain --wasm-staging
            with open(flags_file) as f:
                self.assertIn('--wasm-staging', f.read())

            # Extract the wasm file(s) from the JS. Make sure to not notice
            # stale files.
            for f in glob.glob('extracted*'):
                os.unlink(f)
            extractor = shared.in_binaryen('scripts', 'clusterfuzz', 'extract_wasms.py')
            subprocess.check_call([sys.executable, extractor, fuzz_file, 'extracted'])

            # One wasm file must always exist, and must be valid.
            binary_file = 'extracted.0.wasm'
            assert os.path.exists(binary_file)
            metrics = subprocess.check_output(
                shared.WASM_OPT + ['-all', '--metrics', binary_file, '-q'], text=True)

            # Update with what we see.
            struct_news = re.findall(struct_news_regex, metrics)
            if not struct_news:
                # No line is emitted when --metrics sees no struct.news.
                struct_news = ['0']
            # Metrics should contain one line for StructNews.
            self.assertEqual(len(struct_news), 1)
            seen_struct_news.append(int(struct_news[0]))

            seen_sizes.append(os.path.getsize(binary_file))

            exports = re.findall(exports_regex, metrics)
            # Metrics should contain one line for exports.
            self.assertEqual(len(exports), 1)
            seen_exports.append(int(exports[0]))

            # Sometimes a second wasm file should exist, and it must be valid
            # too.
            second_binary_file = 'extracted.1.wasm'
            if os.path.exists(second_binary_file):
                subprocess.check_call(
                    shared.WASM_OPT + ['-all', second_binary_file, '-q'])

                # Note its size (we leave detailed metrics for the first one;
                # they are generated by the same logic in run.py, so just
                # verifying some valid second wasms are emitted, of random
                # sizes, is enough).
                seen_second_sizes.append(os.path.getsize(second_binary_file))

        print()

        print('struct.news can vary a lot, but should be ~10')
        # Given that, with 100 samples we are incredibly likely to see an
        # interesting number at least once. It is also incredibly unlikely for
        # the stdev to be zero.
        print(f'mean struct.news:   {statistics.mean(seen_struct_news)}')
        print(f'stdev struct.news:  {statistics.stdev(seen_struct_news)}')
        print(f'median struct.news: {statistics.median(seen_struct_news)}')
        self.assertGreaterEqual(max(seen_struct_news), 10)
        self.assertGreater(statistics.stdev(seen_struct_news), 0)

        print()

        print('sizes are distributed as ~ mean 3600, stddev 2500, median 2800')
        print(f'mean sizes:   {statistics.mean(seen_sizes)}')
        print(f'stdev sizes:  {statistics.stdev(seen_sizes)}')
        print(f'median sizes: {statistics.median(seen_sizes)}')
        self.assertGreaterEqual(max(seen_sizes), 1000)
        self.assertGreater(statistics.stdev(seen_sizes), 0)

        print()

        print('exports are distributed as ~ mean 16, stddev 13, median 13')
        print(f'mean exports:   {statistics.mean(seen_exports)}')
        print(f'stdev exports:  {statistics.stdev(seen_exports)}')
        print(f'median exports: {statistics.median(seen_exports)}')
        self.assertGreaterEqual(max(seen_exports), 8)
        self.assertGreater(statistics.stdev(seen_exports), 0)

        print()

        # Second files appear in ~ 1/3 of testcases.
        print('number of second wasms should be around 33 +- 8')
        print(f'number of second wasms: {len(seen_second_sizes)}')
        assert seen_second_sizes, 'must see at least one second wasm'
        print('second sizes are distributed as ~ mean 2933, stddev 2011, median 2510')
        print(f'mean sizes:   {statistics.mean(seen_second_sizes)}')
        print(f'stdev sizes:  {statistics.stdev(seen_second_sizes)}')
        print(f'median sizes: {statistics.median(seen_second_sizes)}')
        # Relax the assert on the max seen second size compared to the max seen
        # primary size, as we see fewer of these. 500 is still proof of an
        # interesting wasm file.
        self.assertGreaterEqual(max(seen_second_sizes), 500)
        self.assertGreater(statistics.stdev(seen_second_sizes), 0)

        print()

        # To check for interesting JS file contents, we'll note how many times
        # we build and run the wasm, and other things like JSPI.
        seen_builds = []
        seen_calls = []
        seen_second_builds = []
        seen_JSPIs = []
        seen_initial_contents = []

        # Initial contents are noted in comments like this:
        #
        # /* using initial content 42.wasm */
        #
        # Note that we may see more than one in a file, as we may have more than
        # one wasm in each testcase: each wasm has a chance.
        initial_content_regex = re.compile(r'[/][*] using initial content ([^ ]+) [*][/]')

        # Some calls to callExports come with a random seed, so we have either
        #
        #  callExports();
        #  callExports(123456);
        #
        call_exports_regex = re.compile(r'callExports[(](\d*)[)]')

        for i in range(1, N + 1):
            fuzz_file = os.path.join(temp_dir.name, f'fuzz-binaryen-{i}.js')
            with open(fuzz_file) as f:
                js = f.read()
            seen_builds.append(js.count('build(binary);'))
            seen_calls.append(re.findall(call_exports_regex, js))
            seen_second_builds.append(js.count('build(secondBinary);'))

            # If JSPI is enabled, the async and await keywords should be
            # enabled (uncommented).
            if 'JSPI = 1' in js:
                seen_JSPIs.append(1)
                assert '/* async */' not in js
                assert '/* await */' not in js
            else:
                seen_JSPIs.append(0)
                assert '/* async */' in js
                assert '/* await */' in js

            seen_initial_contents.append(re.findall(initial_content_regex, js))

        # There is always one build and one call (those are in the default
        # fuzz_shell.js), and we add a couple of operations, each with equal
        # probability to be a build or a call, so over the 100 testcases here we
        # have an overwhelming probability to see at least one extra build and
        # one extra call.
        print('JS builds are distributed as ~ mean 4, stddev 5, median 2')
        print(f'mean JS builds:   {statistics.mean(seen_builds)}')
        print(f'stdev JS builds:  {statistics.stdev(seen_builds)}')
        print(f'median JS builds: {statistics.median(seen_builds)}')
        # Assert on at least 2, which means we added at least one to the default
        # one that always exists, as mentioned before.
        self.assertGreaterEqual(max(seen_builds), 2)
        self.assertGreater(statistics.stdev(seen_builds), 0)

        print()

        # Generate the counts of seen calls, for convenience. We convert
        #  [['11', '22'], [], ['99']]
        # into
        #  [2, 0, 1]
        num_seen_calls = [len(x) for x in seen_calls]
        print('Num JS calls are distributed as ~ mean 4, stddev 5, median 2')
        print(f'mean JS calls:   {statistics.mean(num_seen_calls)}')
        print(f'stdev JS calls:  {statistics.stdev(num_seen_calls)}')
        print(f'median JS calls: {statistics.median(num_seen_calls)}')
        self.assertGreaterEqual(max(num_seen_calls), 2)
        self.assertGreater(statistics.stdev(num_seen_calls), 0)

        # The initial callExports have no seed (that makes the first, default,
        # callExports behave deterministically, so we can compare to
        # wasm-opt --fuzz-exec etc.), and all subsequent ones must have a seed.
        seeds = []
        for calls in seen_calls:
            if calls:
                self.assertEqual(calls[0], '')
                for other in calls[1:]:
                    self.assertNotEqual(other, '')
                    seeds.append(int(other))

        # The seeds are random numbers in 0..2^32-1, so overlap between them
        # should be incredibly unlikely. Allow a few % of such overlap just to
        # avoid extremely rare errors.
        num_seeds = len(seeds)
        num_unique_seeds = len(set(seeds))
        print(f'unique JS call seeds: {num_unique_seeds} (should be almost {num_seeds})')
        self.assertGreaterEqual(num_unique_seeds / num_seeds, 0.95)

        print()

        # Second wasm files are more rarely added, only 1/3 of the time or so,
        # but over 100 samples we are still overwhelmingly likely to see one.
        print('JS second builds are distributed as ~ mean 1.8, stddev 2.2, median 1')
        print(f'mean JS second builds:   {statistics.mean(seen_second_builds)}')
        print(f'stdev JS second builds:  {statistics.stdev(seen_second_builds)}')
        print(f'median JS second builds: {statistics.median(seen_second_builds)}')
        self.assertGreaterEqual(max(seen_second_builds), 2)
        self.assertGreater(statistics.stdev(seen_second_builds), 0)

        print()

        # JSPI is done 1/4 of the time or so.
        print('JSPIs are distributed as ~ mean 0.25')
        print(f'mean JSPIs: {statistics.mean(seen_JSPIs)}')
        self.assertEqual(min(seen_JSPIs), 0)
        self.assertEqual(max(seen_JSPIs), 1)

        print()

        # Flatten the data to help some of the below, from
        #  [['a.wasm', 'b.wasm'], ['c.wasm']]
        # into
        #  ['a.wasm', 'b.wasm', 'c.wasm']
        flat_initial_contents = [item for items in seen_initial_contents for item in items]

        # Initial content appear 50% of the time for each wasm file. Each
        # testcase has 1.333 wasm files on average.
        print('Initial contents are distributed as ~ mean 0.68')
        print(f'mean initial contents: {len(flat_initial_contents) / N}')
        # Initial contents should be mostly unique (we have many, many testcases
        # and we pick just 100 or so). And we must see more than one unique one.
        unique_initial_contents = set(flat_initial_contents)
        print(f'unique initial contents: {len(unique_initial_contents)} should be almost equal to {len(flat_initial_contents)}')
        self.assertGreater(len(unique_initial_contents), 1)
        # Not all testcases have initial contents.
        num_initial_contents = [len(items) for items in seen_initial_contents]
        self.assertEqual(min(num_initial_contents), 0)
        # Some do (this is redundant given that the set of unique initial
        # contents was asserted on before, so this just confirms/checks that).
        self.assertGreaterEqual(max(num_initial_contents), 1)

        print()

        # Execute the files in V8. Almost all should execute properly (some
        # small number may trap during startup, say on a segment out of bounds).
        if shared.V8:
            valid_executions = 0
            for i in range(1, N + 1):
                fuzz_file = os.path.join(temp_dir.name, f'fuzz-binaryen-{i}.js')

                # Add --fuzzing to allow legacy and standard EH to coexist
                cmd = [shared.V8,
                       '--wasm-staging',
                       '--experimental-wasm-custom-descriptors',
                       '--fuzzing',
                       fuzz_file]
                # Capture stderr even though we will not read it. It may
                # contain warnings like us passing v8 experimental flags.
                proc = subprocess.run(cmd,
                                      stdout=subprocess.PIPE,
                                      stderr=subprocess.PIPE)

                # An execution is valid if we exited without error, and if we
                # managed to run some code before exiting (modules with no
                # exports will be considered "invalid" here, but that is very
                # rare, and in a sense they are actually unuseful).
                if proc.returncode == 0 and b'[fuzz-exec] calling ' in proc.stdout:
                    valid_executions += 1

            print('Valid executions are distributed as ~ mean 0.99')
            print(f'mean valid executions: {valid_executions / N}')
            # Assert on having at least half execute properly. Given the true mean
            # is 0.9, for half of 100 to fail is incredibly unlikely.
            self.assertGreater(valid_executions, N / 2)

        print()

    # "zzz" in test name so that this runs last. If it runs first, it can be
    # confusing as it appears next to the logging of which bundle we use (see
    # setUpClass).
    def test_zzz_bundle_build_dir(self):
        cmd = [shared.in_binaryen('scripts', 'bundle_clusterfuzz.py')]
        cmd.append('bundle.tgz')
        # Test that we notice the --build-dir flag. Here we pass an invalid
        # value, so we should error.
        cmd.append('--build-dir=foo_bar')

        failed = False
        try:
            subprocess.check_call(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        except subprocess.CalledProcessError:
            # Expected error.
            failed = True
        self.assertTrue(failed)

        # Test with a valid --build-dir.
        cmd.pop()
        cmd.append(f'--build-dir={get_build_dir()}')
        subprocess.check_call(cmd)
