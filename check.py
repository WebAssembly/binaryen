#!/usr/bin/env python2

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
only_prepare = False

for arg in sys.argv[1:]:
  if arg.startswith('--interpreter='):
    interpreter = arg.split('=')[1]
    print '[ using wasm interpreter at "%s" ]' % interpreter
    assert os.path.exists(interpreter), 'interpreter not found'
  elif arg == '--torture':
    torture = True
  elif arg == '--no-torture':
    torture = False
  elif arg == '--only-prepare':
    only_prepare = True
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
  basename = 'wasm-binaries-' + rev + '.tbz2'
  url = 'https://storage.googleapis.com/wasm-llvm/builds/git/' + basename
  print '(downloading waterfall %s: %s)' % (rev, url)
  downloaded = urllib2.urlopen(url).read().strip()
  fullname = os.path.join('test', basename)
  open(fullname, 'wb').write(downloaded)
  print '(unpacking)'
  if os.path.exists(WATERFALL_BUILD_DIR):
    shutil.rmtree(WATERFALL_BUILD_DIR)
  os.mkdir(WATERFALL_BUILD_DIR)
  subprocess.check_call(['tar', '-xf', os.path.abspath(fullname)], cwd=WATERFALL_BUILD_DIR)
  print '(noting local revision)'
  open(os.path.join('test', 'local-revision'), 'w').write(rev)

has_vanilla_llvm = False

def setup_waterfall():
  # if we can use the waterfall llvm, do so
  global has_vanilla_llvm
  CLANG = os.path.join(BIN_DIR, 'clang')
  print 'trying waterfall clang at', CLANG
  try:
    subprocess.check_call([CLANG, '-v'])
    has_vanilla_llvm = True
    print '...success'
  except Exception, e:
    warn('could not run vanilla LLVM from waterfall: ' + str(e) + ', looked for clang at ' + CLANG)

fetch_waterfall()
setup_waterfall()

if only_prepare:
  print 'waterfall is fetched and setup, exiting since --only-prepare'
  sys.exit(0)

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

def run_command(cmd, stderr=None):
  print 'executing: ', ' '.join(cmd)
  proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=stderr)
  out, err = proc.communicate()
  if proc.returncode != 0: raise Exception(('run_command failed', err))
  return out

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
    while depth > 0 and j < len(wast):
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
  subprocess.check_call(cmd, stdout=subprocess.PIPE)
  assert os.path.exists('a.wasm')

  cmd = [os.path.join('bin', 'wasm-dis'), 'a.wasm', '-o', 'ab.wast']
  print '      ', ' '.join(cmd)
  if os.path.exists('ab.wast'): os.unlink('ab.wast')
  subprocess.check_call(cmd, stdout=subprocess.PIPE)
  assert os.path.exists('ab.wast')

  # make sure it is a valid wast
  cmd = [os.path.join('bin', 'binaryen-shell'), 'ab.wast']
  print '      ', ' '.join(cmd)
  subprocess.check_call(cmd, stdout=subprocess.PIPE)

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

print '\n[ checking binaryen-shell passes... ]\n'

for t in sorted(os.listdir(os.path.join('test', 'passes'))):
  if t.endswith('.wast'):
    print '..', t
    passname = os.path.basename(t).replace('.wast', '')
    opts = ['-O'] if passname == 'O' else ['--' + p for p in passname.split('_')]
    cmd = [os.path.join('bin', 'binaryen-shell')] + opts + [os.path.join('test', 'passes', t), '--print']
    actual = run_command(cmd)
    fail_if_not_identical(actual, open(os.path.join('test', 'passes', passname + '.txt')).read())

print '[ checking asm2wasm testcases... ]\n'

for asm in tests:
  if asm.endswith('.asm.js'):
    for precise in [1, 0]:
      for opts in [1, 0]:
        cmd = [os.path.join('bin', 'asm2wasm'), os.path.join('test', asm)]
        wasm = asm.replace('.asm.js', '.fromasm')
        if not precise:
          cmd += ['--imprecise']
          wasm += '.imprecise'
        if not opts:
          cmd += ['--no-opts']
          wasm += '.no-opts'
        wasm = os.path.join('test', wasm)
        print '..', asm, wasm
        actual = run_command(cmd)

        # verify output
        if not os.path.exists(wasm):
          raise Exception('output .wast file %s does not exist' % wasm)
        expected = open(wasm).read()
        if actual != expected:
          fail(actual, expected)

        binary_format_check(wasm, verify_final_result=False)

        # verify in wasm
        if interpreter:
          # remove imports, spec interpreter doesn't know what to do with them
          subprocess.check_call([os.path.join('bin', 'binaryen-shell'), '--remove-imports', '--print', wasm], stdout=open('ztemp.wast', 'w'), stderr=subprocess.PIPE)
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

print '\n[ checking binaryen-shell parsing & printing... ]\n'

for t in sorted(os.listdir(os.path.join('test', 'print'))):
  if t.endswith('.wast'):
    print '..', t
    wasm = os.path.basename(t).replace('.wast', '')
    cmd = [os.path.join('bin', 'binaryen-shell'), os.path.join('test', 'print', t), '--print']
    print '    ', ' '.join(cmd)
    actual, err = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
    fail_if_not_identical(actual, open(os.path.join('test', 'print', wasm + '.txt')).read())
    cmd = [os.path.join('bin', 'binaryen-shell'), os.path.join('test', 'print', t), '--print-minified']
    print '    ', ' '.join(cmd)
    actual, err = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
    fail_if_not_identical(actual.strip(), open(os.path.join('test', 'print', wasm + '.minified.txt')).read().strip())

print '\n[ checking binaryen-shell testcases... ]\n'

for t in tests:
  if t.endswith('.wast') and not t.startswith('spec'):
    print '..', t
    t = os.path.join('test', t)
    cmd = [os.path.join('bin', 'binaryen-shell'), t, '--print']
    actual = run_command(cmd)
    actual = actual.replace('printing before:\n', '')

    expected = open(t).read()
    if actual != expected:
      fail(actual, expected)

    binary_format_check(t)
    minify_check(t)

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

    def run_spec_test(wast):
      print '       run binaryen-shell on', wast
      cmd = [os.path.join('bin', 'binaryen-shell'), wast]
      return run_command(cmd, stderr=subprocess.PIPE)

    def check_expected(actual, expected):
      if expected and os.path.exists(expected):
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
        actual = actual.strip()
        expected = expected.strip()
        if actual != expected:
          fail(actual, expected)

    expected = os.path.join('test', 'spec', 'expected-output', os.path.basename(wast) + '.log')

    # some spec tests should fail (actual process failure, not just assert_invalid)
    try:
      actual = run_spec_test(wast)
    except Exception, e:
      if 'wasm-validator error' in str(e) and '.fail.' in t:
        print '<< test failed as expected >>'
        continue # don't try all the binary format stuff TODO
      else:
        raise e

    check_expected(actual, expected)

    # check binary format. here we can verify execution of the final result, no need for an output verification
    split_num = 0
    if os.path.basename(wast) not in ['has_feature.wast']: # avoid some tests with things still in spec tests, but likely to be taken out soon
      actual = ''
      for module, asserts in split_wast(wast):
        print '    testing split module', split_num
        split_num += 1
        open('split.wast', 'w').write(module + '\n' + '\n'.join(asserts))
        run_spec_test('split.wast') # before binary stuff - just check it's still ok split out
        result_wast = binary_format_check('split.wast', verify_final_result=False)
        # add the asserts, and verify that the test still passes
        open(result_wast, 'a').write('\n' + '\n'.join(asserts))
        actual += run_spec_test(result_wast)
      # compare all the outputs to the expected output
      check_expected(actual, os.path.join('test', 'spec', 'expected-output', os.path.basename(wast) + '.log'))

''' XXX disable wasm2asm for now, too much flux
print '\n[ checking wasm2asm testcases... ]\n'

for wasm in tests + [os.path.join('spec', name) for name in ['address.wast']]:#spec_tests:
  if wasm.endswith('.wast') and os.path.basename(wasm) not in ['kitchen_sink.wast']: # i64s in kitchen_sink
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
'''

if has_node:
  print '\n[ checking binaryen.js testcases... ]\n'

  for s in sorted(os.listdir(os.path.join('test', 'binaryen.js'))):
    if not s.endswith('.js'): continue
    print s
    f = open('a.js', 'w')
    f.write(open(os.path.join('bin', 'binaryen.js')).read())
    f.write(open(os.path.join('test', 'binaryen.js', s)).read())
    f.close()
    cmd = [has_node, 'a.js']
    out = run_command(cmd)
    expected = open(os.path.join('test', 'binaryen.js', s + '.txt')).read()
    if expected not in out:
      fail(out, expected)

print '\n[ checking .s testcases... ]\n'

for dot_s_dir in ['dot_s', 'llvm_autogenerated']:
  for s in sorted(os.listdir(os.path.join('test', dot_s_dir))):
    if not s.endswith('.s'): continue
    print '..', s
    wasm = s.replace('.s', '.wast')
    full = os.path.join('test', dot_s_dir, s)
    stack_alloc = ['--allocate-stack=1024'] if dot_s_dir == 'llvm_autogenerated' else []
    cmd = [os.path.join('bin', 's2wasm'), full, '--emscripten-glue'] + stack_alloc
    if s.startswith('start_'):
      cmd.append('--start')
    actual = run_command(cmd)

    # verify output
    expected_file = os.path.join('test', dot_s_dir, wasm)
    if not os.path.exists(expected_file):
      print actual
      raise Exception('output ' + expected_file + ' does not exist')
    expected = open(expected_file).read()
    if actual != expected:
      fail(actual, expected)

    # verify with options
    cmd = [os.path.join('bin', 's2wasm'), full, '--global-base=1024'] + stack_alloc
    run_command(cmd)

    # run binaryen-shell on the .wast to verify that it parses
    cmd = [os.path.join('bin', 'binaryen-shell'), expected_file]
    run_command(cmd)

print '\n[ running linker tests... ]\n'
# The {main,foo,bar,baz}.s files were created by running clang over the respective
# c files. The foobar.bar archive was created by running:
# llvm-ar -format=gnu rc foobar.a quux.s foo.s bar.s baz.s
s2wasm = os.path.join('bin', 's2wasm')
cmd = [s2wasm, os.path.join('test', 'linker', 'main.s'), '-l', os.path.join('test', 'linker', 'archive', 'foobar.a')]
output = run_command(cmd)
# foo should come from main.s and return 42
fail_if_not_contained(output, '(func $foo')
fail_if_not_contained(output, '(i32.const 42)')
# bar should be linked in from bar.s
fail_if_not_contained(output, '(func $bar')
# quux should be linked in from bar.s even though it comes before bar.s in the archive
fail_if_not_contained(output, '(func $quux')
# baz should not be linked in at all
if 'baz' in output:
  raise Exception('output should not contain "baz": ' + output)

# Test an archive using a string table
cmd = [s2wasm, os.path.join('test', 'linker', 'main.s'), '-l', os.path.join('test', 'linker', 'archive', 'barlong.a')]
output = run_command(cmd)
# bar should be linked from the archive
fail_if_not_contained(output, '(func $bar')


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
        only = [] if opts != ['-O1'] or '_only' not in base else ['-s', 'ONLY_MY_CODE=1'] # only my code is a hack we used early in wasm backend dev, which somehow worked, but only with -O1
        command = [VANILLA_EMCC, '-o', 'a.wasm.js', os.path.join('test', 'wasm_backend', c)] + opts + only
        print '....' + ' '.join(command)
        if os.path.exists('a.wasm.js'): os.unlink('a.wasm.js')
        subprocess.check_call(command)
        if has_node:
          print '  (check in node)'
          cmd = [has_node, 'a.wasm.js']
          out = run_command(cmd)
          if out.strip() != expected.strip():
            fail(out, expected)
  finally:
    if has_vanilla_llvm:
      del os.environ['LLVM']
    else:
      del os.environ['EMCC_WASM_BACKEND']

print '\n[ checking example testcases... ]\n'

for t in sorted(os.listdir(os.path.join('test', 'example'))):
  output_file = os.path.join('bin', 'example')
  cmd = ['-Isrc', '-g', '-lasmjs', '-lsupport', '-Llib/.', '-pthread', '-o', output_file]
  if t.endswith('.cpp'):
    cmd = [os.path.join('test', 'example', t),
           os.path.join('src', 'passes', 'pass.cpp'),
           os.path.join('src', 'wasm.cpp'),
           os.path.join('src', 'passes', 'Print.cpp')] + cmd
  elif t.endswith('.c'):
    # build the C file separately
    extra = [os.environ.get('CC') or 'gcc',
             os.path.join('test', 'example', t), '-c', '-o', 'example.o',
             '-Isrc', '-g', '-Llib/.', '-pthread']
    print ' '.join(extra)
    subprocess.check_call(extra)
    # Link against the binaryen C library DSO, using an executable-relative rpath
    cmd = ['example.o', '-lbinaryen'] + cmd
    if sys.platform == 'linux' or sys.platform == 'linux2':
      cmd = cmd + ['-Wl,-rpath=$ORIGIN/../lib']
  else:
    continue
  if os.environ.get('COMPILER_FLAGS'):
    for f in os.environ.get('COMPILER_FLAGS').split(' '):
      cmd.append(f)
  cmd = [os.environ.get('CXX') or 'g++', '-std=c++11'] + cmd
  print ' '.join(cmd)
  try:
    subprocess.check_call(cmd)
    actual = subprocess.Popen([output_file], stdout=subprocess.PIPE).communicate()[0]
    expected = open(os.path.join('test', 'example', '.'.join(t.split('.')[:-1]) + '.txt')).read()
  finally:
    os.remove(output_file)
    if sys.platform == 'darwin':
      # Also removes debug directory produced on Mac OS
      shutil.rmtree(output_file + '.dSYM')
  if actual != expected:
    fail(actual, expected)

if has_emcc:

  if has_mozjs:

    print '\n[ checking native wasm support ]\n'

    command = ['emcc', '-o', 'a.wasm.js', '-s', 'BINARYEN=1', os.path.join('test', 'hello_world.c'), '-s', 'BINARYEN_METHOD="native-wasm"', '-s', 'BINARYEN_SCRIPTS="spidermonkify.py"']
    print ' '.join(command)
    subprocess.check_call(command)

    cmd = ['mozjs', 'a.wasm.js']
    out = run_command(cmd)
    assert 'hello, world!' in out, out

    proc = subprocess.Popen([has_node, 'a.wasm.js'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out, err = proc.communicate()
    assert proc.returncode != 0, 'should fail on no wasm support'
    assert 'no native wasm support detected' in err, err

  print '\n[ checking wasm.js methods... ]\n'

  for method_init in ['interpret-asm2wasm', 'interpret-s-expr', 'asmjs', 'interpret-binary']:
    for success in [1, 0]:
      method = method_init
      command = ['emcc', '-o', 'a.wasm.js', '-s', 'BINARYEN=1', os.path.join('test', 'hello_world.c') ]
      command += ['-s', 'BINARYEN_METHOD="' + method + '"']
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
                cmd = [has_node, 'a.' + which + '.js'] + args
                out = run_command(cmd)
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
