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
