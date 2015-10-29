#!/usr/bin/env python

import os, sys, subprocess, difflib

interpreter = None
tests = []

for arg in sys.argv[1:]:
  if arg.startswith('--interpreter='):
    interpreter = arg.split('=')[1]
    print '[ using wasm interpreter at "%s" ]' % interpreter
    assert os.path.exists(interpreter), 'interpreter not found'
  else:
    tests.append(arg)

if not interpreter:
  print '[ no wasm interpreter provided, you should pass one as --interpreter=path/to/interpreter ]'

print '[ checking testcases... ]\n'

if len(tests) == 0:
  tests = sorted(os.listdir('test'))

for asm in tests:
  if asm.endswith('.asm.js'):
    print '  ', asm, ' ',
    wasm = asm.replace('.asm.js', '.wast')
    actual, err = subprocess.Popen([os.path.join('bin', 'asm2wasm'), os.path.join('test', asm)], stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
    assert err == '', 'bad err:' + err
    # verify in wasm
    # verify output
    if not os.path.exists(os.path.join('test', wasm)):
      print actual
      raise Exception('output .wast file does not exist')
    expected = open(os.path.join('test', wasm)).read()
    if actual != expected:
      raise Exception("Expected to have '%s' == '%s', diff:\n\n%s" % (
        expected, actual,
        ''.join([a.rstrip()+'\n' for a in difflib.unified_diff(expected.split('\n'), actual.split('\n'), fromfile='expected', tofile='actual')])
      ))
    print 'OK'

print '\n[ success! ]'

