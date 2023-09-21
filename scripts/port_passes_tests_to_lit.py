#!/usr/bin/env python3
# Copyright 2021 WebAssembly Community Group participants
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

"""Automatically port legacy passes tests to be lit tests
"""

import argparse
import glob
import os
import subprocess
import sys


script_dir = os.path.dirname(__file__)
test_dir = os.path.join(os.path.dirname(script_dir), 'test')


def warn(msg):
    print(f'WARNING: {msg}', file=sys.stderr)


def port_test(args, test):
    name = os.path.basename(test)
    base = name.replace('.wast', '')
    print('..', name)

    if not test.endswith('.wast'):
        warn('Skipping because only .wast files are supported')
        return

    dest = os.path.join(test_dir, 'lit', 'passes', name)
    if not args.force and os.path.exists(dest):
        warn('Skipping because destination file already exist')
        return

    joined_passes = base
    passes_file = os.path.join(test_dir, 'passes', base + '.passes')
    if os.path.exists(passes_file):
        with open(passes_file) as f:
            joined_passes = f.read().strip()

    if 'translate-to-fuzz' in joined_passes or 'dwarf' in joined_passes:
        warn('Skipping due to Windows issues')
        return

    for bad in ['noprint', 'metrics', 'fuzz', 'print', 'emit', 'dump']:
        if bad in joined_passes:
            warn('Skipping due to nonstandard output')
            return

    passes = joined_passes.split('_')
    opts = [('--' + p if not p.startswith('O') and p != 'g' else '-' + p)
            for p in passes]

    run_line = (f';; RUN: foreach %s %t wasm-opt {" ".join(opts)} -S -o -'
                ' | filecheck %s')

    notice = (f';; NOTE: This test was ported using'
              ' port_passes_tests_to_lit.py and could be cleaned up.')

    with open(test, 'r') as src_file:
        with open(dest, 'w') as dest_file:
            print(notice, file=dest_file)
            print('', file=dest_file)
            print(run_line, file=dest_file)
            print('', file=dest_file)
            print(src_file.read(), file=dest_file, end='')

    update_script = os.path.join(script_dir, 'update_lit_checks.py')
    cmd = [sys.executable, update_script, '-f', '--all-items', dest]
    if args.binaryen_bin:
        cmd += ['--binaryen-bin', args.binaryen_bin]
    subprocess.check_call(cmd)

    if not args.no_delete:
        for f in glob.glob(test.replace('.wast', '.*')):
            # Do not delete binary tests with the same name
            if f.endswith('.wasm') or f.endswith('.bin.txt'):
                continue
            os.remove(f)
            if args.git_add:
                subprocess.check_call(['git', 'add', f])

    if args.git_add:
        subprocess.check_call(['git', 'add', dest])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        '--binaryen-bin', dest='binaryen_bin', default='bin',
        help=('Specifies the path to the Binaryen executables in the CMake build'
              ' directory. Default: bin/ of current directory (i.e. assume an'
              ' in-tree build).'))
    parser.add_argument('-f', '--force', action='store_true',
                        help='Overwrite existing lit tests')
    parser.add_argument('--no-delete', action='store_true',
                        help='Do not remove the old tests')
    parser.add_argument('--git-add', action='store_true',
                        help='Stage changes')
    parser.add_argument('tests', nargs='+', help='The test files to port')
    args = parser.parse_args()
    args.binaryen_bin = os.path.abspath(args.binaryen_bin)

    for pattern in args.tests:
        for test in glob.glob(pattern, recursive=True):
            port_test(args, test)


if __name__ == '__main__':
    main()
