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

import glob
import os
import subprocess
import sys
import unittest
from collections import OrderedDict

from scripts.test import binaryenjs
from scripts.test import lld
from scripts.test import shared
from scripts.test import support
from scripts.test import wasm2js
from scripts.test import wasm_opt


def get_changelog_version():
    with open(os.path.join(shared.options.binaryen_root, 'CHANGELOG.md')) as f:
        lines = f.readlines()
    lines = [l for l in lines if len(l.split()) == 1]
    lines = [l for l in lines if l.startswith('v')]
    version = lines[0][1:]
    print("Parsed CHANGELOG.md version: %s" % version)
    return int(version)


def run_version_tests():
    print('[ checking --version ... ]\n')

    not_executable_suffix = ['.DS_Store', '.txt', '.js', '.ilk', '.pdb', '.dll', '.wasm', '.manifest']
    not_executable_prefix = ['binaryen-lit', 'binaryen-unittests']
    bin_files = [os.path.join(shared.options.binaryen_bin, f) for f in os.listdir(shared.options.binaryen_bin)]
    executables = [f for f in bin_files if os.path.isfile(f) and
                   not any(f.endswith(s) for s in not_executable_suffix) and
                   not any(os.path.basename(f).startswith(s) for s in not_executable_prefix)]
    executables = sorted(executables)
    assert len(executables)

    changelog_version = get_changelog_version()
    for e in executables:
        print('.. %s --version' % e)
        out, err = subprocess.Popen([e, '--version'],
                                    stdout=subprocess.PIPE,
                                    stderr=subprocess.PIPE).communicate()
        out = out.decode('utf-8')
        err = err.decode('utf-8')
        assert len(err) == 0, 'Expected no stderr, got:\n%s' % err
        assert os.path.basename(e).replace('.exe', '') in out, 'Expected version to contain program name, got:\n%s' % out
        assert len(out.strip().splitlines()) == 1, 'Expected only version info, got:\n%s' % out
        parts = out.split()
        assert parts[1] == 'version'
        version = int(parts[2])
        assert version == changelog_version


def run_wasm_dis_tests():
    print('\n[ checking wasm-dis on provided binaries... ]\n')

    for t in shared.get_tests(shared.options.binaryen_test, ['.wasm']):
        print('..', os.path.basename(t))
        cmd = shared.WASM_DIS + [t]
        if os.path.isfile(t + '.map'):
            cmd += ['--source-map', t + '.map']

        actual = support.run_command(cmd)
        shared.fail_if_not_identical_to_file(actual, t + '.fromBinary')

        # also verify there are no validation errors
        def check():
            cmd = shared.WASM_OPT + [t, '-all', '-q']
            support.run_command(cmd)

        shared.with_pass_debug(check)


def run_crash_tests():
    print("\n[ checking we don't crash on tricky inputs... ]\n")

    for t in shared.get_tests(shared.get_test_dir('crash'), ['.wast', '.wasm']):
        print('..', os.path.basename(t))
        cmd = shared.WASM_OPT + [t]
        # expect a parse error to be reported
        support.run_command(cmd, expected_err='parse exception:', err_contains=True, expected_status=1)


def run_dylink_tests():
    print("\n[ we emit dylink sections properly... ]\n")

    dylink_tests = glob.glob(os.path.join(shared.options.binaryen_test, 'dylib*.wasm'))
    for t in sorted(dylink_tests):
        print('..', os.path.basename(t))
        cmd = shared.WASM_OPT + [t, '-o', 'a.wasm']
        support.run_command(cmd)
        with open('a.wasm', 'rb') as output:
            index = output.read().find(b'dylink')
            print('  ', index)
            assert index == 11, 'dylink section must be first, right after the magic number etc.'


def run_ctor_eval_tests():
    print('\n[ checking wasm-ctor-eval... ]\n')

    for t in shared.get_tests(shared.get_test_dir('ctor-eval'), ['.wast', '.wasm']):
        print('..', os.path.basename(t))
        ctors = open(t + '.ctors').read().strip()
        cmd = shared.WASM_CTOR_EVAL + [t, '-all', '-o', 'a.wat', '-S', '--ctors', ctors]
        if 'ignore-external-input' in t:
            cmd += ['--ignore-external-input']
        if 'results' in t:
            cmd += ['--kept-exports', 'test1,test3']
        support.run_command(cmd)
        actual = open('a.wat').read()
        out = t + '.out'
        shared.fail_if_not_identical_to_file(actual, out)


def run_wasm_metadce_tests():
    print('\n[ checking wasm-metadce ]\n')

    for t in shared.get_tests(shared.get_test_dir('metadce'), ['.wast', '.wasm']):
        print('..', os.path.basename(t))
        graph = t + '.graph.txt'
        cmd = shared.WASM_METADCE + [t, '--graph-file=' + graph, '-o', 'a.wat', '-S', '-all']
        stdout = support.run_command(cmd)
        expected = t + '.dced'
        with open('a.wat') as seen:
            shared.fail_if_not_identical_to_file(seen.read(), expected)
        shared.fail_if_not_identical_to_file(stdout, expected + '.stdout')


def run_wasm_reduce_tests():
    if not shared.has_shell_timeout():
        print('\n[ skipping wasm-reduce testcases]\n')
        return

    print('\n[ checking wasm-reduce testcases]\n')

    # fixed testcases
    for t in shared.get_tests(shared.get_test_dir('reduce'), ['.wast']):
        print('..', os.path.basename(t))
        # convert to wasm
        support.run_command(shared.WASM_AS + [t, '-o', 'a.wasm', '-all'])
        support.run_command(shared.WASM_REDUCE + ['a.wasm', '--command=%s b.wasm --fuzz-exec -all ' % shared.WASM_OPT[0], '-t', 'b.wasm', '-w', 'c.wasm', '--timeout=4'])
        expected = t + '.txt'
        support.run_command(shared.WASM_DIS + ['c.wasm', '-o', 'a.wat'])
        with open('a.wat') as seen:
            shared.fail_if_not_identical_to_file(seen.read(), expected)

    # run on a nontrivial fuzz testcase, for general coverage
    # this is very slow in ThreadSanitizer, so avoid it there
    if 'fsanitize=thread' not in str(os.environ):
        print('\n[ checking wasm-reduce fuzz testcase ]\n')
        # TODO: re-enable multivalue once it is better optimized
        support.run_command(shared.WASM_OPT + [os.path.join(shared.options.binaryen_test, 'lit/basic/signext.wast'), '-ttf', '-Os', '-o', 'a.wasm', '--detect-features', '--disable-multivalue'])
        before = os.stat('a.wasm').st_size
        support.run_command(shared.WASM_REDUCE + ['a.wasm', '--command=%s b.wasm --fuzz-exec --detect-features' % shared.WASM_OPT[0], '-t', 'b.wasm', '-w', 'c.wasm'])
        after = os.stat('c.wasm').st_size
        # This number is a custom threshold to check if we have shrunk the
        # output sufficiently
        assert after < 0.85 * before, [before, after]


def run_spec_tests():
    print('\n[ checking wasm-shell spec testcases... ]\n')

    for wast in shared.options.spec_tests:
        base = os.path.basename(wast)
        print('..', base)
        # windows has some failures that need to be investigated
        if base == 'names.wast' and shared.skip_if_on_windows('spec: ' + base):
            continue

        def run_spec_test(wast):
            cmd = shared.WASM_SHELL + [wast]
            output = support.run_command(cmd, stderr=subprocess.PIPE)
            # filter out binaryen interpreter logging that the spec suite
            # doesn't expect
            filtered = [line for line in output.splitlines() if not line.startswith('[trap')]
            return '\n'.join(filtered) + '\n'

        def run_opt_test(wast):
            # check optimization validation
            cmd = shared.WASM_OPT + [wast, '-O', '-all', '-q']
            support.run_command(cmd)

        def check_expected(actual, expected):
            if expected and os.path.exists(expected):
                expected = open(expected).read()
                print('       (using expected output)')
                actual = actual.strip()
                expected = expected.strip()
                if actual != expected:
                    shared.fail(actual, expected)

        expected = os.path.join(shared.get_test_dir('spec'), 'expected-output', base + '.log')

        # some spec tests should fail (actual process failure, not just assert_invalid)
        try:
            actual = run_spec_test(wast)
        except Exception as e:
            if ('wasm-validator error' in str(e) or 'error: ' in str(e)) and '.fail.' in base:
                print('<< test failed as expected >>')
                continue  # don't try all the binary format stuff TODO
            else:
                shared.fail_with_error(str(e))

        check_expected(actual, expected)

        run_spec_test(wast)

        # check binary format. here we can verify execution of the final
        # result, no need for an output verification
        split_num = 0
        actual = ''
        with open('spec.wast', 'w') as transformed_spec_file:
            for module, asserts in support.split_wast(wast):
                if not module:
                    # Skip any initial assertions that don't have a module
                    continue
                print('        testing split module', split_num)
                split_num += 1
                support.write_wast('split.wast', module)
                run_opt_test('split.wast')    # also that our optimizer doesn't break on it
                result_wast_file = shared.binary_format_check('split.wast', verify_final_result=False)
                with open(result_wast_file) as f:
                    result_wast = f.read()
                    # add the asserts, and verify that the test still passes
                    transformed_spec_file.write(result_wast + '\n' + '\n'.join(asserts))

        # compare all the outputs to the expected output
        actual = run_spec_test('spec.wast')
        check_expected(actual, os.path.join(shared.get_test_dir('spec'), 'expected-output', base + '.log'))


def run_validator_tests():
    print('\n[ running validation tests... ]\n')
    # Ensure the tests validate by default
    cmd = shared.WASM_AS + [os.path.join(shared.get_test_dir('validator'), 'invalid_export.wast'), '-o', 'a.wasm']
    support.run_command(cmd)
    cmd = shared.WASM_AS + [os.path.join(shared.get_test_dir('validator'), 'invalid_import.wast'), '-o', 'a.wasm']
    support.run_command(cmd)
    cmd = shared.WASM_AS + ['--validate=web', os.path.join(shared.get_test_dir('validator'), 'invalid_export.wast'), '-o', 'a.wasm']
    support.run_command(cmd, expected_status=1)
    cmd = shared.WASM_AS + ['--validate=web', os.path.join(shared.get_test_dir('validator'), 'invalid_import.wast'), '-o', 'a.wasm']
    support.run_command(cmd, expected_status=1)
    cmd = shared.WASM_AS + ['--validate=none', os.path.join(shared.get_test_dir('validator'), 'invalid_return.wast'), '-o', 'a.wasm']
    support.run_command(cmd)
    cmd = shared.WASM_AS + [os.path.join(shared.get_test_dir('validator'), 'invalid_number.wast'), '-o', 'a.wasm']
    support.run_command(cmd, expected_status=1)


def run_example_tests():
    print('\n[ checking native example testcases...]\n')
    if not shared.NATIVECC or not shared.NATIVEXX:
        shared.fail_with_error('Native compiler (e.g. gcc/g++) was not found in PATH!')
        return
    # windows + gcc will need some work
    if shared.skip_if_on_windows('example'):
        return

    for t in shared.get_tests(shared.get_test_dir('example')):
        output_file = 'example'
        cmd = ['-I' + os.path.join(shared.options.binaryen_root, 't'), '-g', '-pthread', '-o', output_file]
        if not t.endswith(('.c', '.cpp')):
            continue
        src = os.path.join(shared.get_test_dir('example'), t)
        expected = os.path.join(shared.get_test_dir('example'), '.'.join(t.split('.')[:-1]) + '.txt')
        # build the C file separately
        libpath = shared.options.binaryen_lib
        extra = [shared.NATIVECC, src, '-c', '-o', 'example.o',
                 '-I' + os.path.join(shared.options.binaryen_root, 'src'), '-g', '-L' + libpath, '-pthread']
        if src.endswith('.cpp'):
            extra += ['-std=c++' + str(shared.cxx_standard)]
        if os.environ.get('COMPILER_FLAGS'):
            for f in os.environ.get('COMPILER_FLAGS').split(' '):
                extra.append(f)
        print('build: ', ' '.join(extra))
        subprocess.check_call(extra)
        # Link against the binaryen C library DSO, using an executable-relative rpath
        cmd = ['example.o', '-L' + libpath, '-lbinaryen'] + cmd + ['-Wl,-rpath,' + libpath]
        print('  ', t, src, expected)
        if os.environ.get('COMPILER_FLAGS'):
            for f in os.environ.get('COMPILER_FLAGS').split(' '):
                cmd.append(f)
        cmd = [shared.NATIVEXX, '-std=c++' + str(shared.cxx_standard)] + cmd
        print('link: ', ' '.join(cmd))
        subprocess.check_call(cmd)
        print('run...', output_file)
        actual = subprocess.check_output([os.path.abspath(output_file)]).decode('utf-8')
        os.remove(output_file)
        shared.fail_if_not_identical_to_file(actual, expected)


def run_unittest():
    print('\n[ checking unit tests...]\n')

    # equivalent to `python -m unittest discover -s ./test -v`
    suite = unittest.defaultTestLoader.discover(os.path.dirname(shared.options.binaryen_test))
    result = unittest.TextTestRunner(verbosity=2, failfast=shared.options.abort_on_first_failure).run(suite)
    shared.num_failures += len(result.errors) + len(result.failures)
    if shared.options.abort_on_first_failure and shared.num_failures:
        raise Exception("unittest failed")


def run_lit():
    def run():
        lit_script = os.path.join(shared.options.binaryen_bin, 'binaryen-lit')
        lit_tests = os.path.join(shared.options.binaryen_root, 'test', 'lit')
        # lit expects to be run as its own executable
        cmd = [sys.executable, lit_script, lit_tests, '-vv']
        result = subprocess.run(cmd)
        if result.returncode != 0:
            shared.num_failures += 1
        if shared.options.abort_on_first_failure and shared.num_failures:
            raise Exception("lit test failed")

    shared.with_pass_debug(run)


def run_gtest():
    def run():
        gtest = os.path.join(shared.options.binaryen_bin, 'binaryen-unittests')
        if not os.path.isfile(gtest):
            shared.warn('gtest binary not found - skipping tests')
        else:
            result = subprocess.run(gtest)
            if result.returncode != 0:
                shared.num_failures += 1
            if shared.options.abort_on_first_failure and shared.num_failures:
                raise Exception("gtest test failed")

    shared.with_pass_debug(run)


TEST_SUITES = OrderedDict([
    ('version', run_version_tests),
    ('wasm-opt', wasm_opt.test_wasm_opt),
    ('wasm-dis', run_wasm_dis_tests),
    ('crash', run_crash_tests),
    ('dylink', run_dylink_tests),
    ('ctor-eval', run_ctor_eval_tests),
    ('wasm-metadce', run_wasm_metadce_tests),
    ('wasm-reduce', run_wasm_reduce_tests),
    ('spec', run_spec_tests),
    ('lld', lld.test_wasm_emscripten_finalize),
    ('wasm2js', wasm2js.test_wasm2js),
    ('validator', run_validator_tests),
    ('example', run_example_tests),
    ('unit', run_unittest),
    ('binaryenjs', binaryenjs.test_binaryen_js),
    ('binaryenjs_wasm', binaryenjs.test_binaryen_wasm),
    ('lit', run_lit),
    ('gtest', run_gtest),
])


# Run all the tests
def main():
    all_suites = TEST_SUITES.keys()
    skip_by_default = ['binaryenjs', 'binaryenjs_wasm']

    if shared.options.list_suites:
        for suite in all_suites:
            print(suite)
        return 0

    for r in shared.requested:
        if r not in all_suites:
            print('invalid test suite: %s (see --list-suites)\n' % r)
            return 1

    if not shared.requested:
        shared.requested = [s for s in all_suites if s not in skip_by_default]

    for test in shared.requested:
        TEST_SUITES[test]()

    # Check/display the results
    if shared.num_failures == 0:
        print('\n[ success! ]')

    if shared.warnings:
        print('\n' + '\n'.join(shared.warnings))

    if shared.num_failures > 0:
        print('\n[ ' + str(shared.num_failures) + ' failures! ]')
        return 1

    return 0


if __name__ == '__main__':
    sys.exit(main())
