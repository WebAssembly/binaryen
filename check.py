#!/usr/bin/env python2
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
import shutil
import subprocess
import sys
import unittest

from scripts.test.support import run_command, split_wast
from scripts.test.shared import (
    BIN_DIR, NATIVECC, NATIVEXX, NODEJS, WASM_AS,
    WASM_CTOR_EVAL, WASM_OPT, WASM_SHELL, WASM_METADCE, WASM_DIS, WASM_REDUCE,
    binary_format_check, delete_from_orbit, fail, fail_with_error,
    fail_if_not_identical, fail_if_not_contained, has_vanilla_emcc,
    has_vanilla_llvm, minify_check, options, tests, requested, warnings,
    has_shell_timeout, fail_if_not_identical_to_file, with_pass_debug,
    validate_binary
)

# For shared.num_failures. Cannot import directly because modifications made in
# shared.py would not affect the version imported here.
from scripts.test import shared
from scripts.test import asm2wasm
from scripts.test import lld
from scripts.test import wasm2js
from scripts.test import binaryenjs

if options.interpreter:
  print '[ using wasm interpreter at "%s" ]' % options.interpreter
  assert os.path.exists(options.interpreter), 'interpreter not found'


def run_help_tests():
  print '[ checking --help is useful... ]\n'

  not_executable_suffix = ['.txt', '.js', '.ilk', '.pdb', '.dll', '.wasm']
  executables = sorted(filter(lambda x: not any(x.endswith(s) for s in
                                                not_executable_suffix) and os.path.isfile(x),
                              os.listdir(options.binaryen_bin)))
  for e in executables:
    print '.. %s --help' % e
    out, err = subprocess.Popen([os.path.join(options.binaryen_bin, e), '--help'],
                                stdout=subprocess.PIPE,
                                stderr=subprocess.PIPE).communicate()
    assert len(out) == 0, 'Expected no stdout, got:\n%s' % out
    assert e.replace('.exe', '') in err, 'Expected help to contain program name, got:\n%s' % err
    assert len(err.split('\n')) > 8, 'Expected some help, got:\n%s' % err


def run_wasm_opt_tests():
  print '\n[ checking wasm-opt -o notation... ]\n'

  for extra_args in [[], ['--no-validation']]:
    wast = os.path.join(options.binaryen_test, 'hello_world.wast')
    delete_from_orbit('a.wast')
    cmd = WASM_OPT + [wast, '-o', 'a.wast', '-S'] + extra_args
    run_command(cmd)
    fail_if_not_identical_to_file(open('a.wast').read(), wast)

  print '\n[ checking wasm-opt binary reading/writing... ]\n'

  shutil.copyfile(os.path.join(options.binaryen_test, 'hello_world.wast'), 'a.wast')
  delete_from_orbit('a.wasm')
  delete_from_orbit('b.wast')
  run_command(WASM_OPT + ['a.wast', '-o', 'a.wasm'])
  assert open('a.wasm', 'rb').read()[0] == '\0', 'we emit binary by default'
  run_command(WASM_OPT + ['a.wasm', '-o', 'b.wast', '-S'])
  assert open('b.wast', 'rb').read()[0] != '\0', 'we emit text with -S'

  print '\n[ checking wasm-opt passes... ]\n'

  for t in sorted(os.listdir(os.path.join(options.binaryen_test, 'passes'))):
    if t.endswith(('.wast', '.wasm')):
      print '..', t
      binary = '.wasm' in t
      base = os.path.basename(t).replace('.wast', '').replace('.wasm', '')
      passname = base
      if passname.isdigit():
        passname = open(os.path.join(options.binaryen_test, 'passes', passname + '.passes')).read().strip()
      opts = [('--' + p if not p.startswith('O') else '-' + p) for p in passname.split('_')]
      t = os.path.join(options.binaryen_test, 'passes', t)
      actual = ''
      for module, asserts in split_wast(t):
        assert len(asserts) == 0
        with open('split.wast', "wb" if binary else 'w') as o:
          o.write(module)
        cmd = WASM_OPT + opts + ['split.wast', '--print']
        curr = run_command(cmd)
        actual += curr
        # also check debug mode output is valid
        debugged = run_command(cmd + ['--debug'], stderr=subprocess.PIPE)
        fail_if_not_contained(actual, debugged)

        # also check pass-debug mode
        def check():
          pass_debug = run_command(cmd)
          fail_if_not_identical(curr, pass_debug)
        with_pass_debug(check)

      expected_file = os.path.join(options.binaryen_test, 'passes',
                                   base + ('.bin' if binary else '') + '.txt')
      fail_if_not_identical_to_file(actual, expected_file)

      if 'emit-js-wrapper' in t:
        with open('a.js') as actual:
          fail_if_not_identical_to_file(actual.read(), t + '.js')
      if 'emit-spec-wrapper' in t:
        with open('a.wat') as actual:
          fail_if_not_identical_to_file(actual.read(), t + '.wat')

  print '\n[ checking wasm-opt parsing & printing... ]\n'

  for t in sorted(os.listdir(os.path.join(options.binaryen_test, 'print'))):
    if t.endswith('.wast'):
      print '..', t
      wasm = os.path.basename(t).replace('.wast', '')
      cmd = WASM_OPT + [os.path.join(options.binaryen_test, 'print', t), '--print', '-all']
      print '    ', ' '.join(cmd)
      actual, err = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True).communicate()
      expected_file = os.path.join(options.binaryen_test, 'print', wasm + '.txt')
      fail_if_not_identical_to_file(actual, expected_file)
      cmd = WASM_OPT + [os.path.join(options.binaryen_test, 'print', t), '--print-minified', '-all']
      print '    ', ' '.join(cmd)
      actual, err = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True).communicate()
      fail_if_not_identical(actual.strip(), open(os.path.join(options.binaryen_test, 'print', wasm + '.minified.txt')).read().strip())

  print '\n[ checking wasm-opt testcases... ]\n'

  for t in tests:
    if t.endswith('.wast') and not t.startswith('spec'):
      print '..', t
      t = os.path.join(options.binaryen_test, t)
      f = t + '.from-wast'
      cmd = WASM_OPT + [t, '--print', '-all']
      actual = run_command(cmd)
      actual = actual.replace('printing before:\n', '')

      fail_if_not_identical_to_file(actual, f)

      binary_format_check(t, wasm_as_args=['-g'])  # test with debuginfo
      binary_format_check(t, wasm_as_args=[], binary_suffix='.fromBinary.noDebugInfo')  # test without debuginfo

      minify_check(t)

  print '\n[ checking wasm-opt debugInfo read-write... ]\n'

  for t in os.listdir('test'):
    if t.endswith('.fromasm') and 'debugInfo' in t:
      print '..', t
      t = os.path.join('test', t)
      f = t + '.read-written'
      run_command(WASM_AS + [t, '--source-map=a.map', '-o', 'a.wasm', '-g'])
      run_command(WASM_OPT + ['a.wasm', '--input-source-map=a.map', '-o', 'b.wasm', '--output-source-map=b.map', '-g'])
      actual = run_command(WASM_DIS + ['b.wasm', '--source-map=b.map'])
      fail_if_not_identical_to_file(actual, f)


def run_wasm_dis_tests():
  print '\n[ checking wasm-dis on provided binaries... ]\n'

  for t in tests:
    if t.endswith('.wasm') and not t.startswith('spec'):
      print '..', t
      t = os.path.join(options.binaryen_test, t)
      cmd = WASM_DIS + [t]
      if os.path.isfile(t + '.map'):
        cmd += ['--source-map', t + '.map']

      actual = run_command(cmd)
      fail_if_not_identical_to_file(actual, t + '.fromBinary')

      # also verify there are no validation errors
      def check():
        cmd = WASM_OPT + [t, '-all']
        run_command(cmd)

      with_pass_debug(check)

      validate_binary(t)


def run_crash_tests():
  print "\n[ checking we don't crash on tricky inputs... ]\n"

  test_dir = os.path.join(options.binaryen_test, 'crash')
  for t in os.listdir(test_dir):
    if t.endswith(('.wast', '.wasm')):
      print '..', t
      t = os.path.join(test_dir, t)
      cmd = WASM_OPT + [t]
      # expect a parse error to be reported
      run_command(cmd, expected_err='parse exception:', err_contains=True, expected_status=1)


def run_dylink_tests():
  print "\n[ we emit dylink sections properly... ]\n"

  for t in os.listdir(options.binaryen_test):
    if t.startswith('dylib') and t.endswith('.wasm'):
      print '..', t
      t = os.path.join(options.binaryen_test, t)
      cmd = WASM_OPT + [t, '-o', 'a.wasm']
      run_command(cmd)
      with open('a.wasm') as output:
        index = output.read().find('dylink')
        print '  ', index
        assert index == 11, 'dylink section must be first, right after the magic number etc.'


def run_ctor_eval_tests():
  print '\n[ checking wasm-ctor-eval... ]\n'

  test_dir = os.path.join(options.binaryen_test, 'ctor-eval')
  for t in os.listdir(test_dir):
    if t.endswith(('.wast', '.wasm')):
      print '..', t
      t = os.path.join(test_dir, t)
      ctors = open(t + '.ctors').read().strip()
      cmd = WASM_CTOR_EVAL + [t, '-o', 'a.wast', '-S', '--ctors', ctors]
      run_command(cmd)
      actual = open('a.wast').read()
      out = t + '.out'
      fail_if_not_identical_to_file(actual, out)


def run_wasm_metadce_tests():
  print '\n[ checking wasm-metadce ]\n'

  test_dir = os.path.join(options.binaryen_test, 'metadce')
  for t in os.listdir(test_dir):
    if t.endswith(('.wast', '.wasm')):
      print '..', t
      t = os.path.join(test_dir, t)
      graph = t + '.graph.txt'
      cmd = WASM_METADCE + [t, '--graph-file=' + graph, '-o', 'a.wast', '-S']
      stdout = run_command(cmd)
      expected = t + '.dced'
      with open('a.wast') as seen:
        fail_if_not_identical_to_file(seen.read(), expected)
      fail_if_not_identical_to_file(stdout, expected + '.stdout')


def run_wasm_reduce_tests():
  print '\n[ checking wasm-reduce testcases]\n'

  # fixed testcases
  test_dir = os.path.join(options.binaryen_test, 'reduce')
  for t in os.listdir(test_dir):
    if t.endswith('.wast'):
      print '..', t
      t = os.path.join(test_dir, t)
      # convert to wasm
      run_command(WASM_AS + [t, '-o', 'a.wasm'])
      run_command(WASM_REDUCE + ['a.wasm', '--command=%s b.wasm --fuzz-exec -all' % WASM_OPT[0], '-t', 'b.wasm', '-w', 'c.wasm', '--timeout=4'])
      expected = t + '.txt'
      run_command(WASM_DIS + ['c.wasm', '-o', 'a.wast'])
      with open('a.wast') as seen:
        fail_if_not_identical_to_file(seen.read(), expected)

  # run on a nontrivial fuzz testcase, for general coverage
  # this is very slow in ThreadSanitizer, so avoid it there
  if 'fsanitize=thread' not in str(os.environ):
    print '\n[ checking wasm-reduce fuzz testcase ]\n'

    run_command(WASM_OPT + [os.path.join(options.binaryen_test, 'unreachable-import_wasm-only.asm.js'), '-ttf', '-Os', '-o', 'a.wasm', '-all'])
    before = os.stat('a.wasm').st_size
    run_command(WASM_REDUCE + ['a.wasm', '--command=%s b.wasm --fuzz-exec -all' % WASM_OPT[0], '-t', 'b.wasm', '-w', 'c.wasm'])
    after = os.stat('c.wasm').st_size
    assert after < 0.6 * before, [before, after]


def run_spec_tests():
  print '\n[ checking wasm-shell spec testcases... ]\n'

  if len(requested) == 0:
    # FIXME we support old and new memory formats, for now, until 0xc, and so can't pass this old-style test.
    BLACKLIST = ['binary.wast']
    # FIXME to update the spec to 0xd, we need to implement (register "name") for import.wast
    spec_tests = [os.path.join('spec', t) for t in sorted(os.listdir(os.path.join(options.binaryen_test, 'spec'))) if t not in BLACKLIST]
  else:
    spec_tests = requested[:]

  for t in spec_tests:
    if t.startswith('spec') and t.endswith('.wast'):
      print '..', t
      wast = os.path.join(options.binaryen_test, t)

      # skip checks for some tests
      if os.path.basename(wast) in ['linking.wast', 'nop.wast', 'stack.wast', 'typecheck.wast', 'unwind.wast']:  # FIXME
        continue

      def run_spec_test(wast):
        cmd = WASM_SHELL + [wast]
        # we must skip the stack machine portions of spec tests or apply other extra args
        extra = {
        }
        cmd = cmd + (extra.get(os.path.basename(wast)) or [])
        return run_command(cmd, stderr=subprocess.PIPE)

      def run_opt_test(wast):
        # check optimization validation
        cmd = WASM_OPT + [wast, '-O', '-all']
        run_command(cmd)

      def check_expected(actual, expected):
        if expected and os.path.exists(expected):
          expected = open(expected).read()

          # fix it up, our pretty (i32.const 83) must become compared to a homely 83 : i32
          def fix_expected(x):
            x = x.strip()
            if not x:
              return x
            v, t = x.split(' : ')
            if v.endswith('.'):
              v = v[:-1]  # remove trailing '.'
            return '(' + t + '.const ' + v + ')'

          def fix_actual(x):
            if '[trap ' in x:
              return ''
            return x

          expected = '\n'.join(map(fix_expected, expected.split('\n')))
          actual = '\n'.join(map(fix_actual, actual.split('\n')))
          print '       (using expected output)'
          actual = actual.strip()
          expected = expected.strip()
          if actual != expected:
            fail(actual, expected)

      expected = os.path.join(options.binaryen_test, 'spec', 'expected-output', os.path.basename(wast) + '.log')

      # some spec tests should fail (actual process failure, not just assert_invalid)
      try:
        actual = run_spec_test(wast)
      except Exception, e:
        if ('wasm-validator error' in str(e) or 'parse exception' in str(e)) and '.fail.' in t:
          print '<< test failed as expected >>'
          continue  # don't try all the binary format stuff TODO
        else:
          fail_with_error(str(e))

      check_expected(actual, expected)

      # skip binary checks for tests that reuse previous modules by name, as that's a wast-only feature
      if os.path.basename(wast) in ['exports.wast']:  # FIXME
        continue

      # we must ignore some binary format splits
      splits_to_skip = {
          'func.wast': [2],
          'return.wast': [2]
      }

      # check binary format. here we can verify execution of the final result, no need for an output verification
      split_num = 0
      if os.path.basename(wast) not in []:  # avoid some tests with things still being sorted out in the spec
        actual = ''
        for module, asserts in split_wast(wast):
          skip = splits_to_skip.get(os.path.basename(wast)) or []
          if split_num in skip:
            print '    skipping split module', split_num - 1
            split_num += 1
            continue
          print '    testing split module', split_num
          split_num += 1
          with open('split.wast', 'w') as o:
            o.write(module + '\n' + '\n'.join(asserts))
          run_spec_test('split.wast')  # before binary stuff - just check it's still ok split out
          run_opt_test('split.wast')  # also that our optimizer doesn't break on it
          result_wast = binary_format_check('split.wast', verify_final_result=False, original_wast=wast)
          # add the asserts, and verify that the test still passes
          open(result_wast, 'a').write('\n' + '\n'.join(asserts))
          actual += run_spec_test(result_wast)
        # compare all the outputs to the expected output
        check_expected(actual, os.path.join(options.binaryen_test, 'spec', 'expected-output', os.path.basename(wast) + '.log'))


def run_validator_tests():
  print '\n[ running validation tests... ]\n'
  # Ensure the tests validate by default
  cmd = WASM_AS + [os.path.join(options.binaryen_test, 'validator', 'invalid_export.wast')]
  run_command(cmd)
  cmd = WASM_AS + [os.path.join(options.binaryen_test, 'validator', 'invalid_import.wast')]
  run_command(cmd)
  cmd = WASM_AS + ['--validate=web', os.path.join(options.binaryen_test, 'validator', 'invalid_export.wast')]
  run_command(cmd, expected_status=1)
  cmd = WASM_AS + ['--validate=web', os.path.join(options.binaryen_test, 'validator', 'invalid_import.wast')]
  run_command(cmd, expected_status=1)
  cmd = WASM_AS + ['--validate=none', os.path.join(options.binaryen_test, 'validator', 'invalid_return.wast')]
  run_command(cmd)
  cmd = WASM_AS + [os.path.join(options.binaryen_test, 'validator', 'invalid_number.wast')]
  run_command(cmd, expected_status=1)


def run_vanilla_tests():
  print '\n[ checking emcc WASM_BACKEND testcases...]\n'

  try:
    if has_vanilla_llvm:
      os.environ['LLVM'] = BIN_DIR  # use the vanilla LLVM
    else:
      # if we did not set vanilla llvm, then we must set this env var to make emcc use the wasm backend.
      # (if we are using vanilla llvm, things should just work)
      print '(not using vanilla llvm, so setting env var to tell emcc to use wasm backend)'
      os.environ['EMCC_WASM_BACKEND'] = '1'
    VANILLA_EMCC = os.path.join(options.binaryen_test, 'emscripten', 'emcc')
    # run emcc to make sure it sets itself up properly, if it was never run before
    command = [VANILLA_EMCC, '-v']
    print '____' + ' '.join(command)
    subprocess.check_call(command)

    for c in sorted(os.listdir(os.path.join(options.binaryen_test, 'wasm_backend'))):
      if not c.endswith('cpp'):
        continue
      print '..', c
      base = c.replace('.cpp', '').replace('.c', '')
      expected = open(os.path.join(options.binaryen_test, 'wasm_backend', base + '.txt')).read()
      for opts in [[], ['-O1'], ['-O2']]:
        # only my code is a hack we used early in wasm backend dev, which somehow worked, but only with -O1
        only = [] if opts != ['-O1'] or '_only' not in base else ['-s', 'ONLY_MY_CODE=1']
        command = [VANILLA_EMCC, '-o', 'a.wasm.js', os.path.join(options.binaryen_test, 'wasm_backend', c)] + opts + only
        print '....' + ' '.join(command)
        if os.path.exists('a.wasm.js'):
          os.unlink('a.wasm.js')
        subprocess.check_call(command)
        if NODEJS:
          print '  (check in node)'
          cmd = [NODEJS, 'a.wasm.js']
          out = run_command(cmd)
          if out.strip() != expected.strip():
            fail(out, expected)
  finally:
    if has_vanilla_llvm:
      del os.environ['LLVM']
    else:
      del os.environ['EMCC_WASM_BACKEND']


def run_gcc_tests():
  print '\n[ checking native gcc testcases...]\n'
  if not NATIVECC or not NATIVEXX:
    fail_with_error('Native compiler (e.g. gcc/g++) was not found in PATH!')
    return

  for t in sorted(os.listdir(os.path.join(options.binaryen_test, 'example'))):
    output_file = 'example'
    cmd = ['-I' + os.path.join(options.binaryen_root, 'src'), '-g', '-pthread', '-o', output_file]
    if t.endswith('.txt'):
      # check if there is a trace in the file, if so, we should build it
      out = subprocess.Popen([os.path.join('scripts', 'clean_c_api_trace.py'), os.path.join(options.binaryen_test, 'example', t)], stdout=subprocess.PIPE).communicate()[0]
      if len(out) == 0:
        print '  (no trace in ', t, ')'
        continue
      print '  (will check trace in ', t, ')'
      src = 'trace.cpp'
      with open(src, 'w') as o:
        o.write(out)
      expected = os.path.join(options.binaryen_test, 'example', t + '.txt')
    else:
      src = os.path.join(options.binaryen_test, 'example', t)
      expected = os.path.join(options.binaryen_test, 'example', '.'.join(t.split('.')[:-1]) + '.txt')
    if src.endswith(('.c', '.cpp')):
      # build the C file separately
      libpath = os.path.join(os.path.dirname(options.binaryen_bin),  'lib')
      extra = [NATIVECC, src, '-c', '-o', 'example.o',
               '-I' + os.path.join(options.binaryen_root, 'src'), '-g', '-L' + libpath, '-pthread']
      if src.endswith('.cpp'):
        extra += ['-std=c++11']
      print 'build: ', ' '.join(extra)
      subprocess.check_call(extra)
      # Link against the binaryen C library DSO, using an executable-relative rpath
      cmd = ['example.o', '-L' + libpath, '-lbinaryen'] + cmd + ['-Wl,-rpath,' + libpath]
    else:
      continue
    print '  ', t, src, expected
    if os.environ.get('COMPILER_FLAGS'):
      for f in os.environ.get('COMPILER_FLAGS').split(' '):
        cmd.append(f)
    cmd = [NATIVEXX, '-std=c++11'] + cmd
    print 'link: ', ' '.join(cmd)
    subprocess.check_call(cmd)
    print 'run...', output_file
    actual = subprocess.check_output([os.path.abspath(output_file)])
    os.remove(output_file)
    if sys.platform == 'darwin':
      # Also removes debug directory produced on Mac OS
      shutil.rmtree(output_file + '.dSYM')

    fail_if_not_identical_to_file(actual, expected)


def run_unittest():
  print '\n[ checking unit tests...]\n'

  # equivalent to `python -m unittest discover -s ./test -v`
  suite = unittest.defaultTestLoader.discover(os.path.dirname(options.binaryen_test))
  result = unittest.TextTestRunner(verbosity=2, failfast=options.abort_on_first_failure).run(suite)
  shared.num_failures += len(result.errors) + len(result.failures)
  if options.abort_on_first_failure and shared.num_failures:
    raise Exception("unittest failed")


# Run all the tests
def main():
  run_help_tests()
  run_wasm_opt_tests()
  asm2wasm.test_asm2wasm()
  asm2wasm.test_asm2wasm_binary()
  run_wasm_dis_tests()
  run_crash_tests()
  run_dylink_tests()
  run_ctor_eval_tests()
  run_wasm_metadce_tests()
  if has_shell_timeout():
    run_wasm_reduce_tests()

  run_spec_tests()
  binaryenjs.test_binaryen_js()
  lld.test_wasm_emscripten_finalize()
  wasm2js.test_wasm2js()
  run_validator_tests()
  if has_vanilla_emcc and has_vanilla_llvm and 0:
    run_vanilla_tests()
  print '\n[ checking example testcases... ]\n'
  if options.run_gcc_tests:
    run_gcc_tests()

  run_unittest()

  # Check/display the results
  if shared.num_failures == 0:
    print '\n[ success! ]'

  if warnings:
    print '\n' + '\n'.join(warnings)

  if shared.num_failures > 0:
    print '\n[ ' + str(shared.num_failures) + ' failures! ]'
    return 1

  return 0


if __name__ == '__main__':
  sys.exit(main())
