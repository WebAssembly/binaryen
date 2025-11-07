#!/usr/bin/python3

'''
Run various fuzzing operations on random inputs, using wasm-opt. See
"testcase_handlers" below for the list of fuzzing operations.

Usage:

./scripts/fuzz_opt.py

That will run forever or until it finds a problem.

You can put files in the local directory 'fuzz' (under the top level of the
binaryen repo) and the fuzzer will treat them as important content to fuzz
with high frequency.

Setup: Some tools are optional, like emcc and wasm2c. The v8 shell (d8),
however, is used in various sub-fuzzers and so it is mandatory.

Note: For afl-fuzz integration, you probably don't want this, and can use
something like

BINARYEN_CORES=1 BINARYEN_PASS_DEBUG=1 afl-fuzz -i afl-testcases/ -o afl-findings/ -m 100 -d -- bin/wasm-opt -ttf --fuzz-exec --Os @@

(that is on a fixed set of arguments to wasm-opt, though - this
script covers different options being passed)
'''

import contextlib
import os
import difflib
import json
import math
import shutil
import subprocess
import random
import re
import sys
import tarfile
import time
import traceback
from os.path import abspath

from test import fuzzing
from test import shared
from test import support


assert sys.version_info.major == 3, 'requires Python 3!'

# parameters

# feature options that are always passed to the tools.
# XXX fp16 is not yet stable, remove from here when it is
CONSTANT_FEATURE_OPTS = ['--all-features', '--disable-fp16']

INPUT_SIZE_MIN = 1024
INPUT_SIZE_MEAN = 40 * 1024
INPUT_SIZE_MAX = 5 * INPUT_SIZE_MEAN

PRINT_WATS = False

given_seed = None

CLOSED_WORLD_FLAG = '--closed-world'


# utilities

def in_binaryen(*args):
    return os.path.join(shared.options.binaryen_root, *args)


def in_bin(tool):
    return os.path.join(shared.options.binaryen_bin, tool)


def random_size():
    if random.random() < 0.25:
        # sometimes do an exponential distribution, which prefers smaller sizes but may
        # also get very high
        ret = int(random.expovariate(1.0 / INPUT_SIZE_MEAN))
        # if the result is valid, use it, otherwise do the normal thing
        # (don't clamp, which would give us a lot of values on the borders)
        if ret >= INPUT_SIZE_MIN and ret <= INPUT_SIZE_MAX:
            return ret

    # most of the time do a simple linear range around the mean
    return random.randint(INPUT_SIZE_MIN, 2 * INPUT_SIZE_MEAN - INPUT_SIZE_MIN)


def make_random_input(input_size, raw_input_data):
    with open(raw_input_data, 'wb') as f:
        f.write(bytes([random.randint(0, 255) for x in range(input_size)]))


def run(cmd, stderr=None, silent=False):
    if not silent:
        print(' '.join(cmd))
    return subprocess.check_output(cmd, stderr=stderr, text=True)


def run_unchecked(cmd):
    print(' '.join(cmd))
    return subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True).communicate()[0]


def randomize_pass_debug():
    if random.random() < 0.1:
        print('[pass-debug]')
        os.environ['BINARYEN_PASS_DEBUG'] = '1'
    else:
        os.environ['BINARYEN_PASS_DEBUG'] = '0'
        del os.environ['BINARYEN_PASS_DEBUG']
    print('randomized pass debug:', os.environ.get('BINARYEN_PASS_DEBUG', ''))


@contextlib.contextmanager
def no_pass_debug():
    old_env = os.environ.copy()
    if os.environ.get('BINARYEN_PASS_DEBUG'):
        del os.environ['BINARYEN_PASS_DEBUG']
    try:
        yield
    finally:
        os.environ.update(old_env)


def randomize_feature_opts():
    global FEATURE_OPTS
    FEATURE_OPTS = CONSTANT_FEATURE_OPTS[:]

    if random.random() < 0.1:
        # 10% of the time disable all features, i.e., fuzz the MVP featureset.
        # Fuzzing that is less and less important as more features get enabled
        # by default, but we don't want to lose all coverage for it entirely
        # (and the odds of randomly not selecting any feature, below, is too
        # small - at 17 features it is far less than 1%).
        FEATURE_OPTS += FEATURE_DISABLE_FLAGS
    elif random.random() < 0.333:
        # 1/3 of the remaining 90% pick each feature randomly.
        for possible in FEATURE_DISABLE_FLAGS:
            if random.random() < 0.5:
                FEATURE_OPTS.append(possible)
                if possible in IMPLIED_FEATURE_OPTS:
                    FEATURE_OPTS.extend(IMPLIED_FEATURE_OPTS[possible])
    else:
        # 2/3 of the remaining 90% use them all. This is useful to maximize
        # coverage, as enabling more features enables more optimizations and
        # code paths, and also allows all initial contents to run.

        # The shared-everything feature is new and we want to fuzz it, but it
        # also currently disables fuzzing V8, so disable it most of the time.
        # Same with strings. Relaxed SIMD's nondeterminism disables much but not
        # all of our V8 fuzzing, so avoid it too. Stack Switching, as well, is
        # not yet ready in V8.
        if random.random() < 0.9:
            FEATURE_OPTS.append('--disable-shared-everything')
            FEATURE_OPTS.append('--disable-strings')
            FEATURE_OPTS.append('--disable-relaxed-simd')
            FEATURE_OPTS.append('--disable-stack-switching')

    print('randomized feature opts:', '\n  ' + '\n  '.join(FEATURE_OPTS))

    # Pick closed or open with equal probability as both matter.
    #
    # Closed world is not a feature flag, technically, since it only makes sense
    # to pass to wasm-opt (and not other tools). But decide on whether we'll
    # be fuzzing in that mode now, as it determinies how we set other things up.
    global CLOSED_WORLD
    CLOSED_WORLD = random.random() < 0.5


ALL_FEATURE_OPTS = ['--all-features', '-all', '--mvp-features', '-mvp']


def update_feature_opts(wasm):
    global FEATURE_OPTS
    # we will re-compute the features; leave all other things as they are
    EXTRA = [x for x in FEATURE_OPTS if not x.startswith('--enable') and
             not x.startswith('--disable') and x not in ALL_FEATURE_OPTS]
    FEATURE_OPTS = run([in_bin('wasm-opt'), wasm] + FEATURE_OPTS + ['--print-features']).strip().split('\n')
    # filter out '', which can happen if no features are enabled
    FEATURE_OPTS = [x for x in FEATURE_OPTS if x]
    print(FEATURE_OPTS, EXTRA)
    FEATURE_OPTS += EXTRA


def randomize_fuzz_settings():
    # a list of the arguments to pass to wasm-opt -ttf when generating the wasm
    global GEN_ARGS
    GEN_ARGS = []

    # a list of the optimizations to run on the wasm
    global FUZZ_OPTS
    FUZZ_OPTS = []

    # a boolean whether NaN values are allowed, or we de-NaN them
    global NANS

    # a boolean whether out of bounds operations are allowed, or we bounds-enforce them
    global OOB

    # a boolean whether we legalize the wasm for JS
    global LEGALIZE

    if random.random() < 0.5:
        NANS = True
    else:
        NANS = False
        GEN_ARGS += ['--denan']
    if random.random() < 0.5:
        OOB = True
    else:
        OOB = False
        GEN_ARGS += ['--no-fuzz-oob']
    if random.random() < 0.5:
        LEGALIZE = True
        GEN_ARGS += ['--legalize-and-prune-js-interface']
    else:
        LEGALIZE = False

    # if GC is enabled then run --dce at the very end, to ensure that our
    # binaries validate in other VMs, due to how non-nullable local validation
    # and unreachable code interact. see
    #   https://github.com/WebAssembly/binaryen/pull/5665
    #   https://github.com/WebAssembly/binaryen/issues/5599
    if '--disable-gc' not in FEATURE_OPTS:
        GEN_ARGS += ['--dce']

        # Add --dce not only when generating the original wasm but to the
        # optimizations we use to create any other wasm file.
        FUZZ_OPTS += ['--dce']

    if CLOSED_WORLD:
        GEN_ARGS += [CLOSED_WORLD_FLAG]
        # Enclose the world much of the time when fuzzing closed-world, so that
        # many types are private and hence optimizable.
        if random.random() < 0.5:
            GEN_ARGS += ['--enclose-world']

    # Test JSPI somewhat rarely, as it may be slower.
    global JSPI
    JSPI = random.random() < 0.25

    print('randomized settings (NaNs, OOB, legalize, JSPI):', NANS, OOB, LEGALIZE, JSPI)


def init_important_initial_contents():
    # Fuzz dir contents are always important to us.
    fuzz_dir = os.path.join(shared.options.binaryen_root, 'fuzz')
    fuzz_cases = shared.get_tests(fuzz_dir, shared.test_suffixes, recursive=True)
    FIXED_IMPORTANT_INITIAL_CONTENTS = fuzz_cases

    # If auto_initial_contents is set we'll also grab all test files that are
    # recent.
    RECENT_DAYS = 30

    # Returns the list of test wast/wat files added or modified within the
    # RECENT_DAYS number of days counting from the commit time of HEAD
    def auto_select_recent_initial_contents():
        # Print 'git log' with changed file status and without commit messages,
        # with commits within RECENT_DAYS number of days, counting from the
        # commit time of HEAD. The reason we use the commit time of HEAD instead
        # of the current system time is to make the results deterministic given
        # the Binaryen HEAD commit.
        from datetime import datetime, timedelta, timezone
        head_ts_str = run(['git', 'log', '-1', '--format=%cd', '--date=raw'],
                          silent=True).split()[0]
        head_dt = datetime.utcfromtimestamp(int(head_ts_str))
        start_dt = head_dt - timedelta(days=RECENT_DAYS)
        start_ts = start_dt.replace(tzinfo=timezone.utc).timestamp()
        log = run(['git', 'log', '--name-status', '--format=', '--date=raw', '--no-renames', f'--since={start_ts}'], silent=True).splitlines()
        # Pick up lines in the form of
        # A       test/../something.wast
        # M       test/../something.wast
        # (wat extension is also included)
        p = re.compile(r'^[AM]\stest' + os.sep + r'(.*\.(wat|wast))$')
        matches = [p.match(e) for e in log]
        auto_set = set([match.group(1) for match in matches if match])
        auto_set = auto_set.difference(set(FIXED_IMPORTANT_INITIAL_CONTENTS))
        return sorted(list(auto_set))

    def is_git_repo():
        try:
            ret = run(['git', 'rev-parse', '--is-inside-work-tree'],
                      silent=True, stderr=subprocess.DEVNULL)
            return ret == 'true\n'
        except subprocess.CalledProcessError:
            return False

    if not is_git_repo() and shared.options.auto_initial_contents:
        print('Warning: The current directory is not a git repository, ' +
              'so not automatically selecting initial contents.')
        shared.options.auto_initial_contents = False

    print('- Important provided initial contents:')
    for test in FIXED_IMPORTANT_INITIAL_CONTENTS:
        print('  ' + test)
    print()

    recent_contents = []
    print('- Recently added or modified initial contents ', end='')
    if shared.options.auto_initial_contents:
        print(f'(automatically selected: within last {RECENT_DAYS} days):')
        recent_contents += auto_select_recent_initial_contents()
    for test in recent_contents:
        print('  ' + test)
    print()

    initial_contents = FIXED_IMPORTANT_INITIAL_CONTENTS + recent_contents
    global IMPORTANT_INITIAL_CONTENTS
    IMPORTANT_INITIAL_CONTENTS = [os.path.join(shared.get_test_dir('.'), t) for t in initial_contents]


all_tests = shared.get_all_tests()


def pick_initial_contents():
    # if we use an initial wasm file's contents as the basis for the
    # fuzzing, then that filename, or None if we start entirely from scratch
    global INITIAL_CONTENTS

    INITIAL_CONTENTS = None
    # half the time don't use any initial contents
    if random.random() < 0.5:
        return
    # some of the time use initial contents that are known to be especially
    # important
    if IMPORTANT_INITIAL_CONTENTS and random.random() < 0.5:
        test_name = random.choice(IMPORTANT_INITIAL_CONTENTS)
    else:
        test_name = random.choice(all_tests)
    print('initial contents:', test_name)
    if shared.options.auto_initial_contents:
        # when using auto initial contents, we look through the git history to
        # find test files. if a test file was renamed or removed then it may
        # no longer exist, and we should just skip it.
        if not os.path.exists(test_name):
            return
    if not fuzzing.is_fuzzable(test_name):
        return
    assert os.path.exists(test_name)

    if test_name.endswith('.wast'):
        # this can contain multiple modules, pick one
        split_parts = support.split_wast(test_name)
        if len(split_parts) > 1:
            index = random.randint(0, len(split_parts) - 1)
            chosen = split_parts[index]
            module, asserts = chosen
            if not module:
                # there is no module in this choice (just asserts), ignore it
                print('initial contents has no module')
                return
            test_name = abspath('initial.wat')
            with open(test_name, 'w') as f:
                f.write(module)
            print('  picked submodule %d from multi-module wast' % index)

    global FEATURE_OPTS
    FEATURE_OPTS += [
        # avoid multivalue for now due to bad interactions with gc non-nullable
        # locals in stacky code. for example, this fails to roundtrip as the
        # tuple code ends up creating stacky binary code that needs to spill
        # non-nullable references to locals, which is not allowed:
        #
        # (module
        #  (type $other (struct))
        #  (func $foo (result (ref $other))
        #   (select
        #    (struct.new $other)
        #    (struct.new $other)
        #    (tuple.extract 2 1
        #     (tuple.make 2
        #      (i32.const 0)
        #      (i32.const 0)
        #     )
        #    )
        #   )
        #  )
        # )
        '--disable-multivalue',
    ]

    # the given wasm may not work with the chosen feature opts. for example, if
    # we pick atomics.wast but want to run with --disable-atomics, then we'd
    # error, so we need to test the wasm. first, make sure it doesn't have a
    # features section, as that would enable a feature that we might want to
    # be disabled, and our test would not error as we want it to.
    if test_name.endswith('.wasm'):
        temp_test_name = 'initial.wasm'
        try:
            run([in_bin('wasm-opt'), test_name, '-all', '--strip-target-features',
                 '-o', temp_test_name])
        except Exception:
            # the input can be invalid if e.g. it is raw data that is used with
            # -ttf as fuzzer input
            print('(initial contents are not valid wasm, ignoring)')
            return
        test_name = temp_test_name

    # Next, test the wasm. Note that we must check for closed world explicitly
    # here, as a testcase may only work in an open world, which means we need to
    # skip it.
    args = FEATURE_OPTS
    if CLOSED_WORLD:
        args.append(CLOSED_WORLD_FLAG)
    try:
        run([in_bin('wasm-opt'), test_name] + args,
            stderr=subprocess.PIPE,
            silent=True)
    except Exception:
        print('(initial contents not valid for features, ignoring)')
        return

    INITIAL_CONTENTS = test_name


# Test outputs we want to ignore are marked this way.
IGNORE = '[binaryen-fuzzer-ignore]'

# Traps are reported as [trap REASON]
TRAP_PREFIX = '[trap '

# Host limits are reported as [host limit REASON]
HOST_LIMIT_PREFIX = '[host limit '

# --fuzz-exec reports calls as [fuzz-exec] calling foo
FUZZ_EXEC_CALL_PREFIX = '[fuzz-exec] calling'

# --fuzz-exec reports a stack limit using this notation
STACK_LIMIT = '[trap stack limit]'

# V8 reports this error in rare cases due to limitations in our handling of non-
# nullable locals in unreachable code, see
#   https://github.com/WebAssembly/binaryen/pull/5665
#   https://github.com/WebAssembly/binaryen/issues/5599
# and also see the --dce workaround below that also links to those issues.
V8_UNINITIALIZED_NONDEF_LOCAL = 'uninitialized non-defaultable local'

# JS exceptions are logged as exception thrown: REASON
EXCEPTION_PREFIX = 'exception thrown: '


# given a call line that includes FUZZ_EXEC_CALL_PREFIX, return the export that
# is called
def get_export_from_call_line(call_line):
    assert FUZZ_EXEC_CALL_PREFIX in call_line
    return call_line.split(FUZZ_EXEC_CALL_PREFIX)[1].strip()


# compare two strings, strictly
def compare(x, y, context, verbose=True):
    if x != y and x != IGNORE and y != IGNORE:
        message = ''.join([a + '\n' for a in difflib.unified_diff(x.splitlines(), y.splitlines(), fromfile='expected', tofile='actual')])
        if verbose:
            raise Exception(context + " comparison error, expected to have '%s' == '%s', diff:\n\n%s" % (
                x, y,
                message
            ))
        else:
            raise Exception(context + "\nDiff:\n\n%s" % (message))


# converts a possibly-signed integer to an unsigned integer
def unsign(x, bits):
    return x & ((1 << bits) - 1)


# numbers are "close enough" if they just differ in printing, as different
# vms may print at different precision levels and verbosity
def numbers_are_close_enough(x, y):
    # handle nan comparisons like -nan:0x7ffff0 vs NaN, ignoring the bits
    if 'nan' in x.lower() and 'nan' in y.lower():
        return True
    # if one input is a pair, then it is in fact a 64-bit integer that is
    # reported as two 32-bit chunks. convert such 'low high' pairs into a 64-bit
    # integer for comparison to the other value
    if ' ' in x or ' ' in y:
        def to_64_bit(a):
            if ' ' not in a:
                return unsign(int(a), bits=64)
            low, high = a.split(' ')
            return unsign(int(low), 32) + (1 << 32) * unsign(int(high), 32)

        return to_64_bit(x) == to_64_bit(y)
    # float() on the strings will handle many minor differences, like
    # float('1.0') == float('1') , float('inf') == float('Infinity'), etc.
    try:
        return float(x) == float(y)
    except Exception:
        pass
    # otherwise, try a full eval which can handle i64s too
    try:
        ex = eval(x)
        ey = eval(y)
        return ex == ey or float(ex) == float(ey)
    except Exception as e:
        print('failed to check if numbers are close enough:', e)
        return False


FUZZ_EXEC_NOTE_RESULT = '[fuzz-exec] note result'


# compare between vms, which may slightly change how numbers are printed
def compare_between_vms(x, y, context):
    x_lines = x.splitlines()
    y_lines = y.splitlines()
    if len(x_lines) != len(y_lines):
        return compare(x, y, context + ' (note: different number of lines between vms)')

    num_lines = len(x_lines)
    for i in range(num_lines):
        x_line = x_lines[i]
        y_line = y_lines[i]
        if x_line != y_line:
            # this is different, but maybe it's a vm difference we can ignore
            LOGGING_PREFIX = '[LoggingExternalInterface logging'
            if x_line.startswith(LOGGING_PREFIX) and y_line.startswith(LOGGING_PREFIX):
                x_val = x_line[len(LOGGING_PREFIX) + 1:-1]
                y_val = y_line[len(LOGGING_PREFIX) + 1:-1]
                if numbers_are_close_enough(x_val, y_val):
                    continue
            if x_line.startswith(FUZZ_EXEC_NOTE_RESULT) and y_line.startswith(FUZZ_EXEC_NOTE_RESULT):
                x_val = x_line.split(' ')[-1]
                y_val = y_line.split(' ')[-1]
                if numbers_are_close_enough(x_val, y_val):
                    continue

            # this failed to compare. print a custom diff of the relevant lines
            MARGIN = 3
            start = max(i - MARGIN, 0)
            end = min(i + MARGIN, num_lines)
            return compare('\n'.join(x_lines[start:end]), '\n'.join(y_lines[start:end]), context)


def fix_output(out):
    # large doubles may print slightly different on different VMs
    def fix_double(x):
        x = x.group(1)
        if 'nan' in x or 'NaN' in x:
            x = 'nan'
        else:
            x = x.replace('Infinity', 'inf')
            x = str(float(x))
        return 'f64.const ' + x
    out = re.sub(r'f64\.const (-?[nanN:abcdefxIity\d+-.]+)', fix_double, out)

    # mark traps from wasm-opt as exceptions, even though they didn't run in a vm
    out = out.replace(TRAP_PREFIX, EXCEPTION_PREFIX + TRAP_PREFIX)

    # funcref(0) has the index of the function in it, and optimizations can
    # change that index, so ignore it
    out = re.sub(r'funcref\([\d\w$+-_:]+\)', 'funcref()', out)

    # JS prints i31 as just a number, so change "i31ref(N)" (which C++ emits)
    # to "N".
    out = re.sub(r'i31ref\((-?\d+)\)', r'\1', out)

    # Tag names may change due to opts, so canonicalize them.
    out = re.sub(r' tag\$\d+', ' tag', out)

    lines = out.splitlines()
    for i in range(len(lines)):
        line = lines[i]
        if 'Warning: unknown flag' in line or 'Try --help for options' in line:
            # ignore some VM warnings that don't matter, like if a newer V8 has
            # removed a flag that is no longer needed. but print the line so the
            # developer can see it.
            print(line)
            lines[i] = None
        elif EXCEPTION_PREFIX in line:
            # exceptions may differ when optimizing, but an exception should
            # occur, so ignore their types (also js engines print them out
            # slightly differently)
            lines[i] = '     *exception*'
    return '\n'.join([line for line in lines if line is not None])


def fix_spec_output(out):
    out = fix_output(out)
    # spec shows a pointer when it traps, remove that
    out = '\n'.join(map(lambda x: x if 'runtime trap' not in x else x[x.find('runtime trap'):], out.splitlines()))
    # https://github.com/WebAssembly/spec/issues/543 , float consts are messed up
    out = '\n'.join(map(lambda x: x if 'f32' not in x and 'f64' not in x else '', out.splitlines()))
    return out


ignored_vm_runs = 0
ignored_vm_run_reasons = dict()


# Notes a VM run that we ignore, and the reason for it (for metrics purposes).
# Extra text can also be printed that is not included in the metrics.
def note_ignored_vm_run(reason, extra_text='', amount=1):
    global ignored_vm_runs
    print(f'(ignore VM run: {reason}{extra_text})')
    ignored_vm_runs += amount
    ignored_vm_run_reasons.setdefault(reason, 0)
    ignored_vm_run_reasons[reason] += amount


# Run a VM command, and filter out known issues.
def run_vm(cmd):
    def filter_known_issues(output):
        known_issues = [
            # can be caused by flatten, ssa, etc. passes
            'local count too large',
            # can be caused by (array.new $type -1) etc.
            'requested new array is too large',
            # https://github.com/WebAssembly/binaryen/issues/3767
            # note that this text is a little too broad, but the problem is rare
            # enough that it's unlikely to hide an unrelated issue
            'found br_if of type',
            # this text is emitted from V8 when it runs out of memory during a
            # GC allocation.
            'out of memory',
            # if the call stack is exceeded we must ignore this, as
            # optimizations can change whether this happens or not (e.g. by
            # removing locals, which makes stack frames smaller), which is
            # noticeable.
            'Maximum call stack size exceeded',
            # all host limitations are arbitrary and may differ between VMs and
            # also be affected by optimizations, so ignore them.
            # this is the prefix that the binaryen interpreter emits. For V8,
            # there is no single host-limit signal, and we have the earlier
            # strings in this list for known issues (to which more need to be
            # added as necessary).
            HOST_LIMIT_PREFIX,
            # see comment above on this constant
            V8_UNINITIALIZED_NONDEF_LOCAL,
            # V8 does not accept nullable stringviews
            # (https://github.com/WebAssembly/binaryen/pull/6574)
            'expected (ref stringview_wtf16), got nullref',
            'expected type (ref stringview_wtf16), found ref.null of type nullref',
            # wasm64 memories have a V8 limit
            'larger than implementation limit',
        ]
        for issue in known_issues:
            if issue in output:
                note_ignored_vm_run(issue)
                return IGNORE
        return output

    try:
        # some known issues do not cause the entire process to fail
        return filter_known_issues(run(cmd))
    except subprocess.CalledProcessError:
        # other known issues do make it fail, so re-run without checking for
        # success and see if we should ignore it
        if filter_known_issues(run_unchecked(cmd)) == IGNORE:
            return IGNORE
        raise


MAX_INTERPRETER_ENV_VAR = 'BINARYEN_MAX_INTERPRETER_DEPTH'
MAX_INTERPRETER_DEPTH = 1000


def run_bynterp(wasm, args):
    # increase the interpreter stack depth, to test more things
    os.environ[MAX_INTERPRETER_ENV_VAR] = str(MAX_INTERPRETER_DEPTH)
    try:
        return run_vm([in_bin('wasm-opt'), wasm] + FEATURE_OPTS + args)
    finally:
        del os.environ['BINARYEN_MAX_INTERPRETER_DEPTH']


# Enable even more things than V8_OPTS. V8_OPTS are the flags we want to use
# when testing, on our fixed test suite, but when fuzzing we may want more.
def get_v8_extra_flags():
    # It is important to use the --fuzzing flag because it does things like
    # enable mixed old and new EH (which is an issue since
    # https://github.com/WebAssembly/exception-handling/issues/344 )
    flags = ['--fuzzing']

    # Sometimes add --future, which may enable new JITs and such, which is good
    # to fuzz for V8's sake.
    if random.random() < 0.5:
        flags += ['--future']

    # Sometimes add V8's type assertions.
    if random.random() < 0.5:
        flags += ['--wasm-assert-types']

    return flags


V8_LIFTOFF_ARGS = ['--liftoff']


# Default to running with liftoff enabled, because we need to pick either
# liftoff or turbo* for consistency (otherwise running the same command twice
# may have different results due to NaN nondeterminism), and liftoff is faster
# for small things.
def run_d8_js(js, args=[], liftoff=True):
    cmd = [shared.V8] + shared.V8_OPTS
    cmd += get_v8_extra_flags()
    if liftoff:
        cmd += V8_LIFTOFF_ARGS
    cmd += [js]
    if args:
        cmd += ['--'] + args
    return run_vm(cmd)


# For JSPI, we must customize fuzz_shell.js. We do so the first time we need
# it, and save the filename here.
JSPI_JS_FILE = None


def get_fuzz_shell_js():
    js = in_binaryen('scripts', 'fuzz_shell.js')

    if not JSPI:
        # Just use the normal fuzz shell script.
        return js

    global JSPI_JS_FILE
    if JSPI_JS_FILE:
        # Use the customized file we've already created.
        return JSPI_JS_FILE

    JSPI_JS_FILE = os.path.abspath('jspi_fuzz_shell.js')
    with open(JSPI_JS_FILE, 'w') as f:
        # Enable JSPI.
        f.write('var JSPI = 1;\n\n')

        # Un-comment the async and await keywords.
        with open(js) as g:
            code = g.read()
        code = code.replace('/* async */', 'async')
        code = code.replace('/* await */', 'await')
        f.write(code)
    return JSPI_JS_FILE


def run_d8_wasm(wasm, liftoff=True, args=[]):
    return run_d8_js(get_fuzz_shell_js(), [wasm] + args, liftoff=liftoff)


def all_disallowed(features):
    return not any(('--enable-' + x) in FEATURE_OPTS for x in features)


class TestCaseHandler:
    # how frequent this handler will be run. 1 means always run it, 0.5 means half the
    # time
    frequency = 1

    def __init__(self):
        self.num_runs = 0

    # If the core handle_pair() method is not overridden, it calls handle() on
    # each of the items. That is useful if you just want the two wasms and don't
    # care about their relationship.
    def handle_pair(self, input, before_wasm, after_wasm, opts):
        self.handle(before_wasm)
        # Add some visual space between the independent parts.
        print('\n')
        self.handle(after_wasm)

    def can_run_on_wasm(self, wasm):
        return True

    def increment_runs(self):
        self.num_runs += 1

    def count_runs(self):
        return self.num_runs


# Fuzz the interpreter with --fuzz-exec.
class FuzzExec(TestCaseHandler):
    frequency = 1

    def handle_pair(self, input, before_wasm, after_wasm, opts):
        run([in_bin('wasm-opt'), before_wasm] + opts + ['--fuzz-exec'])


class CompareVMs(TestCaseHandler):
    frequency = 1

    def __init__(self):
        super(CompareVMs, self).__init__()

        class BinaryenInterpreter:
            name = 'binaryen interpreter'

            def run(self, wasm):
                output = run_bynterp(wasm, ['--fuzz-exec-before'])
                if output != IGNORE:
                    calls = output.count(FUZZ_EXEC_CALL_PREFIX)
                    errors = output.count(TRAP_PREFIX) + output.count(HOST_LIMIT_PREFIX)
                    if errors > calls / 2:
                        # A significant amount of execution on this testcase
                        # simply trapped, and was not very useful, so mark it
                        # as ignored. Ideally the fuzzer testcases would be
                        # improved to reduce this number.
                        #
                        # Note that we don't change output=IGNORE as there may
                        # still be useful testing here (up to 50%), so we only
                        # note that this is a mostly-ignored run, but we do not
                        # ignore the parts that are useful.
                        #
                        # Note that we set amount to 0.5 because we are run both
                        # on the before wasm and the after wasm. Those will be
                        # in sync (because the optimizer does not remove traps)
                        # and so by setting 0.5 we only increment by 1 for the
                        # entire iteration.
                        note_ignored_vm_run('too many errors vs calls',
                                            extra_text=f' ({calls} calls, {errors} errors)',
                                            amount=0.5)
                return output

            def can_run(self, wasm):
                return True

            def can_compare_to_self(self):
                return True

            def can_compare_to_other(self, other):
                return True

        class D8:
            name = 'd8'

            def run(self, wasm, extra_d8_flags=[]):
                return run_vm([shared.V8, get_fuzz_shell_js()] + shared.V8_OPTS + get_v8_extra_flags() + extra_d8_flags + ['--', wasm])

            def can_run(self, wasm):
                # V8 does not support shared memories when running with
                # shared-everything enabled, so do not fuzz shared-everything
                # for now. It also does not yet support strings, nor stack
                # switching
                return all_disallowed(['shared-everything', 'strings', 'stack-switching'])

            def can_compare_to_self(self):
                # With nans, VM differences can confuse us, so only very simple VMs
                # can compare to themselves after opts in that case.
                return not NANS

            def can_compare_to_other(self, other):
                # Relaxed SIMD allows different behavior between VMs, so only
                # allow comparisons to other d8 variants if it is enabled.
                if not all_disallowed(['relaxed-simd']) and not other.name.startswith('d8'):
                    return False

                # If not legalized, the JS will fail immediately, so no point to
                # compare to others.
                return self.can_compare_to_self() and LEGALIZE

        class D8Liftoff(D8):
            name = 'd8_liftoff'

            def run(self, wasm):
                return super(D8Liftoff, self).run(wasm, extra_d8_flags=V8_LIFTOFF_ARGS)

        class D8Turboshaft(D8):
            name = 'd8_turboshaft'

            def run(self, wasm):
                flags = ['--no-liftoff']
                if random.random() < 0.5:
                    flags += ['--no-wasm-generic-wrapper']
                return super(D8Turboshaft, self).run(wasm, extra_d8_flags=flags)

        class Wasm2C:
            name = 'wasm2c'

            def __init__(self):
                # look for wabt in the path. if it's not here, don't run wasm2c
                try:
                    wabt_bin = shared.which('wasm2c')
                    wabt_root = os.path.dirname(os.path.dirname(wabt_bin))
                    self.wasm2c_dir = os.path.join(wabt_root, 'wasm2c')
                    if not os.path.isdir(self.wasm2c_dir):
                        print('wabt found, but not wasm2c support dir')
                        self.wasm2c_dir = None
                except Exception as e:
                    print('warning: no wabt found:', e)
                    self.wasm2c_dir = None

            def can_run(self, wasm):
                if self.wasm2c_dir is None:
                    return False
                # if we legalize for JS, the ABI is not what C wants
                if LEGALIZE:
                    return False
                # relatively slow, so run it less frequently
                if random.random() < 0.5:
                    return False
                # wasm2c doesn't support most features
                return all_disallowed(['exception-handling', 'simd', 'threads', 'bulk-memory', 'nontrapping-float-to-int', 'tail-call', 'sign-ext', 'reference-types', 'multivalue', 'gc', 'custom-descriptors'])

            def run(self, wasm):
                run([in_bin('wasm-opt'), wasm, '--emit-wasm2c-wrapper=main.c'] + FEATURE_OPTS)
                run(['wasm2c', wasm, '-o', 'wasm.c'])
                compile_cmd = ['clang', 'main.c', 'wasm.c', os.path.join(self.wasm2c_dir, 'wasm-rt-impl.c'), '-I' + self.wasm2c_dir, '-lm', '-Werror']
                run(compile_cmd)
                return run_vm(['./a.out'])

            def can_compare_to_self(self):
                # The binaryen optimizer changes NaNs in the ways that wasm
                # expects, but that's not quite what C has
                return not NANS

            def can_compare_to_other(self, other):
                # C won't trap on OOB, and NaNs can differ from wasm VMs
                return not OOB and not NANS

        class Wasm2C2Wasm(Wasm2C):
            name = 'wasm2c2wasm'

            def __init__(self):
                super(Wasm2C2Wasm, self).__init__()

                self.has_emcc = shared.which('emcc') is not None

            def run(self, wasm):
                run([in_bin('wasm-opt'), wasm, '--emit-wasm2c-wrapper=main.c'] + FEATURE_OPTS)
                run(['wasm2c', wasm, '-o', 'wasm.c'])
                compile_cmd = ['emcc', 'main.c', 'wasm.c',
                               os.path.join(self.wasm2c_dir, 'wasm-rt-impl.c'),
                               '-I' + self.wasm2c_dir,
                               '-lm',
                               '-s', 'ENVIRONMENT=shell',
                               '-s', 'ALLOW_MEMORY_GROWTH']
                # disable the signal handler: emcc looks like unix, but wasm has
                # no signals
                compile_cmd += ['-DWASM_RT_MEMCHECK_SIGNAL_HANDLER=0']
                if random.random() < 0.5:
                    compile_cmd += ['-O' + str(random.randint(1, 3))]
                elif random.random() < 0.5:
                    if random.random() < 0.5:
                        compile_cmd += ['-Os']
                    else:
                        compile_cmd += ['-Oz']
                # avoid pass-debug on the emcc invocation itself (which runs
                # binaryen to optimize the wasm), as the wasm here can be very
                # large and it isn't what we are focused on testing here
                with no_pass_debug():
                    run(compile_cmd)
                return run_d8_js(abspath('a.out.js'))

            def can_run(self, wasm):
                # quite slow (more steps), so run it less frequently
                if random.random() < 0.8:
                    return False
                # prefer not to run if the wasm is very large, as it can OOM
                # the JS engine.
                return super(Wasm2C2Wasm, self).can_run(wasm) and self.has_emcc and \
                    os.path.getsize(wasm) <= INPUT_SIZE_MEAN

            def can_compare_to_other(self, other):
                # NaNs can differ from wasm VMs
                return not NANS

        # the binaryen interpreter is specifically useful for various things
        self.bynterpreter = BinaryenInterpreter()

        self.vms = [self.bynterpreter,
                    D8(),
                    D8Liftoff(),
                    D8Turboshaft(),
                    # FIXME: Temprorary disable. See issue #4741 for more details
                    # Wasm2C(),
                    # Wasm2C2Wasm()
                    ]

    def handle_pair(self, input, before_wasm, after_wasm, opts):
        global ignored_vm_runs

        before = self.run_vms(before_wasm)

        after = self.run_vms(after_wasm)
        self.compare_before_and_after(before, after)

    def run_vms(self, wasm):
        ignored_before = ignored_vm_runs

        # vm_results will map vms to their results
        relevant_vms = []
        vm_results = {}
        for vm in self.vms:
            if vm.can_run(wasm):
                print(f'[CompareVMs] running {vm.name}')
                relevant_vms.append(vm)
                vm_results[vm] = fix_output(vm.run(wasm))

                # If the binaryen interpreter hit a host limitation then do not
                # run other VMs, as that is risky: the host limitation may be an
                # an OOM which could be very costly (lots of swapping, and the
                # OOM may change after opts that remove allocations etc.), or it
                # might be an atomic wait which other VMs implement fully (and
                # the wait might be very long). In general host limitations
                # should be rare (which can be verified by looking at the
                # details of how many things we ended up ignoring), and when we
                # see one we are in a situation that we can't fuzz properly.
                if vm == self.bynterpreter and vm_results[vm] == IGNORE:
                    print('(ignored, so not running other VMs)')

                    # the ignoring should have been noted during run_vms()
                    assert ignored_vm_runs > ignored_before

                    return vm_results

        # compare between the vms on this specific input
        num_vms = len(relevant_vms)
        for i in range(0, num_vms):
            for j in range(i + 1, num_vms):
                vm1 = relevant_vms[i]
                vm2 = relevant_vms[j]
                if vm1.can_compare_to_other(vm2) and vm2.can_compare_to_other(vm1):
                    compare_between_vms(vm_results[vm1], vm_results[vm2], 'CompareVMs between VMs: ' + vm1.name + ' and ' + vm2.name)

        return vm_results

    def compare_before_and_after(self, before, after):
        # compare each VM to itself on the before and after inputs
        for vm in before.keys():
            if vm in after and vm.can_compare_to_self():
                compare(before[vm], after[vm], 'CompareVMs between before and after: ' + vm.name)


# Check for determinism - the same command must have the same output.
class CheckDeterminism(TestCaseHandler):
    frequency = 0.2

    def handle_pair(self, input, before_wasm, after_wasm, opts):
        # check for determinism
        run([in_bin('wasm-opt'), before_wasm, '-o', abspath('b1.wasm')] + opts)
        run([in_bin('wasm-opt'), before_wasm, '-o', abspath('b2.wasm')] + opts)
        b1 = open('b1.wasm', 'rb').read()
        b2 = open('b2.wasm', 'rb').read()
        if (b1 != b2):
            run([in_bin('wasm-dis'), abspath('b1.wasm'), '-o', abspath('b1.wat')] + FEATURE_OPTS)
            run([in_bin('wasm-dis'), abspath('b2.wasm'), '-o', abspath('b2.wat')] + FEATURE_OPTS)
            t1 = open(abspath('b1.wat'), 'r').read()
            t2 = open(abspath('b2.wat'), 'r').read()
            compare(t1, t2, 'Output must be deterministic.', verbose=False)


class Wasm2JS(TestCaseHandler):
    frequency = 0.1

    def handle_pair(self, input, before_wasm, after_wasm, opts):
        before_wasm_temp = before_wasm + '.temp.wasm'
        after_wasm_temp = after_wasm + '.temp.wasm'
        # legalize the before wasm, so that comparisons to the interpreter
        # later make sense (if we don't do this, the wasm may have i64 exports).
        # after applying other necessary fixes, we'll recreate the after wasm
        # from scratch.
        run([in_bin('wasm-opt'), before_wasm, '--legalize-and-prune-js-interface', '-o', before_wasm_temp] + FEATURE_OPTS)
        compare_before_to_after = random.random() < 0.5
        compare_to_interpreter = compare_before_to_after and random.random() < 0.5
        if compare_before_to_after:
            # to compare the wasm before and after optimizations, we must
            # remove operations that wasm2js does not support with full
            # precision, such as i64-to-f32, as the optimizer can give different
            # results.
            simplification_passes = ['--stub-unsupported-js']
            if compare_to_interpreter:
                # unexpectedly-unaligned loads/stores work fine in wasm in general but
                # not in wasm2js, since typed arrays silently round down, effectively.
                # if we want to compare to the interpreter, remove unaligned
                # operations (by forcing alignment 1, then lowering those into aligned
                # components, which means all loads and stores are of a single byte).
                simplification_passes += ['--dealign', '--alignment-lowering']
            run([in_bin('wasm-opt'), before_wasm_temp, '-o', before_wasm_temp] + simplification_passes + FEATURE_OPTS)
        # now that the before wasm is fixed up, generate a proper after wasm
        run([in_bin('wasm-opt'), before_wasm_temp, '-o', after_wasm_temp] + opts + FEATURE_OPTS)
        # always check for compiler crashes
        before = self.run(before_wasm_temp)
        after = self.run(after_wasm_temp)
        if NANS:
            # with NaNs we can't compare the output, as a reinterpret through
            # memory might end up different in JS than wasm
            return

        def fix_output_for_js(x):
            # start with the normal output fixes that all VMs need
            x = fix_output(x)

            # replace null with 0. the fuzzing harness passes in nulls instead
            # the specific type of a parameter (since null can be cast to
            # anything without issue, and all fuzz_shell.js knows on the JS side
            # is the number of parameters), which can be noticeable in a
            # situation where we optimize and remove casts, like here:
            #
            # function foo(x) { return x | 0; }
            #
            # When optimizing we can remove that | 0, which is valid if the
            # input is valid, but as we said, the fuzz harness passes in a value
            # of the wrong type - which would be cast on use, but if we remove
            # the casts, we end up returning null here and not 0, which the
            # fuzzer can notice.
            x = re.sub(r' null', ' 0', x)

            # wasm2js converts exports to valid JS forms, which affects some of
            # the names in the test suite. Fix those up.
            x = x.replace('log-', 'log_')
            x = x.replace('call-', 'call_')
            x = x.replace('export-', 'export_')

            # check if a number is 0 or a subnormal, which is basically zero
            def is_basically_zero(x):
                # to check if something is a subnormal, compare it to the largest one
                return x >= 0 and x <= 2.22507385850720088902e-308

            def fix_number(x):
                x = x.group(1)
                try:
                    x = float(x)
                    # There appear to be some cases where JS VMs will print
                    # subnormals in full detail while other VMs do not, and vice
                    # versa. Ignore such really tiny numbers.
                    if is_basically_zero(x):
                        x = 0
                except ValueError:
                    # not a floating-point number, nothing to do
                    pass
                return ' => ' + str(x)

            # logging notation is "function_name => result", look for that with
            # a floating-point result that may need to be fixed up
            return re.sub(r' => (-?[\d+-.e\-+]+)', fix_number, x)

        before = fix_output_for_js(before)
        after = fix_output_for_js(after)

        # we must not compare if the wasm hits a trap, as wasm2js does not
        # trap on many things wasm would, and in those cases it can do weird
        # undefined things. in such a case, at least compare up until before
        # the trap, which lets us compare at least some results in some cases.
        # (this is why wasm2js is not in CompareVMs, which does full
        # comparisons - we need to limit the comparison in a special way here)
        interpreter = run_bynterp(before_wasm_temp, ['--fuzz-exec-before'])
        if TRAP_PREFIX in interpreter:
            trap_index = interpreter.index(TRAP_PREFIX)
            # we can't test this function, which the trap is in the middle of.
            # erase everything from this function's output and onward, so we
            # only compare the previous trap-free code
            call_start = interpreter.rindex(FUZZ_EXEC_CALL_PREFIX, 0, trap_index)
            call_end = interpreter.index('\n', call_start)
            call_line = interpreter[call_start:call_end]
            # fix up the call line so it matches the JS
            fixed_call_line = fix_output_for_js(call_line)
            before = before[:before.index(fixed_call_line)]
            after = after[:after.index(fixed_call_line)]
            interpreter = interpreter[:interpreter.index(call_line)]

        if compare_before_to_after:
            compare_between_vms(before, after, 'Wasm2JS (before/after)')
            if compare_to_interpreter:
                interpreter = fix_output_for_js(interpreter)
                compare_between_vms(before, interpreter, 'Wasm2JS (vs interpreter)')

    def run(self, wasm):
        with open(get_fuzz_shell_js()) as f:
            wrapper = f.read()
        cmd = [in_bin('wasm2js'), wasm, '--emscripten']
        # avoid optimizations if we have nans, as we don't handle them with
        # full precision and optimizations can change things
        # OOB accesses are also an issue with optimizations, that can turn the
        # loaded "undefined" into either 0 (with an |0) or stay undefined
        # in optimized code.
        if not NANS and not OOB and random.random() < 0.5:
            # when optimizing also enable deterministic mode, to avoid things
            # like integer divide by zero causing false positives (1 / 0 is
            # Infinity without a  | 0 , and 0 with one, and the truthiness of
            # those differs; we don't want to care about this because it
            # would trap in wasm anyhow)
            cmd += ['-O', '--deterministic']
        main = run(cmd + FEATURE_OPTS)
        with open(os.path.join(shared.options.binaryen_root, 'scripts', 'wasm2js.js')) as f:
            glue = f.read()
        js_file = wasm + '.js'
        with open(js_file, 'w') as f:
            f.write(glue)
            f.write(main)
            f.write(wrapper)
        return run_vm([shared.NODEJS, js_file, abspath('a.wasm')])

    def can_run_on_wasm(self, wasm):
        # TODO: properly handle memory growth. right now the wasm2js handler
        # uses --emscripten which assumes the Memory is created before, and
        # wasm2js.js just starts with a size of 1 and no limit. We should switch
        # to non-emscripten mode or adding memory information, or check
        # specifically for growth here
        if INITIAL_CONTENTS:
            return False
        # We run in node, which lacks JSPI support, and also we need wasm2js to
        # implement wasm suspending using JS async/await.
        if JSPI:
            return False
        return all_disallowed(['exception-handling', 'simd', 'threads', 'bulk-memory', 'nontrapping-float-to-int', 'tail-call', 'sign-ext', 'reference-types', 'multivalue', 'gc', 'multimemory', 'memory64', 'custom-descriptors'])


# given a wasm, find all the exports of particular kinds (for example, kinds
# can be ['func', 'table'] and then we would find exported functions and
# tables).
def get_exports(wasm, kinds):
    wat = run([in_bin('wasm-dis'), wasm] + FEATURE_OPTS)
    p = re.compile(r'^ [(]export "(.*[^\\]?)" [(](?:' + '|'.join(kinds) + ')')
    exports = []
    for line in wat.splitlines():
        m = p.match(line)
        if m:
            export = m[1]
            exports.append(export)
    return exports


# given a wasm and a list of exports we want to keep, remove all other exports.
# we also keep a list of default exports, unless that is overridden (overriding
# it may lead to changes in behavior).
def filter_exports(wasm, output, keep, keep_defaults=True):
    # based on
    # https://github.com/WebAssembly/binaryen/wiki/Pruning-unneeded-code-in-wasm-files-with-wasm-metadce#example-pruning-exports

    # we append to keep; avoid modifying the object that was sent in.
    keep = keep[:]

    if keep_defaults:
        # some exports must normally be preserved, if they exist, like the table
        # (which can be called from JS imports for table operations).
        existing_exports = set(get_exports(wasm, ['func', 'table']))
        for export in ['table']:
            if export in existing_exports:
                keep.append(export)

    # build json to represent the exports we want.
    graph = [{
        'name': 'outside',
        'reaches': [f'export-{export}' for export in keep],
        'root': True
    }]
    for export in keep:
        graph.append({
            'name': f'export-{export}',
            'export': export
        })

    with open('graph.json', 'w') as f:
        f.write(json.dumps(graph))

    # prune the exports
    run([in_bin('wasm-metadce'), wasm, '-o', output, '--graph-file', 'graph.json'] + FEATURE_OPTS)


# Check if a wasm file would notice normally-unnoticeable changes to exports,
# such as removing one that is not called.
def wasm_notices_export_changes(wasm):
    wat = run([in_bin('wasm-dis'), wasm] + FEATURE_OPTS)

    if '(import "fuzzing-support" "call-export' in wat:
        # The call-export* imports are sensitive to the number and identity of
        # exports.
        return True

    if '(import "fuzzing-support" "table-' in wat and '(export "table" (table ' in wat:
        # The table-get/set imports are sensitive to the "table" export.
        return True

    return False


# Fuzz the interpreter with --fuzz-exec -tnh. The tricky thing with traps-never-
# happen mode is that if a trap *does* happen then that is undefined behavior,
# and the optimizer was free to make changes to observable behavior there. The
# fuzzer therefore needs to ignore code that traps.
class TrapsNeverHappen(TestCaseHandler):
    frequency = 0.25

    def handle_pair(self, input, before_wasm, after_wasm, opts):
        before = run_bynterp(before_wasm, ['--fuzz-exec-before'])

        if before == IGNORE:
            # There is no point to continue since we can't compare this output
            # to anything, and there is a risk since if we did so we might run
            # into an infinite loop (see below).
            return

        # if a trap happened, we must stop comparing from that.
        if TRAP_PREFIX in before:
            trap_index = before.index(TRAP_PREFIX)
            # we can't test this function, which the trap is in the middle of
            # (tnh could move the trap around, so even things before the trap
            # are unsafe). we can only safely call exports before this one, so
            # remove those from the binary.
            #
            # first, find the function call during which the trap happened, by
            # finding the call line right before us. that is, the output looks
            # like this:
            #
            #   [fuzz-exec] calling foo
            #   .. stuff happening during foo ..
            #   [fuzz-exec] calling bar
            #   .. stuff happening during bar ..
            #
            # if the trap happened during bar, the relevant call line is
            # "[fuzz-exec] calling bar".
            call_start = before.rfind(FUZZ_EXEC_CALL_PREFIX, 0, trap_index)
            if call_start < 0:
                # the trap happened before we called an export, so it occured
                # during startup (the start function, or memory segment
                # operations, etc.). in that case there is nothing for us to
                # compare here; just leave.
                return
            # include the line separator in the index, as function names may
            # be prefixes of each other
            call_end = before.index(os.linesep, call_start) + 1
            # we now know the contents of the call line after which the trap
            # happens, which is something like "[fuzz-exec] calling bar", and
            # it is unique since it contains the function being called.
            call_line = before[call_start:call_end]
            trapping_export = get_export_from_call_line(call_line)

            # now that we know the trapping export, we can leave only the safe
            # ones that are before it
            safe_exports = []
            for line in before.splitlines():
                if FUZZ_EXEC_CALL_PREFIX in line:
                    export = get_export_from_call_line(line)
                    if export == trapping_export:
                        break
                    safe_exports.append(export)

            # filter out the other exports
            filtered = before_wasm + '.filtered.wasm'
            filter_exports(before_wasm, filtered, safe_exports)
            before_wasm = filtered

            # re-execute the now safe wasm
            before = run_bynterp(before_wasm, ['--fuzz-exec-before'])
            assert TRAP_PREFIX not in before, 'we should have fixed this problem'

        after_wasm_tnh = after_wasm + '.tnh.wasm'
        run([in_bin('wasm-opt'), before_wasm, '-o', after_wasm_tnh, '-tnh'] + opts + FEATURE_OPTS)
        after = run_bynterp(after_wasm_tnh, ['--fuzz-exec-before'])

        # some results cannot be compared, so we must filter them out here.
        def ignore_references(out):
            ret = []
            for line in out.splitlines():
                # only result lines are relevant here, which look like
                # [fuzz-exec] note result: foo => [...]
                if FUZZ_EXEC_NOTE_RESULT in line:
                    # we want to filter out things like "anyref(null)" or
                    # "[ref null data]".
                    if 'ref(' in line or 'ref ' in line:
                        line = line[:line.index('=>') + 2] + ' ?'
                ret.append(line)
            return '\n'.join(ret)

        before = fix_output(ignore_references(before))
        after = fix_output(ignore_references(after))

        compare_between_vms(before, after, 'TrapsNeverHappen')

    def can_run_on_wasm(self, wasm):
        # If the wasm is sensitive to changes in exports then we cannot alter
        # them, but we must remove trapping exports (see above), so we cannot
        # run in such a case.
        return not wasm_notices_export_changes(wasm)


# Tests wasm-ctor-eval
class CtorEval(TestCaseHandler):
    frequency = 0.1

    def handle(self, wasm):
        # get the expected execution results.
        wasm_exec = run_bynterp(wasm, ['--fuzz-exec-before'])

        # get the list of func exports, so we can tell ctor-eval what to eval.
        ctors = ','.join(get_exports(wasm, ['func']))
        if not ctors:
            return

        # Fix escaping of the names, as we will be passing them as commandline
        # parameters below (e.g. we want --ctors=foo\28bar and not
        # --ctors=foo\\28bar; that extra escaping \ would cause an error).
        ctors = ctors.replace('\\\\', '\\')

        # eval the wasm.
        # we can use --ignore-external-input because the fuzzer passes in 0 to
        # all params, which is the same as ctor-eval assumes in this mode.
        evalled_wasm = wasm + '.evalled.wasm'
        output = run([in_bin('wasm-ctor-eval'), wasm, '-o', evalled_wasm, '--ctors=' + ctors, '--kept-exports=' + ctors, '--ignore-external-input'] + FEATURE_OPTS)

        # stop here if we could not eval anything at all in the module.
        if '...stopping since could not flatten memory' in output or \
           '...stopping since could not create module instance' in output:
            return
        if '...success' not in output and \
           '...partial evalling success' not in output:
            return
        evalled_wasm_exec = run_bynterp(evalled_wasm, ['--fuzz-exec-before'])

        compare_between_vms(fix_output(wasm_exec), fix_output(evalled_wasm_exec), 'CtorEval')

    def can_run_on_wasm(self, wasm):
        # ctor-eval modifies exports, because it assumes they are ctors and so
        # are only called once (so if it evals them away, they can be
        # removed). If the wasm might notice that, we cannot run.
        return not wasm_notices_export_changes(wasm)


# see https://github.com/WebAssembly/binaryen/issues/6823#issuecomment-2649122032
# as the interpreter refers to tags by name, two imports of the same Tag give it
# two different names, but they should behave as if they are one.
def wasm_has_duplicate_tags(wasm):
    # as with wasm_notices_export_changes, we could be more precise here and
    # disassemble the wasm.
    binary = open(wasm, 'rb').read()
    # check if we import jstag or wasmtag, which are used in the wasm, so any
    # duplication may hit the github issue mentioned above.
    return binary.count(b'jstag') >= 2 or binary.count(b'wasmtag') >= 2


# Detect whether there is a trap reported before an export call in the output.
def traps_in_instantiation(output):
    trap_index = output.find(TRAP_PREFIX)
    if trap_index == -1:
        # In "fixed" output, traps are replaced with *exception*.
        trap_index = output.find('*exception*')
        if trap_index == -1:
            return False
    call_index = output.find(FUZZ_EXEC_CALL_PREFIX)
    if call_index == -1:
        return True
    return trap_index < call_index


# Tests wasm-merge
class Merge(TestCaseHandler):
    frequency = 0.15

    def handle(self, wasm):
        # generate a second wasm file to merge. note that we intentionally pick
        # a smaller size than the main wasm file, so that reduction is
        # effective (i.e., as we reduce the main wasm to small sizes, we also
        # end up with small secondary wasms)
        # TODO: add imports and exports that connect between the two
        wasm_size = os.stat(wasm).st_size
        second_size = min(wasm_size, random_size())
        second_input = abspath('second_input.dat')
        make_random_input(second_size, second_input)
        second_wasm = abspath('second.wasm')
        run([in_bin('wasm-opt'), second_input, '-ttf', '-o', second_wasm] + GEN_ARGS + FEATURE_OPTS)

        # the second wasm file must not have an export that can influence our
        # execution. the JS exports have that behavior, as when "table-set" is
        # called it will look for the export "table" on which to operate, then
        # imagine we lack that export in the first module but add it in the
        # second, then code that failed before will now use the exported table
        # from the second module (and maybe work). to avoid that, remove the
        # table export, if it exists (and if the first module doesn't export
        # it).
        second_exports = get_exports(second_wasm, ['func', 'table'])
        wasm_exports = get_exports(wasm, ['table'])
        if 'table' in second_exports and 'table' not in wasm_exports:
            filtered = [e for e in second_exports if e != 'table']
            # note we override the set of default things to keep, as we want to
            # remove the table export. doing so might change the behavior of
            # second.wasm, but that is ok.
            filter_exports(second_wasm, second_wasm, filtered, keep_defaults=False)

        # sometimes also optimize the second module
        if random.random() < 0.5:
            opts = get_random_opts()
            run([in_bin('wasm-opt'), second_wasm, '-o', second_wasm, '-all'] + FEATURE_OPTS + opts)

        # merge the wasm files. note that we must pass -all, as even if the two
        # inputs are MVP, the output may have multiple tables and multiple
        # memories (and we must also do that in the commands later down).
        #
        # Use --skip-export-conflicts as we only look at the first module's
        # exports for now - we don't care about the second module's.
        # TODO: compare the second module's exports as well, but we'd need
        #       to handle renaming of conflicting exports.
        merged = abspath('merged.wasm')
        run([in_bin('wasm-merge'), wasm, 'first',
            abspath('second.wasm'), 'second', '-o', merged,
            '--skip-export-conflicts', '-all'])

        if wasm_has_duplicate_tags(merged):
            note_ignored_vm_run('dupe_tags')
            return

        # sometimes also optimize the merged module
        if random.random() < 0.5:
            opts = get_random_opts()
            run([in_bin('wasm-opt'), merged, '-o', merged, '-all'] + opts)

        # verify that merging in the second module did not alter the output.
        output = run_bynterp(wasm, ['--fuzz-exec-before', '-all'])
        if output == IGNORE:
            return
        output = fix_output(output)
        second_output = run_bynterp(second_wasm, ['--fuzz-exec-before', '-all'])
        second_output = fix_output(second_output)
        if second_output == IGNORE:
            return
        merged_output = run_bynterp(merged, ['--fuzz-exec-before', '-all'])
        merged_output = fix_output(merged_output)
        if merged_output == IGNORE:
            return

        # If the second module traps in instantiation, then the merged module
        # must do so as well, regardless of what the first module does. (In
        # contrast, if the first module traps in instantiation, then the normal
        # checks below will ensure the merged module does as well.)
        if traps_in_instantiation(second_output) and \
                not traps_in_instantiation(output):
            # The merged module should also trap in instantiation, but the
            # exports will not be called, so there's nothing else to compare.
            if not traps_in_instantiation(merged_output):
                raise Exception('expected merged module to trap during ' +
                                'instantiation because second module traps ' +
                                'during instantiation')
            compare(merged_output, second_output, 'Merge: second module traps' +
                    ' in instantiation')
            return

        # a complication is that the second module's exports are appended, so we
        # have extra output. to handle that, just prune the tail, so that we
        # only compare the original exports from the first module.
        # TODO: compare the second module's exports to themselves as well, but
        #       they may have been renamed due to overlaps...
        merged_output = merged_output[:len(output)]

        compare_between_vms(output, merged_output, 'Merge')

    def can_run_on_wasm(self, wasm):
        # wasm-merge combines exports, which can alter their indexes and lead to
        # noticeable differences if the wasm is sensitive to such things, which
        # prevents us from running.
        return not wasm_notices_export_changes(wasm)


FUNC_NAMES_REGEX = re.compile(r'\n [(]func [$](\S+)')


# Tests wasm-split. This also tests that fuzz_shell.js properly executes 2 wasm
# files, which adds coverage for ClusterFuzz (which sometimes runs two wasm
# files in that way).
class Split(TestCaseHandler):
    frequency = 0.1

    def handle(self, wasm):
        # get the list of function names, some of which we will decide to split
        # out
        wat = run([in_bin('wasm-dis'), wasm] + FEATURE_OPTS)
        all_funcs = re.findall(FUNC_NAMES_REGEX, wat)

        # get the original output before splitting
        output = run_d8_wasm(wasm)
        output = fix_output(output)

        # find the names of the exports. we need this because when we split the
        # module then new exports appear to connect the two halves of the
        # original module. we do not want to call all the exports on the new
        # primary module, but only the original ones.
        exports = []
        for line in output.splitlines():
            if FUZZ_EXEC_CALL_PREFIX in line:
                exports.append(get_export_from_call_line(line))

        # pick which to split out, with a random rate of picking (biased towards
        # 0.5).
        rate = (random.random() + random.random()) / 2
        split_funcs = []
        for func in all_funcs:
            if random.random() < rate:
                split_funcs.append(func)

        if not split_funcs:
            # nothing to split out
            return

        # split the wasm into two
        primary = wasm + '.primary.wasm'
        secondary = wasm + '.secondary.wasm'

        # we require reference types, because that allows us to create our own
        # table. without that we use the existing table, and that may interact
        # with user code in odd ways (it really only works with the particular
        # form of table+segments that LLVM emits, and not with random fuzzer
        # content).
        split_feature_opts = FEATURE_OPTS + ['--enable-reference-types']

        run([in_bin('wasm-split'), wasm, '--split',
             '--split-funcs', ','.join(split_funcs),
             # make the new exports easily identifiable, as we need to ignore
             # them in part of fuzz_shell.js
             '--export-prefix=__fuzz_split_',
             '--primary-output', primary,
             '--secondary-output', secondary] + split_feature_opts)

        # sometimes also optimize the split modules
        optimized = False

        def optimize(name):
            # do not optimize if it would change the ABI
            if CLOSED_WORLD:
                return name
            # TODO: use other optimizations here, but we'd need to be careful of
            #       anything that can alter the ABI, and also current
            #       limitations of open-world optimizations (see discussion in
            #       https://github.com/WebAssembly/binaryen/pull/6660)
            opts = ['-O3']
            new_name = name + '.opt.wasm'
            run([in_bin('wasm-opt'), name, '-o', new_name, '-all'] + opts + split_feature_opts)
            nonlocal optimized
            optimized = True
            return new_name

        if random.random() < 0.5:
            primary = optimize(primary)
        if random.random() < 0.5:
            secondary = optimize(secondary)

        # prepare the list of exports to call. the format is
        #
        #  exports:A,B,C
        #
        exports_to_call = 'exports:' + ','.join(exports)

        # get the output from the split modules, linking them using JS
        # TODO run liftoff/turboshaft/etc.
        args = [
            secondary,
            exports_to_call,
            '--fuzz-split',
        ]
        linked_output = run_d8_wasm(primary, args=args)
        linked_output = fix_output(linked_output)

        # see D8.can_compare_to_self: we cannot compare optimized outputs if
        # NaNs are allowed, as the optimizer can modify NaNs differently than
        # the JS engine.
        if not (NANS and optimized):
            compare_between_vms(output, linked_output, 'Split')

    def can_run_on_wasm(self, wasm):
        # to run the split wasm we use JS, that is, JS links the exports of one
        # to the imports of the other, etc. since we run in JS, the wasm must be
        # valid for JS.
        if not LEGALIZE:
            return False

        # see D8.can_run
        return all_disallowed(['shared-everything', 'strings', 'stack-switching'])


# Check that the text format round-trips without error.
class RoundtripText(TestCaseHandler):
    frequency = 0.05

    def handle(self, wasm):
        # use name-types because in wasm GC we can end up truncating the default
        # names which are very long, causing names to collide and the wast to be
        # invalid
        # FIXME: run name-types by default during load?
        run([in_bin('wasm-opt'), wasm, '--name-types', '-S', '-o', abspath('a.wast')] + FEATURE_OPTS)
        run([in_bin('wasm-opt'), abspath('a.wast')] + FEATURE_OPTS)


# The error shown in V8 when a module fails to instantiate.
INSTANTIATE_ERROR = 'exception thrown: failed to instantiate module'


# Fuzz in a near-identical manner to how we fuzz on ClusterFuzz. This is mainly
# to see that fuzzing that way works properly (it likely won't catch anything
# the other fuzzers here catch, though it is possible). That is, running this
# script continuously will give continuous cover that ClusterFuzz should be
# running ok.
#
# Note that this is *not* deterministic like the other fuzzers: it runs run.py
# like ClusterFuzz does, and that generates its own random data. If a bug is
# caught here, it must be reduced manually.
class ClusterFuzz(TestCaseHandler):
    frequency = 0.1

    # Use handle_pair over handle because we don't use these wasm files anyhow,
    # we generate our own using run.py. If we used handle, we'd be called twice
    # for each iteration (once for each of the wasm files we ignore), which is
    # confusing.
    def handle_pair(self, input, before_wasm, after_wasm, opts):
        # Do not run ClusterFuzz in the first seconds of fuzzing: the first time
        # it runs is very slow (to build the bundle), which is annoying when you
        # are just starting the fuzzer and looking for any obvious problems.
        # Check this here as opposed to in e.g. can_run_on_wasm to avoid
        # changing the observed sequence of random numbers before and after this
        # threshold, which could interfere with bug reproduction.
        seconds = 30
        if time.time() - start_time < seconds:
            return

        self.ensure()

        # NO RANDOM DATA SHOULD BE USED BELOW THIS POINT

        # run.py() should emit these two files. Delete them to make sure they
        # are created by run.py() in the next step.
        fuzz_file = 'fuzz-binaryen-1.js'
        flags_file = 'flags-binaryen-1.js'
        for f in [fuzz_file, flags_file]:
            if os.path.exists(f):
                os.unlink(f)

        # Call run.py(), similarly to how ClusterFuzz does.
        run([sys.executable,
             os.path.join(self.clusterfuzz_dir, 'run.py'),
             '--output_dir=' + os.getcwd(),
             '--no_of_files=1',
             # Do not retry on wasm-opt errors: we want to investigate
             # them.
             '--no_retry'])

        # We should see the two files.
        assert os.path.exists(fuzz_file)
        assert os.path.exists(flags_file)

        # We'll use the fuzz file a few times below in commands.
        fuzz_file = os.path.abspath(fuzz_file)

        # Run the testcase in V8, similarly to how ClusterFuzz does.
        cmd = [shared.V8]
        # The flags are given in the flags file - we do *not* use our normal
        # flags here!
        with open(flags_file, 'r') as f:
            flags = f.read()
        cmd += flags.split(' ')
        # Get V8's extra fuzzing flags, the same as the ClusterFuzz runner does
        # (as can be seen from the testcases having --fuzzing and a lot of other
        # flags as well).
        cmd += get_v8_extra_flags()
        # Run the fuzz file, which contains a modified fuzz_shell.js - we do
        # *not* run fuzz_shell.js normally.
        cmd.append(fuzz_file)
        # No wasm file needs to be provided: it is hardcoded into the JS. Note
        # that we use run_vm(), which will ignore known issues in our output and
        # in V8. Those issues may cause V8 to e.g. reject a binary we emit that
        # is invalid, but that should not be a problem for ClusterFuzz (it isn't
        # a crash).
        output = run_vm(cmd)

        # Verify that we called something, if the fuzzer emitted a func export
        # (rarely, none might exist), unless we've decided to ignore the entire
        # run, or if the wasm errored during instantiation, which can happen due
        # to a testcase with a segment out of bounds, say.
        if output != IGNORE and not output.startswith(INSTANTIATE_ERROR):
            # Do the work to find if there were function exports: extract the
            # wasm from the JS, and process it.
            run([sys.executable,
                 in_binaryen('scripts', 'clusterfuzz', 'extract_wasms.py'),
                 fuzz_file,
                 'extracted'])
            if get_exports('extracted.0.wasm', ['func']):
                assert FUZZ_EXEC_CALL_PREFIX in output

    def ensure(self):
        # The first time we actually run, set things up: make a bundle like the
        # one ClusterFuzz receives, and unpack it for execution into a dir. The
        # existence of that dir shows we've ensured all we need.
        if hasattr(self, 'clusterfuzz_dir'):
            return

        self.clusterfuzz_dir = 'clusterfuzz'
        if os.path.exists(self.clusterfuzz_dir):
            shutil.rmtree(self.clusterfuzz_dir)
        os.mkdir(self.clusterfuzz_dir)

        print('Bundling for ClusterFuzz')
        bundle = 'fuzz_opt_clusterfuzz_bundle.tgz'
        run([in_binaryen('scripts', 'bundle_clusterfuzz.py'), bundle])

        print('Unpacking for ClusterFuzz')
        tar = tarfile.open(bundle, "r:gz")
        tar.extractall(path=self.clusterfuzz_dir)
        tar.close()


# Generates two wasm and tests interesting interactions between them. This is a
# little similar to Split(), but rather than split one wasm file into two and
# test that, we start with two.
#
# Fuzzing failures here is a little trickier, as there are two wasm files.
# You can reduce the primary file by finding the secondary one in the log
# (usually out/test/second.wasm), copy that to the side, and add
#
#   BINARYEN_SECOND_WASM=${saved_second}
#
# in the env. That will keep the secondary wasm fixed as you reduce the primary
# one.
#
# Note it may be better to reduce the second one first, so it imports less from
# the first (otherwise, when the second one imports many things, the first will
# fail to remove exports that are used). To reduce the second one, set
#
#   BINARYEN_FIRST_WASM=${saved_first}
#
# The reduce.sh script will then do the right thing, using that as the first
# wasm, and reducing on the second one, if you replace "original.wasm" in the
# reduction command (the command that this fuzzer script recommended that you
# run) with "second.wasm" as needed.
#
# In both cases, make sure to copy the files to a saved location first (do not
# use a path to the scratch files that get constantly overwritten).
class Two(TestCaseHandler):
    # Run at relatively high priority, as this is the main place we check cross-
    # module interactions.
    frequency = 1  # TODO: We may want even higher priority here

    def handle(self, wasm):
        # Generate a second wasm file. (For fuzzing, we may be given one, but we
        # still do the work to prepare to generate it, as that consumes random
        # values, and we don't want that to affect anything later.)
        second_wasm = abspath('second.wasm')
        second_input = abspath('second_input.dat')
        second_size = random_size()
        make_random_input(second_size, second_input)
        args = [second_input, '-ttf']
        # Most of the time, use the first wasm as an import to the second.
        if random.random() < 0.8:
            args += ['--fuzz-import=' + wasm]

        given = os.environ.get('BINARYEN_SECOND_WASM')
        if not given:
            print('Generate second wasm')
            run([in_bin('wasm-opt'), '-o', second_wasm] + args + GEN_ARGS + FEATURE_OPTS)
        else:
            print(f'Use given second wasm {given}')
            shutil.copyfile(given, second_wasm)

        # Run the wasm.
        #
        # Note that we *cannot* run each wasm file separately and compare those
        # to the combined output, as fuzz_shell.js intentionally allows calls
        # *between* the wasm files, through JS APIs like call-export*. So all we
        # do here is see the combined, linked behavior, and then later below we
        # see that that behavior remains even after optimizations.
        output = run_bynterp(wasm, args=['--fuzz-exec-before', f'--fuzz-exec-second={second_wasm}'])

        # Check if we trapped during instantiation.
        if traps_in_instantiation(output):
            # We may fail to instantiate the modules for valid reasons, such as
            # an active segment being out of bounds. There is no point to
            # continue in such cases, as no exports are called.
            note_ignored_vm_run('Two instantiate error')
            return

        if output == IGNORE:
            # There is no point to continue since we can't compare this output
            # to anything.
            return

        # Make sure that we actually executed all exports from both
        # wasm files.
        exports = get_exports(wasm, ['func']) + get_exports(second_wasm, ['func'])
        calls_in_output = output.count(FUZZ_EXEC_CALL_PREFIX)
        if calls_in_output == 0:
            print(f'warning: no calls in output. output:\n{output}')
        assert calls_in_output == len(exports), exports

        # Merge the files and run them that way. The result should be the same,
        # even if we optimize. TODO: merge (no pun intended) the rest of Merge
        # into here.
        merged = abspath('merged.wasm')
        run([in_bin('wasm-merge'), wasm, 'primary', second_wasm, 'secondary',
            '-o', merged, '--rename-export-conflicts', '-all'])

        # Usually also optimize the merged module. Optimizations are very
        # interesting here, because after merging we can safely do even closed-
        # world optimizations, making very aggressive changes that should still
        # behave the same as before merging.
        if random.random() < 0.8:
            merged_opt = abspath('merged.opt.wasm')
            opts = get_random_opts()
            run([in_bin('wasm-opt'), merged, '-o', merged_opt, '-all'] + opts)
            merged = merged_opt

        if not wasm_notices_export_changes(merged):
            # wasm-merge combines exports, which can alter their indexes and
            # lead to noticeable differences if the wasm is sensitive to such
            # things. We only compare the output if that is not an issue.
            merged_output = run_bynterp(merged, args=['--fuzz-exec-before', '-all'])

            if merged_output == IGNORE:
                # The original output was ok, but after merging it becomes
                # something we must ignore. This can happen when we optimize, if
                # the optimizer reorders a normal trap (say a null exception)
                # with a host limit trap (say an allocation limit). Nothing to
                # do here, but verify we did optimize, as otherwise this is
                # inexplicable.
                assert merged == abspath('merged.opt.wasm')
            else:
                self.compare_to_merged_output(output, merged_output)

        # The rest of the testing here depends on being to optimize the
        # two modules independently, which closed-world can break.
        if CLOSED_WORLD:
            return

        # Fix up the normal output for later comparisons.
        output = fix_output(output)

        # We can optimize and compare the results. Optimize at least one of
        # the two.
        wasms = [wasm, second_wasm]
        for i in range(random.randint(1, 2)):
            wasm_index = random.randint(0, 1)
            name = wasms[wasm_index]
            new_name = name + f'.opt{i}.wasm'
            opts = get_random_opts()
            run([in_bin('wasm-opt'), name, '-o', new_name] + opts + FEATURE_OPTS)
            wasms[wasm_index] = new_name

        # Run again, and compare the output
        optimized_output = run_bynterp(wasms[0], args=['--fuzz-exec-before', f'--fuzz-exec-second={wasms[1]}'])
        optimized_output = fix_output(optimized_output)

        compare(output, optimized_output, 'Two-Opt')

        # If we can, also test in V8. We also cannot compare if there are NaNs
        # (as optimizations can lead to different outputs), and we must
        # disallow some features.
        # TODO: relax some of these
        if NANS or not all_disallowed(['shared-everything', 'strings', 'stack-switching']):
            return

        output = run_d8_wasm(wasm, args=[second_wasm])

        if output == IGNORE:
            return

        # We ruled out things we must ignore, like host limitations, and also
        # exited earlier on a deterministic instantiation error, so there should
        # be no such error in V8.
        assert not output.startswith(INSTANTIATE_ERROR)

        output = fix_output(output)

        optimized_output = run_d8_wasm(wasms[0], args=[wasms[1]])
        optimized_output = fix_output(optimized_output)

        compare(output, optimized_output, 'Two-V8')

    def compare_to_merged_output(self, output, merged_output):
        # Comparing the original output from two files to the output after
        # merging them is not trivial. First, remove the extra logging that
        # --fuzz-exec-second adds.
        output = output.replace('[fuzz-exec] running second module\n', '')

        # Fix up both outputs.
        output = fix_output(output)
        merged_output = fix_output(merged_output)

        # Finally, align the export names. We merged with
        # --rename-export-conflicts, so that all exports remain exported,
        # allowing a full comparison, but we do need to handle the different
        # names. We do so by matching the export names in the logging.
        output_lines = output.splitlines()
        merged_output_lines = merged_output.splitlines()

        if len(output_lines) != len(merged_output_lines):
            # The line counts don't even match. Just compare them, which will
            # emit a nice error for that.
            compare(output, merged_output, 'Two-Counts')
            assert False, 'we should have errored on the line counts'

        for i in range(len(output_lines)):
            a = output_lines[i]
            b = merged_output_lines[i]
            if a == b:
                continue
            if a.startswith(FUZZ_EXEC_CALL_PREFIX):
                # Fix up
                #   [fuzz-exec] calling foo/bar
                # for different foo/bar. Just copy the original.
                assert b.startswith(FUZZ_EXEC_CALL_PREFIX)
                merged_output_lines[i] = output_lines[i]
            elif a.startswith(FUZZ_EXEC_NOTE_RESULT):
                # Fix up
                #   [fuzz-exec] note result: foo/bar => 42
                # for different foo/bar. We do not want to copy the result here,
                # which might differ (that would be a bug we want to find).
                assert b.startswith(FUZZ_EXEC_NOTE_RESULT)
                assert a.count(' => ') == 1
                assert b.count(' => ') == 1
                a_prefix, a_result = a.split(' => ')
                b_prefix, b_result = b.split(' => ')
                # Copy a's prefix with b's result.
                merged_output_lines[i] = a_prefix + ' => ' + b_result

        merged_output = '\n'.join(merged_output_lines)

        compare(output, merged_output, 'Two-Merged')


# Test --fuzz-preserve-imports-exports, which never modifies imports or exports.
class PreserveImportsExports(TestCaseHandler):
    frequency = 0.1

    def handle(self, wasm):
        # We will later verify that no imports or exports changed, by comparing
        # to the unprocessed original text.
        original = run([in_bin('wasm-opt'), wasm] + FEATURE_OPTS + ['--print'])

        # We leave if the module has (ref exn) in struct fields (because we have
        # no way to generate an exn in a non-function context, and if we picked
        # that struct for a global, we'd end up needing a (ref exn) in the
        # global scope, which is impossible). The fuzzer is designed to be
        # careful not to emit that in testcases, but after the optimizer runs,
        # we may end up with struct fields getting refined to that, so we need
        # this extra check (which should be hit very rarely).
        structs = [line for line in original.split('\n') if '(struct ' in line]
        if '(ref exn)' in '\n'.join(structs):
            note_ignored_vm_run('has non-nullable exn in struct')
            return

        # Generate some random input data.
        data = abspath('preserve_input.dat')
        make_random_input(random_size(), data)

        # Process the existing wasm file.
        processed = run([in_bin('wasm-opt'), data] + FEATURE_OPTS + [
            '-ttf',
            '--fuzz-preserve-imports-exports',
            '--initial-fuzz=' + wasm,
            '--print',
        ])

        def get_relevant_lines(wat):
            # Imports and exports are relevant.
            lines = [line for line in wat.splitlines() if '(export ' in line or '(import ' in line]

            # Ignore type names, which may vary (e.g. one file may have $5 and
            # another may call the same type $17).
            lines = [re.sub(r'[(]type [$][0-9a-zA-Z_$]+[)]', '', line) for line in lines]

            return '\n'.join(lines)

        compare(get_relevant_lines(original), get_relevant_lines(processed), 'Preserve')


# Test that we preserve branch hints properly. The invariant that we test here
# is that, given correct branch hints (that is, the input wasm's branch hints
# are always correct: a branch is taken iff the hint is that it is taken), then
# the optimizer does not end up with incorrect branch hints. It is fine if the
# optimizer removes some hints (it may remove entire chunks of code in DCE, for
# example, and it may find ways to simplify code so fewer things execute), but
# it should not emit a branch hint that is wrong - if it is not certain, it
# should remove the branch hint.
#
# Note that bugs found by this fuzzer tend to require the following during
# reducing: BINARYEN_TRUST_GIVEN_WASM=1 in the env, and --text as a parameter.
class BranchHintPreservation(TestCaseHandler):
    frequency = 0.1

    def handle(self, wasm):
        # Generate an instrumented wasm.
        instrumented = wasm + '.inst.wasm'
        run([
            in_bin('wasm-opt'),
            wasm,
            '-o', instrumented,
            # Add random branch hints (so we have something to work with).
            '--randomize-branch-hints',
            # Instrument them with logging.
            '--instrument-branch-hints',
            '-g',
        ] + FEATURE_OPTS)

        # Collect the logging.
        out = run_bynterp(instrumented, ['--fuzz-exec-before', '-all'])

        # Process the output. We look at the lines like this:
        #
        #   [LoggingExternalInterface log-branch 1 0 0]
        #
        # where the three integers are: ID, predicted, actual.
        all_ids = set()
        bad_ids = set()
        LOG_BRANCH_PREFIX = '[LoggingExternalInterface log-branch'
        for line in out.splitlines():
            if line.startswith(LOG_BRANCH_PREFIX):
                # (1:-1 strips away the '[', ']' at the edges)
                _, _, id_, hint, actual = line[1:-1].split(' ')
                all_ids.add(id_)
                if hint != actual:
                    # This hint was misleading.
                    bad_ids.add(id_)

        # If no good ids remain, there is nothing to test (no hints will remain
        # later down, after we remove bad ones).
        if bad_ids == all_ids:
            note_ignored_vm_run('no good ids')
            return

        # Generate proper hints for testing: A wasm file with 100% valid branch
        # hints, and instrumentation to verify that.
        de_instrumented = wasm + '.de_inst.wasm'
        args = [
            in_bin('wasm-opt'),
            instrumented,
            '-o', de_instrumented,
        ]
        # Remove the bad ids (using the instrumentation to identify them by ID).
        if bad_ids:
            args += [
                '--delete-branch-hints=' + ','.join(bad_ids),
            ]
        args += [
            # Remove all prior instrumentation, so it does not confuse us later
            # when we log our final hints, and also so it does not inhibit
            # optimizations.
            '--deinstrument-branch-hints',
            '-g',
        ] + FEATURE_OPTS
        run(args)

        # Add optimizations to see if things break.
        opted = wasm + '.opted.wasm'
        args = [
            in_bin('wasm-opt'),
            de_instrumented,
            '-o', opted,
            '-g',

            # Some passes are just skipped, as they do not modify ifs or brs,
            # but they do break the invariant of not adding bad branch hints.
            # There are two main issues here:
            # * Moving code around, possibly causing it to start to execute if
            #   it previously was not reached due to a trap (a branch hint
            #   seems to have no effects in the optimizer, so it will do such
            #   movements). And if it starts to execute and is a wrong hint, we
            #   get an invalid fuzzer finding.
            #   * LICM moves code out of loops.
            '--skip-pass=licm',
            #   * HeapStoreOptimization moves struct.sets closer to struct.news.
            '--skip-pass=heap-store-optimization',
            #   * MergeBlocks moves code out of inner blocks to outer blocks.
            '--skip-pass=merge-blocks',
            #   * Monomorphize can subtly reorder code:
            #
            #       (call $foo
            #         (select
            #           (i32.div_s ..which will trap..)
            #           (if with branch hint)
            #     =>
            #       (call $foo_1
            #         (if with branch hint)
            #
            #     where $foo_1 receives the if's result and uses it in the
            #     ("reverse-inlined") select. Now the if executes first, when
            #     previously the trap stopped it.
            '--skip-pass=monomorphize',
            '--skip-pass=monomorphize-always',
            # SimplifyGlobals finds globals that are "read only to be written",
            # and can remove the ifs that do so:
            #
            #         if (foo) { foo = 1 }
            #     =>
            #         if (0) {}
            #
            # This is valid if the global's value is never read otherwise, but
            # it does alter the if's behavior.
            '--skip-pass=simplify-globals',
            '--skip-pass=simplify-globals-optimizing',

            # * Merging/folding code. When we do so, code identical in content
            #   but differing in metadata will end up with the metadata from one
            #   of the copies, which might be wrong (we follow LLVM here, see
            #   details in the passes).
            #   * CodeFolding merges code blocks inside functions.
            '--skip-pass=code-folding',
            #   * DuplicateFunctionElimination merges functions.
            '--skip-pass=duplicate-function-elimination',

            # Some passes break the invariant in some cases, but we do not want
            # to skip them entirely, as they have other things we need to fuzz.
            # We add pass-args for them:
            # * Do not fold inside OptimizeInstructions.
            '--pass-arg=optimize-instructions-never-fold-or-reorder',
            # * Do not unconditionalize code in RemoveUnusedBrs.
            '--pass-arg=remove-unused-brs-never-unconditionalize',

        ] + get_random_opts() + FEATURE_OPTS
        run(args)

        # Add instrumentation, to see if any branch hints are wrong after
        # optimizations. We must do this in a separate invocation from the
        # optimizations due to flags like --converge (which would instrument
        # multiple times).
        final = wasm + '.final.wasm'
        args = [
            in_bin('wasm-opt'),
            opted,
            '-o', final,
            '--instrument-branch-hints',
            '-g',
        ] + FEATURE_OPTS
        run(args)

        # Run the final wasm.
        out = run_bynterp(final, ['--fuzz-exec-before', '-all'])

        # Preprocess the logging. We must discard all lines from functions that
        # trap, because we are fuzzing branch hints, which are not an effect,
        # and so they can be reordered with traps; consider this:
        #
        #  (i32.add
        #    (block
        #      (if (X) (unreachable)
        #      (i32.const 10)
        #    )
        #    (block
        #      (@metadata.code.branch_hint "\00")
        #      (if (Y) (unreachable)
        #      (i32.const 20)
        #    )
        #  )
        #
        # It is ok to reorder traps, so the optimizer might flip the arms of
        # this add (imagine other code inside the arms justified that). That
        # reordering is fine since the branch hint has no effect that the
        # optimizer needs to care about. However, after we instrument, there
        # *is* an effect, the visible logging, so if X is true we trap and do
        # not log a branch hint, but if we reorder, we do log, then trap.
        #
        # Note that this problem is specific to traps, because the optimizer can
        # reorder them, and does not care about identity.
        #
        # To handle this, gather lines for each call, and then see which groups
        # end in traps. (Initialize the list of groups with an empty group, for
        # any logging before the first call.)
        line_groups = [['before calls']]
        for line in out.splitlines():
            if line.startswith(FUZZ_EXEC_CALL_PREFIX):
                line_groups.append([line])
            else:
                line_groups[-1].append(line)

        # No bad hints should pop up after optimizations.
        for group in line_groups:
            if not group or group[-1] == '[trap unreachable]':
                continue
            for line in group:
                if line.startswith(LOG_BRANCH_PREFIX):
                    _, _, id_, hint, actual = line[1:-1].split(' ')
                    hint = int(hint)
                    actual = int(actual)
                    assert hint in (0, 1)
                    # We do not care about the integer value of the condition,
                    # only if it was 0 or non-zero.
                    actual = (actual != 0)
                    assert hint == actual, 'Bad hint after optimizations'


# The global list of all test case handlers
testcase_handlers = [
    FuzzExec(),
    CompareVMs(),
    CheckDeterminism(),
    Wasm2JS(),
    TrapsNeverHappen(),
    CtorEval(),
    Merge(),
    Split(),
    RoundtripText(),
    ClusterFuzz(),
    Two(),
    PreserveImportsExports(),
    BranchHintPreservation(),
]


# Do one test, given an input file for -ttf and some optimizations to run
def test_one(random_input, given_wasm):
    randomize_pass_debug()
    randomize_feature_opts()
    randomize_fuzz_settings()
    pick_initial_contents()

    opts = get_random_opts()
    print('randomized opts:', '\n  ' + '\n  '.join(opts))
    print()

    if given_wasm:
        # We are given a wasm file to operate on. By default we modify it in the
        # usual ways, like running DeNAN on it, which is important in many cases
        # (imagine the reducer generates a NAN, then we need to restore the
        # property of not having any). However, in some cases we do need to
        # trust the wasm is correct, or it is simpler to debug things without
        # constant changes in each reduction cycle, so we have an env var to
        # control that, BINARYEN_TRUST_GIVEN_WASM.
        if os.environ.get('BINARYEN_TRUST_GIVEN_WASM'):
            shutil.copyfile(given_wasm, abspath('a.wasm'))
        else:
            try:
                run([in_bin('wasm-opt'), given_wasm, '-o', abspath('a.wasm')] + GEN_ARGS + FEATURE_OPTS)
            except Exception as e:
                print("Internal error in fuzzer! Could not run given wasm")
                raise e
    else:
        # emit the target features section so that reduction can work later,
        # without needing to specify the features
        generate_command = [in_bin('wasm-opt'), random_input, '-ttf', '-o', abspath('a.wasm')] + GEN_ARGS + FEATURE_OPTS
        if INITIAL_CONTENTS:
            generate_command += ['--initial-fuzz=' + INITIAL_CONTENTS]
        if PRINT_WATS:
            printed = run(generate_command + ['--print'])
            with open('a.printed.wast', 'w') as f:
                f.write(printed)
        else:
            run(generate_command)
    wasm_size = os.stat('a.wasm').st_size
    bytes = wasm_size
    print('pre wasm size:', wasm_size)
    update_feature_opts('a.wasm')

    # create a second (optimized) wasm for handlers that want to look at pairs.
    generate_command = [in_bin('wasm-opt'), abspath('a.wasm'), '-o', abspath('b.wasm')] + opts + FUZZ_OPTS + FEATURE_OPTS
    if PRINT_WATS:
        printed = run(generate_command + ['--print'])
        with open('b.printed.wast', 'w') as f:
            f.write(printed)
    else:
        run(generate_command)
    wasm_size = os.stat('b.wasm').st_size
    bytes += wasm_size
    print('post wasm size:', wasm_size)

    # First, find which handlers can even run here. Note that we check a.wasm
    # and not b.wasm (optimizations do not change fuzzability).
    relevant_handlers = [handler for handler in testcase_handlers if not hasattr(handler, 'get_commands') and handler.can_run_on_wasm('a.wasm')]
    if len(relevant_handlers) == 0:
        return 0
    # filter by frequency
    filtered_handlers = [handler for handler in relevant_handlers if random.random() < handler.frequency]
    if len(filtered_handlers) == 0:
        # pick at least one, to not waste the effort we put into making the wasm
        filtered_handlers = [random.choice(relevant_handlers)]
    # run only some of the pair handling handlers. if we ran them all all the
    # time that would mean we have less variety in wasm files and passes run
    # on them in the same amount of time.
    NUM_PAIR_HANDLERS = 3
    used_handlers = set()
    for i in range(NUM_PAIR_HANDLERS):
        testcase_handler = random.choice(filtered_handlers)
        if testcase_handler in used_handlers:
            continue
        used_handlers.add(testcase_handler)
        assert testcase_handler.can_run_on_wasm('a.wasm')
        print('running testcase handler:', testcase_handler.__class__.__name__)
        testcase_handler.increment_runs()

        # let the testcase handler handle this testcase however it wants. in this case we give it
        # the input and both wasms.
        testcase_handler.handle_pair(input=random_input, before_wasm=abspath('a.wasm'), after_wasm=abspath('b.wasm'), opts=opts + FEATURE_OPTS)
        print('')

    return bytes


def write_commands(commands, filename):
    with open(filename, 'w') as f:
        f.write('set -e\n')
        for command in commands:
            f.write('echo "%s"\n' % command)
            pre = 'BINARYEN_PASS_DEBUG=%s ' % (os.environ.get('BINARYEN_PASS_DEBUG') or '0')
            f.write(pre + command + ' &> /dev/null\n')
        f.write('echo "ok"\n')


# main

opt_choices = [
    (),
    ('-O1',), ('-O2',), ('-O3',), ('-O4',), ('-Os',), ('-Oz',),
    ("--abstract-type-refining",),
    ("--cfp",),
    ("--cfp-reftest",),
    ("--coalesce-locals",),
    # XXX slow, non-default ("--coalesce-locals-learning",),
    ("--code-pushing",),
    ("--code-folding",),
    ("--const-hoisting",),
    ("--dae",),
    ("--dae-optimizing",),
    ("--dce",),
    ("--directize",),
    ("--discard-global-effects",),
    ("--flatten", "--dfo",),
    ("--duplicate-function-elimination",),
    ("--flatten",),
    # ("--fpcast-emu",), # removes indirect call failures as it makes them go through regardless of type
    ("--inlining",),
    ("--inlining-optimizing",),
    ("--flatten", "--simplify-locals-notee-nostructure", "--local-cse",),
    # note that no pass we run here should add effects to a function, so it is
    # ok to run this pass and let the passes after it use the effects to
    # optimize
    ("--generate-global-effects",),
    ("--global-refining",),
    ("--gsi",),
    ("--gto",),
    ("--gufa",),
    ("--gufa-cast-all",),
    ("--gufa-optimizing",),
    ("--local-cse",),
    ("--heap2local",),
    ("--remove-unused-names", "--heap2local",),
    ("--heap-store-optimization",),
    ("--generate-stack-ir",),
    ("--licm",),
    ("--local-subtyping",),
    ("--memory-packing",),
    ("--merge-blocks",),
    ('--merge-locals',),
    # test a few monomorphization levels, and also -always
    ('--monomorphize', '--pass-arg=monomorphize-min-benefit@0'),
    ('--monomorphize', '--pass-arg=monomorphize-min-benefit@50'),
    ('--monomorphize', '--pass-arg=monomorphize-min-benefit@95'),
    ('--monomorphize-always',),
    ('--minimize-rec-groups',),
    ('--no-stack-ir',),
    ('--once-reduction',),
    ("--optimize-casts",),
    ("--optimize-instructions",),
    ("--optimize-stack-ir",),
    ("--generate-stack-ir", "--optimize-stack-ir",),
    # the full lifecycle of stack IR: generate, optimize, and write (and read)
    ("--generate-stack-ir", "--optimize-stack-ir", "--roundtrip"),
    ("--pick-load-signs",),
    ("--precompute",),
    ("--precompute-propagate",),
    ("--print",),
    ("--remove-unused-brs",),
    ("--remove-unused-nonfunction-module-elements",),
    ("--remove-unused-module-elements",),
    ("--remove-unused-names",),
    ("--remove-unused-types",),
    ("--reorder-functions",),
    ("--reorder-locals",),
    ("--flatten", "--rereloop",),
    ("--roundtrip",),
    ("--rse",),
    ("--signature-pruning",),
    ("--signature-refining",),
    ("--simplify-globals",),
    ("--simplify-globals-optimizing",),
    ("--simplify-locals",),
    ("--simplify-locals-nonesting",),
    ("--simplify-locals-nostructure",),
    ("--simplify-locals-notee",),
    ("--simplify-locals-notee-nostructure",),
    ("--ssa",),
    ("--tuple-optimization",),
    ("--type-finalizing",),
    ("--type-refining",),
    ("--type-refining-gufa",),
    ("--type-merging",),
    ("--type-ssa",),
    ("--type-unfinalizing",),
    ("--unsubtyping",),
    ("--vacuum",),
]

# TODO: Fix these passes so that they still work without --closed-world!
requires_closed_world = {("--type-refining",),
                         ("--type-refining-gufa",),
                         ("--signature-pruning",),
                         ("--signature-refining",),
                         ("--gto",),
                         ("--remove-unused-types",),
                         ("--abstract-type-refining",),
                         ("--cfp",),
                         ("--cfp-reftest",),
                         ("--gsi",),
                         ("--type-ssa",),
                         ("--type-merging",),
                         ("--unsubtyping",)}


def get_random_opts():
    flag_groups = []
    has_flatten = False

    if CLOSED_WORLD:
        usable_opt_choices = opt_choices
    else:
        usable_opt_choices = [choice
                              for choice in opt_choices
                              if choice not in requires_closed_world]

    # core opts
    while 1:
        choice = random.choice(usable_opt_choices)
        if '--flatten' in choice or '-O4' in choice:
            if has_flatten:
                print('avoiding multiple --flatten in a single command, due to exponential overhead')
                continue
            if '--enable-multivalue' in FEATURE_OPTS and '--enable-reference-types' in FEATURE_OPTS:
                print('avoiding --flatten due to multivalue + reference types not supporting it (spilling of non-nullable tuples)')
                print('TODO: Resolving https://github.com/WebAssembly/binaryen/issues/4824 may fix this')
                continue
            if '--enable-exception-handling' in FEATURE_OPTS:
                print('avoiding --flatten due to exception-handling not supporting it (requires blocks with results)')
                continue
            if '--gc' not in FEATURE_OPTS:
                print('avoiding --flatten due to GC not supporting it (spilling of non-nullable locals)')
                continue
            if INITIAL_CONTENTS and os.path.getsize(INITIAL_CONTENTS) > 2000:
                print('avoiding --flatten due using a large amount of initial contents, which may blow up')
                continue
            else:
                has_flatten = True
        if ('--rereloop' in choice or '--dfo' in choice) and \
           '--enable-exception-handling' in FEATURE_OPTS:
            print('avoiding --rereloop or --dfo due to exception-handling not supporting it')
            continue
        flag_groups.append(choice)
        if len(flag_groups) > 20 or random.random() < 0.3:
            break
    # maybe add an extra round trip
    if random.random() < 0.5:
        pos = random.randint(0, len(flag_groups))
        flag_groups = flag_groups[:pos] + [('--roundtrip',)] + flag_groups[pos:]
    ret = [flag for group in flag_groups for flag in group]
    # modifiers (if not already implied by a -O? option)
    if '-O' not in str(ret):
        if random.random() < 0.5:
            ret += ['--optimize-level=' + str(random.randint(0, 3))]
        if random.random() < 0.5:
            ret += ['--shrink-level=' + str(random.randint(0, 3))]
    # possibly converge. don't do this very often as it can be slow.
    if random.random() < 0.05:
        ret += ['--converge']
    # possibly inline all the things as much as possible. inlining that much may
    # be realistic in some cases (on GC benchmarks it is very helpful), but
    # also, inlining so much allows other optimizations to kick in, which
    # increases coverage
    # (the specific number here doesn't matter, but it is far higher than the
    # wasm limitation on function body size which is 128K)
    if random.random() < 0.5:
        ret += ['-fimfs=99999999']
    # the default for partial-inlining-ifs is 0, so also test with a realistic
    # value (the same used in j2wasm atm)
    if random.random() < 0.5:
        ret += ['-pii=4']
    # test both closed and open world
    if CLOSED_WORLD:
        ret += [CLOSED_WORLD_FLAG]
    assert ret.count('--flatten') <= 1
    return ret


# main

# list of all the flags to disable all the features. if all of these are added
# then we target the MVP.
FEATURE_DISABLE_FLAGS = run([in_bin('wasm-opt'), '--print-features', in_binaryen('test', 'hello_world.wat')] + CONSTANT_FEATURE_OPTS).replace('--enable', '--disable').strip().split('\n')
print('FEATURE_DISABLE_FLAGS:', FEATURE_DISABLE_FLAGS)

# some features depend on other features, so if a required feature is
# disabled, its dependent features need to be disabled as well.
IMPLIED_FEATURE_OPTS = {
    '--disable-reference-types': ['--disable-gc', '--disable-exception-handling', '--disable-strings'],
    '--disable-gc': ['--disable-strings', '--disable-stack-switching', '--disable-custom-descriptors'],
}

print('''
<<< fuzz_opt.py >>>
''')

if not shared.V8:
    print('The v8 shell, d8, must be in the path')
    sys.exit(1)

start_time = time.time()

if __name__ == '__main__':
    # if we are given a seed, run exactly that one testcase. otherwise,
    # run new ones until we fail
    # if we are given a seed, we can also be given a wasm file, which we use
    # instead of the randomly generating one. this can be useful for
    # reduction.
    given_wasm = None
    if len(shared.requested) >= 1:
        given_seed = int(shared.requested[0])
        print('checking a single given seed', given_seed)
        if len(shared.requested) >= 2:
            given_wasm = shared.requested[1]
            print('using given wasm file', given_wasm)
    else:
        given_seed = None
        print('checking infinite random inputs')

    init_important_initial_contents()

    seed = time.time() * os.getpid()
    raw_input_data = abspath('input.dat')
    counter = 0
    total_wasm_size = 0
    total_input_size = 0
    total_input_size_squares = 0
    while True:
        counter += 1
        if given_seed is not None:
            seed = given_seed
            given_seed_error = 0
        else:
            seed = random.randint(0, 1 << 64)
        random.seed(seed)
        input_size = random_size()
        total_input_size += input_size
        total_input_size_squares += input_size ** 2
        print('')
        mean = float(total_input_size) / counter
        mean_of_squares = float(total_input_size_squares) / counter
        stddev = math.sqrt(mean_of_squares - (mean ** 2))
        elapsed = max(0.000001, time.time() - start_time)
        print('ITERATION:', counter, 'seed:', seed, 'size:', input_size,
              '(mean:', str(mean) + ', stddev:', str(stddev) + ')',
              'speed:', counter / elapsed, 'iters/sec, ',
              total_wasm_size / counter, 'wasm_bytes/iter')
        if ignored_vm_runs:
            print(f'(ignored {ignored_vm_runs} iters, for reasons {ignored_vm_run_reasons})')
        print()
        make_random_input(input_size, raw_input_data)
        assert os.path.getsize(raw_input_data) == input_size
        # remove the generated wasm file, so that we can tell if the fuzzer
        # fails to create one
        if os.path.exists('a.wasm'):
            os.remove('a.wasm')
        # run an iteration of the fuzzer
        try:
            total_wasm_size += test_one(raw_input_data, given_wasm)
        except KeyboardInterrupt:
            print('(stopping by user request)')
            break
        except Exception as e:
            # print the exception manually, so that we can show our message at
            # the very end where it won't be missed
            ex_type, ex, tb = sys.exc_info()
            print('!')
            print('-----------------------------------------')
            print('Exception:')
            traceback.print_tb(tb)
            print('-----------------------------------------')
            print('!')
            # Default to an error code of 1, but change it for certain errors,
            # so we report them differently (useful for the reducer to keep
            # reducing the exact same error category)
            if given_seed is not None:
                given_seed_error = 1
            for arg in e.args:
                print(arg)
                if type(arg) is str:
                    if 'comparison error' in arg:
                        given_seed_error = 2

            # We want to generate a template reducer script only when there is
            # no given wasm file. That we have a given wasm file means we are no
            # longer working on the original test case but modified one, which
            # is likely to be called within wasm-reduce script itself, so
            # original.wasm and reduce.sh should not be overwritten.
            if not given_wasm:
                # We can't do this if a.wasm doesn't exist, which can be the
                # case if we failed to even generate the wasm.
                if not os.path.exists('a.wasm'):
                    print('''\
================================================================================
You found a bug in the fuzzer itself! It failed to generate a valid wasm file
from the random input. Please report it with

  seed: %(seed)d

and the exact version of Binaryen you found it on, plus the exact Python
version (hopefully deterministic random numbers will be identical).

You can run that testcase again with "fuzz_opt.py %(seed)d"

(We can't automatically reduce this testcase since we can only run the reducer
on valid wasm files.)
================================================================================
                ''' % {'seed': seed})
                    break
                # show some useful info about filing a bug and reducing the
                # testcase (to make reduction simple, save "original.wasm" on
                # the side, so that we can autoreduce using the name "a.wasm"
                # which we use internally)
                original_wasm = abspath('original.wasm')
                shutil.copyfile('a.wasm', original_wasm)
                # write out a useful reduce.sh
                auto_init = ''
                if not shared.options.auto_initial_contents:
                    auto_init = '--no-auto-initial-contents'
                with open('reduce.sh', 'w') as reduce_sh:
                    reduce_sh.write('''\
# check the input is even a valid wasm file
echo "The following value should be 0:"
%(wasm_opt)s %(features)s %(temp_wasm)s
echo "  " $?

echo "The following value should be >0:"

if [ -z "$BINARYEN_FIRST_WASM" ]; then
  # run the command normally
  ./scripts/fuzz_opt.py %(auto_init)s --binaryen-bin %(bin)s %(seed)d %(temp_wasm)s > o 2> e
else
  # BINARYEN_FIRST_WASM was provided so we should actually reduce the *second*
  # file. pass the first one in as the main file, and use the env var for the
  # second.
  BINARYEN_SECOND_WASM=%(temp_wasm)s ./scripts/fuzz_opt.py %(auto_init)s --binaryen-bin %(bin)s %(seed)d $BINARYEN_FIRST_WASM > o 2> e
fi

echo "  " $?

#
# You may want to print out part of "o" or "e", if the output matters and not
# just the return code. For example,
#
#   cat o | tail -n 10
#
# would print out the last few lines of stdout, which might be useful if that
# mentions the specific error you want. Make sure that includes the right
# details (sometimes stderr matters too), and preferably no more (less details
# allow more reduction, but raise the risk of it reducing to something you don't
# quite want).
#
# To do a "dry run" of what the reducer will do, copy the original file to the
# test file that this script will run on,
#
#   cp %(original_wasm)s %(temp_wasm)s
#
# and then run
#
#   bash %(reduce_sh)s
#
# You may also need to add  --timeout 5  or such if the testcase is a slow one.
#
# If the testcase handler uses a second wasm file, you may be able to reduce it
# using BINARYEN_SECOND_WASM.
#
                  ''' % {'wasm_opt': in_bin('wasm-opt'),
                         'bin': shared.options.binaryen_bin,
                         'seed': seed,
                         'auto_init': auto_init,
                         'original_wasm': original_wasm,
                         'temp_wasm': abspath('t.wasm'),
                         'features': ' '.join(FEATURE_OPTS),
                         'reduce_sh': abspath('reduce.sh')})

                print('''\
================================================================================
You found a bug! Please report it with

  seed: %(seed)d

and the exact version of Binaryen you found it on, plus the exact Python
version (hopefully deterministic random numbers will be identical).

You can run that testcase again with "fuzz_opt.py %(seed)d"

The initial wasm file used here is saved as %(original_wasm)s

You can reduce the testcase by running this now:

||||
vvvv


%(wasm_reduce)s %(features)s %(original_wasm)s '--command=bash %(reduce_sh)s' -t %(temp_wasm)s -w %(working_wasm)s


^^^^
||||

Make sure to verify by eye that the output says something like this:

The following value should be 0:
  0
The following value should be >0:
  1

(If it does not, then one possible issue is that the fuzzer fails to write a
valid binary. If so, you can print the output of the fuzzer's first command
(using -ttf / --translate-to-fuzz) in text form and run the reduction from that,
passing --text to the reducer. Another possible fix is to avoid re-processing
the wasm for fuzzing in each iteration, by adding
BINARYEN_TRUST_GIVEN_WASM=1 in the env.)

You can also read "%(reduce_sh)s" which has been filled out for you and includes
docs and suggestions.

After reduction, the reduced file will be in %(working_wasm)s
================================================================================
                ''' % {'seed': seed,
                       'original_wasm': original_wasm,
                       'temp_wasm': abspath('t.wasm'),
                       'working_wasm': abspath('w.wasm'),
                       'wasm_reduce': in_bin('wasm-reduce'),
                       'reduce_sh': abspath('reduce.sh'),
                       'features': ' '.join(FEATURE_OPTS)})
                break
        if given_seed is not None:
            break

        print('\nInvocations so far:')
        for testcase_handler in testcase_handlers:
            print('  ', testcase_handler.__class__.__name__ + ':', testcase_handler.count_runs())

    if given_seed is not None:
        if not given_seed_error:
            print('(finished running seed %d without error)' % given_seed)
            sys.exit(0)
        else:
            print('(finished running seed %d, see error above)' % given_seed)
            sys.exit(given_seed_error)
