import os
import unittest
from scripts.test.shared import WASM_OPT, run_process, options


class BinaryenTestCase(unittest.TestCase):
  def input_path(self, filename):
    return os.path.join(options.binaryen_test, 'unit', 'input', filename)

  def roundtrip(self, filename, opts=[]):
    path = self.input_path(filename)
    p = run_process(WASM_OPT + ['-g', '-o', '-', path] + opts, check=False,
                    capture_output=True)
    self.assertEqual(p.returncode, 0)
    self.assertEqual(p.stderr, '')
    with open(path, 'rb') as f:
      self.assertEqual(str(p.stdout), str(f.read()))

  def disassemble(self, filename):
    path = self.input_path(filename)
    p = run_process(WASM_OPT + ['--print', '-o', os.devnull, path], check=False,
                    capture_output=True)
    self.assertEqual(p.returncode, 0)
    self.assertEqual(p.stderr, '')
    return p.stdout

  def check_features(self, filename, features, opts=[]):
    path = self.input_path(filename)
    cmd = WASM_OPT + ['--print-features', '-o', os.devnull, path] + opts
    p = run_process(cmd, check=False, capture_output=True)
    self.assertEqual(p.returncode, 0)
    self.assertEqual(p.stderr, '')
    self.assertEqual(p.stdout.split('\n')[:-1],
                     ['--enable-' + f for f in features])
