#!/usr/bin/env python

import os, sys, subprocess, difflib, json

interpreter = None
requested = []

for arg in sys.argv[1:]:
  if arg.startswith('--interpreter='):
    interpreter = arg.split('=')[1]
    print '[ using wasm interpreter at "%s" ]' % interpreter
    assert os.path.exists(interpreter), 'interpreter not found'
  else:
    requested.append(arg)

def fail(actual, expected):
  raise Exception("incorrect output, diff:\n\n%s" % (
    ''.join([a.rstrip()+'\n' for a in difflib.unified_diff(expected.split('\n'), actual.split('\n'), fromfile='expected', tofile='actual')])
  ))

if not interpreter:
  print '[ no wasm interpreter provided, you should pass one as --interpreter=path/to/interpreter ]'

print '[ checking asm2wasm testcases... ]\n'

if len(requested) == 0:
  tests = sorted(os.listdir('test'))
else:
  tests = requested[:]

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

print '\n[ checking binaryen-shell testcases... ]\n'

for t in tests:
  if t.endswith('.wast') and not t.startswith('spec'):
    print '..', t
    t = os.path.join('test', t)
    actual, err = subprocess.Popen([os.path.join('bin', 'binaryen-shell'), t, '--print-before'], stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
    assert err == '', 'bad err:' + err

    expected = open(t).read()
    if actual != expected:
      fail(actual, expected)

print '\n[ checking example testcases... ]\n'

subprocess.check_call(['g++', '-std=c++11', os.path.join('test', 'example', 'find_div0s.cpp'), '-Isrc', '-g'])
actual = subprocess.Popen(['./a.out'], stdout=subprocess.PIPE).communicate()[0]
expected = open(os.path.join('test', 'example', 'find_div0s.txt')).read()
if actual != expected:
  fail(actual, expected)

print '\n[ checking binaryen-shell spec testcases... ]\n'

if len(requested) == 0:
  BLACKLIST = []
  spec_tests = [os.path.join('spec', t) for t in sorted(os.listdir(os.path.join('test', 'spec'))) if t not in BLACKLIST]
else:
  spec_tests = requested[:]

for t in spec_tests:
  if t.startswith('spec') and t.endswith('.wast'):
    print '..', t
    wast = os.path.join('test', t)
    proc = subprocess.Popen([os.path.join('bin', 'binaryen-shell'), wast], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    actual, err = proc.communicate()
    assert proc.returncode == 0, err

    expected = os.path.join('test', 'spec', 'expected-output', os.path.basename(wast) + '.log')
    if os.path.exists(expected):
      expected = open(expected).read()
      # fix it up, our pretty (i32.const 83) must become compared to a homely 83 : i32
      def fix(x):
        x = x.strip()
        if not x: return x
        v, t = x.split(' : ')
        if v.endswith('.'): v = v[:-1] # remove trailing '.'
        return '(' + t + '.const ' + v + ')'
      expected = '\n'.join(map(fix, expected.split('\n')))
      print '       (using expected output)'
    else:
      continue
    actual = actual.strip()
    expected = expected.strip()
    if actual != expected:
      fail(actual, expected)

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
    for opts in [[], ['-O1'], ['-O2'], ['-O3'], ['-Oz']]:
      command = ['./emcc_to_wasm.js.sh', os.path.join('test', c)] + opts + extra
      subprocess.check_call(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
      print '....' + ' '.join(command)
      if post:
        open('a.normal.js', 'a').write(post)
        open('a.wasm.js', 'a').write(post)
      else:
        print '     (no post)'
      for which in ['normal', 'wasm']:
        print '......', which
        try:
          args = json.loads(open(os.path.join('test', base + '.args')).read())
        except:
          args = []
          print '     (no args)'
        proc = subprocess.Popen(['nodejs', 'a.' + which + '.js'] + args, stdout=subprocess.PIPE)
        out, err = proc.communicate()
        assert proc.returncode == 0
        if out.strip() != expected.strip():
          fail(out, expected)

print '\n[ success! ]'

