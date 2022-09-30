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

from . import shared
from . import support

tests = shared.get_tests(shared.options.binaryen_test)
# memory64 is not supported in wasm2js yet (but may be with BigInt eventually).
tests = [t for t in tests if '64.wast' not in t]
spec_tests = shared.options.spec_tests
spec_tests = [t for t in spec_tests if '.fail' not in t]
spec_tests = [t for t in spec_tests if '64.wast' not in t]
wasm2js_tests = shared.get_tests(shared.get_test_dir('wasm2js'), ['.wast'])
assert_tests = ['wasm2js.wast.asserts']
# These tests exercise functionality not supported by wasm2js
wasm2js_blacklist = ['empty_imported_table.wast']


def check_for_stale_files():
    if shared.options.test_name_filter:
        return

    # TODO(sbc): Generalize and apply other test suites
    all_tests = []
    for t in tests + spec_tests + wasm2js_tests:
        all_tests.append(os.path.basename(os.path.splitext(t)[0]))

    all_files = os.listdir(shared.get_test_dir('wasm2js'))
    for f in all_files:
        prefix = f.split('.')[0]
        if prefix not in all_tests:
            shared.fail_with_error('orphan test output: %s' % f)


def test_wasm2js_output():
    for opt in (0, 1):
        for t in tests + spec_tests + wasm2js_tests:
            basename = os.path.basename(t)
            if basename in wasm2js_blacklist:
                continue

            asm = basename.replace('.wast', '.2asm.js')
            expected_file = os.path.join(shared.get_test_dir('wasm2js'), asm)
            if opt:
                expected_file += '.opt'

            if not os.path.exists(expected_file):
                continue

            print('..', os.path.basename(t))

            all_js = []
            all_out = ''

            for module, asserts in support.split_wast(t):
                support.write_wast('split.wast', module, asserts)

                # wasm2js does not yet support EH, and enabling it can reduce
                # optimization opportunities
                cmd = shared.WASM2JS + ['split.wast', '-all',
                                        '--disable-exception-handling']
                if opt:
                    cmd += ['-O']
                if 'emscripten' in t:
                    cmd += ['--emscripten']
                if 'deterministic' in t:
                    cmd += ['--deterministic']
                js = support.run_command(cmd)
                all_js.append(js)

                if not shared.NODEJS and not shared.MOZJS:
                    print('No JS interpreters. Skipping spec tests.')
                    continue

                open('a.2asm.mjs', 'w').write(js)

                cmd += ['--allow-asserts']
                js = support.run_command(cmd)
                # also verify it passes pass-debug verifications
                shared.with_pass_debug(lambda: support.run_command(cmd))

                open('a.2asm.asserts.mjs', 'w').write(js)

                # verify asm.js is valid js, note that we're using --experimental-modules
                # to enable ESM syntax and we're also passing a custom loader to handle the
                # `spectest` and `env` modules in our tests.
                if shared.NODEJS:
                    loader = os.path.join(shared.options.binaryen_root, 'scripts', 'test', 'node-esm-loader.mjs')
                    node = [shared.NODEJS, '--experimental-modules', '--no-warnings', '--loader', loader]
                    cmd = node[:]
                    cmd.append('a.2asm.mjs')
                    out = support.run_command(cmd)
                    shared.fail_if_not_identical(out, '')
                    cmd = node[:]
                    cmd.append('a.2asm.asserts.mjs')
                    out = support.run_command(cmd, expected_err='', err_ignore='ExperimentalWarning')
                    all_out += out

            shared.fail_if_not_identical_to_file(''.join(all_js), expected_file)
            expected_out = os.path.join(shared.get_test_dir('spec'), 'expected-output', os.path.basename(t) + '.log')
            if os.path.exists(expected_out):
                expected_out = open(expected_out).read()
            else:
                expected_out = ''
            shared.fail_if_not_identical(all_out, expected_out)


def test_asserts_output():
    for wasm in assert_tests:
        print('..', wasm)

        asserts = os.path.basename(wasm).replace('.wast.asserts', '.asserts.js')
        traps = os.path.basename(wasm).replace('.wast.asserts', '.traps.js')
        asserts_expected_file = os.path.join(shared.options.binaryen_test, asserts)
        traps_expected_file = os.path.join(shared.options.binaryen_test, traps)

        wasm = os.path.join(shared.get_test_dir('wasm2js'), wasm)
        cmd = shared.WASM2JS + [wasm, '--allow-asserts', '-all',
                                '--disable-exception-handling']
        out = support.run_command(cmd)
        shared.fail_if_not_identical_to_file(out, asserts_expected_file)

        cmd += ['--pedantic']
        out = support.run_command(cmd)
        shared.fail_if_not_identical_to_file(out, traps_expected_file)


def test_wasm2js():
    print('\n[ checking wasm2js testcases... ]\n')
    check_for_stale_files()
    if shared.skip_if_on_windows('wasm2js'):
        return
    test_wasm2js_output()
    test_asserts_output()


def update_wasm2js_tests():
    print('\n[ checking wasm2js ]\n')

    for opt in (0, 1):
        for wasm in tests + spec_tests + wasm2js_tests:
            if not wasm.endswith('.wast'):
                continue

            if os.path.basename(wasm) in wasm2js_blacklist:
                continue

            asm = os.path.basename(wasm).replace('.wast', '.2asm.js')
            expected_file = os.path.join(shared.get_test_dir('wasm2js'), asm)
            if opt:
                expected_file += '.opt'

            # we run wasm2js on tests and spec tests only if the output
            # exists - only some work so far. the tests in extra are in
            # the test/wasm2js dir and so are specific to wasm2js, and
            # we run all of those.
            if wasm not in wasm2js_tests and not os.path.exists(expected_file):
                continue

            print('..', wasm)

            t = os.path.join(shared.options.binaryen_test, wasm)

            all_out = []

            for module, asserts in support.split_wast(t):
                support.write_wast('split.wast', module, asserts)

                # wasm2js does not yet support EH, and enable it can reduce
                # optimization opportunities
                cmd = shared.WASM2JS + ['split.wast', '-all',
                                        '--disable-exception-handling']
                if opt:
                    cmd += ['-O']
                if 'emscripten' in wasm:
                    cmd += ['--emscripten']
                if 'deterministic' in t:
                    cmd += ['--deterministic']
                out = support.run_command(cmd)
                all_out.append(out)

            with open(expected_file, 'w') as o:
                o.write(''.join(all_out))

    for wasm in assert_tests:
        print('..', wasm)

        asserts = os.path.basename(wasm).replace('.wast.asserts', '.asserts.js')
        traps = os.path.basename(wasm).replace('.wast.asserts', '.traps.js')
        asserts_expected_file = os.path.join(shared.options.binaryen_test, asserts)
        traps_expected_file = os.path.join(shared.options.binaryen_test, traps)

        cmd = shared.WASM2JS + [os.path.join(shared.get_test_dir('wasm2js'), wasm), '--allow-asserts', '-all', '--disable-exception-handling']
        out = support.run_command(cmd)
        with open(asserts_expected_file, 'w') as o:
            o.write(out)

        cmd += ['--pedantic']
        out = support.run_command(cmd)
        with open(traps_expected_file, 'w') as o:
            o.write(out)
