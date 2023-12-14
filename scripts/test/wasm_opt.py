# Copyright 2016 WebAssembly Community Group participants
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
import shutil
import subprocess

from . import shared
from . import support


def test_wasm_opt():
    print('\n[ checking wasm-opt -o notation... ]\n')

    for extra_args in [[], ['--no-validation']]:
        wast = os.path.join(shared.options.binaryen_test, 'hello_world.wat')
        shared.delete_from_orbit('a.wat')
        out = 'a.wat'
        cmd = shared.WASM_OPT + [wast, '-o', out, '-S', '-q'] + extra_args
        support.run_command(cmd)
        shared.fail_if_not_identical_to_file(open(out).read(), wast)

    print('\n[ checking wasm-opt binary reading/writing... ]\n')

    shutil.copyfile(os.path.join(shared.options.binaryen_test, 'hello_world.wat'), 'a.wat')
    shared.delete_from_orbit('a.wasm')
    shared.delete_from_orbit('b.wast')
    support.run_command(shared.WASM_OPT + ['a.wat', '-o', 'a.wasm', '-q'])
    assert open('a.wasm', 'rb').read()[0] == 0, 'we emit binary by default'
    support.run_command(shared.WASM_OPT + ['a.wasm', '-o', 'b.wast', '-S', '-q'])
    assert open('b.wast', 'rb').read()[0] != 0, 'we emit text with -S'

    print('\n[ checking wasm-opt passes... ]\n')

    for t in shared.get_tests(shared.get_test_dir('passes'), ['.wast', '.wasm']):
        print('..', os.path.basename(t))
        # windows has some failures that need to be investigated:
        # * ttf tests have different outputs - order of execution of params?
        # * dwarf tests print windows slashes instead of unix
        if ('translate-to-fuzz' in t or 'dwarf' in t) and \
           shared.skip_if_on_windows('fuzz translation tests'):
            continue
        binary = '.wasm' in t
        base = os.path.basename(t).replace('.wast', '').replace('.wasm', '')
        passname = base
        passes_file = os.path.join(shared.get_test_dir('passes'), passname + '.passes')
        if os.path.exists(passes_file):
            passname = open(passes_file).read().strip()
        passes = [p for p in passname.split('_') if p != 'noprint']
        opts = [('--' + p if not p.startswith('O') and p != 'g' else '-' + p) for p in passes]
        actual = ''
        for module, asserts in support.split_wast(t):
            assert len(asserts) == 0
            support.write_wast('split.wast', module)
            cmd = shared.WASM_OPT + opts + ['split.wast', '-q']
            if 'noprint' not in t:
                cmd.append('--print')
            curr = support.run_command(cmd)
            actual += curr
            # also check debug mode output is valid
            debugged = support.run_command(cmd + ['--debug'], stderr=subprocess.PIPE)
            shared.fail_if_not_contained(actual, debugged)

            # also check pass-debug mode
            def check():
                # ignore stderr, as the pass-debug output is very verbose in CI
                pass_debug = support.run_command(cmd, stderr=subprocess.PIPE)
                shared.fail_if_not_identical(curr, pass_debug)
            shared.with_pass_debug(check)

        expected_file = os.path.join(shared.get_test_dir('passes'), base + ('.bin' if binary else '') + '.txt')
        shared.fail_if_not_identical_to_file(actual, expected_file)

        if 'emit-js-wrapper' in t:
            with open('a.js') as actual:
                shared.fail_if_not_identical_to_file(actual.read(), t + '.js')
        if 'emit-spec-wrapper' in t:
            with open('a.wat') as actual:
                shared.fail_if_not_identical_to_file(actual.read(), t + '.wat')

    print('\n[ checking wasm-opt parsing & printing... ]\n')

    for t in shared.get_tests(shared.get_test_dir('print'), ['.wast']):
        print('..', os.path.basename(t))
        wasm = os.path.basename(t).replace('.wast', '')
        cmd = shared.WASM_OPT + [t, '--print', '-all']
        print('    ', ' '.join(cmd))
        actual, err = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True).communicate()
        expected_file = os.path.join(shared.get_test_dir('print'), wasm + '.txt')
        shared.fail_if_not_identical_to_file(actual, expected_file)
        cmd = shared.WASM_OPT + [os.path.join(shared.get_test_dir('print'), t), '--print-minified', '-all']
        print('    ', ' '.join(cmd))
        actual, err = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True).communicate()
        shared.fail_if_not_identical(actual.strip(), open(os.path.join(shared.get_test_dir('print'), wasm + '.minified.txt')).read().strip())


def update_wasm_opt_tests():
    print('\n[ updating wasm-opt -o notation... ]\n')
    wast = os.path.join(shared.options.binaryen_test, 'hello_world.wat')
    cmd = shared.WASM_OPT + [wast, '-o', 'a.wast', '-S']
    support.run_command(cmd)
    open(wast, 'w').write(open('a.wast').read())

    print('\n[ updating wasm-opt parsing & printing... ]\n')
    for t in shared.get_tests(shared.get_test_dir('print'), ['.wast']):
        print('..', os.path.basename(t))
        wasm = t.replace('.wast', '')
        cmd = shared.WASM_OPT + [t, '--print', '-all']
        print('    ', ' '.join(cmd))
        actual = subprocess.check_output(cmd)
        print(cmd, actual)
        with open(wasm + '.txt', 'wb') as o:
            o.write(actual)
        cmd = shared.WASM_OPT + [t, '--print-minified', '-all']
        print('    ', ' '.join(cmd))
        actual = subprocess.check_output(cmd)
        with open(wasm + '.minified.txt', 'wb') as o:
            o.write(actual)

    print('\n[ updating wasm-opt passes... ]\n')
    for t in shared.get_tests(shared.get_test_dir('passes'), ['.wast', '.wasm']):
        print('..', os.path.basename(t))
        # windows has some failures that need to be investigated:
        # * ttf tests have different outputs - order of execution of params?
        # * dwarf tests print windows slashes instead of unix
        if ('translate-to-fuzz' in t or 'dwarf' in t) and \
           shared.skip_if_on_windows('fuzz translation tests'):
            continue
        binary = t.endswith('.wasm')
        base = os.path.basename(t).replace('.wast', '').replace('.wasm', '')
        passname = base
        passes_file = os.path.join(shared.get_test_dir('passes'), passname + '.passes')
        if os.path.exists(passes_file):
            passname = open(passes_file).read().strip()
        passes = [p for p in passname.split('_') if p != 'noprint']
        opts = [('--' + p if not p.startswith('O') and p != 'g' else '-' + p) for p in passes]
        actual = ''
        for module, asserts in support.split_wast(t):
            assert len(asserts) == 0
            support.write_wast('split.wast', module)
            cmd = shared.WASM_OPT + opts + ['split.wast']
            if 'noprint' not in t:
                cmd.append('--print')
            actual += support.run_command(cmd)
        with open(os.path.join(shared.options.binaryen_test, 'passes', base + ('.bin' if binary else '') + '.txt'), 'w') as o:
            o.write(actual)
        if 'emit-js-wrapper' in t:
            with open('a.js') as i:
                with open(t + '.js', 'w') as o:
                    o.write(i.read())
        if 'emit-spec-wrapper' in t:
            with open('a.wat') as i:
                with open(t + '.wat', 'w') as o:
                    o.write(i.read())
