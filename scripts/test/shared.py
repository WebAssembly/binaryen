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

import argparse
import difflib
import glob
import os
import shutil
import subprocess
import sys


def parse_args(args):
  usage_str = ("usage: 'python check.py [options]'\n\n"
               "Runs the Binaryen test suite.")
  parser = argparse.ArgumentParser(description=usage_str)
  parser.add_argument(
      '--torture', dest='torture', action='store_true', default=True,
      help='Chooses whether to run the torture testcases. Default: true.')
  parser.add_argument(
      '--no-torture', dest='torture', action='store_false',
      help='Disables running the torture testcases.')
  parser.add_argument(
      '--abort-on-first-failure', dest='abort_on_first_failure',
      action='store_true', default=True,
      help=('Specifies whether to halt test suite execution on first test error.'
            ' Default: true.'))
  parser.add_argument(
      '--no-abort-on-first-failure', dest='abort_on_first_failure',
      action='store_false',
      help=('If set, the whole test suite will run to completion independent of'
            ' earlier errors.'))
  parser.add_argument(
      '--run-gcc-tests', dest='run_gcc_tests', action='store_true', default=True,
      help=('Chooses whether to run the tests that require building with native'
            ' GCC. Default: true.'))
  parser.add_argument(
      '--no-run-gcc-tests', dest='run_gcc_tests', action='store_false',
      help='If set, disables the native GCC tests.')

  parser.add_argument(
      '--interpreter', dest='interpreter', default='',
      help='Specifies the wasm interpreter executable to run tests on.')
  parser.add_argument(
      '--binaryen-bin', dest='binaryen_bin', default='',
      help=('Specifies a path to where the built Binaryen executables reside at.'
            ' Default: bin/ of current directory (i.e. assume an in-tree build).'
            ' If not specified, the environment variable BINARYEN_ROOT= can also'
            ' be used to adjust this.'))
  parser.add_argument(
      '--binaryen-root', dest='binaryen_root', default='',
      help=('Specifies a path to the root of the Binaryen repository tree.'
            ' Default: the directory where this file check.py resides.'))
  parser.add_argument(
      '--valgrind', dest='valgrind', default='',
      help=('Specifies a path to Valgrind tool, which will be used to validate'
            ' execution if specified. (Pass --valgrind=valgrind to search in'
            ' PATH)'))
  parser.add_argument(
      '--valgrind-full-leak-check', dest='valgrind_full_leak_check',
      action='store_true', default=False,
      help=('If specified, all unfreed (but still referenced) pointers at the'
            ' end of execution are considered memory leaks. Default: disabled.'))

  parser.add_argument(
      'positional_args', metavar='tests', nargs=argparse.REMAINDER,
      help='Names specific tests to run.')

  return parser.parse_args(args)


options = parse_args(sys.argv[1:])
requested = options.positional_args

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
    if os.path.isdir(os.path.join(os.environ.get('BINARYEN_ROOT'), 'bin')):
      options.binaryen_bin = os.path.join(
          os.environ.get('BINARYEN_ROOT'), 'bin')
    else:
      options.binaryen_bin = os.environ.get('BINARYEN_ROOT')
  else:
    options.binaryen_bin = 'bin'

# ensure BINARYEN_ROOT is set up
os.environ['BINARYEN_ROOT'] = os.path.dirname(os.path.abspath(
    options.binaryen_bin))

options.binaryen_bin = os.path.normpath(options.binaryen_bin)

wasm_dis_filenames = ['wasm-dis', 'wasm-dis.exe']
if not any(os.path.isfile(os.path.join(options.binaryen_bin, f))
           for f in wasm_dis_filenames):
  warn('Binaryen not found (or has not been successfully built to bin/ ?')

# Locate Binaryen source directory if not specified.
if not options.binaryen_root:
  path_parts = os.path.abspath(__file__).split(os.path.sep)
  options.binaryen_root = os.path.sep.join(path_parts[:-3])

options.binaryen_test = os.path.join(options.binaryen_root, 'test')


# Finds the given executable 'program' in PATH.
# Operates like the Unix tool 'which'.
def which(program):
  def is_exe(fpath):
    return os.path.isfile(fpath) and os.access(fpath, os.X_OK)
  fpath, fname = os.path.split(program)
  if fpath:
    if is_exe(program):
      return program
  else:
    for path in os.environ["PATH"].split(os.pathsep):
      path = path.strip('"')
      exe_file = os.path.join(path, program)
      if is_exe(exe_file):
        return exe_file
      if '.' not in fname:
        if is_exe(exe_file + '.exe'):
          return exe_file + '.exe'
        if is_exe(exe_file + '.cmd'):
          return exe_file + '.cmd'
        if is_exe(exe_file + '.bat'):
          return exe_file + '.bat'


WATERFALL_BUILD_DIR = os.path.join(options.binaryen_test, 'wasm-install')
BIN_DIR = os.path.abspath(os.path.join(
    WATERFALL_BUILD_DIR, 'wasm-install', 'bin'))

NATIVECC = (os.environ.get('CC') or which('mingw32-gcc') or
            which('gcc') or which('clang'))
NATIVEXX = (os.environ.get('CXX') or which('mingw32-g++') or
            which('g++') or which('clang++'))
NODEJS = which('nodejs') or which('node')
MOZJS = which('mozjs') or which('spidermonkey')
EMCC = which('emcc')

BINARYEN_INSTALL_DIR = os.path.dirname(options.binaryen_bin)
WASM_OPT = [os.path.join(options.binaryen_bin, 'wasm-opt')]
WASM_AS = [os.path.join(options.binaryen_bin, 'wasm-as')]
WASM_DIS = [os.path.join(options.binaryen_bin, 'wasm-dis')]
ASM2WASM = [os.path.join(options.binaryen_bin, 'asm2wasm')]
WASM2JS = [os.path.join(options.binaryen_bin, 'wasm2js')]
WASM_CTOR_EVAL = [os.path.join(options.binaryen_bin, 'wasm-ctor-eval')]
WASM_SHELL = [os.path.join(options.binaryen_bin, 'wasm-shell')]
WASM_MERGE = [os.path.join(options.binaryen_bin, 'wasm-merge')]
WASM_REDUCE = [os.path.join(options.binaryen_bin, 'wasm-reduce')]
WASM_METADCE = [os.path.join(options.binaryen_bin, 'wasm-metadce')]
WASM_EMSCRIPTEN_FINALIZE = [os.path.join(options.binaryen_bin,
                                         'wasm-emscripten-finalize')]
BINARYEN_JS = os.path.join(options.binaryen_bin, 'binaryen.js')


def wrap_with_valgrind(cmd):
  # Exit code 97 is arbitrary, used to easily detect when an error occurs that
  # is detected by Valgrind.
  valgrind = [options.valgrind, '--quiet', '--error-exitcode=97']
  if options.valgrind_full_leak_check:
    valgrind += ['--leak-check=full', '--show-leak-kinds=all']
  return valgrind + cmd


if options.valgrind:
  WASM_OPT = wrap_with_valgrind(WASM_OPT)
  WASM_AS = wrap_with_valgrind(WASM_AS)
  WASM_DIS = wrap_with_valgrind(WASM_DIS)
  ASM2WASM = wrap_with_valgrind(ASM2WASM)
  WASM_SHELL = wrap_with_valgrind(WASM_SHELL)

os.environ['BINARYEN'] = os.getcwd()


def get_platform():
  return {'linux2': 'linux',
          'darwin': 'mac',
          'win32': 'windows',
          'cygwin': 'windows'}[sys.platform]


def has_shell_timeout():
  return get_platform() != 'windows' and os.system('timeout 1s pwd') == 0


has_vanilla_llvm = False

# external tools

try:
  if NODEJS is not None:
    subprocess.check_call(
        [NODEJS, '--version'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
except (OSError, subprocess.CalledProcessError):
  NODEJS = None
if NODEJS is None:
  warn('no node found (did not check proper js form)')

try:
  if MOZJS is not None:
    subprocess.check_call(
        [MOZJS, '--version'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
except (OSError, subprocess.CalledProcessError):
  MOZJS = None
if MOZJS is None:
  warn('no mozjs found (did not check native wasm support nor asm.js'
       ' validation)')

try:
  if EMCC is not None:
    subprocess.check_call(
        [EMCC, '--version'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
except (OSError, subprocess.CalledProcessError):
  EMCC = None
if EMCC is None:
  warn('no emcc found (did not check non-vanilla emscripten/binaryen'
       ' integration)')

has_vanilla_emcc = False
try:
  subprocess.check_call(
      [os.path.join(options.binaryen_test, 'emscripten', 'emcc'), '--version'],
      stdout=subprocess.PIPE, stderr=subprocess.PIPE)
  has_vanilla_emcc = True
except (OSError, subprocess.CalledProcessError):
  pass


# utilities

# removes a file if it exists, using any and all ways of doing so
def delete_from_orbit(filename):
  try:
    os.unlink(filename)
  except OSError:
    pass
  if not os.path.exists(filename):
    return
  try:
    shutil.rmtree(filename, ignore_errors=True)
  except OSError:
    pass
  if not os.path.exists(filename):
    return
  try:
    import stat
    os.chmod(filename, os.stat(filename).st_mode | stat.S_IWRITE)

    def remove_readonly_and_try_again(func, path, exc_info):
      if not (os.stat(path).st_mode & stat.S_IWRITE):
        os.chmod(path, os.stat(path).st_mode | stat.S_IWRITE)
        func(path)
      else:
        raise
    shutil.rmtree(filename, onerror=remove_readonly_and_try_again)
  except OSError:
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


def fail(actual, expected, fromfile='expected'):
  diff_lines = difflib.unified_diff(
      expected.split('\n'), actual.split('\n'),
      fromfile=fromfile, tofile='actual')
  diff_str = ''.join([a.rstrip() + '\n' for a in diff_lines])[:]
  fail_with_error("incorrect output, diff:\n\n%s" % diff_str)


def fail_if_not_identical(actual, expected, fromfile='expected'):
  if expected != actual:
    fail(actual, expected, fromfile=fromfile)


def fail_if_not_contained(actual, expected):
  if expected not in actual:
    fail(actual, expected)


def fail_if_not_identical_to_file(actual, expected_file):
  with open(expected_file, 'rb' if expected_file.endswith(".wasm") else 'r') as f:
    fail_if_not_identical(actual, f.read(), fromfile=expected_file)


if len(requested) == 0:
  tests = sorted(os.listdir(os.path.join(options.binaryen_test)))
else:
  tests = requested[:]

if not options.interpreter:
  warn('no interpreter provided (did not test spec interpreter validation)')

if not has_vanilla_emcc:
  warn('no functional emcc submodule found')


# check utilities

def binary_format_check(wast, verify_final_result=True, wasm_as_args=['-g'],
                        binary_suffix='.fromBinary'):
  # checks we can convert the wast to binary and back

  print '     (binary format check)'
  cmd = WASM_AS + [wast, '-o', 'a.wasm'] + wasm_as_args
  print '      ', ' '.join(cmd)
  if os.path.exists('a.wasm'):
    os.unlink('a.wasm')
  subprocess.check_call(cmd, stdout=subprocess.PIPE)
  assert os.path.exists('a.wasm')

  cmd = WASM_DIS + ['a.wasm', '-o', 'ab.wast']
  print '      ', ' '.join(cmd)
  if os.path.exists('ab.wast'):
    os.unlink('ab.wast')
  subprocess.check_call(cmd, stdout=subprocess.PIPE)
  assert os.path.exists('ab.wast')

  # make sure it is a valid wast
  cmd = WASM_OPT + ['ab.wast']
  print '      ', ' '.join(cmd)
  subprocess.check_call(cmd, stdout=subprocess.PIPE)

  if verify_final_result:
    actual = open('ab.wast').read()
    fail_if_not_identical_to_file(actual, wast + binary_suffix)

  return 'ab.wast'


def minify_check(wast, verify_final_result=True):
  # checks we can parse minified output

  print '     (minify check)'
  cmd = WASM_OPT + [wast, '--print-minified']
  print '      ', ' '.join(cmd)
  subprocess.check_call(
      WASM_OPT + [wast, '--print-minified'],
      stdout=open('a.wast', 'w'), stderr=subprocess.PIPE)
  assert os.path.exists('a.wast')
  subprocess.check_call(
      WASM_OPT + ['a.wast', '--print-minified'],
      stdout=open('b.wast', 'w'), stderr=subprocess.PIPE)
  assert os.path.exists('b.wast')
  if verify_final_result:
    expected = open('a.wast').read()
    actual = open('b.wast').read()
    if actual != expected:
      fail(actual, expected)
  if os.path.exists('a.wast'):
    os.unlink('a.wast')
  if os.path.exists('b.wast'):
    os.unlink('b.wast')


def files_with_pattern(*path_pattern):
  return sorted(glob.glob(os.path.join(*path_pattern)))
