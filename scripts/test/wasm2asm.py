#!/usr/bin/env python2

import os

from support import run_command
from shared import (
    WASM2ASM, MOZJS, NODEJS, fail_if_not_identical, options, tests
)

# tests with i64s, invokes, etc.
spec_dir = os.path.join(options.binaryen_test, 'spec')
spec_tests = [os.path.join(spec_dir, t)
              for t in sorted(os.listdir(spec_dir))
              if '.fail' not in t]
wasm2asm_dir = os.path.join(options.binaryen_test, 'wasm2asm')
extra_tests = [os.path.join(wasm2asm_dir, t) for t in
               sorted(os.listdir(wasm2asm_dir))]
assert_tests = ['wasm2asm.wast.asserts']


def test_wasm2asm_output():
  for wasm in tests + spec_tests + extra_tests:
    if not wasm.endswith('.wast'):
      continue

    asm = os.path.basename(wasm).replace('.wast', '.2asm.js')
    expected_file = os.path.join(options.binaryen_test, asm)

    if not os.path.exists(expected_file):
      continue

    print '..', wasm

    cmd = WASM2ASM + [os.path.join(options.binaryen_test, wasm)]
    out = run_command(cmd)
    expected = open(expected_file).read()
    fail_if_not_identical(out, expected)

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

    wasm = os.path.join(options.binaryen_test, wasm)
    cmd = WASM2ASM + [wasm, '--allow-asserts']
    out = run_command(cmd)
    expected = open(asserts_expected_file).read()
    fail_if_not_identical(out, expected)

    cmd += ['--pedantic']
    out = run_command(cmd)
    expected = open(traps_expected_file).read()
    fail_if_not_identical(out, expected)


def test_wasm2asm():
  print '\n[ checking wasm2asm testcases... ]\n'
  test_wasm2asm_output()
  test_asserts_output()


if __name__ == "__main__":
  test_wasm2asm()
