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

os.environ['BINARYEN'] = os.getcwd()

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
  warn('no mozjs found (did not check native wasm support nor asm.js validation)')
if not has_emcc:
  warn('no emcc found (did not check non-vanilla emscripten/binaryen integration)')
if not has_vanilla_emcc:
  warn('no functional emcc submodule found')

# check utilities

def split_wast(wast):
  # .wast files can contain multiple modules, and assertions for each one.
  # this splits out a wast into [(module, assertions), ..]
  # we ignore module invalidity tests here.
  wast = open(wast).read()
  ret = []
  def to_end(j):
    depth = 1
    while depth > 0:
      if wast[j] == '"':
        j = wast.find('"', j + 1)
      elif wast[j] == '(':
        depth += 1
      elif wast[j] == ')':
        depth -= 1
      elif wast[j] == ';' and wast[j+1] == ';':
        j = wast.find('\n', j)
      j += 1
    return j
  i = 0
  while i >= 0:
    start = wast.find('(', i)
    if start >= 0 and wast[start+1] == ';':
      # block comment
      i = wast.find(';)', start+2)
      assert i > 0, wast[start:]
      i += 2
      continue
    skip = wast.find(';', i)
    if skip >= 0 and skip < start and skip + 1 < len(wast):
      if wast[skip+1] == ';':
        i = wast.find('\n', i) + 1
        continue
    if start < 0: break
    i = to_end(start + 1)
    chunk = wast[start:i]
    if chunk.startswith('(module'):
      ret += [(chunk, [])]
    elif chunk.startswith('(assert_invalid'):
      continue
    elif chunk.startswith(('(assert', '(invoke')):
      ret[-1][1].append(chunk)
  return ret

def binary_format_check(wast, verify_final_result=True):
  # checks we can convert the wast to binary and back

  print '     (binary format check)'
  cmd = [os.path.join('bin', 'wasm-as'), wast, '-o', 'a.wasm']
  print '      ', ' '.join(cmd)
  if os.path.exists('a.wasm'): os.unlink('a.wasm')
  subprocess.check_call(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
  assert os.path.exists('a.wasm')

  cmd = [os.path.join('bin', 'wasm-dis'), 'a.wasm', '-o', 'ab.wast']
  print '      ', ' '.join(cmd)
  if os.path.exists('ab.wast'): os.unlink('ab.wast')
  subprocess.check_call(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
  assert os.path.exists('ab.wast')

  # make sure it is a valid wast
  cmd = [os.path.join('bin', 'binaryen-shell'), 'ab.wast']
  print '      ', ' '.join(cmd)
  subprocess.check_call(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

  if verify_final_result:
    expected = open(wast + '.fromBinary').read()
    actual = open('ab.wast').read()
    if actual != expected:
      fail(actual, expected)

  return 'ab.wast'

def minify_check(wast, verify_final_result=True):
  # checks we can parse minified output

  print '     (minify check)'
  cmd = [os.path.join('bin', 'binaryen-shell'), wast, '--print-minified']
  print '      ', ' '.join(cmd)
  subprocess.check_call([os.path.join('bin', 'binaryen-shell'), wast, '--print-minified'], stdout=open('a.wasm', 'w'), stderr=subprocess.PIPE)
  assert os.path.exists('a.wasm')
  subprocess.check_call([os.path.join('bin', 'binaryen-shell'), 'a.wasm', '--print-minified'], stdout=open('b.wasm', 'w'), stderr=subprocess.PIPE)
  assert os.path.exists('b.wasm')
  if verify_final_result:
    expected = open('a.wasm').read()
    actual = open('b.wasm').read()
    if actual != expected:
      fail(actual, expected)
  if os.path.exists('a.wasm'): os.unlink('a.wasm')
  if os.path.exists('b.wasm'): os.unlink('b.wasm')

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

# waka

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
      out='',
      wasmjs='')

  shutil.rmtree(s2wasm_torture_out)
  if unexpected_result_count:
    fail('%s failures' % unexpected_result_count, '0 failures')

if has_vanilla_emcc and has_vanilla_llvm:

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
      for opts in [[], ['-O1'], ['-O2']]:
        only = [] if opts != ['-O1'] or 'real' in base else ['-s', 'ONLY_MY_CODE=1'] # only my code is a hack we used early in wasm backend dev, which somehow worked, but only with -O1
        command = [VANILLA_EMCC, '-o', 'a.wasm.js', os.path.join('test', 'wasm_backend', c)] + opts + only
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

cmd = [os.environ.get('CXX') or 'g++', '-std=c++11',
       os.path.join('test', 'example', 'find_div0s.cpp'),
       os.path.join('src', 'pass.cpp'),
       os.path.join('src', 'passes', 'Print.cpp'),
       '-Isrc', '-g', '-lsupport', '-Llib/.']
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

  if has_mozjs:

    print '\n[ checking native wasm support ]\n'

    command = ['emcc', '-o', 'a.wasm.js', '-s', 'BINARYEN=1', os.path.join('test', 'hello_world.c'), '-s', 'BINARYEN_METHOD="native-wasm"', '-s', 'BINARYEN_SCRIPTS="spidermonkify.py"']
    print ' '.join(command)
    subprocess.check_call(command)

    proc = subprocess.Popen(['mozjs', 'a.wasm.js'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out, err = proc.communicate()
    assert proc.returncode == 0, err
    assert 'hello, world!' in out, out

    proc = subprocess.Popen([has_node, 'a.wasm.js'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out, err = proc.communicate()
    assert proc.returncode != 0, 'should fail on no wasm support'
    assert 'no native wasm support detected' in err, err

  print '\n[ checking wasm.js methods... ]\n'

  for method_init in [None, 'interpret-asm2wasm', 'interpret-s-expr', 'asmjs', 'interpret-binary']:
    for success in [1, 0]:
      method = method_init
      command = ['emcc', '-o', 'a.wasm.js', '-s', 'BINARYEN=1', os.path.join('test', 'hello_world.c') ]
      if method:
        command += ['-s', 'BINARYEN_METHOD="' + method + '"']
      else:
        method = 'interpret-s-expr' # this is the default
      print method, ' : ', ' '.join(command), ' => ', success
      subprocess.check_call(command)

      see_polyfill =  'var WasmJS = ' in open('a.wasm.js').read()

      if method and 'interpret' not in method:
        assert not see_polyfill, 'verify polyfill was not added - we specified a method, and it does not need it'
      else:
        assert see_polyfill, 'we need the polyfill'

      def break_cashew():
        asm = open('a.wasm.asm.js').read()
        asm = asm.replace('"almost asm"', '"use asm"; var not_in_asm = [].length + (true || { x: 5 }.x);')
        asm = asm.replace("'almost asm'", '"use asm"; var not_in_asm = [].length + (true || { x: 5 }.x);')
        open('a.wasm.asm.js', 'w').write(asm)
      if method == 'interpret-asm2wasm':
        os.unlink('a.wasm.wast') # we should not need the .wast
        if not success:
          break_cashew() # we need cashew
      elif method == 'interpret-s-expr':
        os.unlink('a.wasm.asm.js') # we should not need the .asm.js
        if not success:
          os.unlink('a.wasm.wast.mappedGlobals')
      elif method == 'asmjs':
        os.unlink('a.wasm.wast') # we should not need the .wast
        break_cashew() # we don't use cashew, so ok to break it
        if not success:
          os.unlink('a.wasm.js')
      elif method == 'interpret-binary':
        os.unlink('a.wasm.wast') # we should not need the .wast
        os.unlink('a.wasm.asm.js') # we should not need the .asm.js
        if not success:
          os.unlink('a.wasm.wasm')
      else:
        1/0
      if has_node:
        proc = subprocess.Popen([has_node, 'a.wasm.js'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        out, err = proc.communicate()
        if success:
          assert proc.returncode == 0, err
          assert 'hello, world!' in out, out
        else:
          assert proc.returncode != 0, err
          assert 'hello, world!' not in out, out

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
        for method in ['interpret-asm2wasm', 'interpret-s-expr', 'asmjs', 'interpret-binary']:
          command = ['emcc', '-o', 'a.wasm.js', '-s', 'BINARYEN=1', os.path.join('test', c)] + opts + extra
          command += ['-s', 'BINARYEN_METHOD="' + method + '"']
          print '....' + ' '.join(command)
          subprocess.check_call(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
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

            def execute():
              if has_node:
                proc = subprocess.Popen([has_node, 'a.' + which + '.js'] + args, stdout=subprocess.PIPE)
                out, err = proc.communicate()
                assert proc.returncode == 0
                if out.strip() != expected.strip():
                  fail(out, expected)

            execute()

            if method in ['interpret-asm2wasm', 'interpret-s-expr']:
              # binary and back
              shutil.copyfile('a.wasm.wast', 'a.wasm.original.wast')
              recreated = binary_format_check('a.wasm.wast', verify_final_result=False)
              shutil.copyfile(recreated, 'a.wasm.wast')
              execute()

print '\n[ success! ]'

if warnings:
  print '\n' + '\n'.join(warnings)
