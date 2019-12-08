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

from __future__ import print_function

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
        '--out-dir', dest='out_dir', default='',
        help=('Specifies a path to the output directory for temp files, which '
              'is also where the test runner changes directory into.'
              ' Default:. out/test under the binaryen root.'))
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
        '--spec-test', action='append', nargs='*', default=[], dest='spec_tests',
        help='Names specific spec tests to run.')
    parser.add_argument(
        'positional_args', metavar='TEST_SUITE', nargs='*',
        help=('Names specific test suites to run. Use --list-suites to see a '
              'list of all test suites'))
    parser.add_argument(
        '--list-suites', action='store_true',
        help='List the test suites that can be run.')

    return parser.parse_args(args)


options = parse_args(sys.argv[1:])
requested = options.positional_args

num_failures = 0
warnings = []


def warn(text):
    global warnings
    warnings.append(text)
    print('warning:', text, file=sys.stderr)


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

options.binaryen_bin = os.path.normpath(os.path.abspath(options.binaryen_bin))

# ensure BINARYEN_ROOT is set up
os.environ['BINARYEN_ROOT'] = os.path.dirname(options.binaryen_bin)

wasm_dis_filenames = ['wasm-dis', 'wasm-dis.exe']
if not any(os.path.isfile(os.path.join(options.binaryen_bin, f))
           for f in wasm_dis_filenames):
    warn('Binaryen not found (or has not been successfully built to bin/ ?')

# Locate Binaryen source directory if not specified.
if not options.binaryen_root:
    path_parts = os.path.abspath(__file__).split(os.path.sep)
    options.binaryen_root = os.path.sep.join(path_parts[:-3])

options.binaryen_test = os.path.join(options.binaryen_root, 'test')

if not options.out_dir:
    options.out_dir = os.path.join(options.binaryen_root, 'out', 'test')

if not os.path.exists(options.out_dir):
    os.makedirs(options.out_dir)
os.chdir(options.out_dir)


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
BIN_DIR = os.path.abspath(os.path.join(WATERFALL_BUILD_DIR, 'wasm-install', 'bin'))

NATIVECC = (os.environ.get('CC') or which('mingw32-gcc') or
            which('gcc') or which('clang'))
NATIVEXX = (os.environ.get('CXX') or which('mingw32-g++') or
            which('g++') or which('clang++'))
NODEJS = os.getenv('NODE', which('nodejs') or which('node'))
MOZJS = which('mozjs') or which('spidermonkey')
V8 = which('v8') or which('d8')
EMCC = which('emcc')

BINARYEN_INSTALL_DIR = os.path.dirname(options.binaryen_bin)
WASM_OPT = [os.path.join(options.binaryen_bin, 'wasm-opt')]
WASM_AS = [os.path.join(options.binaryen_bin, 'wasm-as')]
WASM_DIS = [os.path.join(options.binaryen_bin, 'wasm-dis')]
ASM2WASM = [os.path.join(options.binaryen_bin, 'asm2wasm')]
WASM2JS = [os.path.join(options.binaryen_bin, 'wasm2js')]
WASM_CTOR_EVAL = [os.path.join(options.binaryen_bin, 'wasm-ctor-eval')]
WASM_SHELL = [os.path.join(options.binaryen_bin, 'wasm-shell')]
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


def in_binaryen(*args):
    __rootpath__ = os.path.abspath(os.path.dirname(os.path.dirname(os.path.dirname(__file__))))
    return os.path.join(__rootpath__, *args)


os.environ['BINARYEN'] = in_binaryen()


def get_platform():
    return {'linux': 'linux',
            'linux2': 'linux',
            'darwin': 'mac',
            'win32': 'windows',
            'cygwin': 'windows'}[sys.platform]


def has_shell_timeout():
    return get_platform() != 'windows' and os.system('timeout 1s pwd') == 0


# Default options to pass to v8. These enable all features.
V8_OPTS = [
    '--experimental-wasm-eh',
    '--experimental-wasm-mv',
    '--experimental-wasm-sat-f2i-conversions',
    '--experimental-wasm-se',
    '--experimental-wasm-threads',
    '--experimental-wasm-simd',
    '--experimental-wasm-anyref',
    '--experimental-wasm-bulk-memory',
    '--experimental-wasm-return-call'
]

has_vanilla_llvm = False

# external tools

try:
    if NODEJS is not None:
        subprocess.check_call([NODEJS, '--version'],
                              stdout=subprocess.PIPE,
                              stderr=subprocess.PIPE)
except (OSError, subprocess.CalledProcessError):
    NODEJS = None
if NODEJS is None:
    warn('no node found (did not check proper js form)')

try:
    if MOZJS is not None:
        subprocess.check_call([MOZJS, '--version'],
                              stdout=subprocess.PIPE,
                              stderr=subprocess.PIPE)
except (OSError, subprocess.CalledProcessError):
    MOZJS = None
if MOZJS is None:
    warn('no mozjs found (did not check native wasm support nor asm.js'
         ' validation)')

try:
    if EMCC is not None:
        subprocess.check_call([EMCC, '--version'],
                              stdout=subprocess.PIPE,
                              stderr=subprocess.PIPE)
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


# This is a workaround for https://bugs.python.org/issue9400
class Py2CalledProcessError(subprocess.CalledProcessError):
    def __init__(self, returncode, cmd, output=None, stderr=None):
        super(Exception, self).__init__(returncode, cmd, output, stderr)
        self.returncode = returncode
        self.cmd = cmd
        self.output = output
        self.stderr = stderr


def run_process(cmd, check=True, input=None, capture_output=False, decode_output=True, *args, **kw):
    if input and type(input) == str:
        input = bytes(input, 'utf-8')
    if capture_output:
        kw['stdout'] = subprocess.PIPE
        kw['stderr'] = subprocess.PIPE
    ret = subprocess.run(cmd, check=check, input=input, *args, **kw)
    if decode_output and ret.stdout is not None:
        ret.stdout = ret.stdout.decode('utf-8')
    if ret.stderr is not None:
        ret.stderr = ret.stderr.decode('utf-8')
    return ret


def fail_with_error(msg):
    global num_failures
    try:
        num_failures += 1
        raise Exception(msg)
    except Exception as e:
        print(str(e))
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
    binary = expected_file.endswith(".wasm") or type(actual) == bytes
    with open(expected_file, 'rb' if binary else 'r') as f:
        fail_if_not_identical(actual, f.read(), fromfile=expected_file)


def get_test_dir(name):
    """Returns the test directory located at BINARYEN_ROOT/test/[name]."""
    return os.path.join(options.binaryen_test, name)


def get_tests(test_dir, extensions=[]):
    """Returns the list of test files in a given directory. 'extensions' is a
    list of file extensions. If 'extensions' is empty, returns all files.
    """
    tests = []
    if not extensions:
        tests += glob.glob(os.path.join(test_dir, '*'))
    for ext in extensions:
        tests += glob.glob(os.path.join(test_dir, '*' + ext))
    return sorted(tests)


if not options.interpreter:
    warn('no interpreter provided (did not test spec interpreter validation)')

if not has_vanilla_emcc:
    warn('no functional emcc submodule found')


if not options.spec_tests:
    options.spec_tests = get_tests(get_test_dir('spec'), ['.wast'])
else:
    options.spec_tests = options.spec_tests[:]

# 11/27/2019: We updated the spec test suite to upstream spec repo. For some
# files that started failing after this update, we added the new files to this
# blacklist and preserved old ones by renaming them to 'old_[FILENAME].wast'
# not to lose coverage. When the cause of the error is fixed or the unsupported
# construct gets support so the new test passes, we can delete the
# corresponding 'old_[FILENAME].wast' file. When you fix the new file and
# delete the old file, make sure you rename the corresponding .wast.log file in
# expected-output/ if any.
SPEC_TEST_BLACKLIST = [
    # Stacky code / notation
    'block.wast',
    'call.wast',
    'float_exprs.wast',
    'globals.wast',
    'loop.wast',
    'nop.wast',
    'select.wast',
    'stack.wast',
    'unwind.wast',

    # Binary module
    'binary.wast',
    'binary-leb128.wast',
    'custom.wast',

    # Empty 'then' or 'else' in 'if'
    'if.wast',
    'local_set.wast',
    'store.wast',

    # No module in a file
    'token.wast',
    'utf8-custom-section-id.wast',
    'utf8-import-field.wast',
    'utf8-import-module.wast',
    'utf8-invalid-encoding.wast',

    # 'register' command
    'imports.wast',
    'linking.wast',

    # Misc. unsupported constructs
    'call_indirect.wast',  # Empty (param) and (result)
    'const.wast',  # Unparenthesized expression
    'data.wast',  # Various unsupported (data) notations
    'elem.wast',  # Unsupported 'offset' syntax in (elem)
    'exports.wast',  # Multiple inlined exports for a function
    'func.wast',  # Forward named type reference
    'skip-stack-guard-page.wast',  # Hexadecimal style (0x..) in memory offset

    # Untriaged: We don't know the cause of the error yet
    'address.wast',  # wasm2js 'assert_return' failure
    'br_if.wast',  # Validation error
    'float_literals.wast',  # 'assert_return' failure
    'int_literals.wast',  # 'assert_return' failure
    'local_tee.wast',  # Validation failure
    'memory_grow.wast',  # 'assert_return' failure
    'start.wast',  # Assertion failure
    'type.wast',  # 'assertion_invalid' failure
    'unreachable.wast',  # Validation failure
    'unreached-invalid.wast'  # 'assert_invalid' failure
]
options.spec_tests = [t for t in options.spec_tests if os.path.basename(t) not
                      in SPEC_TEST_BLACKLIST]


# check utilities


def validate_binary(wasm):
    if V8:
        cmd = [V8] + V8_OPTS + [in_binaryen('scripts', 'validation_shell.js'), '--', wasm]
        print('            ', ' '.join(cmd))
        subprocess.check_call(cmd, stdout=subprocess.PIPE)
    else:
        print('(skipping v8 binary validation)')


def binary_format_check(wast, verify_final_result=True, wasm_as_args=['-g'],
                        binary_suffix='.fromBinary', original_wast=None):
    # checks we can convert the wast to binary and back

    print('         (binary format check)')
    cmd = WASM_AS + [wast, '-o', 'a.wasm', '-all'] + wasm_as_args
    print('            ', ' '.join(cmd))
    if os.path.exists('a.wasm'):
        os.unlink('a.wasm')
    subprocess.check_call(cmd, stdout=subprocess.PIPE)
    assert os.path.exists('a.wasm')

    # make sure it is a valid wasm, using a real wasm VM
    if os.path.basename(original_wast or wast) not in [
        'atomics.wast',    # https://bugs.chromium.org/p/v8/issues/detail?id=9425
        'simd.wast',    # https://bugs.chromium.org/p/v8/issues/detail?id=8460
    ]:
        validate_binary('a.wasm')

    cmd = WASM_DIS + ['a.wasm', '-o', 'ab.wast']
    print('            ', ' '.join(cmd))
    if os.path.exists('ab.wast'):
        os.unlink('ab.wast')
    subprocess.check_call(cmd, stdout=subprocess.PIPE)
    assert os.path.exists('ab.wast')

    # make sure it is a valid wast
    cmd = WASM_OPT + ['ab.wast', '-all']
    print('            ', ' '.join(cmd))
    subprocess.check_call(cmd, stdout=subprocess.PIPE)

    if verify_final_result:
        actual = open('ab.wast').read()
        fail_if_not_identical_to_file(actual, wast + binary_suffix)

    return 'ab.wast'


def minify_check(wast, verify_final_result=True):
    # checks we can parse minified output

    print('     (minify check)')
    cmd = WASM_OPT + [wast, '--print-minified', '-all']
    print('      ', ' '.join(cmd))
    subprocess.check_call(cmd, stdout=open('a.wast', 'w'), stderr=subprocess.PIPE)
    assert os.path.exists('a.wast')
    subprocess.check_call(WASM_OPT + ['a.wast', '--print-minified', '-all'],
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


# run a check with BINARYEN_PASS_DEBUG set, to do full validation
def with_pass_debug(check):
    old_pass_debug = os.environ.get('BINARYEN_PASS_DEBUG')
    try:
        os.environ['BINARYEN_PASS_DEBUG'] = '1'
        check()
    finally:
        if old_pass_debug is not None:
            os.environ['BINARYEN_PASS_DEBUG'] = old_pass_debug
        else:
            if 'BINARYEN_PASS_DEBUG' in os.environ:
                del os.environ['BINARYEN_PASS_DEBUG']
