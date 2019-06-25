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
import time

from test.shared import options, NODEJS


# parameters

NANS = True

FEATURE_OPTS = []  # '--all-features' etc

FUZZ_OPTS = []

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

INPUT_SIZE_LIMIT = 150 * 1024

LOG_LIMIT = 125


# utilities


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


def run_bynterp(wasm):
  return fix_output(run_vm([in_bin('wasm-opt'), wasm, '--fuzz-exec-before'] + FEATURE_OPTS))


# Each test case handler receives two wasm files, one before and one after some changes
# that should have kept it equivalent. It also receives the optimizations that the
# fuzzer chose to run.
class TestCaseHandler:
  # If the core handle_pair() method is not overridden, it calls handle_single()
  # on each of the pair. That is useful if you just want the two wasms, and don't
  # care about their relationship
  def handle_pair(self, before_wasm, after_wasm, opts):
    self.handle(before_wasm)
    self.handle(after_wasm)


# Run VMs and compare results
class CompareVMs(TestCaseHandler):
  def handle_pair(self, before_wasm, after_wasm, opts):
    run([in_bin('wasm-opt'), before_wasm, '--emit-js-wrapper=a.js', '--emit-spec-wrapper=a.wat'])
    run([in_bin('wasm-opt'), after_wasm, '--emit-js-wrapper=b.js', '--emit-spec-wrapper=b.wat'])
    before = self.run_vms('a.js', before_wasm)
    after = self.run_vms('b.js', after_wasm)
    self.compare_vs(before, after)

  def run_vms(self, js, wasm):
    results = []
    results.append(run_bynterp(wasm))
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


# Fuzz the interpreter with --fuzz-exec. This tests everything in a single command (no
# two separate binaries) so it's easy to reproduce.
class FuzzExec(TestCaseHandler):
  def handle_pair(self, before_wasm, after_wasm, opts):
    # fuzz binaryen interpreter itself. separate invocation so result is easily fuzzable
    run([in_bin('wasm-opt'), before_wasm, '--fuzz-exec', '--fuzz-binary'] + opts)


# Check for determinism - the same command must have the same output
class CheckDeterminism(TestCaseHandler):
  def handle_pair(self, before_wasm, after_wasm, opts):
    # check for determinism
    run([in_bin('wasm-opt'), before_wasm, '-o', 'b1.wasm'] + opts)
    run([in_bin('wasm-opt'), before_wasm, '-o', 'b2.wasm'] + opts)
    assert open('b1.wasm').read() == open('b2.wasm').read(), 'output must be deterministic'


class Wasm2JS(TestCaseHandler):
  def handle_pair(self, before_wasm, after_wasm, opts):
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


class Bysyncify(TestCaseHandler):
  def handle(self, wasm):
    # run normally and run in an async manner, and compare
    before = run([in_bin('wasm-opt'), wasm, '--fuzz-exec'])
    # TODO: also something that actually does async sleeps in the code, say
    # on the logging commands?
    # --remove-unused-module-elements removes the bysyncify intrinsics, which are not valid to call
    cmd = [in_bin('wasm-opt'), wasm, '--bysyncify', '--remove-unused-module-elements', '-o', 'by.wasm']
    if random.random() < 0.5:
      cmd += ['--optimize-level=3'] # TODO: more
    run(cmd)
    after = run([in_bin('wasm-opt'), 'by.wasm', '--fuzz-exec'])
    after = '\n'.join([line for line in after.splitlines() if '[fuzz-exec] calling $bysyncify' not in line])
    compare(before, after, 'Bysyncify')


# The global list of all test case handlers
testcase_handlers = [
  CompareVMs(),
  FuzzExec(),
  CheckDeterminism(),
  Wasm2JS(),
  #Bysyncify(),
]


# Do one test, given an input file for -ttf and some optimizations to run
def test_one(infile, opts):
  randomize_pass_debug()

  bytes = 0

  # fuzz vms
  # gather VM outputs on input file
  run([in_bin('wasm-opt'), infile, '-ttf', '-o', 'a.wasm'] + FUZZ_OPTS + FEATURE_OPTS)
  wasm_size = os.stat('a.wasm').st_size
  bytes += wasm_size
  print('pre js size :', os.stat('a.js').st_size, ' wasm size:', wasm_size)
  print('----------------')

  # gather VM outputs on processed file
  run([in_bin('wasm-opt'), 'a.wasm', '-o', 'b.wasm'] + opts + FUZZ_OPTS + FEATURE_OPTS)
  wasm_size = os.stat('b.wasm').st_size
  bytes += wasm_size
  print('post js size:', os.stat('a.js').st_size, ' wasm size:', wasm_size)
  shutil.copyfile('a.js', 'b.js')

  for testcase_handler in testcase_handlers:
    testcase_handler.handle_pair(before_wasm='a.wasm', after_wasm='b.wasm', opts=opts + FUZZ_OPTS + FEATURE_OPTS)

  return bytes


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
