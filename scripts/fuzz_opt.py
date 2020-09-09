#!/usr/bin/python3

'''
Runs random passes and options on random inputs, using wasm-opt.

Can be configured to run just wasm-opt itself (using --fuzz-exec)
or also run VMs on it.

For afl-fuzz integration, you probably don't want this, and can use
something like

BINARYEN_CORES=1 BINARYEN_PASS_DEBUG=1 afl-fuzz -i afl-testcases/ -o afl-findings/ -m 100 -d -- bin/wasm-opt -ttf --fuzz-exec --Os @@

(that is on a fixed set of arguments to wasm-opt, though - this
script covers different options being passed)
'''

import contextlib
import os
import difflib
import math
import shutil
import subprocess
import random
import re
import sys
import time
import traceback

from test import shared

assert sys.version_info.major == 3, 'requires Python 3!'

# parameters

# feature options that are always passed to the tools.
# * multivalue: https://github.com/WebAssembly/binaryen/issues/2770
CONSTANT_FEATURE_OPTS = ['--all-features']

INPUT_SIZE_MIN = 1024
INPUT_SIZE_MEAN = 40 * 1024
INPUT_SIZE_MAX = 5 * INPUT_SIZE_MEAN

PRINT_WATS = False


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


def run(cmd):
    print(' '.join(cmd))
    return subprocess.check_output(cmd, text=True)


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
    # half the time apply all the possible opts. this lets all test runners work at max
    # capacity at least half the time, as otherwise if they need almost all the opts, the
    # chance of getting them is exponentially small.
    if random.random() < 0.5:
        FEATURE_OPTS += POSSIBLE_FEATURE_OPTS
    else:
        for possible in POSSIBLE_FEATURE_OPTS:
            if random.random() < 0.5:
                FEATURE_OPTS.append(possible)
    print('randomized feature opts:', ' '.join(FEATURE_OPTS))


FUZZ_OPTS = None
NANS = None
OOB = None
LEGALIZE = None
ORIGINAL_V8_OPTS = shared.V8_OPTS[:]


def randomize_fuzz_settings():
    global FUZZ_OPTS, NANS, OOB, LEGALIZE
    FUZZ_OPTS = []
    if random.random() < 0.5:
        NANS = True
    else:
        NANS = False
        FUZZ_OPTS += ['--denan']
    if random.random() < 0.5:
        OOB = True
    else:
        OOB = False
        FUZZ_OPTS += ['--no-fuzz-oob']
    if random.random() < 0.5:
        LEGALIZE = True
        FUZZ_OPTS += ['--legalize-js-interface']
    else:
        LEGALIZE = False
    extra_v8_opts = []
    # 50% of the time test v8 normally, that is, the same way it runs in
    # production (which as of 07/15/2020 means baseline, then tier up to
    # optimizing, but that may change in the future).
    if random.random() < 0.5:
        # test either the optimizing compiler or the baseline compiler, with
        # equal probability. it's useful to do this because the normal tier-up
        # mode does not check them both equally (typically baseline does not get
        # enough testing, as we quickly leave it), and also because the tiering
        # up is nondeterministic (when optimized code becomes ready, we switch
        # to it)
        if random.random() < 0.5:
            extra_v8_opts += ['--no-liftoff']
        else:
            extra_v8_opts += ['--liftoff', '--no-wasm-tier-up']
    shared.V8_OPTS = ORIGINAL_V8_OPTS + extra_v8_opts
    print('randomized settings (NaNs, OOB, legalize, extra V8_OPTS):', NANS, OOB, LEGALIZE, extra_v8_opts)


# Test outputs we want to ignore are marked this way.
IGNORE = '[binaryen-fuzzer-ignore]'

# Traps are reported as [trap REASON]
TRAP_PREFIX = '[trap '

# --fuzz-exec reports calls as [fuzz-exec] calling foo
FUZZ_EXEC_CALL_PREFIX = '[fuzz-exec] calling'


# compare two strings, strictly
def compare(x, y, context):
    if x != y and x != IGNORE and y != IGNORE:
        message = ''.join([a + '\n' for a in difflib.unified_diff(x.splitlines(), y.splitlines(), fromfile='expected', tofile='actual')])
        raise Exception(context + " comparison error, expected to have '%s' == '%s', diff:\n\n%s" % (
            x, y,
            message
        ))


# numbers are "close enough" if they just differ in printing, as different
# vms may print at different precision levels and verbosity
def numbers_are_close_enough(x, y):
    # handle nan comparisons like -nan:0x7ffff0 vs NaN, ignoring the bits
    if 'nan' in x.lower() and 'nan' in y.lower():
        return True
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
            LEI_LOGGING = '[LoggingExternalInterface logging'
            if x_line.startswith(LEI_LOGGING) and y_line.startswith(LEI_LOGGING):
                x_val = x_line[len(LEI_LOGGING) + 1:-1]
                y_val = y_line[len(LEI_LOGGING) + 1:-1]
                if numbers_are_close_enough(x_val, y_val):
                    continue
            NOTE_RESULT = '[fuzz-exec] note result'
            if x_line.startswith(NOTE_RESULT) and y_line.startswith(NOTE_RESULT):
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
    out = out.replace(TRAP_PREFIX, 'exception: ' + TRAP_PREFIX)
    lines = out.splitlines()
    for i in range(len(lines)):
        line = lines[i]
        if 'Warning: unknown flag' in line or 'Try --help for options' in line:
            # ignore some VM warnings that don't matter, like if a newer V8 has
            # removed a flag that is no longer needed. but print the line so the
            # developer can see it.
            print(line)
            lines[i] = None
        elif 'exception' in line:
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


def run_vm(cmd):
    # ignore some vm assertions, if bugs have already been filed
    known_issues = [
        'local count too large',    # ignore this; can be caused by flatten, ssa, etc. passes
    ]
    try:
        return run(cmd)
    except subprocess.CalledProcessError:
        output = run_unchecked(cmd)
        for issue in known_issues:
            if issue in output:
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


def run_d8_js(js, args=[]):
    return run_vm([shared.V8] + shared.V8_OPTS + [js] + (['--'] if args else []) + args)


def run_d8_wasm(wasm):
    return run_d8_js(in_binaryen('scripts', 'fuzz_shell.js'), [wasm])


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
        self.handle(after_wasm)

    def can_run_on_feature_opts(self, feature_opts):
        return True

    def increment_runs(self):
        self.num_runs += 1

    def count_runs(self):
        return self.num_runs


# Run VMs and compare results

class VM:
    def __init__(self, name, run, can_compare_to_self, can_compare_to_others):
        self.name = name
        self.run = run
        self.can_compare_to_self = can_compare_to_self
        self.can_compare_to_others = can_compare_to_others

    def can_run(self, wasm):
        return True


# Fuzz the interpreter with --fuzz-exec.
class FuzzExec(TestCaseHandler):
    frequency = 1

    def handle_pair(self, input, before_wasm, after_wasm, opts):
        run([in_bin('wasm-opt'), before_wasm] + opts + ['--fuzz-exec'])


class CompareVMs(TestCaseHandler):
    frequency = 0.6

    def __init__(self):
        super(CompareVMs, self).__init__()

        def byn_run(wasm):
            return run_bynterp(wasm, ['--fuzz-exec-before'])

        def v8_run(wasm):
            run([in_bin('wasm-opt'), wasm, '--emit-js-wrapper=' + wasm + '.js'] + FEATURE_OPTS)
            return run_vm([shared.V8, wasm + '.js'] + shared.V8_OPTS + ['--', wasm])

        def yes():
            return True

        def if_legal_and_no_nans():
            return LEGALIZE and not NANS

        def if_no_nans():
            return not NANS

        class Wasm2C(VM):
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
                return all([x in FEATURE_OPTS for x in ['--disable-exception-handling', '--disable-simd', '--disable-threads', '--disable-bulk-memory', '--disable-nontrapping-float-to-int', '--disable-tail-call', '--disable-sign-ext', '--disable-reference-types', '--disable-multivalue', '--disable-anyref']])

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

            def can_compare_to_others(self):
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
                compile_cmd = ['emcc', 'main.c', 'wasm.c', os.path.join(self.wasm2c_dir, 'wasm-rt-impl.c'), '-I' + self.wasm2c_dir, '-lm']
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
                return run_d8_js('a.out.js')

            def can_run(self, wasm):
                # quite slow (more steps), so run it less frequently
                if random.random() < 0.8:
                    return False
                # prefer not to run if the wasm is very large, as it can OOM
                # the JS engine.
                return super(Wasm2C2Wasm, self).can_run(wasm) and self.has_emcc and \
                    os.path.getsize(wasm) <= INPUT_SIZE_MEAN

            def can_compare_to_others(self):
                # NaNs can differ from wasm VMs
                return not NANS

        self.vms = [
            VM('binaryen interpreter', byn_run,    can_compare_to_self=yes,        can_compare_to_others=yes),
            # with nans, VM differences can confuse us, so only very simple VMs can compare to themselves after opts in that case.
            # if not legalized, the JS will fail immediately, so no point to compare to others
            VM('d8',                   v8_run,     can_compare_to_self=if_no_nans, can_compare_to_others=if_legal_and_no_nans),
            Wasm2C(),
            Wasm2C2Wasm(),
        ]

    def handle_pair(self, input, before_wasm, after_wasm, opts):
        before = self.run_vms(before_wasm)
        after = self.run_vms(after_wasm)
        self.compare_before_and_after(before, after)

    def run_vms(self, wasm):
        # vm_results will map vms to their results
        vm_results = {}
        for vm in self.vms:
            if vm.can_run(wasm):
                vm_results[vm] = fix_output(vm.run(wasm))

        # compare between the vms on this specific input

        first_vm = None
        for vm in vm_results.keys():
            if vm.can_compare_to_others():
                if first_vm is None:
                    first_vm = vm
                else:
                    compare_between_vms(vm_results[first_vm], vm_results[vm], 'CompareVMs between VMs: ' + first_vm.name + ' and ' + vm.name)

        return vm_results

    def compare_before_and_after(self, before, after):
        # compare each VM to itself on the before and after inputs
        for vm in before.keys():
            if vm in after and vm.can_compare_to_self():
                compare(before[vm], after[vm], 'CompareVMs between before and after: ' + vm.name)

    def can_run_on_feature_opts(self, feature_opts):
        return all([x in feature_opts for x in ['--disable-simd', '--disable-reference-types', '--disable-exception-handling', '--disable-multivalue', '--disable-anyref']])


# Check for determinism - the same command must have the same output.
class CheckDeterminism(TestCaseHandler):
    # not that important
    frequency = 0.1

    def handle_pair(self, input, before_wasm, after_wasm, opts):
        # check for determinism
        run([in_bin('wasm-opt'), before_wasm, '-o', 'b1.wasm'] + opts)
        run([in_bin('wasm-opt'), before_wasm, '-o', 'b2.wasm'] + opts)
        assert open('b1.wasm', 'rb').read() == open('b2.wasm', 'rb').read(), 'output must be deterministic'


class Wasm2JS(TestCaseHandler):
    frequency = 0.6

    def handle_pair(self, input, before_wasm, after_wasm, opts):
        before_wasm_temp = before_wasm + '.temp.wasm'
        after_wasm_temp = after_wasm + '.temp.wasm'
        # legalize the before wasm, so that comparisons to the interpreter
        # later make sense (if we don't do this, the wasm may have i64 exports).
        # after applying other necessary fixes, we'll recreate the after wasm
        # from scratch.
        run([in_bin('wasm-opt'), before_wasm, '--legalize-js-interface', '-o', before_wasm_temp] + FEATURE_OPTS)
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
        # we also cannot compare if the wasm hits a trap, as wasm2js does not
        # trap on many things wasm would, and in those cases it can do weird
        # undefined things. in such a case, at least compare up until before
        # the trap, which lets us compare at least some results in some cases.
        # (this is why wasm2js is not in CompareVMs, which does full
        # comparisons - we need to limit the comparison in a special way here)
        interpreter = run([in_bin('wasm-opt'), before_wasm_temp, '--fuzz-exec-before'])
        if TRAP_PREFIX in interpreter:
            trap_index = interpreter.index(TRAP_PREFIX)
            # we can't test this function, which the trap is in the middle of.
            # erase everything from this function's output and onward, so we
            # only compare the previous trap-free code
            call_start = interpreter.rindex(FUZZ_EXEC_CALL_PREFIX, 0, trap_index)
            call_end = interpreter.index('\n', call_start)
            call_line = interpreter[call_start:call_end]
            before = before[:before.index(call_line)]
            after = after[:after.index(call_line)]
            interpreter = interpreter[:interpreter.index(call_line)]

        def fix_output_for_js(x):
            # start with the normal output fixes that all VMs need
            x = fix_output(x)

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
        if compare_before_to_after:
            compare_between_vms(before, after, 'Wasm2JS (before/after)')
            if compare_to_interpreter:
                interpreter = fix_output_for_js(interpreter)
                compare_between_vms(before, interpreter, 'Wasm2JS (vs interpreter)')

    def run(self, wasm):
        wrapper = run([in_bin('wasm-opt'), wasm, '--emit-js-wrapper=/dev/stdout'] + FEATURE_OPTS)
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
        return run_vm([shared.NODEJS, js_file, 'a.wasm'])

    def can_run_on_feature_opts(self, feature_opts):
        return all([x in feature_opts for x in ['--disable-exception-handling', '--disable-simd', '--disable-threads', '--disable-bulk-memory', '--disable-nontrapping-float-to-int', '--disable-tail-call', '--disable-sign-ext', '--disable-reference-types', '--disable-multivalue', '--disable-anyref']])


class Asyncify(TestCaseHandler):
    frequency = 0.6

    def handle_pair(self, input, before_wasm, after_wasm, opts):
        # we must legalize in order to run in JS
        run([in_bin('wasm-opt'), before_wasm, '--legalize-js-interface', '-o', 'async.' + before_wasm] + FEATURE_OPTS)
        run([in_bin('wasm-opt'), after_wasm, '--legalize-js-interface', '-o', 'async.' + after_wasm] + FEATURE_OPTS)
        before_wasm = 'async.' + before_wasm
        after_wasm = 'async.' + after_wasm
        before = fix_output(run_d8_wasm(before_wasm))
        after = fix_output(run_d8_wasm(after_wasm))

        try:
            compare(before, after, 'Asyncify (before/after)')
        except Exception:
            # if we failed to just compare the builds before asyncify even runs,
            # then it may use NaNs or be sensitive to legalization; ignore it
            print('ignoring due to pre-asyncify difference')
            return

        def do_asyncify(wasm):
            cmd = [in_bin('wasm-opt'), wasm, '--asyncify', '-o', 'async.t.wasm']
            # if we allow NaNs, running binaryen optimizations and then
            # executing in d8 may lead to different results due to NaN
            # nondeterminism between VMs.
            if not NANS:
                if random.random() < 0.5:
                    cmd += ['--optimize-level=%d' % random.randint(1, 3)]
                if random.random() < 0.5:
                    cmd += ['--shrink-level=%d' % random.randint(1, 2)]
            cmd += FEATURE_OPTS
            run(cmd)
            out = run_d8_wasm('async.t.wasm')
            # ignore the output from the new asyncify API calls - the ones with asserts will trap, too
            for ignore in ['[fuzz-exec] calling asyncify_start_unwind\nexception!\n',
                           '[fuzz-exec] calling asyncify_start_unwind\n',
                           '[fuzz-exec] calling asyncify_start_rewind\nexception!\n',
                           '[fuzz-exec] calling asyncify_start_rewind\n',
                           '[fuzz-exec] calling asyncify_stop_rewind\n',
                           '[fuzz-exec] calling asyncify_stop_unwind\n']:
                out = out.replace(ignore, '')
            out = '\n'.join([l for l in out.splitlines() if 'asyncify: ' not in l])
            return fix_output(out)

        before_asyncify = do_asyncify(before_wasm)
        after_asyncify = do_asyncify(after_wasm)

        compare(before, before_asyncify, 'Asyncify (before/before_asyncify)')
        compare(before, after_asyncify, 'Asyncify (before/after_asyncify)')

    def can_run_on_feature_opts(self, feature_opts):
        return all([x in feature_opts for x in ['--disable-exception-handling', '--disable-simd', '--disable-tail-call', '--disable-reference-types', '--disable-multivalue', '--disable-anyref']])


# The global list of all test case handlers
testcase_handlers = [
    FuzzExec(),
    CompareVMs(),
    CheckDeterminism(),
    Wasm2JS(),
    Asyncify(),
]


# Do one test, given an input file for -ttf and some optimizations to run
def test_one(random_input, opts, given_wasm):
    randomize_pass_debug()
    randomize_feature_opts()
    randomize_fuzz_settings()
    print()

    if given_wasm:
        # if given a wasm file we want to use it as is, but we also want to
        # apply properties like not having any NaNs, which the original fuzz
        # wasm had applied. that is, we need to preserve properties like not
        # having nans through reduction.
        run([in_bin('wasm-opt'), given_wasm, '-o', 'a.wasm'] + FUZZ_OPTS + FEATURE_OPTS)
    else:
        # emit the target features section so that reduction can work later,
        # without needing to specify the features
        generate_command = [in_bin('wasm-opt'), random_input, '-ttf', '-o', 'a.wasm', '--emit-target-features'] + FUZZ_OPTS + FEATURE_OPTS
        if PRINT_WATS:
            printed = run(generate_command + ['--print'])
            with open('a.printed.wast', 'w') as f:
                f.write(printed)
        else:
            run(generate_command)
    wasm_size = os.stat('a.wasm').st_size
    bytes = wasm_size
    print('pre wasm size:', wasm_size)

    # create a second wasm for handlers that want to look at pairs.
    generate_command = [in_bin('wasm-opt'), 'a.wasm', '-o', 'b.wasm'] + opts + FUZZ_OPTS + FEATURE_OPTS
    if PRINT_WATS:
        printed = run(generate_command + ['--print'])
        with open('b.printed.wast', 'w') as f:
            f.write(printed)
    else:
        run(generate_command)
    wasm_size = os.stat('b.wasm').st_size
    bytes += wasm_size
    print('post wasm size:', wasm_size)

    # first, find which handlers can even run here
    relevant_handlers = [handler for handler in testcase_handlers if not hasattr(handler, 'get_commands') and handler.can_run_on_feature_opts(FEATURE_OPTS)]
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
        assert testcase_handler.can_run_on_feature_opts(FEATURE_OPTS)
        print('running testcase handler:', testcase_handler.__class__.__name__)
        testcase_handler.increment_runs()

        # let the testcase handler handle this testcase however it wants. in this case we give it
        # the input and both wasms.
        testcase_handler.handle_pair(input=random_input, before_wasm='a.wasm', after_wasm='b.wasm', opts=opts + FEATURE_OPTS)
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
    [],
    ['-O1'], ['-O2'], ['-O3'], ['-O4'], ['-Os'], ['-Oz'],
    ["--coalesce-locals"],
    # XXX slow, non-default ["--coalesce-locals-learning"],
    ["--code-pushing"],
    ["--code-folding"],
    ["--const-hoisting"],
    ["--dae"],
    ["--dae-optimizing"],
    ["--dce"],
    ["--directize"],
    ["--flatten", "--dfo"],
    ["--duplicate-function-elimination"],
    ["--flatten"],
    # ["--fpcast-emu"], # removes indirect call failures as it makes them go through regardless of type
    ["--inlining"],
    ["--inlining-optimizing"],
    ["--flatten", "--local-cse"],
    ["--generate-stack-ir"],
    ["--licm"],
    ["--memory-packing"],
    ["--merge-blocks"],
    ['--merge-locals'],
    ["--optimize-instructions"],
    ["--optimize-stack-ir"],
    ["--generate-stack-ir", "--optimize-stack-ir"],
    ["--pick-load-signs"],
    ["--precompute"],
    ["--precompute-propagate"],
    ["--print"],
    ["--remove-unused-brs"],
    ["--remove-unused-nonfunction-module-elements"],
    ["--remove-unused-module-elements"],
    ["--remove-unused-names"],
    ["--reorder-functions"],
    ["--reorder-locals"],
    ["--flatten", "--rereloop"],
    ["--roundtrip"],
    ["--rse"],
    ["--simplify-locals"],
    ["--simplify-locals-nonesting"],
    ["--simplify-locals-nostructure"],
    ["--simplify-locals-notee"],
    ["--simplify-locals-notee-nostructure"],
    ["--ssa"],
    ["--vacuum"],
]


def randomize_opt_flags():
    flag_groups = []
    has_flatten = False
    # core opts
    while 1:
        choice = random.choice(opt_choices)
        if '--flatten' in choice:
            if has_flatten:
                print('avoiding multiple --flatten in a single command, due to exponential overhead')
                continue
            else:
                has_flatten = True
        flag_groups.append(choice)
        if len(flag_groups) > 20 or random.random() < 0.3:
            break
    # maybe add an extra round trip
    if random.random() < 0.5:
        pos = random.randint(0, len(flag_groups))
        flag_groups = flag_groups[:pos] + [['--roundtrip']] + flag_groups[pos:]
    ret = [flag for group in flag_groups for flag in group]
    # modifiers (if not already implied by a -O? option)
    if '-O' not in str(ret):
        if random.random() < 0.5:
            ret += ['--optimize-level=' + str(random.randint(0, 3))]
        if random.random() < 0.5:
            ret += ['--shrink-level=' + str(random.randint(0, 3))]
    assert ret.count('--flatten') <= 1
    return ret


# main

# possible feature options that are sometimes passed to the tools. this
# contains the list of all possible feature flags we can disable (after
# we enable all before that in the constant options)
POSSIBLE_FEATURE_OPTS = run([in_bin('wasm-opt'), '--print-features', in_binaryen('test', 'hello_world.wat')] + CONSTANT_FEATURE_OPTS).replace('--enable', '--disable').strip().split('\n')
print('POSSIBLE_FEATURE_OPTS:', POSSIBLE_FEATURE_OPTS)

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
    seed = time.time() * os.getpid()
    raw_input_data = 'input.dat'
    counter = 0
    total_wasm_size = 0
    total_input_size = 0
    total_input_size_squares = 0
    start_time = time.time()
    while True:
        counter += 1
        if given_seed is not None:
            seed = given_seed
            given_seed_passed = True
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
        print('ITERATION:', counter, 'seed:', seed, 'size:', input_size, '(mean:', str(mean) + ', stddev:', str(stddev) + ')', 'speed:', counter / (time.time() - start_time), 'iters/sec, ', total_wasm_size / (time.time() - start_time), 'wasm_bytes/sec\n')
        with open(raw_input_data, 'wb') as f:
            f.write(bytes([random.randint(0, 255) for x in range(input_size)]))
        assert os.path.getsize(raw_input_data) == input_size
        opts = randomize_opt_flags()
        print('randomized opts:', ' '.join(opts))
        try:
            total_wasm_size += test_one(raw_input_data, opts, given_wasm)
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
            for arg in e.args:
                print(arg)
            if given_seed is not None:
                given_seed_passed = False

            # We want to generate a template reducer script only when there is
            # no given wasm file. That we have a given wasm file means we are no
            # longer working on the original test case but modified one, which
            # is likely to be called within wasm-reduce script itself, so
            # original.wasm and reduce.sh should not be overwritten.
            if not given_wasm:
                # show some useful info about filing a bug and reducing the
                # testcase (to make reduction simple, save "original.wasm" on
                # the side, so that we can autoreduce using the name "a.wasm"
                # which we use internally)
                original_wasm = os.path.abspath('original.wasm')
                shutil.copyfile('a.wasm', original_wasm)
                # write out a useful reduce.sh
                with open('reduce.sh', 'w') as reduce_sh:
                    reduce_sh.write('''\
# check the input is even a valid wasm file
%(wasm_opt)s --detect-features %(temp_wasm)s
echo "should be 0:" $?

# run the command
./scripts/fuzz_opt.py %(seed)d %(temp_wasm)s > o 2> e
echo "should be 1:" $?

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
                  ''' % {'wasm_opt': in_bin('wasm-opt'),
                         'seed': seed,
                         'original_wasm': original_wasm,
                         'temp_wasm': os.path.abspath('t.wasm'),
                         'reduce_sh': os.path.abspath('reduce.sh')})

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


%(wasm_reduce)s %(original_wasm)s '--command=bash %(reduce_sh)s' -t %(temp_wasm)s -w %(working_wasm)s


^^^^
||||

Make sure to verify by eye that the output says

should be 0: 0
should be 1: 1

You can also read "%(reduce_sh)s" which has been filled out for you and includes
docs and suggestions.

After reduction, the reduced file will be in %(working_wasm)s
================================================================================
                ''' % {'seed': seed,
                       'original_wasm': original_wasm,
                       'temp_wasm': os.path.abspath('t.wasm'),
                       'working_wasm': os.path.abspath('w.wasm'),
                       'wasm_reduce': in_bin('wasm-reduce'),
                       'reduce_sh': os.path.abspath('reduce.sh')})
                break
        if given_seed is not None:
            break

        print('\nInvocations so far:')
        for testcase_handler in testcase_handlers:
            print('  ', testcase_handler.__class__.__name__ + ':', testcase_handler.count_runs())

    if given_seed is not None:
        if given_seed_passed:
            print('(finished running seed %d without error)' % given_seed)
            sys.exit(0)
        else:
            print('(finished running seed %d, see error above)' % given_seed)
            sys.exit(1)
