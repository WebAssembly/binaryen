#!/usr/bin/python3

'''
Bundle files for ClusterFuzz.

Usage:

bundle.py OUTPUT_FILE.tgz

The output file will be a .tgz file.

This assumes you build wasm-opt into the bin dir, and that it is a static build
(cmake -DBUILD_STATIC_LIB=1).
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
    tar.add(os.path.join(shared.options.binaryen_bin, 'wasm-opt'),
            arcname='bin/wasm-opt')

print('Done.')

