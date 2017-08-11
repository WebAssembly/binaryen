#!/usr/bin/env python2

import os

from support import run_command
from shared import (WASM2ASM, MOZJS, NODEJS, fail_if_not_identical, tests)


def test_wasm2asm_output(wasm, expected_file):
  cmd = WASM2ASM + [os.path.join('test', wasm)]
  out = run_command(cmd)
  expected = open(expected_file).read()
  fail_if_not_identical(out, expected)

  open('a.2asm.js', 'w').write(out)

  # verify asm.js is valid js
  if NODEJS:
    out = run_command([NODEJS, 'a.2asm.js'])
    fail_if_not_identical(out, '')

  if MOZJS:
    # verify asm.js validates
    # check only subset of err because mozjs emits timing info
    out = run_command([MOZJS, '-w', 'a.2asm.js'],
                      expected_err='Successfully compiled asm.js code',
                      err_contains=True)
    fail_if_not_identical(out, '')


def test_asserts_output(wasm, expected_file):
  cmd = WASM2ASM + [os.path.join('test', wasm), '--allow-asserts']
  out = run_command(cmd)
  expected = open(expected_file).read()
  fail_if_not_identical(out, expected)

  open('a.asserts.js', 'w').write(out)

  for engine in [NODEJS, MOZJS]:
    if not engine:
      continue
    out = run_command([engine, 'a.asserts.js'])
    fail_if_not_identical(out, '')


def test_trap_asserts_output(wasm, expected_file):
  cmd = WASM2ASM + [os.path.join('test', wasm),
                    '--allow-asserts', '--pedantic']
  out = run_command(cmd)
  expected = open(expected_file).read()
  fail_if_not_identical(out, expected)


def test_wasm2asm():
  print '\n[ checking wasm2asm testcases... ]\n'

  # tests with i64s, invokes, etc.
  blacklist = ['address.wast']
  spec_tests = [os.path.join('spec', t) for t in
                sorted(os.listdir(os.path.join('test', 'spec')))]

  for wasm in tests + [w for w in spec_tests if '.fail' not in w]:
    if not wasm.endswith('.wast') or os.path.basename(wasm) in blacklist:
      continue

    asm = os.path.basename(wasm).replace('.wast', '.2asm.js')
    asserts = os.path.basename(wasm).replace('.wast', '.asserts.js')
    traps = os.path.basename(wasm).replace('.wast', '.traps.js')

    asm_expected_file = os.path.join('test', asm)
    asserts_expected_file = os.path.join('test', asserts)
    traps_expected_file = os.path.join('test', traps)

    if not os.path.exists(asm_expected_file):
      continue

    print '..', wasm
    if not NODEJS and not MOZJS:
      print 'No JS interpreters. Skipping spec tests.'

    test_wasm2asm_output(wasm, asm_expected_file)

    if not os.path.exists(asserts_expected_file):
      continue

    test_asserts_output(wasm, asserts_expected_file)
    test_trap_asserts_output(wasm, traps_expected_file)


if __name__ == "__main__":
  test_wasm2asm()
