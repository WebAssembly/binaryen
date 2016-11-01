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

import os, shutil, sys, subprocess, difflib, json, time, urllib2, argparse

import scripts.storage
from scripts.support import run_command, split_wast

usage_str = "usage: 'python check.py [options]'\n\n Runs the Binaryen test suite."
parser = argparse.ArgumentParser(description=usage_str)
parser.add_argument('--torture', dest='torture', action='store_true', default=True, help='Chooses whether to run the torture testcases. Default: true.')
parser.add_argument('--no-torture', dest='torture', action='store_false', help='Disables running the torture testcases.')
parser.add_argument('--only-prepare', dest='only_prepare', action='store_true', default=False, help='If enabled, only fetches the waterfall build. Default: false.')
parser.add_argument('--only_prepare', dest='only_prepare', action='store_true', default=False, help='If enabled, only fetches the waterfall build. Default: false.') # Backwards compatibility
parser.add_argument('--test-waterfall', dest='test_waterfall', action='store_true', default=True, help='If enabled, fetches and tests the LLVM waterfall builds. Default: true.')
parser.add_argument('--no-test-waterfall', dest='test_waterfall', action='store_false', help='Disables downloading and testing of the LLVM waterfall builds.')
parser.add_argument('--abort-on-first-failure', dest='abort_on_first_failure', action='store_true', default=True, help='Specifies whether to halt test suite execution on first test error. Default: true.')
parser.add_argument('--no-abort-on-first-failure', dest='abort_on_first_failure', action='store_false', help='If set, the whole test suite will run to completion independent of earlier errors.')
parser.add_argument('--run-gcc-tests', dest='run_gcc_tests', action='store_true', default=True, help='Chooses whether to run the tests that require building with native GCC. Default: true.')
parser.add_argument('--no-run-gcc-tests', dest='run_gcc_tests', action='store_false', help='If set, disables the native GCC tests.')

parser.add_argument('--interpreter', dest='interpreter', default='', help='Specifies the wasm interpreter executable to run tests on.')
parser.add_argument('--binaryen-bin', dest='binaryen_bin', default='', help='Specifies a path to where the built Binaryen executables reside at. Default: bin/ of current directory (i.e. assume an in-tree build). If not specified, the environment variable BINARYEN_ROOT= can also be used to adjust this.')
parser.add_argument('--binaryen-root', dest='binaryen_root', default='', help='Specifies a path to the root of the Binaryen repository tree. Default: the directory where this file check.py resides.')
parser.add_argument('--valgrind', dest='valgrind', default='', help='Specifies a path to Valgrind tool, which will be used to validate execution if specified. (Pass --valgrind=valgrind to search in PATH)')
parser.add_argument('--valgrind-full-leak-check', dest='valgrind_full_leak_check', action='store_true', default=False, help='If specified, all unfreed (but still referenced) pointers at the end of execution are considered memory leaks. Default: disabled.')

parser.add_argument('positional_args', metavar='tests', nargs=argparse.REMAINDER, help='Names specific tests to run.')
options = parser.parse_args()
requested = options.positional_args

if options.interpreter:
  print '[ using wasm interpreter at "%s" ]' % options.interpreter
  assert os.path.exists(options.interpreter), 'interpreter not found'

num_failures = 0
warnings = []

def warn(text):
  global warnings
  warnings.append(text)
  print 'warning:', text

# setup

# Locate Binaryen build artifacts directory (bin/ by default)
if not options.binaryen_bin:
  if os.environ.get('BINARYEN_ROOT'):
    if os.path.isdir(os.path.join(os.environ.get('BINARYEN_ROOT'), 'bin')): options.binaryen_bin = os.path.join(os.environ.get('BINARYEN_ROOT'), 'bin')
    else: options.binaryen_bin = os.environ.get('BINARYEN_ROOT')
  else:
    options.binaryen_bin = 'bin'

if not os.path.isfile(os.path.join(options.binaryen_bin, 'wasm-dis')) and not os.path.isfile(os.path.join(options.binaryen_bin, 'wasm-dis.exe')):
  warn('Binaryen not found (or has not been successfully built to bin/ ?')

# Locate Binaryen source directory if not specified.
if not options.binaryen_root:
  options.binaryen_root = os.path.dirname(os.path.abspath(__file__))

options.binaryen_test = os.path.join(options.binaryen_root, 'test')

# Finds the given executable 'program' in PATH. Operates like the Unix tool 'which'.
def which(program):
  def is_exe(fpath): return os.path.isfile(fpath) and os.access(fpath, os.X_OK)
  fpath, fname = os.path.split(program)
  if fpath:
    if is_exe(program): return program
  else:
    for path in os.environ["PATH"].split(os.pathsep):
      path = path.strip('"')
      exe_file = os.path.join(path, program)
      if is_exe(exe_file): return exe_file
      if not '.' in fname:
        if is_exe(exe_file + '.exe'): return exe_file + '.exe'
        if is_exe(exe_file + '.cmd'): return exe_file + '.cmd'
        if is_exe(exe_file + '.bat'): return exe_file + '.bat'

WATERFALL_BUILD_DIR = os.path.join(options.binaryen_test, 'wasm-install')
BIN_DIR = os.path.abspath(os.path.join(WATERFALL_BUILD_DIR, 'wasm-install', 'bin'))

NATIVECC = os.environ.get('CC') or which('mingw32-gcc') or which('gcc') or which('clang')
NATIVEXX = os.environ.get('CXX') or which('mingw32-g++') or which('g++') or which('clang++')
NODEJS = which('nodejs') or which('node')
MOZJS = which('mozjs')
EMCC = which('emcc')

WASM_OPT = [os.path.join(options.binaryen_bin, 'wasm-opt')]
WASM_AS = [os.path.join(options.binaryen_bin, 'wasm-as')]
WASM_DIS = [os.path.join(options.binaryen_bin, 'wasm-dis')]
ASM2WASM = [os.path.join(options.binaryen_bin, 'asm2wasm')]
WASM_SHELL = [os.path.join(options.binaryen_bin, 'wasm-shell')]
S2WASM = [os.path.join(options.binaryen_bin, 's2wasm')]

S2WASM_EXE = S2WASM[0]
WASM_SHELL_EXE = WASM_SHELL[0]

def wrap_with_valgrind(cmd):
  valgrind = [options.valgrind, '--quiet', '--error-exitcode=97'] # Exit code 97 is arbitrary, used to easily detect when an error occurs that is detected by Valgrind.
  if options.valgrind_full_leak_check:
    valgrind += ['--leak-check=full', '--show-leak-kinds=all']
  return valgrind + cmd

if options.valgrind:
  WASM_OPT = wrap_with_valgrind(WASM_OPT)
  WASM_AS = wrap_with_valgrind(WASM_AS)
  WASM_DIS = wrap_with_valgrind(WASM_DIS)
  ASM2WASM = wrap_with_valgrind(ASM2WASM)
  WASM_SHELL = wrap_with_valgrind(WASM_SHELL)
  S2WASM = wrap_with_valgrind(S2WASM)

os.environ['BINARYEN'] = os.getcwd()

def fetch_waterfall():
  rev = open(os.path.join(options.binaryen_test, 'revision')).read().strip()
  buildername = { 'linux2':'linux',
                  'darwin':'mac',
                  'win32':'windows',
                  'cygwin':'windows' }[sys.platform]
  try:
    local_rev = open(os.path.join(options.binaryen_test, 'local-revision')).read().strip()
  except:
    local_rev = None
  if local_rev == rev: return
  # fetch it
  basename = 'wasm-binaries-' + rev + '.tbz2'
  url = '/'.join(['https://storage.googleapis.com/wasm-llvm/builds', buildername, rev, basename])
  print '(downloading waterfall %s: %s)' % (rev, url)
  downloaded = urllib2.urlopen(url).read().strip()
  fullname = os.path.join(options.binaryen_test, basename)
  open(fullname, 'wb').write(downloaded)
  print '(unpacking)'
  if os.path.exists(WATERFALL_BUILD_DIR):
    shutil.rmtree(WATERFALL_BUILD_DIR)
  os.mkdir(WATERFALL_BUILD_DIR)
  subprocess.check_call(['tar', '-xf', os.path.abspath(fullname)], cwd=WATERFALL_BUILD_DIR)
  print '(noting local revision)'
  with open(os.path.join(options.binaryen_test, 'local-revision'), 'w') as o: o.write(rev)

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

if options.test_waterfall:
  fetch_waterfall()
  setup_waterfall()

if options.only_prepare:
  print 'waterfall is fetched and setup, exiting since --only-prepare'
  sys.exit(0)

# external tools

try:
  subprocess.check_call([NODEJS, '--version'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
except:
  NODEJS = None
  warn('no node found (did not check proper js form)')

try:
  subprocess.check_call([MOZJS, '--version'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
except:
  MOZJS = None
  warn('no mozjs found (did not check native wasm support nor asm.js validation)')

try:
  subprocess.check_call([EMCC, '--version'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
except:
  EMCC = None
  warn('no emcc found (did not check non-vanilla emscripten/binaryen integration)')

has_vanilla_emcc = False
try:
  subprocess.check_call([os.path.join(options.binaryen_test, 'emscripten', 'emcc'), '--version'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
  has_vanilla_emcc = True
except:
  pass

# utilities

def delete_from_orbit(filename): # removes a file if it exists, using any and all ways of doing so
  try:
    os.unlink(filename)
  except:
    pass
  if not os.path.exists(filename): return
  try:
    shutil.rmtree(filename, ignore_errors=True)
  except:
    pass
  if not os.path.exists(filename): return
  try:
    os.chmod(filename, os.stat(filename).st_mode | stat.S_IWRITE)
    def remove_readonly_and_try_again(func, path, exc_info):
      if not (os.stat(path).st_mode & stat.S_IWRITE):
        os.chmod(path, os.stat(path).st_mode | stat.S_IWRITE)
        func(path)
      else:
        raise
    shutil.rmtree(filename, onerror=remove_readonly_and_try_again)
  except:
    pass

def fail_with_error(msg):
  global num_failures
  try:
    num_failures += 1
    raise Exception(msg)
  except Exception, e:
    print >> sys.stderr, str(e)
    if options.abort_on_first_failure:
      raise

def fail(actual, expected):
  fail_with_error("incorrect output, diff:\n\n%s" % (''.join([a.rstrip()+'\n' for a in difflib.unified_diff(expected.split('\n'), actual.split('\n'), fromfile='expected', tofile='actual')])[:]))

def fail_if_not_identical(actual, expected):
  if expected != actual:
    fail(actual, expected)

def fail_if_not_contained(actual, expected):
  if expected not in actual:
    fail(actual, expected)

if len(requested) == 0:
  tests = sorted(os.listdir(os.path.join(options.binaryen_test)))
else:
  tests = requested[:]

if not options.interpreter:
  warn('no interpreter provided (did not test spec interpreter validation)')

if not has_vanilla_emcc:
  warn('no functional emcc submodule found')

# check utilities

def binary_format_check(wast, verify_final_result=True, wasm_as_args=['-g'], binary_suffix='.fromBinary'):
  # checks we can convert the wast to binary and back

  print '     (binary format check)'
  cmd = WASM_AS + [wast, '-o', 'a.wasm'] + wasm_as_args
  print '      ', ' '.join(cmd)
  if os.path.exists('a.wasm'): os.unlink('a.wasm')
  subprocess.check_call(cmd, stdout=subprocess.PIPE)
  assert os.path.exists('a.wasm')

  cmd = WASM_DIS + ['a.wasm', '-o', 'ab.wast']
  print '      ', ' '.join(cmd)
  if os.path.exists('ab.wast'): os.unlink('ab.wast')
  subprocess.check_call(cmd, stdout=subprocess.PIPE)
  assert os.path.exists('ab.wast')

  # make sure it is a valid wast
  cmd = WASM_OPT + ['ab.wast']
  print '      ', ' '.join(cmd)
  subprocess.check_call(cmd, stdout=subprocess.PIPE)

  if verify_final_result:
    expected = open(wast + binary_suffix).read()
    actual = open('ab.wast').read()
    if actual != expected:
      fail(actual, expected)

  return 'ab.wast'

def minify_check(wast, verify_final_result=True):
  # checks we can parse minified output

  print '     (minify check)'
  cmd = WASM_OPT + [wast, '--print-minified']
  print '      ', ' '.join(cmd)
  subprocess.check_call(WASM_OPT + [wast, '--print-minified'], stdout=open('a.wasm', 'w'), stderr=subprocess.PIPE)
  assert os.path.exists('a.wasm')
  subprocess.check_call(WASM_OPT + ['a.wasm', '--print-minified'], stdout=open('b.wasm', 'w'), stderr=subprocess.PIPE)
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

not_executable_suffix = ['.txt', '.js', '.ilk', '.pdb', '.dll']
executables = sorted(filter(lambda x: not any(x.endswith(s) for s in
                                              not_executable_suffix) and os.path.isfile(x),
                            os.listdir(options.binaryen_bin)))
for e in executables:
  print '.. %s --help' % e
  out, err = subprocess.Popen([os.path.join(options.binaryen_bin, e), '--help'],
                              stdout=subprocess.PIPE,
                              stderr=subprocess.PIPE).communicate()
  assert len(out) == 0, 'Expected no stdout, got:\n%s' % out
  assert e.replace('.exe', '') in err, 'Expected help to contain program name, got:\n%s' % err
  assert len(err.split('\n')) > 8, 'Expected some help, got:\n%s' % err

print '\n[ checking wasm-opt -o notation... ]\n'

wast = os.path.join(options.binaryen_test, 'hello_world.wast')
delete_from_orbit('a.wast')
cmd = WASM_OPT + [wast, '-o', 'a.wast']
run_command(cmd)
fail_if_not_identical(open('a.wast').read(), open(wast).read())

print '\n[ checking wasm-opt passes... ]\n'

for t in sorted(os.listdir(os.path.join(options.binaryen_test, 'passes'))):
  if t.endswith('.wast'):
    print '..', t
    passname = os.path.basename(t).replace('.wast', '')
    opts = ['-' + passname] if passname.startswith('O') else ['--' + p for p in passname.split('_')]
    t = os.path.join(options.binaryen_test, 'passes', t)
    actual = ''
    for module, asserts in split_wast(t):
      assert len(asserts) == 0
      with open('split.wast', 'w') as o: o.write(module)
      cmd = WASM_OPT + opts + ['split.wast', '--print']
      actual += run_command(cmd)
      # also check debug mode output is valid
      debugged = run_command(cmd + ['--debug'], stderr=subprocess.PIPE)
      fail_if_not_contained(actual, debugged)
    fail_if_not_identical(actual, open(os.path.join(options.binaryen_test, 'passes', passname + '.txt'), 'rb').read())

print '[ checking asm2wasm testcases... ]\n'

for asm in tests:
  if asm.endswith('.asm.js'):
    for precise in [1, 0]:
      for opts in [1, 0]:
        cmd = ASM2WASM + [os.path.join(options.binaryen_test, asm)]
        wasm = asm.replace('.asm.js', '.fromasm')
        if not precise:
          cmd += ['--imprecise']
          wasm += '.imprecise'
        if not opts:
          wasm += '.no-opts'
          if precise:
            cmd += ['-O0'] # test that -O0 does nothing
        else:
          cmd += ['-O']
        if precise and opts:
          # test mem init importing
          open('a.mem', 'wb').write(asm)
          cmd += ['--mem-init=a.mem']
          if asm[0] == 'e':
            cmd += ['--mem-base=1024']
        if 'i64' in asm or 'wasm-only' in asm:
          cmd += ['--wasm-only']
        wasm = os.path.join(options.binaryen_test, wasm)
        print '..', asm, wasm
        actual = run_command(cmd)

        # verify output
        if not os.path.exists(wasm):
          fail_with_error('output .wast file %s does not exist' % wasm)
        expected = open(wasm, 'rb').read()
        if actual != expected:
          fail(actual, expected)

        binary_format_check(wasm, verify_final_result=False)

        # verify in wasm
        if options.interpreter:
          # remove imports, spec interpreter doesn't know what to do with them
          subprocess.check_call(WASM_OPT + ['--remove-imports', wasm], stdout=open('ztemp.wast', 'w'), stderr=subprocess.PIPE)
          proc = subprocess.Popen([options.interpreter, 'ztemp.wast'], stderr=subprocess.PIPE)
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
              fail_with_error('wasm interpreter error: ' + err) # failed to pretty-print
            fail_with_error('wasm interpreter error')

print '\n[ checking wasm-opt parsing & printing... ]\n'

for t in sorted(os.listdir(os.path.join(options.binaryen_test, 'print'))):
  if t.endswith('.wast'):
    print '..', t
    wasm = os.path.basename(t).replace('.wast', '')
    cmd = WASM_OPT + [os.path.join(options.binaryen_test, 'print', t), '--print']
    print '    ', ' '.join(cmd)
    actual, err = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
    fail_if_not_identical(actual, open(os.path.join(options.binaryen_test, 'print', wasm + '.txt')).read())
    cmd = WASM_OPT + [os.path.join(options.binaryen_test, 'print', t), '--print-minified']
    print '    ', ' '.join(cmd)
    actual, err = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
    fail_if_not_identical(actual.strip(), open(os.path.join(options.binaryen_test, 'print', wasm + '.minified.txt')).read().strip())

print '\n[ checking wasm-opt testcases... ]\n'

for t in tests:
  if t.endswith('.wast') and not t.startswith('spec'):
    print '..', t
    t = os.path.join(options.binaryen_test, t)
    cmd = WASM_OPT + [t, '--print']
    actual = run_command(cmd)
    actual = actual.replace('printing before:\n', '')

    expected = open(t, 'rb').read()
    if actual != expected:
      fail(actual, expected)

    binary_format_check(t, wasm_as_args=['-g']) # test with debuginfo
    binary_format_check(t, wasm_as_args=[], binary_suffix='.fromBinary.noDebugInfo') # test without debuginfo

    minify_check(t)

print '\n[ checking wasm-shell spec testcases... ]\n'

if len(requested) == 0:
  BLACKLIST = ['memory.wast', 'binary.wast'] # FIXME we support old and new memory formats, for now, until 0xc, and so can't pass this old-style test.
  # FIXME to update the spec to 0xd, we need to implement (register "name") for import.wast
  spec_tests = [os.path.join('spec', t) for t in sorted(os.listdir(os.path.join(options.binaryen_test, 'spec'))) if t not in BLACKLIST]
else:
  spec_tests = requested[:]

for t in spec_tests:
  if t.startswith('spec') and t.endswith('.wast'):
    print '..', t
    wast = os.path.join(options.binaryen_test, t)

    # skip checks for some tests
    if os.path.basename(wast) in ['linking.wast', 'nop.wast', 'stack.wast', 'typecheck.wast', 'unwind.wast']: # FIXME
      continue

    def run_spec_test(wast):
      cmd = WASM_SHELL + [wast]
      # we must skip the stack machine portions of spec tests or apply other extra args
      extra = {
      }
      cmd = cmd + (extra.get(os.path.basename(wast)) or [])
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

    expected = os.path.join(options.binaryen_test, 'spec', 'expected-output', os.path.basename(wast) + '.log')

    # some spec tests should fail (actual process failure, not just assert_invalid)
    try:
      actual = run_spec_test(wast)
    except Exception, e:
      if ('wasm-validator error' in str(e) or 'parse exception' in str(e)) and '.fail.' in t:
        print '<< test failed as expected >>'
        continue # don't try all the binary format stuff TODO
      else:
        fail_with_error(str(e))

    check_expected(actual, expected)

    # skip binary checks for tests that reuse previous modules by name, as that's a wast-only feature
    if os.path.basename(wast) in ['exports.wast']: # FIXME
      continue

    # we must ignore some binary format splits
    splits_to_skip = {
        'func.wast': [2],
        'return.wast': [2]
    }

    # check binary format. here we can verify execution of the final result, no need for an output verification
    split_num = 0
    if os.path.basename(wast) not in []: # avoid some tests with things still being sorted out in the spec
      actual = ''
      for module, asserts in split_wast(wast):
        skip = splits_to_skip.get(os.path.basename(wast)) or []
        if split_num in skip:
          print '    skipping split module', split_num - 1
          split_num += 1
          continue
        print '    testing split module', split_num
        split_num += 1
        with open('split.wast', 'w') as o: o.write(module + '\n' + '\n'.join(asserts))
        run_spec_test('split.wast') # before binary stuff - just check it's still ok split out
        result_wast = binary_format_check('split.wast', verify_final_result=False)
        # add the asserts, and verify that the test still passes
        open(result_wast, 'a').write('\n' + '\n'.join(asserts))
        actual += run_spec_test(result_wast)
      # compare all the outputs to the expected output
      check_expected(actual, os.path.join(options.binaryen_test, 'spec', 'expected-output', os.path.basename(wast) + '.log'))

if NODEJS:
  print '\n[ checking binaryen.js testcases... ]\n'

  for s in sorted(os.listdir(os.path.join(options.binaryen_test, 'binaryen.js'))):
    if not s.endswith('.js'): continue
    print s
    f = open('a.js', 'w')
    f.write(open(os.path.join(options.binaryen_bin, 'binaryen.js')).read())
    f.write(open(os.path.join(options.binaryen_test, 'binaryen.js', s)).read())
    f.close()
    cmd = [NODEJS, 'a.js']
    out = run_command(cmd)
    expected = open(os.path.join(options.binaryen_test, 'binaryen.js', s + '.txt')).read()
    if expected not in out:
      fail(out, expected)

print '\n[ checking .s testcases... ]\n'

for dot_s_dir in ['dot_s', 'llvm_autogenerated']:
  for s in sorted(os.listdir(os.path.join(options.binaryen_test, dot_s_dir))):
    if not s.endswith('.s'): continue
    print '..', s
    wasm = s.replace('.s', '.wast')
    full = os.path.join(options.binaryen_test, dot_s_dir, s)
    stack_alloc = ['--allocate-stack=1024'] if dot_s_dir == 'llvm_autogenerated' else []
    cmd = S2WASM + [full, '--emscripten-glue'] + stack_alloc
    if s.startswith('start_'):
      cmd.append('--start')
    actual = run_command(cmd)

    # verify output
    expected_file = os.path.join(options.binaryen_test, dot_s_dir, wasm)
    if not os.path.exists(expected_file):
      print actual
      fail_with_error('output ' + expected_file + ' does not exist')
    expected = open(expected_file, 'rb').read()
    if actual != expected:
      fail(actual, expected)

    # verify with options
    cmd = S2WASM + [full, '--global-base=1024'] + stack_alloc
    run_command(cmd)

    # run wasm-shell on the .wast to verify that it parses
    cmd = WASM_SHELL + [expected_file]
    run_command(cmd)

print '\n[ running linker tests... ]\n'
# The {main,foo,bar,baz}.s files were created by running clang over the respective
# c files. The foobar.bar archive was created by running:
# llvm-ar -format=gnu rc foobar.a quux.s foo.s bar.s baz.s
cmd = S2WASM + [os.path.join(options.binaryen_test, 'linker', 'main.s'), '-l', os.path.join(options.binaryen_test, 'linker', 'archive', 'foobar.a')]
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
  fail_with_error('output should not contain "baz": ' + output)

# Test an archive using a string table
cmd = S2WASM + [os.path.join(options.binaryen_test, 'linker', 'main.s'), '-l', os.path.join(options.binaryen_test, 'linker', 'archive', 'barlong.a')]
output = run_command(cmd)
# bar should be linked from the archive
fail_if_not_contained(output, '(func $bar')

# Test exporting memory growth function
cmd = S2WASM + [os.path.join(options.binaryen_test, 'linker', 'main.s'), '--emscripten-glue', '--allow-memory-growth']
output = run_command(cmd)
fail_if_not_contained(output, '(export "__growWasmMemory" (func $__growWasmMemory))')
fail_if_not_contained(output, '(func $__growWasmMemory (param $newSize i32)')

print '\n[ running validation tests... ]\n'
# Ensure the tests validate by default
cmd = WASM_AS + [os.path.join(options.binaryen_test, 'validator', 'invalid_export.wast')]
run_command(cmd)
cmd = WASM_AS + [os.path.join(options.binaryen_test, 'validator', 'invalid_import.wast')]
run_command(cmd)
cmd = WASM_AS + ['--validate=web', os.path.join(options.binaryen_test, 'validator', 'invalid_export.wast')]
run_command(cmd, expected_status=1)
cmd = WASM_AS + ['--validate=web', os.path.join(options.binaryen_test, 'validator', 'invalid_import.wast')]
run_command(cmd, expected_status=1)
cmd = WASM_AS + ['--validate=none', os.path.join(options.binaryen_test, 'validator', 'invalid_return.wast')]
run_command(cmd)

if options.torture and options.test_waterfall:

  print '\n[ checking torture testcases... ]\n'

  unexpected_result_count = 0

  import test.waterfall.src.link_assembly_files as link_assembly_files
  s2wasm_torture_out = os.path.abspath(os.path.join(options.binaryen_test, 's2wasm-torture-out'))
  if os.path.isdir(s2wasm_torture_out):
    shutil.rmtree(s2wasm_torture_out)
  os.mkdir(s2wasm_torture_out)
  unexpected_result_count += link_assembly_files.run(
      linker=os.path.abspath(S2WASM_EXE),
      files=os.path.abspath(os.path.join(options.binaryen_test, 'torture-s', '*.s')),
      fails=os.path.abspath(os.path.join(options.binaryen_test, 's2wasm_known_gcc_test_failures.txt')),
      out=s2wasm_torture_out)
  assert os.path.isdir(s2wasm_torture_out), 'Expected output directory %s' % s2wasm_torture_out

  import test.waterfall.src.execute_files as execute_files
  unexpected_result_count += execute_files.run(
      runner=os.path.abspath(WASM_SHELL_EXE),
      files=os.path.abspath(os.path.join(s2wasm_torture_out, '*.wast')),
      fails=os.path.abspath(os.path.join(options.binaryen_test, 's2wasm_known_binaryen_shell_test_failures.txt')),
      out='',
      wasmjs='')

  shutil.rmtree(s2wasm_torture_out)
  if unexpected_result_count:
    fail('%s failures' % unexpected_result_count, '0 failures')

if has_vanilla_emcc and has_vanilla_llvm and 0:

  print '\n[ checking emcc WASM_BACKEND testcases...]\n'

  try:
    if has_vanilla_llvm:
      os.environ['LLVM'] = BIN_DIR # use the vanilla LLVM
    else:
      # if we did not set vanilla llvm, then we must set this env var to make emcc use the wasm backend.
      # (if we are using vanilla llvm, things should just work)
      print '(not using vanilla llvm, so setting env var to tell emcc to use wasm backend)'
      os.environ['EMCC_WASM_BACKEND'] = '1'
    VANILLA_EMCC = os.path.join(options.binaryen_test, 'emscripten', 'emcc')
    # run emcc to make sure it sets itself up properly, if it was never run before
    command = [VANILLA_EMCC, '-v']
    print '____' + ' '.join(command)
    subprocess.check_call(command)

    for c in sorted(os.listdir(os.path.join(options.binaryen_test, 'wasm_backend'))):
      if not c.endswith('cpp'): continue
      print '..', c
      base = c.replace('.cpp', '').replace('.c', '')
      expected = open(os.path.join(options.binaryen_test, 'wasm_backend', base + '.txt')).read()
      for opts in [[], ['-O1'], ['-O2']]:
        only = [] if opts != ['-O1'] or '_only' not in base else ['-s', 'ONLY_MY_CODE=1'] # only my code is a hack we used early in wasm backend dev, which somehow worked, but only with -O1
        command = [VANILLA_EMCC, '-o', 'a.wasm.js', os.path.join(options.binaryen_test, 'wasm_backend', c)] + opts + only
        print '....' + ' '.join(command)
        if os.path.exists('a.wasm.js'): os.unlink('a.wasm.js')
        subprocess.check_call(command)
        if NODEJS:
          print '  (check in node)'
          cmd = [NODEJS, 'a.wasm.js']
          out = run_command(cmd)
          if out.strip() != expected.strip():
            fail(out, expected)
  finally:
    if has_vanilla_llvm:
      del os.environ['LLVM']
    else:
      del os.environ['EMCC_WASM_BACKEND']

print '\n[ checking example testcases... ]\n'

if options.run_gcc_tests:
  print '\n[ checking native gcc testcases...]\n'  
  if not NATIVECC or not NATIVEXX:
    fail_with_error('Native compiler (e.g. gcc/g++) was not found in PATH!')
  else:
    for t in sorted(os.listdir(os.path.join(options.binaryen_test, 'example'))):
      output_file = os.path.join(options.binaryen_bin, 'example')
      cmd = ['-I' + os.path.join(options.binaryen_root, 'src'), '-g', '-lasmjs', '-lsupport', '-L' + os.path.join(options.binaryen_bin, '..', 'lib'), '-pthread', '-o', output_file]
      if t.endswith('.txt'):
        # check if there is a trace in the file, if so, we should build it
        out = subprocess.Popen([os.path.join('scripts', 'clean_c_api_trace.py'), os.path.join(options.binaryen_test, 'example', t)], stdout=subprocess.PIPE).communicate()[0]
        if len(out) == 0:
          print '  (no trace in ', t, ')'
          continue
        print '  (will check trace in ', t, ')'
        src = 'trace.cpp'
        with open(src, 'w') as o: o.write(out)
        expected = os.path.join(options.binaryen_test, 'example', t + '.txt')
      else:
        src = os.path.join(options.binaryen_test, 'example', t)
        expected = os.path.join(options.binaryen_test, 'example', '.'.join(t.split('.')[:-1]) + '.txt')
      if src.endswith(('.c', '.cpp')):
        # build the C file separately
        extra = [NATIVECC, src, '-c', '-o', 'example.o',
                 '-I' + os.path.join(options.binaryen_root, 'src'), '-g', '-L' + os.path.join(options.binaryen_bin, '..', 'lib'), '-pthread']
        print 'build: ', ' '.join(extra)
        subprocess.check_call(extra)
        # Link against the binaryen C library DSO, using an executable-relative rpath
        cmd = ['example.o', '-lbinaryen'] + cmd + ['-Wl,-rpath=$ORIGIN/../lib']
      else:
        continue
      print '  ', t, src, expected
      if os.environ.get('COMPILER_FLAGS'):
        for f in os.environ.get('COMPILER_FLAGS').split(' '):
          cmd.append(f)
      cmd = [NATIVEXX, '-std=c++11'] + cmd
      try:
        print 'link: ', ' '.join(cmd)
        subprocess.check_call(cmd)
        print 'run...', output_file
        proc = subprocess.Popen([output_file], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        actual, err = proc.communicate()
        assert proc.returncode == 0, [proc.returncode, actual, err]
      finally:
        os.remove(output_file)
        if sys.platform == 'darwin':
          # Also removes debug directory produced on Mac OS
          shutil.rmtree(output_file + '.dSYM')

      expected = open(expected).read()
      if actual != expected:
        fail(actual, expected)

if EMCC:

  if MOZJS and 0:

    print '\n[ checking native wasm support ]\n'

    command = [EMCC, '-o', 'a.wasm.js', '-s', 'BINARYEN=1', os.path.join(options.binaryen_test, 'hello_world.c'), '-s', 'BINARYEN_METHOD="native-wasm"', '-s', 'BINARYEN_SCRIPTS="spidermonkify.py"']
    print ' '.join(command)
    subprocess.check_call(command)

    cmd = [MOZJS, 'a.wasm.js']
    out = run_command(cmd)
    assert 'hello, world!' in out, out

    proc = subprocess.Popen([NODEJS, 'a.wasm.js'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out, err = proc.communicate()
    assert proc.returncode != 0, 'should fail on no wasm support'
    assert 'no native wasm support detected' in err, err

  print '\n[ checking wasm.js methods... ]\n'

  for method_init in ['interpret-asm2wasm', 'interpret-s-expr', 'asmjs', 'interpret-binary', 'asmjs,interpret-binary', 'interpret-binary,asmjs']:
    # check success and failure for simple modes, only success for combined/fallback ones
    for success in [1, 0] if ',' not in method_init else [1]:
      method = method_init
      command = [EMCC, '-o', 'a.wasm.js', '-s', 'BINARYEN=1', os.path.join(options.binaryen_test, 'hello_world.c') ]
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
        with open('a.wasm.asm.js', 'w') as o: o.write(asm)
      if method.startswith('interpret-asm2wasm'):
        os.unlink('a.wasm.wast') # we should not need the .wast
        if not success:
          break_cashew() # we need cashew
      elif method.startswith('interpret-s-expr'):
        os.unlink('a.wasm.asm.js') # we should not need the .asm.js
        if not success:
          os.unlink('a.wasm.wast')
      elif method.startswith('asmjs'):
        os.unlink('a.wasm.wast') # we should not need the .wast
        break_cashew() # we don't use cashew, so ok to break it
        if not success:
          os.unlink('a.wasm.js')
      elif method.startswith('interpret-binary'):
        os.unlink('a.wasm.wast') # we should not need the .wast
        os.unlink('a.wasm.asm.js') # we should not need the .asm.js
        if not success:
          os.unlink('a.wasm.wasm')
      else:
        1/0
      if NODEJS:
        proc = subprocess.Popen([NODEJS, 'a.wasm.js'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
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
        post = open(os.path.join(options.binaryen_test, post)).read()
      except:
        post = None
      expected = open(os.path.join(options.binaryen_test, base + '.txt')).read()
      emcc = os.path.join(options.binaryen_test, base + '.emcc')
      extra = []
      if os.path.exists(emcc):
        extra = json.loads(open(emcc).read())
      if os.path.exists('a.normal.js'): os.unlink('a.normal.js')
      for opts in [[], ['-O1'], ['-O2'], ['-O3'], ['-Oz']]:
        for method in ['interpret-asm2wasm', 'interpret-s-expr', 'interpret-binary']:
          command = [EMCC, '-o', 'a.wasm.js', '-s', 'BINARYEN=1', os.path.join(options.binaryen_test, c)] + opts + extra
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
              args = json.loads(open(os.path.join(options.binaryen_test, base + '.args')).read())
            except:
              args = []
              print '     (no args)'

            def execute():
              if NODEJS:
                cmd = [NODEJS, 'a.' + which + '.js'] + args
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

if num_failures == 0:
  print '\n[ success! ]'

if warnings:
  print '\n' + '\n'.join(warnings)

if num_failures > 0:
  print '\n[ ' + str(num_failures) + ' failures! ]'

sys.exit(num_failures)
