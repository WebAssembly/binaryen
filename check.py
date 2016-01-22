#!/usr/bin/env python

# Copyright 2015 WebAssembly Community Group participants
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

import os, shutil, sys, subprocess, difflib, json, time, urllib2

import scripts.storage
import scripts.support

interpreter = None
requested = []
torture = True

for arg in sys.argv[1:]:
  if arg.startswith('--interpreter='):
    interpreter = arg.split('=')[1]
    print '[ using wasm interpreter at "%s" ]' % interpreter
    assert os.path.exists(interpreter), 'interpreter not found'
  elif arg == '--torture':
    torture = True
  elif arg == '--no-torture':
    torture = False
  else:
    requested.append(arg)

warnings = []

def warn(text):
  global warnings
  warnings.append(text)
  print 'warning:', text

# setup

BASE_DIR = os.path.abspath('test')
WATERFALL_BUILD_DIR = os.path.join(BASE_DIR, 'wasm-install')
BIN_DIR = os.path.abspath(os.path.join(WATERFALL_BUILD_DIR, 'wasm-install', 'bin'))

def fetch_waterfall():
  rev = open(os.path.join('test', 'revision')).read().strip()
  try:
    local_rev = open(os.path.join('test', 'local-revision')).read().strip()
  except:
    local_rev = None
  if local_rev == rev: return
  # fetch it
  print '(downloading waterfall ' + rev + ')'
  basename = 'wasm-binaries-' + rev + '.tbz2'
  downloaded = urllib2.urlopen('https://storage.googleapis.com/wasm-llvm/builds/git/' + basename).read().strip()
  fullname = os.path.join('test', basename)
  open(fullname, 'wb').write(downloaded)
  print '(unpacking)'
  if os.path.exists(WATERFALL_BUILD_DIR):
    shutil.rmtree(WATERFALL_BUILD_DIR)
  os.mkdir(WATERFALL_BUILD_DIR)
  subprocess.check_call(['tar', '-xvf', os.path.abspath(fullname)], cwd=WATERFALL_BUILD_DIR)
  print '(noting local revision)'
  open(os.path.join('test', 'local-revision'), 'w').write(rev)

has_vanilla_llvm = False

def setup_waterfall():
  # if we can use the waterfall llvm, do so
  global has_vanilla_llvm
  CLANG = os.path.join(BIN_DIR, 'clang')
  try:
    subprocess.check_call([CLANG, '-v'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    has_vanilla_llvm = True
  except Exception, e:
    warn('could not run vanilla LLVM from waterfall: ' + str(e) + ', looked for clang at ' + CLANG)

fetch_waterfall()
setup_waterfall()


# external tools

has_node = False
try:
  subprocess.check_call(['nodejs', '--version'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
  has_node = 'nodejs'
except:
  try:
    subprocess.check_call(['node', '--version'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    has_node = 'node'
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

has_vanilla_emcc = False
try:
  subprocess.check_call([os.path.join('test', 'emscripten', 'emcc'), '--version'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
  has_vanilla_emcc = True
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
  warn('no interpreter provided (did not test spec interpreter validation)')
if not has_node:
  warn('no node found (did not check proper js form)')
if not has_mozjs:
  warn('no mozjs found (did not check asm.js validation)')
if not has_emcc:
  warn('no emcc found (did not check non-vanilla emscripten/binaryen integration)')
if not has_vanilla_emcc:
  warn('no functional emcc submodule found')


# tests

print '[ checking --help is useful... ]\n'

not_executable_suffix = ['.txt', '.js']
executables = sorted(filter(lambda x: not any(x.endswith(s) for s in
                                              not_executable_suffix),
                            os.listdir('bin')))
for e in executables:
  print '.. %s --help' % e
  out, err = subprocess.Popen([os.path.join('bin', e), '--help'],
                              stdout=subprocess.PIPE,
                              stderr=subprocess.PIPE).communicate()
  assert len(out) == 0, 'Expected no stdout, got:\n%s' % out
  assert e in err, 'Expected help to contain program name, got:\n%s' % err
  assert len(err.split('\n')) > 8, 'Expected some help, got:\n%s' % err

print '[ checking asm2wasm testcases... ]\n'

for asm in tests:
  if asm.endswith('.asm.js'):
    wasm = asm.replace('.asm.js', '.fromasm')
    print '..', asm, wasm
    cmd = [os.path.join('bin', 'asm2wasm'), os.path.join('test', asm)]
    print '    ', ' '.join(cmd)
    actual, err = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
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
      subprocess.check_call([os.path.join('bin', 'binaryen-shell'), '--remove-imports', '--print-after', os.path.join('test', wasm)], stdout=open('ztemp.wast', 'w'), stderr=subprocess.PIPE)
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

print '\n[ checking binaryen-shell passes... ]\n'

for t in sorted(os.listdir(os.path.join('test', 'passes'))):
  if t.endswith('.wast'):
    print '..', t
    passname = os.path.basename(t).replace('.wast', '')
    opt = '-O' if passname == 'O' else '--' + passname
    cmd = [os.path.join('bin', 'binaryen-shell'), '--print-after', opt, os.path.join('test', 'passes', t)]
    print '    ', ' '.join(cmd)
    actual, err = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
    fail_if_not_identical(actual, open(os.path.join('test', 'passes', passname + '.txt')).read())

print '\n[ checking binaryen-shell testcases... ]\n'

for t in tests:
  if t.endswith('.wast') and not t.startswith('spec'):
    print '..', t
    t = os.path.join('test', t)
    cmd = [os.path.join('bin', 'binaryen-shell'), t, '--print-before']
    print '    ', ' '.join(cmd)
    actual, err = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
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
      proc = subprocess.Popen([has_node, 'a.2asm.js'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
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

for dot_s_dir in ['dot_s', 'llvm_autogenerated']:
  for s in sorted(os.listdir(os.path.join('test', dot_s_dir))):
    if not s.endswith('.s'): continue
    print '..', s
    wasm = s.replace('.s', '.wast')
    full = os.path.join('test', dot_s_dir, s)
    actual, err = subprocess.Popen([os.path.join('bin', 's2wasm'), full], stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
    assert err == '', 'bad err:' + err

    # verify output
    expected_file = os.path.join('test', dot_s_dir, wasm)
    if not os.path.exists(expected_file):
      print actual
      raise Exception('output ' + expected_file + ' does not exist')
    expected = open(expected_file).read()
    if actual != expected:
      fail(actual, expected)

    # verify with options
    proc = subprocess.Popen([os.path.join('bin', 's2wasm'), full, '--global-base=1024'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out, err = proc.communicate()
    assert proc.returncode == 0, err

    # run binaryen-shell on the .wast to verify that it parses
    proc = subprocess.Popen([os.path.join('bin', 'binaryen-shell'), expected_file], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    actual, err = proc.communicate()
    assert proc.returncode == 0, err

if torture:

  print '\n[ checking torture testcases... ]\n'

  unexpected_result_count = 0

  import test.waterfall.src.link_assembly_files as link_assembly_files
  s2wasm_torture_out = os.path.abspath(os.path.join('test', 's2wasm-torture-out'))
  if os.path.isdir(s2wasm_torture_out):
    shutil.rmtree(s2wasm_torture_out)
  os.mkdir(s2wasm_torture_out)
  unexpected_result_count += link_assembly_files.run(
      linker=os.path.abspath(os.path.join('bin', 's2wasm')),
      files=os.path.abspath(os.path.join('test', 'torture-s', '*.s')),
      fails=os.path.abspath(os.path.join('test', 's2wasm_known_gcc_test_failures.txt')),
      out=s2wasm_torture_out)
  assert os.path.isdir(s2wasm_torture_out), 'Expected output directory %s' % s2wasm_torture_out

  import test.waterfall.src.execute_files as execute_files
  unexpected_result_count += execute_files.run(
      runner=os.path.abspath(os.path.join('bin', 'binaryen-shell')),
      files=os.path.abspath(os.path.join(s2wasm_torture_out, '*.wast')),
      fails=os.path.abspath(os.path.join('test', 's2wasm_known_binaryen_shell_test_failures.txt')),
      out='')

  shutil.rmtree(s2wasm_torture_out)
  if unexpected_result_count:
    fail('%s failures' % unexpected_result_count, '0 failures')

print '\n[ checking binary format testcases... ]\n'

for wast in tests:
  if wast.endswith('.wast') and not wast in []: # blacklist some known failures
    cmd = [os.path.join('bin', 'wasm-as'), os.path.join('test', wast), '-o', 'a.wasm']
    print ' '.join(cmd)
    if os.path.exists('a.wasm'): os.unlink('a.wasm')
    subprocess.check_call(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    assert os.path.exists('a.wasm')

    cmd = [os.path.join('bin', 'wasm-dis'), 'a.wasm', '-o', 'a.wast']
    print ' '.join(cmd)
    if os.path.exists('a.wast'): os.unlink('a.wast')
    subprocess.check_call(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    assert os.path.exists('a.wast')
    expected = open(os.path.join('test', wast + '.fromBinary')).read()
    actual = open('a.wast').read()
    if actual != expected:
      fail(actual, expected)

if has_vanilla_emcc:

  print '\n[ checking emcc WASM_BACKEND testcases...]\n'

  try:
    if has_vanilla_llvm:
      os.environ['LLVM'] = BIN_DIR # use the vanilla LLVM
    else:
      # if we did not set vanilla llvm, then we must set this env var to make emcc use the wasm backend.
      # (if we are using vanilla llvm, things should just work)
      print '(not using vanilla llvm, so setting env var to tell emcc to use wasm backend)'
      os.environ['EMCC_WASM_BACKEND'] = '1'
    VANILLA_EMCC = os.path.join('test', 'emscripten', 'emcc')
    # run emcc to make sure it sets itself up properly, if it was never run before
    command = [VANILLA_EMCC, '-v']
    print '____' + ' '.join(command)
    subprocess.check_call(command)

    for c in sorted(os.listdir(os.path.join('test', 'wasm_backend'))):
      if not c.endswith('cpp'): continue
      print '..', c
      base = c.replace('.cpp', '').replace('.c', '')
      expected = open(os.path.join('test', 'wasm_backend', base + '.txt')).read()
      command = [VANILLA_EMCC, '-o', 'a.wasm.js', '-s', 'BINARYEN="' + os.getcwd() + '"', os.path.join('test', 'wasm_backend', c), '-O1', '-s', 'ONLY_MY_CODE=1']
      print '....' + ' '.join(command)
      if os.path.exists('a.wasm.js'): os.unlink('a.wasm.js')
      subprocess.check_call(command)
      if has_node:
        print '  (check in node)'
        proc = subprocess.Popen([has_node, 'a.wasm.js'], stdout=subprocess.PIPE)
        out, err = proc.communicate()
        assert proc.returncode == 0
        if out.strip() != expected.strip():
          fail(out, expected)
  finally:
    if has_vanilla_llvm:
      del os.environ['LLVM']
    else:
      del os.environ['EMCC_WASM_BACKEND']

print '\n[ checking example testcases... ]\n'

cmd = [os.environ.get('CXX') or 'g++', '-std=c++11', os.path.join('test', 'example', 'find_div0s.cpp'), '-Isrc', '-g', '-lsupport', '-Llib/.']
if os.environ.get('COMPILER_FLAGS'):
  for f in os.environ.get('COMPILER_FLAGS').split(' '):
    cmd.append(f)
print ' '.join(cmd)
subprocess.check_call(cmd)
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
      print method, ' : ', ' '.join(command), ' => ', success
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
        proc = subprocess.Popen([has_node, 'a.wasm.js'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        out, err = proc.communicate()
        if success:
          assert proc.returncode == 0
          assert 'hello, world!' in out
        else:
          assert proc.returncode != 0
          assert 'hello, world!' not in out

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
              proc = subprocess.Popen([has_node, 'a.' + which + '.js'] + args, stdout=subprocess.PIPE)
              out, err = proc.communicate()
              assert proc.returncode == 0
              if out.strip() != expected.strip():
                fail(out, expected)

print '\n[ success! ]'

if warnings:
  print '\n' + '\n'.join(warnings)
