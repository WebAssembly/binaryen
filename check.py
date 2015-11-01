#!/usr/bin/env python

import os, sys, subprocess, difflib, json

interpreter = None
tests = []

for arg in sys.argv[1:]:
  if arg.startswith('--interpreter='):
    interpreter = arg.split('=')[1]
    print '[ using wasm interpreter at "%s" ]' % interpreter
    assert os.path.exists(interpreter), 'interpreter not found'
  else:
    tests.append(arg)

def fail(actual, expected):
  raise Exception("incorrect output, diff:\n\n%s" % (
    ''.join([a.rstrip()+'\n' for a in difflib.unified_diff(expected.split('\n'), actual.split('\n'), fromfile='expected', tofile='actual')])
  ))

if not interpreter:
  print '[ no wasm interpreter provided, you should pass one as --interpreter=path/to/interpreter ]'

print '[ checking asm2wasm testcases... ]\n'

if len(tests) == 0:
  tests = sorted(os.listdir('test'))

for asm in tests:
  if asm.endswith('.asm.js'):
    print '..', asm
    wasm = asm.replace('.asm.js', '.wast')
    actual, err = subprocess.Popen([os.path.join('bin', 'asm2wasm'), os.path.join('test', asm)], stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
    assert err == '', 'bad err:' + err

    # verify output
    if not os.path.exists(os.path.join('test', wasm)):
      print actual
      raise Exception('output .wast file does not exist')
    expected = open(os.path.join('test', wasm)).read()
    if actual != expected:
      fail(actual, expected)

    # verify in wasm
    if interpreter:
      proc = subprocess.Popen([interpreter, os.path.join('test', wasm)], stderr=subprocess.PIPE)
      out, err = proc.communicate()
      if proc.returncode != 0:
        try: # to parse the error
          reported = err.split(':')[1]
          start, end = reported.split('-')
          start_line, start_col = map(int, start.split('.'))
          lines = expected.split('\n')
          print
          print '='*80
          print lines[start_line-1]
          print (' '*(start_col-1)) + '^'
          print (' '*(start_col-1)) + '|'
          print '='*80
          print err
        except Exception, e:
          raise Exception('wasm interpreter error: ' + err) # failed to pretty-print
        raise Exception('wasm interpreter error')

print '\n[ checking wasm.js polyfill testcases... (need both emcc and nodejs in your path) ]\n'

for c in tests:
  if c.endswith(('.c', '.cpp')):
    print '..', c
    base = c.replace('.cpp', '').replace('.c', '')
    post = base + '.post.js'
    try:
      post = open(os.path.join('test', post)).read()
    except:
      post = None
    expected = open(os.path.join('test', base + '.txt')).read()
    emcc = os.path.join('test', base + '.emcc')
    extra = []
    if os.path.exists(emcc):
      extra = json.loads(open(emcc).read())
    if os.path.exists('a.normal.js'): os.unlink('a.normal.js')
    subprocess.check_call(['./emcc_to_wasm.js.sh', os.path.join('test', c)] + extra, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if post:
      open('a.normal.js', 'a').write(post)
      open('a.wasm.js', 'a').write(post)
    for which in ['normal', 'wasm']:
      print '....', which
      proc = subprocess.Popen(['nodejs', 'a.' + which + '.js'], stdout=subprocess.PIPE)
      out, err = proc.communicate()
      assert proc.returncode == 0
      if out.strip() != expected.strip():
        fail(out, expected)

print '\n[ success! ]'

