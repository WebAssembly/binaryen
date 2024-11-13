import os
import re
import subprocess
import sys
import tarfile
import tempfile

from scripts.test import shared
from . import utils


class ClusterFuzz(utils.BinaryenTestCase):
    # Bundle up our ClusterFuzz package, and unbundle it to a directory.
    # Return that directory as a TemporaryDirectory object.
    # TODO for speed, reuse this?
    def bundle_and_unpack(self):
        temp_dir = tempfile.TemporaryDirectory()

        print('Bundling')
        bundle = os.path.join(temp_dir.name, 'bundle.tgz')
        shared.run_process([shared.in_binaryen('scripts', 'bundle_clusterfuzz.py'), bundle])

        print('Unpacking')
        tar = tarfile.open(bundle, "r:gz")
        tar.extractall(path=temp_dir.name)
        tar.close()

        return temp_dir

    # Test our bundler for ClusterFuzz.
    def ztest_bundle(self):
        temp_dir = self.bundle_and_unpack()

        # The bundle should contain certain files:
        # 1. run.py, the main entry point.
        assert os.path.exists(os.path.join(temp_dir.name, 'run.py'))
        # 2. scripts/fuzz_shell.js, the js testcase shell
        assert os.path.exists(os.path.join(temp_dir.name, 'scripts', 'fuzz_shell.js'))
        # 3. bin/wasm-opt, the wasm-opt binary in a static build
        wasm_opt = os.path.join(temp_dir.name, 'bin', 'wasm-opt')
        assert os.path.exists(wasm_opt)

        # See that we can execute the bundled wasm-opt. It should be able to
        # print out its version.
        out = subprocess.check_output([wasm_opt, '--version'], text=True)
        assert 'wasm-opt version ' in out

    # Generate N testcases, using run.py from a temp dir, and outputting to a
    # testcase dir.
    def generate_testcases(self, N, temp_dir, testcase_dir):
        proc = subprocess.run([sys.executable,
                               os.path.join(temp_dir, 'run.py'),
                               f'--output_dir={testcase_dir}',
                               f'--no_of_files={N}'],
                               text=True,
                               stdout=subprocess.PIPE,
                               stderr=subprocess.PIPE)
        assert proc.returncode == 0
        return proc

    # Test the bundled run.py script.
    def ztest_run_py(self):
        temp_dir = self.bundle_and_unpack()

        testcase_dir = os.path.join(temp_dir.name, 'testcases')
        assert not os.path.exists(testcase_dir), 'we must run in a fresh dir'
        os.mkdir(testcase_dir)

        N = 10
        proc = self.generate_testcases(N, temp_dir.name, testcase_dir)

        print('Checking')

        # We should have logged the creation of N testcases.
        assert proc.stdout.count('Created testcase:') == N

        # We should have actually created them.
        for i in range(0, N + 2):
            fuzz_file = os.path.join(testcase_dir, f'fuzz-binaryen-{i}.js')
            flags_file = os.path.join(testcase_dir, f'flags-binaryen-{i}.js')
            # We actually emit the range [1, N], so 0 or N+1 should not exist.
            if i >= 1 and i <= N:
                assert os.path.exists(fuzz_file)
                assert os.path.exists(flags_file)
            else:
                assert not os.path.exists(fuzz_file)
                assert not os.path.exists(flags_file)

    def ztest_fuzz_passes(self):
        # We should see interesting passes being run in run.py. This is *NOT* a
        # deterministic test, since the number of passes run is random (we just
        # let run.py run normally, to simulate the real environment), so flakes
        # are possible here. However, we do the check in a way that the
        # statistical likelihood of a flake is insignificant. Specifically, we
        # just check that we see a different number of passes run in two
        # different invocations, which is enough to prove that we are running
        # different passes each time. And the number of passes is on average
        # over 100 here (10 testcases, and each runs 0-20 passes or so).
        temp_dir = self.bundle_and_unpack()
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
                proc = self.generate_testcases(N, temp_dir.name, temp_dir.name)
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
        temp_dir = self.bundle_and_unpack()
        N = 100
        proc = self.generate_testcases(N, temp_dir.name, temp_dir.name)

        # To check for interesting wasm file contents, we'll note how many
        # struct.news appear (a signal that we are emitting WasmGC, and also a
        # non-trivial number of them), and the sizes of the wasm files.
        seen_struct_news = []
        seen_sizes = []

        # The number of struct.news appears in the metrics report like this:
        #
        # StructNew      : 18
        #
        struct_news_regex = re.compile(r'StructNew(\S+):(\S+)(\d+)')

        for i in range(1, N + 1):
            fuzz_file = os.path.join(temp_dir.name, f'fuzz-binaryen-{i}.js')
            flags_file = os.path.join(temp_dir.name, f'flags-binaryen-{i}.js')

            # The flags file must contain --wasm-staging
            with open(flags_file) as f:
                assert f.read() == '--wasm-staging'

            # The fuzz files begin with
            #
            #   var binary = new Uint8Array([..binary data as numbers..]);
            #
            with open(fuzz_file) as f:
                first_line = f.readline().strip()
                start = 'var binary = new Uint8Array(['
                end = ']);'
                assert first_line.startswith(start)
                assert first_line.endswith(end)
                numbers = first_line[len(start):-len(end)]

            # Convert to binary, and see that it is a valid file.
            numbers_array = [int(x) for x in numbers.split(',')]
            binary_file = os.path.join(temp_dir.name, 'file.wasm')
            with open(binary_file, 'wb') as f:
                f.write(bytes(numbers_array))
            metrics = subprocess.check_output(
                shared.WASM_OPT + ['-all', '--metrics', binary_file], text=True)
            # Update with what we see.
            struct_news = re.findall(struct_news_regex, metrics)
            if not struct_news:
                # No line is emitted when --metrics seens no struct.news.
                struct_news = [0]               
            seen_struct_news.append(struct_news)
            seen_sizes.append(os.path.getsize(binary_file))

        # Check what we've seen sufficiently-interesting data.
        print(seen_struct_news)
        print("XXX", seen_sizes)

# TODO check the wasm files are not trivial. min functions called? inspect the actual wasm with --metrics? we should see variety there

