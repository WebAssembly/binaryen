import os
import tarfile
import tempfile

from scripts.test import shared
from . import utils


class ClusterFuzz(utils.BinaryenTestCase):
    # Bundle up our ClusterFuzz package, and unbundle it to a directory.
    # Return that directory's name.
    def bundle_and_unpack(self):
        # Keep the temp dir alive as long as we are.
        self.bundle_temp_dir = tempfile.TemporaryDirectory()

        print('Bundling')
        bundle = os.path.join(self.bundle_temp_dir.name, 'bundle.tgz')
        shared.run_process([shared.in_binaryen('scripts', 'bundle_clusterfuzz.py'), bundle])

        print('Unpacking')
        tar = tarfile.open(bundle, "r:gz")
        tar.extractall(path=self.bundle_temp_dir.name)
        tar.close()

        return self.bundle_temp_dir.name

    def test_bundle(self):
        temp_dir = self.bundle_and_unpack()

#        p = shared.run_process(shared.WASM_OPT + ['-o', os.devnull],
#                               input=module, capture_output=True)
#        self.assertIn('Some VMs may not accept this binary because it has a large number of parameters in function foo.',
#                      p.stderr)

# TODO test --fuzz-passes, see that with pass-debug it runs some passes (try 1000 times)
# TODO check the wasm files are not trivial. min functions called? inspect the actual wasm with --metrics? we should see variety there
# TODO test default values (without --output-dir etc., 100 funcs, etc.)
