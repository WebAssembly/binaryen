import os
from scripts.test.shared import WASM_OPT, run_process, options


def input_path(filename):
  return os.path.join(options.binaryen_test, 'unit', 'input', filename)


def roundtrip(testcase, filename, opts=[]):
  path = input_path(filename)
  p = run_process(WASM_OPT + ['-g', '-o', '-', path] + opts, check=False,
                  capture_output=True)
  testcase.assertEqual(p.returncode, 0)
  testcase.assertEqual(p.stderr, '')
  with open(path, 'rb') as f:
    testcase.assertEqual(str(p.stdout), str(f.read()))

def check_features(testcase, filename, features, opts=[]):
  path = input_path(filename)
  cmd = WASM_OPT + ['--print-features', '-o', os.devnull, path] + opts
  p = run_process(cmd, check=False, capture_output=True)
  testcase.assertEqual(p.returncode, 0)
  testcase.assertEqual(p.stderr, '')
  testcase.assertEqual(p.stdout.split('\n')[:-1],
                       ['--enable-' + f for f in features])
