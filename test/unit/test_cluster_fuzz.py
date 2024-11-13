import os
import subprocess
import sys
import tarfile
import tempfile

from scripts.test import shared
from . import utils


class ClusterFuzz(utils.BinaryenTestCase):
    # Bundle up our ClusterFuzz package, and unbundle it to a directory.
    # Return that directory as a TemporaryDirectory object.
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
    def WAKA___________________________________________________________________________________________________________test_bundle(self):
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
        try:
            out = subprocess.check_output([wasm_opt, '--version'], text=True)
        except subprocess.CalledProcessError:
            print('(if this fails because wasm-opt was not built statically, use cmake -DBUILD_STATIC_LIB=1)')
            raise
        assert 'wasm-opt version ' in out

    # Test the bundled run.py script.
    def test_run_py(self):
        temp_dir = self.bundle_and_unpack()

        testcase_dir = os.path.join(temp_dir.name, 'testcases')
        assert not os.path.exists(testcase_dir), 'we must run in a fresh dir'
        os.mkdir(testcase_dir)

        N = 10
        run_py = os.path.join(temp_dir.name, 'run.py')

        # The ClusterFuzz run.py uses --fuzz-passes to add some interesting
        # changes to the wasm. Make sure that actually runs passes, by using
        # pass-debug mode to scan for the logging as we create N testcases.
        os.environ['BINARYEN_PASS_DEBUG'] = '1'
        try:
            proc = subprocess.run([sys.executable,
                                   run_py,
                                   f'--output_dir={testcase_dir}',
                                   f'--no_of_files={N}'],
                                   text=True,
                                   stdout=subprocess.PIPE,
                                   stderr=subprocess.PIPE)
        finally:
            del os.environ['BINARYEN_PASS_DEBUG']
        assert proc.returncode == 0

        # We should have logged the creation of N testcases.
        assert proc.stdout.count('Created testcase:') == N

        # We should have actually created them.
        for i in range(0, N + 2):
            fuzz_file = os.path.join(testcase_dir, f'fuzz-binaryen-{i}.js')
            flags_file = os.path.join(testcase_dir, f'flags-binaryen-{i}.js')
            # We actually emit the range [1, N], and not 0 or N+1
            if i >= 1 and i <= N:
                assert os.path.exists(fuzz_file)
                assert os.path.exists(flags_file)
            else:
                assert not os.path.exists(fuzz_file)
                assert not os.path.exists(flags_file)


# TODO test --fuzz-passes, see that with pass-debug it runs some passes (try 1000 times). can we do this using run.py?
# TODO check the wasm files are not trivial. min functions called? inspect the actual wasm with --metrics? we should see variety there
# TODO test default values (without --output-dir etc., 100 funcs, etc.)
