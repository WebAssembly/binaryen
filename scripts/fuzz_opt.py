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
import subprocess
import random
import re
import shutil
import sys
import time

from test.shared import options, NODEJS, V8_OPTS


# parameters

NANS = True

# feature options that are always passed to the tools.
# exceptions: https://github.com/WebAssembly/binaryen/issues/2195
# simd: known issues with d8
# atomics, bulk memory: doesn't work in wasm2js
# truncsat: https://github.com/WebAssembly/binaryen/issues/2198
# tail-call: WIP
CONSTANT_FEATURE_OPTS = ['--all-features']

# possible feature options that are sometimes passed to the tools.
POSSIBLE_FEATURE_OPTS = ['--disable-exception-handling', '--disable-simd', '--disable-threads', '--disable-bulk-memory', '--disable-nontrapping-float-to-int', '--disable-tail-call']

FUZZ_OPTS = []

INPUT_SIZE_LIMIT = 150 * 1024

LOG_LIMIT = 125


# utilities


def in_binaryen(*args):
  return os.path.join(options.binaryen_root, *args)


def in_bin(tool):
  return os.path.join(options.binaryen_root, 'bin', tool)


def random_size():
  return random.randint(1, INPUT_SIZE_LIMIT)


def run(cmd):
  print(' '.join(cmd)[:LOG_LIMIT])
  return subprocess.check_output(cmd)


def run_unchecked(cmd):
  print(' '.join(cmd)[:LOG_LIMIT])
  return subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT).communicate()[0]


def randomize_pass_debug():
  if random.random() < 0.125:
    print('[pass-debug]')
    os.environ['BINARYEN_PASS_DEBUG'] = '1'
  else:
    os.environ['BINARYEN_PASS_DEBUG'] = '0'
    del os.environ['BINARYEN_PASS_DEBUG']


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
  print('feature opts:', ' '.join(FEATURE_OPTS))


# Test outputs we want to ignore are marked this way.
IGNORE = '[binaryen-fuzzer-ignore]'


def compare(x, y, context):
  if x != y and x != IGNORE and y != IGNORE:
    message = ''.join([a + '\n' for a in difflib.unified_diff(x.splitlines(), y.splitlines(), fromfile='expected', tofile='actual')])
    raise Exception(context + " comparison error, expected to have '%s' == '%s', diff:\n\n%s" % (
      x, y,
      message
    ))


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
  return '\n'.join(map(lambda x: '   *exception*' if 'exception' in x else x, out.splitlines()))


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
    'local count too large',  # ignore this; can be caused by flatten, ssa, etc. passes
    'liftoff-assembler.cc, line 239\n',  # https://bugs.chromium.org/p/v8/issues/detail?id=8631
    'liftoff-assembler.cc, line 245\n',  # https://bugs.chromium.org/p/v8/issues/detail?id=8631
    'liftoff-register.h, line 86\n',  # https://bugs.chromium.org/p/v8/issues/detail?id=8632
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
  return run_vm(['d8'] + V8_OPTS + [in_binaryen('scripts', 'fuzz_shell.js'), '--', wasm])


# There are two types of test case handlers:
#  * get_commands() users: these return a list of commands to run (for example, "run this wasm-opt
#    command, then that one"). The calling code gets and runs those commands on the test wasm
#    file, and has enough information and control to be able to perform auto-reduction of any
#    bugs found.
#  * Totally generic: These receive the input pattern, a wasm generated from it, and a wasm
#    optimized from that, and can then do anything it wants with those.
class TestCaseHandler:
  # If the core handle_pair() method is not overridden, it calls handle_single()
  # on each of the pair. That is useful if you just want the two wasms, and don't
  # care about their relationship
  def handle_pair(self, input, before_wasm, after_wasm, opts):
    self.handle(before_wasm)
    self.handle(after_wasm)

  def can_run_on_feature_opts(self, feature_opts):
    return True


# Run VMs and compare results
class CompareVMs(TestCaseHandler):
  def handle_pair(self, input, before_wasm, after_wasm, opts):
    run([in_bin('wasm-opt'), before_wasm, '--emit-js-wrapper=a.js', '--emit-spec-wrapper=a.wat'] + FEATURE_OPTS)
    run([in_bin('wasm-opt'), after_wasm, '--emit-js-wrapper=b.js', '--emit-spec-wrapper=b.wat'] + FEATURE_OPTS)
    before = self.run_vms('a.js', before_wasm)
    after = self.run_vms('b.js', after_wasm)
    self.compare_vs(before, after)

  def run_vms(self, js, wasm):
    results = []
    results.append(fix_output(run_bynterp(wasm, ['--fuzz-exec-before'])))
    results.append(fix_output(run_vm(['d8', js] + V8_OPTS + ['--', wasm])))

    # append to add results from VMs
    # results += [fix_output(run_vm(['d8', js] + V8_OPTS + ['--', wasm]))]
    # results += [fix_output(run_vm([os.path.expanduser('~/.jsvu/jsc'), js, '--', wasm]))]
    # spec has no mechanism to not halt on a trap. so we just check until the first trap, basically
    # run(['../spec/interpreter/wasm', wasm])
    # results += [fix_spec_output(run_unchecked(['../spec/interpreter/wasm', wasm, '-e', open(prefix + 'wat').read()]))]

    if len(results) == 0:
      results = [0]

    # NaNs are a source of nondeterminism between VMs; don't compare them
    if not NANS:
      first = results[0]
      for i in range(len(results)):
        compare(first, results[i], 'CompareVMs at ' + str(i))

    return results

  def compare_vs(self, before, after):
    for i in range(len(before)):
      compare(before[i], after[i], 'CompareVMs at ' + str(i))
      # with nans, we can only compare the binaryen interpreter to itself
      if NANS:
        break

  def can_run_on_feature_opts(self, feature_opts):
    return all([x in feature_opts for x in ['--disable-simd']])


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


# As FuzzExec, but without a separate invocation. This can find internal bugs with generating
# the IR (which might be worked around by writing it and then reading it).
class FuzzExecImmediately(TestCaseHandler):
  def handle_pair(self, input, before_wasm, after_wasm, opts):
    # fuzz binaryen interpreter itself. separate invocation so result is easily reduceable
    run_bynterp(before_wasm, ['--fuzz-exec', '--fuzz-binary'] + opts)


# Check for determinism - the same command must have the same output.
# Note that this doesn't use get_commands() intentionally, since we are testing
# for something that autoreduction won't help with anyhow (nondeterminism is very
# hard to reduce).
class CheckDeterminism(TestCaseHandler):
  def handle_pair(self, input, before_wasm, after_wasm, opts):
    # check for determinism
    run([in_bin('wasm-opt'), before_wasm, '-o', 'b1.wasm'] + opts)
    run([in_bin('wasm-opt'), before_wasm, '-o', 'b2.wasm'] + opts)
    assert open('b1.wasm').read() == open('b2.wasm').read(), 'output must be deterministic'


class Wasm2JS(TestCaseHandler):
  def handle_pair(self, input, before_wasm, after_wasm, opts):
    compare(self.run(before_wasm), self.run(after_wasm), 'Wasm2JS')

  def run(self, wasm):
    # TODO: wasm2js does not handle nans precisely, and does not
    # handle oob loads etc. with traps, should we use
    #   FUZZ_OPTS += ['--no-fuzz-nans']
    #   FUZZ_OPTS += ['--no-fuzz-oob']
    # ?
    wrapper = run([in_bin('wasm-opt'), wasm, '--emit-js-wrapper=/dev/stdout'] + FEATURE_OPTS)
    cmd = [in_bin('wasm2js'), wasm, '--emscripten']
    if random.random() < 0.5:
      cmd += ['-O']
    main = run(cmd + FEATURE_OPTS)
    with open(os.path.join(options.binaryen_root, 'scripts', 'wasm2js.js')) as f:
      glue = f.read()
    with open('js.js', 'w') as f:
      f.write(glue)
      f.write(main)
      f.write(wrapper)
    out = fix_output(run_vm([NODEJS, 'js.js', 'a.wasm']))
    if 'exception' in out:
      # exception, so ignoring - wasm2js does not have normal wasm trapping, so opts can eliminate a trap
      out = IGNORE
    return out

  def can_run_on_feature_opts(self, feature_opts):
    return all([x in feature_opts for x in ['--disable-exception-handling', '--disable-simd', '--disable-threads', '--disable-bulk-memory', '--disable-nontrapping-float-to-int']])


class Asyncify(TestCaseHandler):
  def handle_pair(self, input, before_wasm, after_wasm, opts):
    # we must legalize in order to run in JS
    run([in_bin('wasm-opt'), before_wasm, '--legalize-js-interface', '-o', before_wasm] + FEATURE_OPTS)
    run([in_bin('wasm-opt'), after_wasm, '--legalize-js-interface', '-o', after_wasm] + FEATURE_OPTS)
    before = fix_output(run_d8(before_wasm))
    after = fix_output(run_d8(after_wasm))

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
      for ignore in ['[fuzz-exec] calling $asyncify_start_unwind\nexception!\n',
                     '[fuzz-exec] calling $asyncify_start_unwind\n',
                     '[fuzz-exec] calling $asyncify_start_rewind\nexception!\n',
                     '[fuzz-exec] calling $asyncify_start_rewind\n',
                     '[fuzz-exec] calling $asyncify_stop_rewind\n',
                     '[fuzz-exec] calling $asyncify_stop_unwind\n']:
        out = out.replace(ignore, '')
      out = '\n'.join([l for l in out.splitlines() if 'asyncify: ' not in l])
      return fix_output(out)

    before_asyncify = do_asyncify(before_wasm)
    after_asyncify = do_asyncify(after_wasm)

    compare(before, after, 'Asyncify (before/after)')
    compare(before, before_asyncify, 'Asyncify (before/before_asyncify)')
    compare(before, after_asyncify, 'Asyncify (before/after_asyncify)')

  def can_run_on_feature_opts(self, feature_opts):
    return all([x in feature_opts for x in ['--disable-exception-handling', '--disable-simd']])


# The global list of all test case handlers
testcase_handlers = [
  FuzzExec(),
  CompareVMs(),
  CheckDeterminism(),
  Wasm2JS(),
  Asyncify(),
  FuzzExecImmediately(),
]


# Do one test, given an input file for -ttf and some optimizations to run
def test_one(random_input, opts):
  randomize_pass_debug()
  randomize_feature_opts()

  run([in_bin('wasm-opt'), random_input, '-ttf', '-o', 'a.wasm'] + FUZZ_OPTS + FEATURE_OPTS)
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
          sys.exit(1)
        print('')

  # created a second wasm for handlers that want to look at pairs.
  run([in_bin('wasm-opt'), 'a.wasm', '-o', 'b.wasm'] + opts + FUZZ_OPTS + FEATURE_OPTS)
  wasm_size = os.stat('b.wasm').st_size
  bytes += wasm_size
  print('post wasm size:', wasm_size)

  for testcase_handler in testcase_handlers:
    if testcase_handler.can_run_on_feature_opts(FEATURE_OPTS):
      if not hasattr(testcase_handler, 'get_commands'):
        print('running testcase handler:', testcase_handler.__class__.__name__)
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
  ["--rse"],
  ["--simplify-locals"],
  ["--simplify-locals-nonesting"],
  ["--simplify-locals-nostructure"],
  ["--simplify-locals-notee"],
  ["--simplify-locals-notee-nostructure"],
  ["--ssa"],
  ["--vacuum"],
]


def get_multiple_opt_choices():
  ret = []
  # core opts
  while 1:
    ret += random.choice(opt_choices)
    if len(ret) > 20 or random.random() < 0.3:
      break
  # modifiers (if not already implied by a -O? option)
  if '-O' not in str(ret):
    if random.random() < 0.5:
      ret += ['--optimize-level=' + str(random.randint(0, 3))]
    if random.random() < 0.5:
      ret += ['--shrink-level=' + str(random.randint(0, 3))]
  return ret


# main

if not NANS:
  FUZZ_OPTS += ['--no-fuzz-nans']

if __name__ == '__main__':
  print('checking infinite random inputs')
  random.seed(time.time() * os.getpid())
  temp = 'input.dat'
  counter = 0
  bytes = 0  # wasm bytes tested
  start_time = time.time()
  while True:
    counter += 1
    f = open(temp, 'w')
    size = random_size()
    print('')
    print('ITERATION:', counter, 'size:', size, 'speed:', counter / (time.time() - start_time), 'iters/sec, ', bytes / (time.time() - start_time), 'bytes/sec\n')
    for x in range(size):
      f.write(chr(random.randint(0, 255)))
    f.close()
    opts = get_multiple_opt_choices()
    print('opts:', ' '.join(opts))
    bytes += test_one('input.dat', opts)
