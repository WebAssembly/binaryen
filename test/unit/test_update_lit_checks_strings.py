import os
import subprocess
import sys
import tempfile
from pathlib import Path

from scripts.test import shared

from . import utils


class UpdateLitChecksStringsTest(utils.BinaryenTestCase):
    def test_parentheses_in_strings(self):
        # The updater must not treat data bytes as WAT delimiters. Include
        # escaped quotes and backslashes so the following function stays separate.
        strings = ['hello', 'hello(', 'hello)', 'hello(()', r'hello\"(', r'hello\\(']
        with tempfile.TemporaryDirectory() as temp:
            for string in strings:
                with self.subTest(string=string):
                    test = Path(temp) / 'input.wat'
                    test.write_text(';; RUN: wasm-opt %s -S -o - | filecheck %s\n'
                                    '(module\n'
                                    ' (memory $mem 1)\n'
                                    f' (data $data (i32.const 0) "{string}")\n'
                                    ' (func $after (result i32) (i32.const 42))\n'
                                    ')\n')
                    command = [sys.executable,
                               os.path.join(shared.options.binaryen_root, 'scripts', 'update_lit_checks.py'),
                               '--binaryen-bin', shared.options.binaryen_bin,
                               '--force', '--all-items', '--dry-run', str(test)]
                    result = subprocess.run(command, capture_output=True, text=True)
                    self.assertEqual(result.returncode, 0, result.stderr)
                    lines = result.stdout.splitlines()
                    # Both items get their own CHECK block, rather than the
                    # function being absorbed into data's CHECK-NEXT block.
                    self.assertEqual(sum(';; CHECK:' in line and '(func $after' in line
                                         for line in lines), 1, result.stdout)
                    self.assertFalse(any(';; CHECK-NEXT:' in line and '(func $after' in line
                                         for line in lines), result.stdout)
                    self.assertTrue(any(';; CHECK:' in line and '(data $data' in line
                                        and line.rstrip().endswith('")') for line in lines), result.stdout)
