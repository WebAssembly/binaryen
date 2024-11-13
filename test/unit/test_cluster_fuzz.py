import os
import subprocess
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

    def test_bundle(self):
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


# TODO test --fuzz-passes, see that with pass-debug it runs some passes (try 1000 times)
# TODO check the wasm files are not trivial. min functions called? inspect the actual wasm with --metrics? we should see variety there
# TODO test default values (without --output-dir etc., 100 funcs, etc.)
