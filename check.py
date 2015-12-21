#!/usr/bin/env python

import os, sys, subprocess, difflib, json, time

interpreter = None
requested = []

for arg in sys.argv[1:]:
  if arg.startswith('--interpreter='):
    interpreter = arg.split('=')[1]
    print '[ using wasm interpreter at "%s" ]' % interpreter
    assert os.path.exists(interpreter), 'interpreter not found'
  else:
    requested.append(arg)

# external tools

has_node = False
try:
  subprocess.check_call(['nodejs', '--version'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
  has_node = True
except:
  pass

has_mozjs = False
try:
  subprocess.check_call(['mozjs', '--version'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
  has_mozjs = True
except:
  pass

has_emcc = False
try:
  subprocess.check_call(['emcc', '--version'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
  has_emcc = True
except:
  pass

# utilities

def fail(actual, expected):
  raise Exception("incorrect output, diff:\n\n%s" % (
    ''.join([a.rstrip()+'\n' for a in difflib.unified_diff(expected.split('\n'), actual.split('\n'), fromfile='expected', tofile='actual')])[-1000:]
  ))

def fail_if_not_identical(actual, expected):
  if expected != actual:
    fail(actual, expected)

def fail_if_not_contained(actual, expected):
  if expected not in actual:
    fail(actual, expected)

if len(requested) == 0:
  tests = sorted(os.listdir('test'))
else:
  tests = requested[:]

if not interpreter:
  print 'warning: no interpreter provided (not testing spec interpreter validation)'
  time.sleep(0.5)
if not has_node:
  print 'warning: no node found (not checking proper js form)'
  time.sleep(0.5)
if not has_mozjs:
  print 'warning: no mozjs found (not checking asm.js validation)'
  time.sleep(0.5)
if not has_emcc:
  print 'warning: no emcc found (not checking emscripten/binaryen integration)'
  time.sleep(0.5)

print '[ checking asm2wasm testcases... ]\n'

for asm in tests:
  if asm.endswith('.asm.js'):
    wasm = asm.replace('.asm.js', '.fromasm')
    print '..', asm, wasm
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
      # remove imports, spec interpreter doesn't know what to do with them
      subprocess.check_call([os.path.join('bin', 'binaryen-shell'), '-remove-imports', '-print-after', os.path.join('test', wasm)], stdout=open('ztemp.wast', 'w'), stderr=subprocess.PIPE)
      proc = subprocess.Popen([interpreter, 'ztemp.wast'], stderr=subprocess.PIPE)
      out, err = proc.communicate()
      if proc.returncode != 0:
        try: # to parse the error
          reported = err.split(':')[1]
          start, end = reported.split('-')
          start_line, start_col = map(int, start.split('.'))
          lines = open('ztemp.wast').read().split('\n')
          print
          print '='*80
          print lines[start_line-1]
          print (' '*(start_col-1)) + '^'
          print (' '*(start_col-2)) + '/_\\'
          print '='*80
          print err
        except Exception, e:
          raise Exception('wasm interpreter error: ' + err) # failed to pretty-print
        raise Exception('wasm interpreter error')

print '\n[ checking binaryen-shell... ]\n'

actual, err = subprocess.Popen([os.path.join('bin', 'binaryen-shell'), '--help'], stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
fail_if_not_contained(actual, 'binaryen shell')
fail_if_not_contained(actual, 'options:')
fail_if_not_contained(actual, 'passes:')
fail_if_not_contained(actual, '  -lower-if-else')

print '\n[ checking binaryen-shell passes... ]\n'

for t in sorted(os.listdir(os.path.join('test', 'passes'))):
  if t.endswith('.wast'):
    print '..', t
    passname = os.path.basename(t).replace('.wast', '')
    cmd = [os.path.join('bin', 'binaryen-shell'), '-print-before', '-print-after', '-' + passname, os.path.join('test', 'passes', t)]
    print '    ', ' '.join(cmd)
    actual, err = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
    fail_if_not_identical(actual, open(os.path.join('test', 'passes', passname + '.txt')).read())

print '\n[ checking binaryen-shell testcases... ]\n'

for t in tests:
  if t.endswith('.wast') and not t.startswith('spec'):
    print '..', t
    t = os.path.join('test', t)
    actual, err = subprocess.Popen([os.path.join('bin', 'binaryen-shell'), t, '-print-before'], stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
    assert err.replace('printing before:', '').strip() == '', 'bad err:' + err
    actual = actual.replace('printing before:\n', '')

    expected = open(t).read()
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

print '\n[ checking binaryen-shell experimental testcases... ]\n'

if len(requested) == 0:
  BLACKLIST = ['call.wast', # bad indirect_call
               'cfg-stackify.wast', # bad and on import with no return value
               'inline-asm.wast',
               'switch.wast', # bad tableswitch
              ]
  experimental_tests = [os.path.join('experimental', 'prototype-wasmate', 'test', 'expected-output', t) for t in sorted(os.listdir(os.path.join('test', 'experimental', 'prototype-wasmate', 'test', 'expected-output'))) if t not in BLACKLIST]
else:
  experimental_tests = requested[:]

for t in experimental_tests:
  if t.startswith('experimental') and t.endswith('.wast'):
    print '..', t
    wast = os.path.join('test', t)
    proc = subprocess.Popen([os.path.join('bin', 'binaryen-shell'), wast], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    actual, err = proc.communicate()
    assert proc.returncode == 0, err

print '\n[ checking wasm2asm testcases... ]\n'

for wasm in tests + [os.path.join('spec', name) for name in ['address.wast']]:#spec_tests:
  if wasm.endswith('.wast'):
    print '..', wasm
    asm = os.path.basename(wasm).replace('.wast', '.2asm.js')
    actual, err = subprocess.Popen([os.path.join('bin', 'wasm2asm'), os.path.join('test', wasm)], stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
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

    if has_node:
      # verify asm.js is valid js
      proc = subprocess.Popen(['nodejs', 'a.2asm.js'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
      out, err = proc.communicate()
      assert proc.returncode == 0
      assert not out and not err, [out, err]

    if has_mozjs:
      # verify asm.js validates
      open('a.2asm.js', 'w').write(actual)
      proc = subprocess.Popen(['mozjs', '-w', 'a.2asm.js'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
      out, err = proc.communicate()
      assert proc.returncode == 0
      fail_if_not_contained(err, 'Successfully compiled asm.js code')

print '\n[ checking .s testcases... ]\n'

for s in sorted(os.listdir(os.path.join('test', 'dot_s'))) + sorted(os.listdir(os.path.join('test', 'experimental', 'prototype-wasmate', 'test'))):
  if not s.endswith('.s'): continue
  if s in ['inline-asm.s', 'userstack.s']: continue
  print '..', s
  wasm = s.replace('.s', '.wast')
  full = os.path.join('test', 'dot_s', s)
  if not os.path.exists(full):
    full = os.path.join('test', 'experimental', 'prototype-wasmate', 'test', s)
  actual, err = subprocess.Popen([os.path.join('bin', 's2wasm'), full], stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
  assert err == '', 'bad err:' + err

  # verify output
  expected_file = os.path.join('test', 'dot_s', wasm)
  if not os.path.exists(expected_file):
    print actual
    raise Exception('output ' + expected_file + ' does not exist')
  expected = open(expected_file).read()
  if actual != expected:
    fail(actual, expected)

print '\n[ checking example testcases... ]\n'

subprocess.check_call(['g++', '-std=c++11', os.path.join('test', 'example', 'find_div0s.cpp'), '-Isrc', '-g'])
actual = subprocess.Popen(['./a.out'], stdout=subprocess.PIPE).communicate()[0]
expected = open(os.path.join('test', 'example', 'find_div0s.txt')).read()
if actual != expected:
  fail(actual, expected)

if has_emcc:

  print '\n[ checking wasm.js methods... ]\n'

  for method in [None, 'asm2wasm', 'wasm-s-parser', 'just-asm']:
    for success in [1, 0]:
      command = ['emcc', '-o', 'a.wasm.js', '-s', 'BINARYEN="' + os.getcwd() + '"', os.path.join('test', 'hello_world.c') ]
      if method:
        command += ['-s', 'BINARYEN_METHOD="' + method + '"']
      else:
        method = 'wasm-s-parser' # this is the default
      print method, ' : ', command, ' => ', success
      subprocess.check_call(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
      def break_cashew():
        asm = open('a.wasm.asm.js').read()
        asm = asm.replace('"almost asm"', '"use asm"; var not_in_asm = [].length + (true || { x: 5 }.x);')
        asm = asm.replace("'almost asm'", '"use asm"; var not_in_asm = [].length + (true || { x: 5 }.x);')
        open('a.wasm.asm.js', 'w').write(asm)
      if method == 'asm2wasm':
        os.unlink('a.wasm.wast') # we should not need the .wast
        if not success:
          break_cashew() # we need cashew
      elif method == 'wasm-s-parser':
        os.unlink('a.wasm.asm.js') # we should not need the .asm.js
        if not success:
          os.unlink('a.wasm.wast.mappedGlobals')
      elif method == 'just-asm':
        os.unlink('a.wasm.wast') # we should not need the .wast
        break_cashew() # we don't use cashew, so ok to break it
        if not success:
          os.unlink('a.wasm.js')
      else:
        1/0
      if has_node:
        proc = subprocess.Popen(['nodejs', 'a.wasm.js'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        out, err = proc.communicate()
        if success:
          assert proc.returncode == 0
          assert 'hello, world!' in out
        else:
          assert proc.returncode != 0
          assert 'hello, world!' not in out

  print '\n[ checking emcc WASM_BACKEND testcases... ]\n'

  for c in ['hello_world.cpp', 'hello_num.cpp']:
    print '..', c
    base = c.replace('.cpp', '').replace('.c', '')
    expected = open(os.path.join('test', 'wasm_backend', base + '.txt')).read()
    command = ['emcc', '-o', 'a.wasm.js', '-s', 'BINARYEN="' + os.getcwd() + '"', os.path.join('test', 'wasm_backend', c), '-O1', '-s', 'WASM_BACKEND=1', '-s', 'ONLY_MY_CODE=1']
    print '....' + ' '.join(command)
    subprocess.check_call(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if has_node:
      proc = subprocess.Popen(['nodejs', 'a.wasm.js'], stdout=subprocess.PIPE)
      out, err = proc.communicate()
      assert proc.returncode == 0
      if out.strip() != expected.strip():
        fail(out, expected)

  print '\n[ checking wasm.js testcases... ]\n'

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
        for method in ['asm2wasm', 'wasm-s-parser', 'just-asm']:
          command = ['emcc', '-o', 'a.wasm.js', '-s', 'BINARYEN="' + os.getcwd() + '"', os.path.join('test', c)] + opts + extra
          command += ['-s', 'BINARYEN_METHOD="' + method + '"']
          subprocess.check_call(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
          print '....' + ' '.join(command)
          if post:
            open('a.wasm.js', 'a').write(post)
          else:
            print '     (no post)'
          for which in ['wasm']:
            print '......', which
            try:
              args = json.loads(open(os.path.join('test', base + '.args')).read())
            except:
              args = []
              print '     (no args)'
            if has_node:
              proc = subprocess.Popen(['nodejs', 'a.' + which + '.js'] + args, stdout=subprocess.PIPE)
              out, err = proc.communicate()
              assert proc.returncode == 0
              if out.strip() != expected.strip():
                fail(out, expected)

print '\n[ success! ]'

