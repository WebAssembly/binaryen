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

from test.shared import options


# parameters

NANS = True

FUZZ_OPTS = ['--mvp-features']

INPUT_SIZE_LIMIT = 250 * 1024

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


def compare(x, y, comment):
  if x != y and x != IGNORE and y != IGNORE:
    message = ''.join([a.rstrip() + '\n' for a in difflib.unified_diff(x.split('\n'), y.split('\n'), fromfile='expected', tofile='actual')])
    raise Exception(str(comment) + ": Expected to have '%s' == '%s', diff:\n\n%s" % (
      x, y,
      message
    ))


def run_vms(prefix):
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
    return '\n'.join(map(lambda x: '   *exception*' if 'exception' in x else x, out.split('\n')))

  def fix_spec_output(out):
    out = fix_output(out)
    # spec shows a pointer when it traps, remove that
    out = '\n'.join(map(lambda x: x if 'runtime trap' not in x else x[x.find('runtime trap'):], out.split('\n')))
    # https://github.com/WebAssembly/spec/issues/543 , float consts are messed up
    out = '\n'.join(map(lambda x: x if 'f32' not in x and 'f64' not in x else '', out.split('\n')))
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
    except:
      output = run_unchecked(cmd)
      for issue in known_issues:
        if issue in output:
          return IGNORE
      raise

  results = []
  # append to this list to add results from VMs
  results += [fix_output(run_vm([in_bin('wasm-opt'), prefix + 'wasm', '--fuzz-exec-before']))]
  results += [fix_output(run_vm([os.path.expanduser('d8'), prefix + 'js', '--', prefix + 'wasm']))]
  # results += [fix_output(run_vm([os.path.expanduser('~/.jsvu/jsc'), prefix + 'js', '--', prefix + 'wasm']))]
  # spec has no mechanism to not halt on a trap. so we just check until the first trap, basically
  # run(['../spec/interpreter/wasm', prefix + 'wasm'])
  # results += [fix_spec_output(run_unchecked(['../spec/interpreter/wasm', prefix + 'wasm', '-e', open(prefix + 'wat').read()]))]

  if len(results) == 0:
    results = [0]

  # NaNs are a source of nondeterminism between VMs; don't compare them
  if not NANS:
    first = results[0]
    for i in range(len(results)):
      compare(first, results[i], 'comparing between vms at ' + str(i))

  return results


def test_one(infile, opts):
  randomize_pass_debug()

  bytes = 0

  # fuzz vms
  # gather VM outputs on input file
  run([in_bin('wasm-opt'), infile, '-ttf', '--emit-js-wrapper=a.js', '--emit-spec-wrapper=a.wat', '-o', 'a.wasm'] + FUZZ_OPTS)
  wasm_size = os.stat('a.wasm').st_size
  bytes += wasm_size
  print('pre js size :', os.stat('a.js').st_size, ' wasm size:', wasm_size)
  before = run_vms('a.')
  print('----------------')
  # gather VM outputs on processed file
  run([in_bin('wasm-opt'), 'a.wasm', '-o', 'b.wasm'] + opts)
  wasm_size = os.stat('b.wasm').st_size
  bytes += wasm_size
  print('post js size:', os.stat('a.js').st_size, ' wasm size:', wasm_size)
  shutil.copyfile('a.js', 'b.js')
  after = run_vms('b.')
  for i in range(len(before)):
    compare(before[i], after[i], 'comparing between builds at ' + str(i))
  # fuzz binaryen interpreter itself. separate invocation so result is easily fuzzable
  run([in_bin('wasm-opt'), 'a.wasm', '--fuzz-exec', '--fuzz-binary'] + opts)
  # check for determinism
  run([in_bin('wasm-opt'), 'a.wasm', '-o', 'b.wasm'] + opts)
  run([in_bin('wasm-opt'), 'a.wasm', '-o', 'c.wasm'] + opts)
  assert open('b.wasm').read() == open('c.wasm').read(), 'output must be deterministic'

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
    print('\nITERATION:', counter, 'size:', size, 'speed:', counter / (time.time() - start_time), 'iters/sec, ', bytes / (time.time() - start_time), 'bytes/sec\n')
    for x in range(size):
      f.write(chr(random.randint(0, 255)))
    f.close()
    opts = get_multiple_opt_choices()
    print('opts:', ' '.join(opts))
    bytes += test_one('input.dat', opts)
