#!/usr/bin/python3

'''
Bundle files for ClusterFuzz.

Usage:

bundle.py OUTPUT_FILE.tgz

The output file will be a .tgz file.

This assumes you build wasm-opt into the bin dir, and that it is a static build
(cmake -DBUILD_STATIC_LIB=1).

Before uploading to ClusterFuzz, it is worth doing two things:

  1. Run the local fuzzer (scripts/fuzz_opt.py). That includes a ClusterFuzz
     testcase handler, which simulates what ClusterFuzz does.
  2. Run the unit tests, which include smoke tests for our ClusterFuzz support.
     You can run
       ./check.py unit
     for all unit tests, or you can run the ClusterFuzz ones specifically:
       python -m unittest test/unit/test_cluster_fuzz.py
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

    # Static builds, which we require, are much larger than dynamic ones. For
    # lack of a better way to test, warn the build might not be static if it
    # is too small. (Numbers on one machine: 1.6M dynamic, 23MB static.)
    if os.path.getsize(wasm_opt) < 10 * 1024 * 1024:
        print('WARNING: wasm-opt size seems small! Is it a static build?')

print('Done.')

