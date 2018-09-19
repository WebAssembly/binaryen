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
import sys
import difflib
import subprocess
import random
import shutil
import time

# parameters

LOG_LIMIT = 125
INPUT_SIZE_LIMIT = 250 * 1024


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


def test_one(infile, opts):
  def compare(x, y, comment):
    if x != y:
      message = ''.join([a.rstrip() + '\n' for a in difflib.unified_diff(x.split('\n'), y.split('\n'), fromfile='expected', tofile='actual')])
      raise Exception(str(comment) + ": Expected to have '%s' == '%s', diff:\n\n%s" % (
        x, y,
        message
      ))

  def run_vms(prefix):
    def fix_output(out):
      # exceptions may differ when optimizing, but an exception should occur. so ignore their types
      # also js engines print them out slightly differently
      return '\n'.join(map(lambda x: '   *exception*' if 'exception' in x else x, out.split('\n')))

      # normalize different vm output
      # also the binaryen optimizer can reorder traps (but not remove them), so
      # it really just matters if you trap, not how you trap
      return out.replace('unreachable executed', 'unreachable') \
                .replace('integer result unrepresentable', 'integer overflow') \
                .replace('invalid conversion to integer', 'integer overflow') \
                .replace('memory access out of bounds', 'index out of bounds') \
                .replace('integer divide by zero', 'divide by zero') \
                .replace('integer remainder by zero', 'remainder by zero') \
                .replace('remainder by zero', 'divide by zero') \
                .replace('divide result unrepresentable', 'integer overflow') \
                .replace('divide by zero', 'integer overflow') \
                .replace('index out of bounds', 'integer overflow') \
                .replace('out of bounds memory access', 'integer overflow')

    def fix_spec_output(out):
      out = fix_output(out)
      # spec shows a pointer when it traps, remove that
      out = '\n'.join(map(lambda x: x if 'runtime trap' not in x else x[x.find('runtime trap'):], out.split('\n')))
      # https://github.com/WebAssembly/spec/issues/543 , float consts are messed up
      out = '\n'.join(map(lambda x: x if 'f32' not in x and 'f64' not in x else '', out.split('\n')))
      return out

    results = []
    # append to this list to add results from VMs
    # results += [fix_output(run([os.path.expanduser('d8'), '--', prefix + 'js', prefix + 'wasm']))]
    # spec has no mechanism to not halt on a trap. so we just check until the first trap, basically
    # run(['../spec/interpreter/wasm', prefix + 'wasm'])
    # results += [fix_spec_output(run_unchecked(['../spec/interpreter/wasm', prefix + 'wasm', '-e', open(prefix + 'wat').read()]))]

    if len(results) == 0:
      results = [0]

    first = results[0]
    for i in range(len(results)):
      compare(first, results[i], 'comparing between vms at ' + str(i))

    return results

  randomize_pass_debug()

  bytes = 0

  # fuzz vms
  # gather VM outputs on input file
  run(['bin/wasm-opt', infile, '-ttf', '--emit-js-wrapper=a.js', '--emit-spec-wrapper=a.wat', '-o', 'a.wasm'])
  wasm_size = os.stat('a.wasm').st_size
  bytes += wasm_size
  print('pre js size :', os.stat('a.js').st_size, ' wasm size:', wasm_size)
  before = run_vms('a.')
  print('----------------')
  # gather VM outputs on processed file
  run(['bin/wasm-opt', 'a.wasm', '-o', 'b.wasm'] + opts)
  wasm_size = os.stat('b.wasm').st_size
  bytes += wasm_size
  print('post js size:', os.stat('a.js').st_size, ' wasm size:', wasm_size)
  shutil.copyfile('a.js', 'b.js')
  after = run_vms('b.')
  for i in range(len(before)):
    compare(before[i], after[i], 'comparing between builds at ' + str(i))
  # fuzz binaryen interpreter itself. separate invocation so result is easily fuzzable
  run(['bin/wasm-opt', 'a.wasm', '--fuzz-exec', '--fuzz-binary'] + opts)

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

if len(sys.argv) >= 2:
  print('checking given input')
  if len(sys.argv) >= 3:
    test_one(sys.argv[1], sys.argv[2:])
  else:
    for opts in opt_choices:
      print(opts)
      test_one(sys.argv[1], opts)
else:
  print('checking infinite random inputs')
  random.seed(time.time())
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
