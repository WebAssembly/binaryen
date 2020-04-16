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

import os
import difflib
import math
import subprocess
import random
import re
import shutil
import sys
import time
import traceback

from test import shared

assert sys.version_info.major == 3, 'requires Python 3!'

# parameters

# feature options that are always passed to the tools.
# exceptions: https://github.com/WebAssembly/binaryen/issues/2195
# simd: known issues with d8
# atomics, bulk memory: doesn't work in wasm2js
# truncsat: https://github.com/WebAssembly/binaryen/issues/2198
CONSTANT_FEATURE_OPTS = ['--all-features']

INPUT_SIZE_MIN = 1024
INPUT_SIZE_MEAN = 40 * 1024
INPUT_SIZE_MAX = 5 * INPUT_SIZE_MEAN

PRINT_WATS = False


# utilities

def in_binaryen(*args):
    return os.path.join(shared.options.binaryen_root, *args)


def in_bin(tool):
    return os.path.join(shared.options.binaryen_root, 'bin', tool)


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
    if random.random() < 0.125:
        print('[pass-debug]')
        os.environ['BINARYEN_PASS_DEBUG'] = '1'
    else:
        os.environ['BINARYEN_PASS_DEBUG'] = '0'
        del os.environ['BINARYEN_PASS_DEBUG']
    print('randomized pass debug:', os.environ.get('BINARYEN_PASS_DEBUG', ''))


def randomize_feature_opts():
    global FEATURE_OPTS
    FEATURE_OPTS = CONSTANT_FEATURE_OPTS[:]
    # half the time apply all the possible opts. this lets all test runners work at max
    # capacity at least half the time, as otherwise if they need almost all the opts, the
    # chance of getting them is exponentially small.
    if random.random() < 1: # 0.5:
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


def randomize_fuzz_settings():
    global FUZZ_OPTS, NANS, OOB, LEGALIZE
    FUZZ_OPTS = []
    if random.random() < 0.5:
        NANS = True
    else:
        NANS = False
        FUZZ_OPTS += ['--no-fuzz-nans']
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
    print('randomized settings (NaNs, OOB, legalize):', NANS, OOB, LEGALIZE)


# Test outputs we want to ignore are marked this way.
IGNORE = '[binaryen-fuzzer-ignore]'


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
        x = eval(x)
        y = eval(y)
        return x == y or float(x) == float(y)
    except Exception as e:
        print('failed to check if numbers are close enough:', e)
        return False


# compare between vms, which may slightly change how numbers are printed
def compare_between_vms(x, y, context):
    x_lines = x.splitlines()
    y_lines = y.splitlines()
    if len(x_lines) != len(y_lines):
        return compare(x, y, context)

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
    out = out.replace('[trap ', 'exception: [trap ')
    # exceptions may differ when optimizing, but an exception should occur. so ignore their types
    # also js engines print them out slightly differently
    return '\n'.join(map(lambda x: '     *exception*' if 'exception' in x else x, out.splitlines()))


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


def run_d8(wasm):
    return run_vm([shared.V8] + shared.V8_OPTS + [in_binaryen('scripts', 'fuzz_shell.js'), '--', wasm])


# wabt integration

try:
    wabt_bin = run(['whereis', 'wasm2c'])
    wabt_bin = wabt_bin.split()[-1]  # whereis returns    wasm2c: PATH
except Exception:
    wabt_bin = None

def get_wasm2c_dir():
    wabt_root = os.path.dirname(os.path.dirname(wabt_bin))
    return os.path.join(wabt_root, 'wasm2c')


# There are two types of test case handlers:
#    * get_commands() users: these return a list of commands to run (for example, "run this wasm-opt
#        command, then that one"). The calling code gets and runs those commands on the test wasm
#        file, and has enough information and control to be able to perform auto-reduction of any
#        bugs found.
#    * Totally generic: These receive the input pattern, a wasm generated from it, and a wasm
#        optimized from that, and can then do anything it wants with those.
class TestCaseHandler:
    # how frequent this handler will be run. 1 means always run it, 0.5 means half the
    # time
    frequency = 1

    def __init__(self):
        self.num_runs = 0

    # If the core handle_pair() method is not overridden, it calls handle_single()
    # on each of the pair. That is useful if you just want the two wasms, and don't
    # care about their relationship
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
    def __init__(self, name, run, can_run, can_compare_to_self, can_compare_to_others):
        self.name = name
        self.run = run
        self.can_run = can_run
        self.can_compare_to_self = can_compare_to_self
        self.can_compare_to_others = can_compare_to_others


class CompareVMs(TestCaseHandler):
    def __init__(self):
        super(CompareVMs, self).__init__()

        def byn_run(wasm):
            return run_bynterp(wasm, ['--fuzz-exec-before'])

        def v8_run(wasm):
            run([in_bin('wasm-opt'), wasm, '--emit-js-wrapper=' + wasm + '.js'] + FEATURE_OPTS)
            return run_vm([shared.V8, wasm + '.js'] + shared.V8_OPTS + ['--', wasm])

        def wasm2c_run(wasm):
            # this expects wasm2c to be in the path
            run([in_bin('wasm-opt'), wasm, '--emit-wasm2c-wrapper=main.c'] + FEATURE_OPTS)
            run(['wasm2c', wasm, '-o', 'wasm.c'])
            compile_cmd = ['cc', 'main.c', 'wasm.c', os.path.join(get_wasm2c_dir(), 'wasm-rt-impl.c'), '-I' + get_wasm2c_dir(), '-lm']
            if random.random() < 0.5:
              compile_cmd += ['-O' + str(random.randint(1, 3))]
            run(compile_cmd)
            return run_vm(['./a.out'])

        def yes():
            return True

        def if_legal_and_no_nans():
            # if not legalized, the JS will fail immediately
            # with nans, VM differences can confuse us
            return LEGALIZE and not NANS

        def if_no_nans():
            # if not legalized, the JS will fail immediately
            # with nans, VM differences can confuse us
            return not NANS

        def if_no_oob():
            return not OOB

        def if_mvp():
            return all([x in FEATURE_OPTS for x in ['--disable-exception-handling', '--disable-simd', '--disable-threads', '--disable-bulk-memory', '--disable-nontrapping-float-to-int', '--disable-tail-call', '--disable-sign-ext', '--disable-reference-types']])

        self.vms = [
            VM('binaryen interpreter', byn_run,    can_run=yes,    can_compare_to_self=yes,        can_compare_to_others=yes),
            VM('d8',                   v8_run,     can_run=yes,    can_compare_to_self=if_no_nans, can_compare_to_others=if_legal_and_no_nans),
            VM('wasm2c',               wasm2c_run, can_run=if_mvp, can_compare_to_self=yes,        can_compare_to_others=if_no_oob),
        ]

    def handle_pair(self, input, before_wasm, after_wasm, opts):
        before = self.run_vms(before_wasm)
        after = self.run_vms(after_wasm)
        self.compare_before_and_after(before, after)

    def run_vms(self, wasm):
        results = []
        for vm in self.vms:
            # when a vm can't run, mark the result as None
            if vm.can_run():
                results.append(fix_output(vm.run(wasm)))
            else:
                results.append(None)

        # compare between the vms on this specific input

        first = None
        for i in range(len(results)):
            # No legalization for JS means we can't compare JS to others, as any
            # illegal export will fail immediately.
            vm = self.vms[i]
            if vm.can_compare_to_others() and results[i] is not None:
                if first is None:
                    first = i
                else:
                    compare_between_vms(results[first], results[i], 'CompareVMs between VMs: ' + self.vms[first].name + ' and ' + vm.name)

        return results

    def compare_before_and_after(self, before, after):
        # compare each VM to itself on the before and after inputs
        for i in range(len(before)):
            vm = self.vms[i]
            if vm.can_compare_to_self() and before[i] is not None:
                compare(before[i], after[i], 'CompareVMs between before and after: ' + vm.name)

    def can_run_on_feature_opts(self, feature_opts):
        return all([x in feature_opts for x in ['--disable-simd', '--disable-reference-types', '--disable-exception-handling']])


# Fuzz the interpreter with --fuzz-exec. This tests everything in a single command (no
# two separate binaries) so it's easy to reproduce.
class FuzzExec(TestCaseHandler):
    def get_commands(self, wasm, opts, random_seed):
        return [
            '%(MAX_INTERPRETER_ENV_VAR)s=%(MAX_INTERPRETER_DEPTH)d %(wasm_opt)s --fuzz-exec --fuzz-binary %(opts)s %(wasm)s' % {
                'MAX_INTERPRETER_ENV_VAR': MAX_INTERPRETER_ENV_VAR,
                'MAX_INTERPRETER_DEPTH': MAX_INTERPRETER_DEPTH,
                'wasm_opt': in_bin('wasm-opt'),
                'opts': ' '.join(opts),
                'wasm': wasm
            }
        ]


# Check for determinism - the same command must have the same output.
# Note that this doesn't use get_commands() intentionally, since we are testing
# for something that autoreduction won't help with anyhow (nondeterminism is very
# hard to reduce).
class CheckDeterminism(TestCaseHandler):
    # not that important
    frequency = 0.333

    def handle_pair(self, input, before_wasm, after_wasm, opts):
        # check for determinism
        run([in_bin('wasm-opt'), before_wasm, '-o', 'b1.wasm'] + opts)
        run([in_bin('wasm-opt'), before_wasm, '-o', 'b2.wasm'] + opts)
        assert open('b1.wasm', 'rb').read() == open('b2.wasm', 'rb').read(), 'output must be deterministic'


class Wasm2JS(TestCaseHandler):
    def handle_pair(self, input, before_wasm, after_wasm, opts):
        # always check for compiler crashes. without NaNs we can also compare
        # before and after (with NaNs, a reinterpret through memory might end up
        # different in JS than wasm)
        before = self.run(before_wasm)
        after = self.run(after_wasm)
        if not NANS:
            compare(before, after, 'Wasm2JS')

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
        with open('js.js', 'w') as f:
            f.write(glue)
            f.write(main)
            f.write(wrapper)
        out = fix_output(run_vm([shared.NODEJS, 'js.js', 'a.wasm']))
        if 'exception' in out:
            # exception, so ignoring - wasm2js does not have normal wasm trapping, so opts can eliminate a trap
            out = IGNORE
        return out

    def can_run_on_feature_opts(self, feature_opts):
        return all([x in feature_opts for x in ['--disable-exception-handling', '--disable-simd', '--disable-threads', '--disable-bulk-memory', '--disable-nontrapping-float-to-int', '--disable-tail-call', '--disable-sign-ext', '--disable-reference-types']])


class Asyncify(TestCaseHandler):
    def handle_pair(self, input, before_wasm, after_wasm, opts):
        # we must legalize in order to run in JS
        run([in_bin('wasm-opt'), before_wasm, '--legalize-js-interface', '-o', before_wasm] + FEATURE_OPTS)
        run([in_bin('wasm-opt'), after_wasm, '--legalize-js-interface', '-o', after_wasm] + FEATURE_OPTS)
        before = fix_output(run_d8(before_wasm))
        after = fix_output(run_d8(after_wasm))

        try:
            compare(before, after, 'Asyncify (before/after)')
        except Exception:
            # if we failed to just compare the builds before asyncify even runs,
            # then it may use NaNs or be sensitive to legalization; ignore it
            print('ignoring due to pre-asyncify difference')
            return

        # TODO: also something that actually does async sleeps in the code, say
        # on the logging commands?
        # --remove-unused-module-elements removes the asyncify intrinsics, which are not valid to call

        def do_asyncify(wasm):
            cmd = [in_bin('wasm-opt'), wasm, '--asyncify', '-o', 't.wasm']
            if random.random() < 0.5:
                cmd += ['--optimize-level=%d' % random.randint(1, 3)]
            if random.random() < 0.5:
                cmd += ['--shrink-level=%d' % random.randint(1, 2)]
            cmd += FEATURE_OPTS
            run(cmd)
            out = run_d8('t.wasm')
            # emit some status logging from asyncify
            print(out.splitlines()[-1])
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
        return all([x in feature_opts for x in ['--disable-exception-handling', '--disable-simd', '--disable-tail-call', '--disable-reference-types']])


# The global list of all test case handlers
testcase_handlers = [
    #FuzzExec(),
    CompareVMs(),
    #CheckDeterminism(),
    #Wasm2JS(),
    #Asyncify(),
]


# Do one test, given an input file for -ttf and some optimizations to run
def test_one(random_input, opts):
    randomize_pass_debug()
    randomize_feature_opts()
    randomize_fuzz_settings()
    print()

    generate_command = [in_bin('wasm-opt'), random_input, '-ttf', '-o', 'a.wasm'] + FUZZ_OPTS + FEATURE_OPTS
    if PRINT_WATS:
        printed = run(generate_command + ['--print'])
        with open('a.printed.wast', 'w') as f:
            f.write(printed)
    else:
        run(generate_command)
    wasm_size = os.stat('a.wasm').st_size
    bytes = wasm_size
    print('pre wasm size:', wasm_size)

    # first, run all handlers that use get_commands(). those don't need the second wasm in the
    # pair, since they all they do is return their commands, and expect us to run them, and
    # those commands do the actual testing, by operating on the original input wasm file. by
    # fuzzing the get_commands() ones first we can find bugs in creating the second wasm (that
    # has the opts run on it) before we try to create it later down for the passes that
    # expect to get it as one of their inputs.
    for testcase_handler in testcase_handlers:
        if testcase_handler.can_run_on_feature_opts(FEATURE_OPTS):
            if hasattr(testcase_handler, 'get_commands'):
                print('running testcase handler:', testcase_handler.__class__.__name__)
                testcase_handler.increment_runs()

                # if the testcase handler supports giving us a list of commands, then we can get those commands
                # and use them to do useful things like automatic reduction. in this case we give it the input
                # wasm plus opts and a random seed (if it needs any internal randomness; we want to have the same
                # value there if we reduce).
                random_seed = random.random()

                # gets commands from the handler, for a given set of optimizations. this is all the commands
                # needed to run the testing that that handler wants to do.
                def get_commands(opts):
                    return testcase_handler.get_commands(wasm='a.wasm', opts=opts + FUZZ_OPTS + FEATURE_OPTS, random_seed=random_seed)

                def write_commands_and_test(opts):
                    commands = get_commands(opts)
                    write_commands(commands, 't.sh')
                    subprocess.check_call(['bash', 't.sh'])

                try:
                    write_commands_and_test(opts)
                except subprocess.CalledProcessError:
                    print('')
                    print('====================')
                    print('Found a problem! See "t.sh" for the commands, and "input.wasm" for the input. Auto-reducing to "reduced.wasm" and "tt.sh"...')
                    print('====================')
                    print('')
                    # first, reduce the fuzz opts: keep removing until we can't
                    while 1:
                        reduced = False
                        for i in range(len(opts)):
                            # some opts can't be removed, like --flatten --dfo requires flatten
                            if opts[i] == '--flatten':
                                if i != len(opts) - 1 and opts[i + 1] in ('--dfo', '--local-cse', '--rereloop'):
                                    continue
                            shorter = opts[:i] + opts[i + 1:]
                            try:
                                write_commands_and_test(shorter)
                            except subprocess.CalledProcessError:
                                # great, the shorter one is good as well
                                opts = shorter
                                print('reduced opts to ' + ' '.join(opts))
                                reduced = True
                                break
                        if not reduced:
                            break
                    # second, reduce the wasm
                    # copy a.wasm to a safe place as the reducer will use the commands on new inputs, and the commands work on a.wasm
                    shutil.copyfile('a.wasm', 'input.wasm')
                    # add a command to verify the input. this lets the reducer see that it is indeed working on the input correctly
                    commands = [in_bin('wasm-opt') + ' -all a.wasm'] + get_commands(opts)
                    write_commands(commands, 'tt.sh')
                    # reduce the input to something smaller with the same behavior on the script
                    subprocess.check_call([in_bin('wasm-reduce'), 'input.wasm', '--command=bash tt.sh', '-t', 'a.wasm', '-w', 'reduced.wasm'])
                    print('Finished reduction. See "tt.sh" and "reduced.wasm".')
                    raise Exception('halting after autoreduction')
                print('')

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

    # run some of the pair handling handlers. we don't run them all so that we get more
    # coverage of different wasm files (but we do run all get_commands() using ones,
    # earlier, because those are autoreducible and we want to maximize the chance of
    # that)
    # however, also try our best to pick a handler that can run this
    relevant_handlers = [handler for handler in testcase_handlers if not hasattr(handler, 'get_commands') and handler.can_run_on_feature_opts(FEATURE_OPTS)]
    NUM_PAIR_HANDLERS = 2
    if len(relevant_handlers) > 0:
        chosen_handlers = set(random.choices(relevant_handlers, k=NUM_PAIR_HANDLERS))
        for testcase_handler in chosen_handlers:
            assert testcase_handler.can_run_on_feature_opts(FEATURE_OPTS)
            assert not hasattr(testcase_handler, 'get_commands')
            if random.random() < testcase_handler.frequency:
                print('running testcase handler:', testcase_handler.__class__.__name__)
                testcase_handler.increment_runs()

                # let the testcase handler handle this testcase however it wants. in this case we give it
                # the input and both wasms.
                testcase_handler.handle_pair(input=random_input, before_wasm='a.wasm', after_wasm='b.wasm', opts=opts + FUZZ_OPTS + FEATURE_OPTS)
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
    ret = []
    # core opts
    while 1:
        choice = random.choice(opt_choices)
        if '--flatten' in ret and '--flatten' in choice:
            print('avoiding multiple --flatten in a single command, due to exponential overhead')
        else:
            ret += choice
        if len(ret) > 20 or random.random() < 0.3:
            break
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
POSSIBLE_FEATURE_OPTS = run([in_bin('wasm-opt'), '--print-features', '-all', in_binaryen('test', 'hello_world.wat'), '-all']).replace('--enable', '--disable').strip().split('\n')
print('POSSIBLE_FEATURE_OPTS:', POSSIBLE_FEATURE_OPTS)

if __name__ == '__main__':
    # if we are given a seed, run exactly that one testcase. otherwise,
    # run new ones until we fail
    if len(sys.argv) == 2:
        given_seed = int(sys.argv[1])
        print('checking a single given seed', given_seed)
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
            total_wasm_size += test_one(raw_input_data, opts)
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
            else:
                print('''\
================================================================================
You found a bug! Please report it with

  seed: %(seed)d

and the exact version of Binaryen you found it on, plus the exact Python
version (hopefully deterministic random numbers will be identical).

(you can run that testcase again with "fuzz_opt.py %(seed)d")
================================================================================
                ''' % {'seed': seed})
                break
        if given_seed is not None:
            if given_seed_passed:
                print('(finished running seed %d without error)' % given_seed)
            else:
                print('(finished running seed %d, see error above)' % given_seed)
            break

        print('\nInvocations so far:')
        for testcase_handler in testcase_handlers:
            print('  ', testcase_handler.__class__.__name__ + ':', testcase_handler.count_runs())
