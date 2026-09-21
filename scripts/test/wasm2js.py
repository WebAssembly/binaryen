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
import subprocess

from . import shared, support
from .shared import print_heading

basic_tests = shared.get_tests(os.path.join(shared.options.binaryen_test, 'lit', 'basic'))
# memory64 is not supported in wasm2js yet (but may be with BigInt eventually).
basic_tests = [t for t in basic_tests if '64.wast' not in t]
spec_tests = shared.options.spec_tests
spec_tests = [t for t in spec_tests if '.fail' not in t]
spec_tests = [t for t in spec_tests if '64.wast' not in t]
wasm2js_tests = shared.get_tests(shared.get_test_dir('wasm2js'), ['.wast'])
assert_tests = ['wasm2js.wast.asserts']
# These tests exercise functionality not supported by wasm2js
wasm2js_skipped_tests = [
    'empty_imported_table.wast',
    'br.wast',  # depends on multivalue
    'fac.wast',  # depends on mutlivalue
    'br_table.wast',  # needs support for externref in assert_return
]


def check_for_stale_files():
    if shared.options.test_name_filter:
        return

    # TODO(sbc): Generalize and apply other test suites
    all_tests = basic_tests + spec_tests + wasm2js_tests
    all_tests = [os.path.basename(os.path.splitext(t)[0]) for t in all_tests]

    assert_test_prefixes = [t.split('.')[0] for t in assert_tests]
    skipped_test_prefixes = [t.split('.')[0] for t in shared.SPEC_TESTSUITE_TESTS_TO_SKIP]

    all_files = os.listdir(shared.get_test_dir('wasm2js'))
    for f in all_files:
        prefix = f.split('.')[0]
        if prefix in assert_test_prefixes:
            continue
        if prefix in skipped_test_prefixes:
            continue
        if prefix not in all_tests:
            shared.fail_with_error(f'orphan test output: {f}')


def run_one_wasm2js_test(item, stdout=None):
    t, opt, expected_file = item
    basename = os.path.basename(t)
    print('..', basename, file=stdout)

    # Include the path to avoid collisions between test suites (e.g. lit/basic,
    # spec, and wasm2js) when running in parallel.
    # /path/to/binaryen/test/wasm2js/foo.wast -> wasm2js-foo
    rel = os.path.relpath(t, shared.options.binaryen_test)
    base_name = os.path.splitext(rel)[0].replace(os.sep, '-')
    split_file = f'split_{base_name}_{opt}.wast'
    mjs_file = f'a_{base_name}_{opt}.2asm.mjs'
    asserts_mjs_file = f'a_{base_name}_{opt}.2asm.asserts.mjs'

    all_js = []
    all_out = ''

    try:
        for module, asserts in support.split_wast(t):
            support.write_wast(split_file, module, asserts)

            # wasm2js does not yet support EH or stack switching, and
            # enabling them can reduce optimization opportunities
            cmd = shared.WASM2JS + [split_file, '-all',
                                    '--disable-exception-handling',
                                    '--disable-stack-switching']
            if opt:
                cmd += ['-O']
            if 'emscripten' in basename:
                cmd += ['--emscripten']
            if 'deterministic' in basename:
                cmd += ['--deterministic']
            js = support.run_command(cmd, stdout=stdout)
            all_js.append(js)

            if not shared.NODEJS and not shared.MOZJS:
                print('No JS interpreters. Skipping spec tests.', file=stdout)
                continue

            with open(mjs_file, 'w') as f:
                f.write(js)

            cmd_asserts = cmd + ['--allow-asserts']
            js_asserts = support.run_command(cmd_asserts, stdout=stdout)
            # also verify it passes pass-debug verifications
            support.run_command(cmd_asserts, stderr=subprocess.PIPE, stdout=stdout, env=shared.pass_debug_env())

            with open(asserts_mjs_file, 'w') as f:
                f.write(js_asserts)

            # verify asm.js is valid js, note that we're using --experimental-modules
            # to enable ESM syntax and we're also passing a custom loader to handle the
            # `spectest` and `env` modules in our tests.
            if shared.NODEJS:
                loader = os.path.join(shared.options.binaryen_root, 'scripts', 'test', 'node-esm-loader.mjs')
                node = [shared.NODEJS, '--experimental-modules', '--no-warnings', '--loader', loader]
                cmd_node = node[:]
                cmd_node.append(mjs_file)
                out = support.run_command(cmd_node, stdout=stdout)
                shared.fail_if_not_identical(out, '')
                cmd_node = node[:]
                cmd_node.append(asserts_mjs_file)
                out = support.run_command(cmd_node, expected_err='', err_ignore='ExperimentalWarning', stdout=stdout)
                all_out += out

        shared.fail_if_not_identical_to_file(''.join(all_js), expected_file)
        expected_out = os.path.join(shared.get_test_dir('spec'), 'expected-output', basename + '.log')
        if os.path.exists(expected_out):
            expected_out_text = open(expected_out).read()
        else:
            expected_out_text = ''
        shared.fail_if_not_identical(all_out, expected_out_text)
    finally:
        shared.delete_from_orbit(split_file)
        shared.delete_from_orbit(mjs_file)
        shared.delete_from_orbit(asserts_mjs_file)


def test_wasm2js_output():
    tests = []
    for opt in (0, 1):
        for t in basic_tests + spec_tests + wasm2js_tests:
            basename = os.path.basename(t)
            if basename in wasm2js_skipped_tests:
                continue

            asm = basename.replace('.wast', '.2asm.js')
            expected_file = os.path.join(shared.get_test_dir('wasm2js'), asm)
            if opt:
                expected_file += '.opt'

            if not os.path.exists(expected_file):
                # It is ok to skip tests from other test suites that we also
                # test on wasm2js (the basic and spec tests). When such files
                # pass in wasm2js, we add expected files for them, so lacking
                # such a file just means we should ignore it. But lacking an
                # expected file for an explicit wasm2js test is an error.
                if t in basic_tests or t in spec_tests:
                    continue
                else:
                    raise Exception(f'missing expected file {expected_file}')

            tests.append((t, opt, expected_file))

    shared.run_parallel_tests(run_one_wasm2js_test, tests)


def test_asserts_output():
    for wasm in assert_tests:
        print('..', wasm)

        asserts = os.path.basename(wasm).replace('.wast.asserts', '.asserts.js')
        traps = os.path.basename(wasm).replace('.wast.asserts', '.traps.js')
        asserts_expected_file = os.path.join(shared.options.binaryen_test, 'wasm2js', asserts)
        traps_expected_file = os.path.join(shared.options.binaryen_test, 'wasm2js', traps)

        wasm = os.path.join(shared.get_test_dir('wasm2js'), wasm)
        cmd = shared.WASM2JS + [wasm, '--allow-asserts', '-all',
                                '--disable-exception-handling',
                                '--disable-stack-switching']
        out = support.run_command(cmd)
        shared.fail_if_not_identical_to_file(out, asserts_expected_file)

        cmd += ['--pedantic']
        out = support.run_command(cmd)
        shared.fail_if_not_identical_to_file(out, traps_expected_file)


def test_wasm2js():
    print_heading('checking wasm2js testcases...')
    check_for_stale_files()
    if shared.skip_if_on_windows('wasm2js'):
        return
    test_wasm2js_output()
    test_asserts_output()


def update_wasm2js_tests():
    print_heading('checking wasm2js')

    for opt in (0, 1):
        for wasm in basic_tests + spec_tests + wasm2js_tests:
            if not wasm.endswith('.wast'):
                continue

            basename = os.path.basename(wasm)
            if basename in wasm2js_skipped_tests:
                continue

            asm = basename.replace('.wast', '.2asm.js')
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

                # wasm2js does not yet support EH or stack switching, and
                # enabling them can reduce optimization opportunities
                cmd = shared.WASM2JS + ['split.wast', '-all',
                                        '--disable-exception-handling',
                                        '--disable-stack-switching']
                if opt:
                    cmd += ['-O']
                if 'emscripten' in basename:
                    cmd += ['--emscripten']
                if 'deterministic' in basename:
                    cmd += ['--deterministic']
                out = support.run_command(cmd)
                all_out.append(out)

            with open(expected_file, 'w') as o:
                o.write(''.join(all_out))

    for wasm in assert_tests:
        print('..', wasm)

        asserts = os.path.basename(wasm).replace('.wast.asserts', '.asserts.js')
        traps = os.path.basename(wasm).replace('.wast.asserts', '.traps.js')
        asserts_expected_file = os.path.join(shared.options.binaryen_test, 'wasm2js', asserts)
        traps_expected_file = os.path.join(shared.options.binaryen_test, 'wasm2js', traps)

        cmd = shared.WASM2JS + [os.path.join(shared.get_test_dir('wasm2js'), wasm), '--allow-asserts', '-all', '--disable-exception-handling', '--disable-stack-switching']
        out = support.run_command(cmd)
        with open(asserts_expected_file, 'w') as o:
            o.write(out)

        cmd += ['--pedantic']
        out = support.run_command(cmd)
        with open(traps_expected_file, 'w') as o:
            o.write(out)
