#!/usr/bin/python3

'''
Bundle files for ClusterFuzz.

Usage:

bundle.py OUTPUT_FILE.tgz

The output file will be a .tgz file.

Before uploading to ClusterFuzz, it is worth doing two things:

  1. Run the local fuzzer (scripts/fuzz_opt.py). That includes a ClusterFuzz
     testcase handler, which simulates what ClusterFuzz does.

  2. Run the unit tests, which include smoke tests for our ClusterFuzz support:

       python -m unittest test/unit/test_cluster_fuzz.py

     Look at the logs for any warnings.
'''

import os
import sys
import tarfile

# Read the output filename first, as importing |shared| changes the directory.
output_file = os.path.abspath(sys.argv[1])
print(f'Bundling to: {output_file}')
assert output_file.endswith('.tgz'), 'Can only generate a .tgz'

from test import shared

with tarfile.open(output_file, "w:gz") as tar:
    # run.py
    tar.add(os.path.join(shared.options.binaryen_root, 'scripts', 'clusterfuzz', 'run.py'),
            arcname='run.py')

    # fuzz_shell.js
    tar.add(os.path.join(shared.options.binaryen_root, 'scripts', 'fuzz_shell.js'),
            arcname='scripts/fuzz_shell.js')

    # wasm-opt binary
    wasm_opt = os.path.join(shared.options.binaryen_bin, 'wasm-opt')
    tar.add(wasm_opt, arcname='bin/wasm-opt')

    # For a dynamic build we also need libbinaryen.so.
    libbinaryen_so = os.path.join(shared.options.binaryen_lib, 'libbinaryen.so')
    if os.path.exists(libbinaryen_so):
        tar.add(libbinaryen_so, arcname='lib/libbinaryen.so')

print('Done.')

