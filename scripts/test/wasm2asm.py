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
    WASM2ASM, MOZJS, NODEJS, fail_if_not_identical, options, tests,
    fail_if_not_identical_to_file
)

# tests with i64s, invokes, etc.
spec_dir = os.path.join(options.binaryen_test, 'spec')
spec_tests = [os.path.join(spec_dir, t)
              for t in sorted(os.listdir(spec_dir))
              if '.fail' not in t]
wasm2asm_dir = os.path.join(options.binaryen_test, 'wasm2asm')
extra_wasm2asm_tests = [os.path.join(wasm2asm_dir, t) for t in
                        sorted(os.listdir(wasm2asm_dir))]
assert_tests = ['wasm2asm.wast.asserts']


def test_wasm2asm_output():
  for wasm in tests + spec_tests + extra_wasm2asm_tests:
    if not wasm.endswith('.wast'):
      continue

    asm = os.path.basename(wasm).replace('.wast', '.2asm.js')
    expected_file = os.path.join(wasm2asm_dir, asm)

    if not os.path.exists(expected_file):
      continue

    print '..', wasm

    cmd = WASM2ASM + [os.path.join(options.binaryen_test, wasm)]
    out = run_command(cmd)
    fail_if_not_identical_to_file(out, expected_file)

    if not NODEJS and not MOZJS:
      print 'No JS interpreters. Skipping spec tests.'
      continue

    open('a.2asm.js', 'w').write(out)

    cmd += ['--allow-asserts']
    out = run_command(cmd)

    open('a.2asm.asserts.js', 'w').write(out)

    # verify asm.js is valid js
    if NODEJS:
      out = run_command([NODEJS, 'a.2asm.js'])
      fail_if_not_identical(out, '')
      out = run_command([NODEJS, 'a.2asm.asserts.js'], expected_err='')
      fail_if_not_identical(out, '')

    if MOZJS:
      # verify asm.js validates, if this is asm.js code (we emit
      # almost-asm instead when we need to)
      if 'use asm' in open('a.2asm.js').read():
        # check only subset of err because mozjs emits timing info
        out = run_command([MOZJS, '-w', 'a.2asm.js'],
                          expected_err='Successfully compiled asm.js code',
                          err_contains=True)
        fail_if_not_identical(out, '')
        out = run_command([MOZJS, 'a.2asm.asserts.js'], expected_err='')
        fail_if_not_identical(out, '')


def test_asserts_output():
  for wasm in assert_tests:
    print '..', wasm

    asserts = os.path.basename(wasm).replace('.wast.asserts', '.asserts.js')
    traps = os.path.basename(wasm).replace('.wast.asserts', '.traps.js')
    asserts_expected_file = os.path.join(options.binaryen_test, asserts)
    traps_expected_file = os.path.join(options.binaryen_test, traps)

    wasm = os.path.join(wasm2asm_dir, wasm)
    cmd = WASM2ASM + [wasm, '--allow-asserts']
    out = run_command(cmd)
    fail_if_not_identical_to_file(out, asserts_expected_file)

    cmd += ['--pedantic']
    out = run_command(cmd)
    fail_if_not_identical_to_file(out, traps_expected_file)


def test_wasm2asm():
  print '\n[ checking wasm2asm testcases... ]\n'
  test_wasm2asm_output()
  test_asserts_output()


if __name__ == "__main__":
  test_wasm2asm()
