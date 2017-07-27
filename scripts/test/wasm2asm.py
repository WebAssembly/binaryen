#!/usr/bin/env python2

import os
import subprocess
import sys

from support import run_command, split_wast
from shared import (
    ASM2WASM, BIN_DIR, EMCC, MOZJS, NATIVECC, NATIVEXX, NODEJS, S2WASM_EXE,
    WASM_AS, WASM_CTOR_EVAL, WASM_OPT, WASM_SHELL, WASM_MERGE, WASM_SHELL_EXE,
    WASM_DIS, binary_format_check, delete_from_orbit, fail, fail_with_error,
    fail_if_not_identical, fail_if_not_contained, has_vanilla_emcc,
    has_vanilla_llvm, minify_check, num_failures, options, tests,
    requested, warnings
)

print '\n[ checking wasm2asm testcases... ]\n'

# tests with i64s
blacklist = ['atomics.wast']
spec_tests = [os.path.join('spec', t) for t in
              sorted(os.listdir(os.path.join('test', 'spec')))]
for wasm in tests + [os.path.join('spec', name) for name in spec_tests]:
  if wasm.endswith('.wast') and os.path.basename(wasm) not in blacklist:
    print '..', wasm
    asm = os.path.basename(wasm).replace('.wast', '.2asm.js')
    actual, err = subprocess.Popen([os.path.join('bin', 'wasm2asm'),
                                    os.path.join('test', wasm)],
                                   stdout=subprocess.PIPE,
                                   stderr=subprocess.PIPE).communicate()
    assert err == '', 'bad err:' + err

    # verify output
    expected_file = os.path.join('test', asm)
    if not os.path.exists(expected_file):
      print actual
      raise Exception('output ' + expected_file + ' does not exist')
    expected = open(expected_file).read()
    if actual != expected:
      fail(actual, expected)

    open('a.2asm.js', 'w').write(actual)

    if NODEJS:
      # verify asm.js is valid js
      proc = subprocess.Popen([NODEJS, 'a.2asm.js'],
                              stdout=subprocess.PIPE,
                              stderr=subprocess.PIPE)
      out, err = proc.communicate()
      assert proc.returncode == 0
      assert not out and not err, [out, err]

    if MOZJS:
      # verify asm.js validates
      open('a.2asm.js', 'w').write(actual)
      proc = subprocess.Popen([MOZJS, '-w', 'a.2asm.js'],
                              stdout=subprocess.PIPE,
                              stderr=subprocess.PIPE)
      out, err = proc.communicate()
      assert proc.returncode == 0
      fail_if_not_contained(err, 'Successfully compiled asm.js code')
