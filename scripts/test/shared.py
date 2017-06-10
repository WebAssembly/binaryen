import argparse
import difflib
import os
import shutil
import subprocess
import sys
import urllib2


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
    '--only-prepare', dest='only_prepare', action='store_true', default=False,
    help='If enabled, only fetches the waterfall build. Default: false.')
parser.add_argument(
    # Backwards compatibility
    '--only_prepare', dest='only_prepare', action='store_true', default=False,
    help='If enabled, only fetches the waterfall build. Default: false.')
parser.add_argument(
    '--test-waterfall', dest='test_waterfall', action='store_true',
    default=True,
    help=('If enabled, fetches and tests the LLVM waterfall builds.'
          ' Default: true.'))
parser.add_argument(
    '--no-test-waterfall', dest='test_waterfall', action='store_false',
    help='Disables downloading and testing of the LLVM waterfall builds.')
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
options = parser.parse_args()
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

wasm_dis_filenames = ['wasm-dis', 'wasm-dis.exe']
if all(map(lambda f: not os.path.isfile(os.path.join(options.binaryen_bin, f)),
           wasm_dis_filenames)):
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
MOZJS = which('mozjs')
EMCC = which('emcc')

WASM_OPT = [os.path.join(options.binaryen_bin, 'wasm-opt')]
WASM_AS = [os.path.join(options.binaryen_bin, 'wasm-as')]
WASM_DIS = [os.path.join(options.binaryen_bin, 'wasm-dis')]
ASM2WASM = [os.path.join(options.binaryen_bin, 'asm2wasm')]
WASM_CTOR_EVAL = [os.path.join(options.binaryen_bin, 'wasm-ctor-eval')]
WASM_SHELL = [os.path.join(options.binaryen_bin, 'wasm-shell')]
WASM_MERGE = [os.path.join(options.binaryen_bin, 'wasm-merge')]
S2WASM = [os.path.join(options.binaryen_bin, 's2wasm')]

S2WASM_EXE = S2WASM[0]
WASM_SHELL_EXE = WASM_SHELL[0]


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
  S2WASM = wrap_with_valgrind(S2WASM)

os.environ['BINARYEN'] = os.getcwd()


def fetch_waterfall():
  rev = open(os.path.join(options.binaryen_test, 'revision')).read().strip()
  buildername = {'linux2': 'linux',
                 'darwin': 'mac',
                 'win32': 'windows',
                 'cygwin': 'windows'}[sys.platform]
  try:
    local_rev_path = os.path.join(options.binaryen_test, 'local-revision')
    local_rev = open(local_rev_path).read().strip()
  except:
    local_rev = None
  if local_rev == rev:
    return
  # fetch it
  basename = 'wasm-binaries-' + rev + '.tbz2'
  url = '/'.join(['https://storage.googleapis.com/wasm-llvm/builds',
                  buildername, rev, basename])
  print '(downloading waterfall %s: %s)' % (rev, url)
  downloaded = urllib2.urlopen(url).read().strip()
  fullname = os.path.join(options.binaryen_test, basename)
  open(fullname, 'wb').write(downloaded)
  print '(unpacking)'
  if os.path.exists(WATERFALL_BUILD_DIR):
    shutil.rmtree(WATERFALL_BUILD_DIR)
  os.mkdir(WATERFALL_BUILD_DIR)
  subprocess.check_call(['tar', '-xf', os.path.abspath(fullname)],
                        cwd=WATERFALL_BUILD_DIR)
  print '(noting local revision)'
  with open(os.path.join(options.binaryen_test, 'local-revision'), 'w') as o:
    o.write(rev)


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
    warn('could not run vanilla LLVM from waterfall: ' + str(e) +
         ', looked for clang at ' + CLANG)


if options.test_waterfall:
  fetch_waterfall()
  setup_waterfall()

if options.only_prepare:
  print 'waterfall is fetched and setup, exiting since --only-prepare'
  sys.exit(0)

# external tools

try:
  subprocess.check_call(
      [NODEJS, '--version'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
except:
  NODEJS = None
  warn('no node found (did not check proper js form)')

try:
  subprocess.check_call(
      [MOZJS, '--version'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
except:
  MOZJS = None
  warn('no mozjs found (did not check native wasm support nor asm.js'
       ' validation)')

try:
  subprocess.check_call(
      [EMCC, '--version'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
except:
  EMCC = None
  warn('no emcc found (did not check non-vanilla emscripten/binaryen'
       ' integration)')

has_vanilla_emcc = False
try:
  subprocess.check_call(
      [os.path.join(options.binaryen_test, 'emscripten', 'emcc'), '--version'],
      stdout=subprocess.PIPE, stderr=subprocess.PIPE)
  has_vanilla_emcc = True
except:
  pass


# utilities

# removes a file if it exists, using any and all ways of doing so
def delete_from_orbit(filename):
  try:
    os.unlink(filename)
  except:
    pass
  if not os.path.exists(filename):
    return
  try:
    shutil.rmtree(filename, ignore_errors=True)
  except:
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
  diff_lines = difflib.unified_diff(
      expected.split('\n'), actual.split('\n'),
      fromfile='expected', tofile='actual')
  diff_str = ''.join([a.rstrip() + '\n' for a in diff_lines])[:]
  fail_with_error("incorrect output, diff:\n\n%s" % diff_str)


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
