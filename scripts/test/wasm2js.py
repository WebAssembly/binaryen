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

from support import run_command
from shared import (
    WASM2JS, MOZJS, NODEJS, fail_if_not_identical, options, tests,
    fail_if_not_identical_to_file
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
  for wasm in tests + spec_tests + extra_wasm2js_tests:
    if not wasm.endswith('.wast'):
      continue
    basename = os.path.basename(wasm)
    if basename in wasm2js_blacklist:
      continue

    asm = basename.replace('.wast', '.2asm.js')
    expected_file = os.path.join(wasm2js_dir, asm)

    if not os.path.exists(expected_file):
      continue

    print '..', wasm

    cmd = WASM2JS + [os.path.join(options.binaryen_test, wasm)]
    out = run_command(cmd)
    fail_if_not_identical_to_file(out, expected_file)

    if not NODEJS and not MOZJS:
      print 'No JS interpreters. Skipping spec tests.'
      continue

    open('a.2asm.mjs', 'w').write(out)

    cmd += ['--allow-asserts']
    out = run_command(cmd)

    open('a.2asm.asserts.mjs', 'w').write(out)

    # verify asm.js is valid js, note that we're using --experimental-modules
    # to enable ESM syntax and we're also passing a custom loader to handle the
    # `spectest` module in our tests.
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


if __name__ == "__main__":
  test_wasm2js()
