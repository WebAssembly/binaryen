#!/usr/bin/env python

import os, subprocess, difflib

print '[ checking testcases... ]\n'

for asm in os.listdir('test'):
  if asm.endswith('.asm.js'):
    print '  ', asm, ' ',
    wasm = asm.replace('.asm.js', '.wast')
    actual, err = subprocess.Popen([os.path.join('bin', 'asm2wasm'), os.path.join('test', asm)], stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
    assert err == '', 'bad err:' + err
    if not os.path.exists(os.path.join('test', wasm)):
      raise Exception('output .wast file does not exist')
    expected = open(os.path.join('test', wasm)).read()
    if actual != expected:
      raise Exception("Expected to have '%s' == '%s', diff:\n\n%s" % (
        expected, actual,
        ''.join([a.rstrip()+'\n' for a in difflib.unified_diff(expected.split('\n'), actual.split('\n'), fromfile='expected', tofile='actual')])
      ))
    print 'OK'

print '\n[ success! ]'
