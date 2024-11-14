#!/usr/bin/python3

'''
Bundle files for ClusterFuzz.

Usage:

bundle.py OUTPUT_FILE.tgz [--build-dir=BUILD_DIR]

The output file will be a .tgz file.

if a build directory is provided, we will look under there to find bin/wasm-opt
and lib/libbinaryen.so. A useful place to get builds from is the Emscripten SDK,
as you can do

  ./emsdk install tot

after which ./upstream/ (from the emsdk dir) will contain fully static builds of
wasm-opt and libbinaryen.so. Thus, the full workflow could be

  cd emsdk
  ./emsdk install tot
  cd ../binaryen
  python3 scripts/bundle_clusterfuzz.py binaryen_wasm_fuzzer.tgz --build-dir=../emsdk/upstream

Before uploading to ClusterFuzz, it is worth doing two things:

  1. Run the local fuzzer (scripts/fuzz_opt.py). That includes a ClusterFuzz
     testcase handler, which simulates what ClusterFuzz does.

  2. Run the unit tests, which include smoke tests for our ClusterFuzz support:

       python -m unittest test/unit/test_cluster_fuzz.py

     Look at the logs, which will contain statistics on the wasm files the
     fuzzer emits, and see that they look reasonable.

     You should run the unit tests on the bundle you are about to upload, by
     setting the proper env var like this (using the same filename as above):

       BINARYEN_CLUSTER_FUZZ_BUNDLE=`pwd`/binaryen_wasm_fuzzer.tgz python -m unittest test/unit/test_cluster_fuzz.py

     Note that you must pass an absolute filename (e.g. using pwd as shown).

     The unittest logs should reflect that that bundle is being used at the
     very start ("Using existing bundle: PATH" rather than "Making a new
     bundle"). Note that some of the unittests also create their own bundles, to
     test the bundling script itself, so later down you will see logging of
     bundle creation even if you provide a bundle.
'''

import os
import sys
import tarfile

# Read the filenames first, as importing |shared| changes the directory.
output_file = os.path.abspath(sys.argv[1])
print(f'Bundling to: {output_file}')
assert output_file.endswith('.tgz'), 'Can only generate a .tgz'

build_dir = None
if len(sys.argv) >= 3:
    assert sys.argv[2].startswith('--build-dir=')
    build_dir = sys.argv[2].split('=')[1]
    build_dir = os.path.abspath(build_dir)
    # Delete the argument, as importing |shared| scans it.
    sys.argv.pop()

from test import shared

# Pick where to get the builds
if build_dir:
    binaryen_bin = os.path.join(build_dir, 'bin')
    binaryen_lib = os.path.join(build_dir, 'lib')
else:
    binaryen_bin = shared.options.binaryen_bin
    binaryen_lib = shared.options.binaryen_lib

with tarfile.open(output_file, "w:gz") as tar:
    # run.py
    run = os.path.join(shared.options.binaryen_root, 'scripts', 'clusterfuzz', 'run.py')
    print(f'  .. run:         {run}')
    tar.add(run, arcname='run.py')

    # fuzz_shell.js
    fuzz_shell = os.path.join(shared.options.binaryen_root, 'scripts', 'fuzz_shell.js')
    print(f'  .. fuzz_shell:  {fuzz_shell}')
    tar.add(fuzz_shell, arcname='scripts/fuzz_shell.js')

    # wasm-opt binary
    wasm_opt = os.path.join(binaryen_bin, 'wasm-opt')
    print(f'  .. wasm-opt:    {wasm_opt}')
    tar.add(wasm_opt, arcname='bin/wasm-opt')

    # For a dynamic build we also need libbinaryen.so.
    libbinaryen = os.path.join(binaryen_lib, 'libbinaryen.so')
    if os.path.exists(libbinaryen):
        print(f'  .. libbinaryen: {libbinaryen}')
        tar.add(libbinaryen, arcname='lib/libbinaryen.so')

print('Done.')

