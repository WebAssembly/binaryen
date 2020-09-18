#!/usr/bin/env python3
#
# Copyright 2015 WebAssembly Community Group participants
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

import os
import subprocess
import sys
from collections import OrderedDict

from scripts.test import binaryenjs
from scripts.test import lld
from scripts.test import shared
from scripts.test import support
from scripts.test import wasm2js
from scripts.test import wasm_opt


def update_example_tests():
    print('\n[ checking example testcases... ]\n')
    for t in shared.get_tests(shared.get_test_dir('example')):
        basename = os.path.basename(t)
        output_file = os.path.join(shared.options.binaryen_bin, 'example')
        libdir = os.path.join(shared.BINARYEN_INSTALL_DIR, 'lib')
        cmd = ['-I' + os.path.join(shared.options.binaryen_root, 'src'), '-g', '-pthread', '-o', output_file]
        if t.endswith('.txt'):
            # check if there is a trace in the file, if so, we should build it
            out = subprocess.Popen([os.path.join(shared.options.binaryen_root, 'scripts', 'clean_c_api_trace.py'), t], stdout=subprocess.PIPE).communicate()[0]
            if len(out) == 0:
                print('  (no trace in ', basename, ')')
                continue
            print('  (will check trace in ', basename, ')')
            src = 'trace.cpp'
            with open(src, 'wb') as o:
                o.write(out)
            expected = t + '.txt'
        else:
            src = t
            expected = os.path.splitext(t)[0] + '.txt'
        if not src.endswith(('.c', '.cpp')):
            continue
        # windows + gcc will need some work
        if shared.skip_if_on_windows('gcc'):
            return
        # build the C file separately
        extra = [os.environ.get('CC') or 'gcc',
                 src, '-c', '-o', 'example.o',
                 '-I' + os.path.join(shared.options.binaryen_root, 'src'), '-g', '-L' + libdir, '-pthread']
        print('build: ', ' '.join(extra))
        if src.endswith('.cpp'):
            extra += ['-std=c++' + str(shared.cxx_standard)]
        print(os.getcwd())
        subprocess.check_call(extra)
        # Link against the binaryen C library DSO, using rpath
        cmd = ['example.o', '-L' + libdir, '-lbinaryen', '-Wl,-rpath,' + os.path.abspath(libdir)] + cmd
        print('    ', basename, src, expected)
        if os.environ.get('COMPILER_FLAGS'):
            for f in os.environ.get('COMPILER_FLAGS').split(' '):
                cmd.append(f)
        cmd = [os.environ.get('CXX') or 'g++', '-std=c++' + str(shared.cxx_standard)] + cmd
        try:
            print('link: ', ' '.join(cmd))
            subprocess.check_call(cmd)
            print('run...', output_file)
            proc = subprocess.Popen([output_file], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            actual, err = proc.communicate()
            assert proc.returncode == 0, [proc.returncode, actual, err]
            with open(expected, 'wb') as o:
                o.write(actual)
        finally:
            os.remove(output_file)


def update_wasm_dis_tests():
    print('\n[ checking wasm-dis on provided binaries... ]\n')
    for t in shared.get_tests(shared.options.binaryen_test, ['.wasm']):
        print('..', os.path.basename(t))
        cmd = shared.WASM_DIS + [t]
        if os.path.isfile(t + '.map'):
            cmd += ['--source-map', t + '.map']
        actual = support.run_command(cmd)

        open(t + '.fromBinary', 'w').write(actual)


def update_ctor_eval_tests():
    print('\n[ checking wasm-ctor-eval... ]\n')
    for t in shared.get_tests(shared.get_test_dir('ctor-eval'), ['.wast', '.wasm']):
        print('..', os.path.basename(t))
        ctors = open(t + '.ctors').read().strip()
        cmd = shared.WASM_CTOR_EVAL + [t, '-all', '-o', 'a.wast', '-S', '--ctors', ctors]
        support.run_command(cmd)
        actual = open('a.wast').read()
        out = t + '.out'
        with open(out, 'w') as o:
            o.write(actual)


def update_metadce_tests():
    print('\n[ checking wasm-metadce... ]\n')
    for t in shared.get_tests(shared.get_test_dir('metadce'), ['.wast', '.wasm']):
        print('..', os.path.basename(t))
        graph = t + '.graph.txt'
        cmd = shared.WASM_METADCE + [t, '--graph-file=' + graph, '-o', 'a.wast', '-S', '-all']
        stdout = support.run_command(cmd)
        actual = open('a.wast').read()
        out = t + '.dced'
        with open(out, 'w') as o:
            o.write(actual)
        with open(out + '.stdout', 'w') as o:
            o.write(stdout)


def update_reduce_tests():
    print('\n[ checking wasm-reduce ]\n')
    for t in shared.get_tests(shared.get_test_dir('reduce'), ['.wast']):
        print('..', os.path.basename(t))
        # convert to wasm
        support.run_command(shared.WASM_AS + [t, '-o', 'a.wasm'])
        print(support.run_command(shared.WASM_REDUCE + ['a.wasm', '--command=%s b.wasm --fuzz-exec' % shared.WASM_OPT[0], '-t', 'b.wasm', '-w', 'c.wasm']))
        expected = t + '.txt'
        support.run_command(shared.WASM_DIS + ['c.wasm', '-o', expected])


def update_spec_tests():
    print('\n[ updating wasm-shell spec testcases... ]\n')

    for t in shared.options.spec_tests:
        print('..', os.path.basename(t))

        cmd = shared.WASM_SHELL + [t]
        expected = os.path.join(shared.get_test_dir('spec'), 'expected-output', os.path.basename(t) + '.log')
        if os.path.isfile(expected):
            stdout = support.run_command(cmd, stderr=subprocess.PIPE)
            # filter out binaryen interpreter logging that the spec suite
            # doesn't expect
            filtered = [line for line in stdout.splitlines() if not line.startswith('[trap')]
            stdout = '\n'.join(filtered) + '\n'
            with open(expected, 'w') as o:
                o.write(stdout)


TEST_SUITES = OrderedDict([
    ('wasm-opt', wasm_opt.update_wasm_opt_tests),
    ('wasm-dis', update_wasm_dis_tests),
    ('example', update_example_tests),
    ('ctor-eval', update_ctor_eval_tests),
    ('wasm-metadce', update_metadce_tests),
    ('wasm-reduce', update_reduce_tests),
    ('spec', update_spec_tests),
    ('lld', lld.update_lld_tests),
    ('wasm2js', wasm2js.update_wasm2js_tests),
    ('binaryenjs', binaryenjs.update_binaryen_js_tests),
])


def main():
    all_suites = TEST_SUITES.keys()
    skip_by_default = ['binaryenjs']

    if shared.options.list_suites:
        for suite in all_suites:
            print(suite)
        return 0

    if not shared.requested:
        shared.requested = [s for s in all_suites if s not in skip_by_default]

    for test in shared.requested:
        TEST_SUITES[test]()

    print('\n[ success! ]')


if __name__ == '__main__':
    sys.exit(main())
