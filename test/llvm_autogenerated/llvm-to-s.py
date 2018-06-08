#!/usr/bin/env python
#
# 2016 WebAssembly Community Group participants
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import argparse
import os
import re
import shlex
import subprocess
import sys


ROOT_DIR = os.path.dirname(os.path.abspath(__file__))
LLVM_TEST_DIR = os.path.join('test', 'CodeGen', 'WebAssembly')
S_TEST_DIR = ROOT_DIR


def FindTestFiles(directory, ext):
    tests = []
    for root, dirs, files in os.walk(directory):
        for f in files:
            path = os.path.join(root, f)
            if os.path.splitext(f)[1] == ext:
                tests.append(path)
    tests.sort()
    return tests


def GetRunLine(test):
    run_line = ''
    with open(test) as test_file:
        for line in test_file.readlines():
            m = re.match(r'; RUN: (.*?)(\\?)$', line)
            if m:
                run_line += m.group(1)
                if not m.group(2):
                    break
    # Remove FileCheck
    run_line = re.sub(r'\|\s*FileCheck.*$', '', run_line)
    # Remove pipe input
    run_line = re.sub(r'<\s*%s', '', run_line)
    # Remove stderr > stdout redirect
    run_line = re.sub(r'2>&1', '', run_line)
    return run_line


def main(args):
    parser = argparse.ArgumentParser()
    parser.add_argument('-l', '--llvm-dir', required=True)
    parser.add_argument('-b', '--bin-dir', required=True)
    options = parser.parse_args(args)
    llvm_dir = options.llvm_dir
    bin_dir = options.bin_dir
    llvm_test_dir = os.path.join(llvm_dir, LLVM_TEST_DIR)

    tests = FindTestFiles(llvm_test_dir, '.ll')
    for ll_test in tests:
        name_noext = os.path.splitext(os.path.basename(ll_test))[0]

        BLACKLIST = ['inline-asm',  # inline asm containing invalid syntax
                     'dbgvalue',  # external global symbol
                     'returned',  # external global symbol
                     'vtable',  # external global symbol
                     'offset-folding',  # external global symbol
                     'address-offsets',  # external global symbol
                     'memory-addr64',  # wasm64
                     'simd-arith',  # No SIMD in binaryen yet
                     ]
        if name_noext in BLACKLIST:
          continue

        s = os.path.join(S_TEST_DIR, name_noext + '.s')
        run_line = GetRunLine(ll_test)
        cmd = shlex.split(run_line)
        cmd.extend([ll_test, '-o', s])
        # Don't run if the command isn't llc. Some are opt and they don't
        # generate .s files.
        if cmd[0] != 'llc':
            continue
        cmd[0] = os.path.join(bin_dir, cmd[0])
        print ' '.join(cmd)
        subprocess.check_call(cmd)


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
