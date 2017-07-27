#!/usr/bin/env python2

import os

from support import run_command
from shared import (WASM2ASM, MOZJS, NODEJS, fail_if_not_identical, tests)

def test_wasm2asm():
  print '\n[ checking wasm2asm testcases... ]\n'

  # tests with i64s
  blacklist = ['atomics.wast']
  spec_tests = [os.path.join('spec', t) for t in
                sorted(os.listdir(os.path.join('test', 'spec')))]
  for wasm in tests + [os.path.join('spec', name) for name in spec_tests]:
    if wasm.endswith('.wast') and os.path.basename(wasm) not in blacklist:
      print '..', wasm
      asm = os.path.basename(wasm).replace('.wast', '.2asm.js')
      cmd = WASM2ASM + [os.path.join('test', wasm)]
      out = run_command(cmd)

      # verify output
      expected_file = os.path.join('test', asm)
      if not os.path.exists(expected_file):
        print out
        raise Exception('output ' + expected_file + ' does not exist')
      expected = open(expected_file).read()
      fail_if_not_identical(out, expected)

      open('a.2asm.js', 'w').write(out)

      if NODEJS:
        # verify asm.js is valid js
        out = run_command([NODEJS, 'a.2asm.js'])
        fail_if_not_identical(out, '')

      if MOZJS:
        # verify asm.js validates
        out = run_command([MOZJS, '-w', 'a.2asm.js'],
                          expected_err='Successfully compiled asm.js code',
                          err_contains=True)
        fail_if_not_identical(out, '')

if __name__ == "__main__":
  test_wasm2asm()
