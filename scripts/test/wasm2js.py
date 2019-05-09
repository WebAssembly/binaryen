#!/usr/bin/env python
#
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

from support import run_command, split_wast
from shared import (
    WASM2JS, MOZJS, NODEJS, fail_if_not_identical, options, tests,
    fail_if_not_identical_to_file, with_pass_debug
)

# tests with i64s, invokes, etc.
spec_dir = os.path.join(options.binaryen_test, 'spec')
spec_tests = [os.path.join(spec_dir, t)
              for t in sorted(os.listdir(spec_dir))
              if '.fail' not in t]
wasm2js_dir = os.path.join(options.binaryen_test, 'wasm2js')
extra_wasm2js_tests = [os.path.join(wasm2js_dir, t) for t in
                       sorted(os.listdir(wasm2js_dir))]
assert_tests = ['wasm2js.wast.asserts']
# These tests exercise functionality not supported by wasm2js
wasm2js_blacklist = ['empty_imported_table.wast']


def test_wasm2js_output():
  for opt in (0, 1):
    for wasm in tests + spec_tests + extra_wasm2js_tests:
      if not wasm.endswith('.wast'):
        continue
      basename = os.path.basename(wasm)
      if basename in wasm2js_blacklist:
        continue

      asm = basename.replace('.wast', '.2asm.js')
      expected_file = os.path.join(wasm2js_dir, asm)
      if opt:
        expected_file += '.opt'

      if not os.path.exists(expected_file):
        continue

      print '..', wasm

      t = os.path.join(options.binaryen_test, wasm)

      all_out = []

      for module, asserts in split_wast(t):
        with open('split.wast', 'w') as o:
          o.write(module + '\n'.join(asserts))

        cmd = WASM2JS + ['split.wast']
        if opt:
          cmd += ['-O']
        if 'emscripten' in wasm:
          cmd += ['--emscripten']
        out = run_command(cmd)
        all_out.append(out)

        if not NODEJS and not MOZJS:
          print 'No JS interpreters. Skipping spec tests.'
          continue

        open('a.2asm.mjs', 'w').write(out)

        cmd += ['--allow-asserts']
        out = run_command(cmd)
        # also verify it passes pass-debug verifications
        with_pass_debug(lambda: run_command(cmd))

        open('a.2asm.asserts.mjs', 'w').write(out)

        # verify asm.js is valid js, note that we're using --experimental-modules
        # to enable ESM syntax and we're also passing a custom loader to handle the
        # `spectest` and `env` modules in our tests.
        if NODEJS:
          node = [NODEJS, '--experimental-modules', '--loader', './scripts/test/node-esm-loader.mjs']
          cmd = node[:]
          cmd.append('a.2asm.mjs')
          out = run_command(cmd)
          fail_if_not_identical(out, '')
          cmd = node[:]
          cmd.append('a.2asm.asserts.mjs')
          out = run_command(cmd, expected_err='', err_ignore='The ESM module loader is experimental')
          fail_if_not_identical(out, '')

      fail_if_not_identical_to_file(''.join(all_out), expected_file)


def test_asserts_output():
  for wasm in assert_tests:
    print '..', wasm

    asserts = os.path.basename(wasm).replace('.wast.asserts', '.asserts.js')
    traps = os.path.basename(wasm).replace('.wast.asserts', '.traps.js')
    asserts_expected_file = os.path.join(options.binaryen_test, asserts)
    traps_expected_file = os.path.join(options.binaryen_test, traps)

    wasm = os.path.join(wasm2js_dir, wasm)
    cmd = WASM2JS + [wasm, '--allow-asserts']
    out = run_command(cmd)
    fail_if_not_identical_to_file(out, asserts_expected_file)

    cmd += ['--pedantic']
    out = run_command(cmd)
    fail_if_not_identical_to_file(out, traps_expected_file)


def test_wasm2js():
  print '\n[ checking wasm2js testcases... ]\n'
  test_wasm2js_output()
  test_asserts_output()


def update_wasm2js_tests():
  print '\n[ checking wasm2js ]\n'

  for opt in (0, 1):
    for wasm in tests + spec_tests + extra_wasm2js_tests:
      if not wasm.endswith('.wast'):
        continue

      if os.path.basename(wasm) in wasm2js_blacklist:
        continue

      asm = os.path.basename(wasm).replace('.wast', '.2asm.js')
      expected_file = os.path.join(wasm2js_dir, asm)
      if opt:
        expected_file += '.opt'

      # we run wasm2js on tests and spec tests only if the output
      # exists - only some work so far. the tests in extra are in
      # the test/wasm2js dir and so are specific to wasm2js, and
      # we run all of those.
      if wasm not in extra_wasm2js_tests and not os.path.exists(expected_file):
        continue

      print '..', wasm

      t = os.path.join(options.binaryen_test, wasm)

      all_out = []

      for module, asserts in split_wast(t):
        with open('split.wast', 'w') as o:
          o.write(module + '\n'.join(asserts))

        cmd = WASM2JS + ['split.wast']
        if opt:
          cmd += ['-O']
        if 'emscripten' in wasm:
          cmd += ['--emscripten']
        out = run_command(cmd)
        all_out.append(out)

      with open(expected_file, 'w') as o:
        o.write(''.join(all_out))

  for wasm in assert_tests:
    print '..', wasm

    asserts = os.path.basename(wasm).replace('.wast.asserts', '.asserts.js')
    traps = os.path.basename(wasm).replace('.wast.asserts', '.traps.js')
    asserts_expected_file = os.path.join('test', asserts)
    traps_expected_file = os.path.join('test', traps)

    cmd = WASM2JS + [os.path.join(wasm2js_dir, wasm), '--allow-asserts']
    out = run_command(cmd)
    with open(asserts_expected_file, 'w') as o:
      o.write(out)

    cmd += ['--pedantic']
    out = run_command(cmd)
    with open(traps_expected_file, 'w') as o:
      o.write(out)


if __name__ == "__main__":
  test_wasm2js()
