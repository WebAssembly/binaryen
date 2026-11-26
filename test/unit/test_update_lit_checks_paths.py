import os
import subprocess
import sys
import tempfile
from pathlib import Path

from scripts.test import shared

from . import utils


class UpdateLitChecksPathsTest(utils.BinaryenTestCase):
    def test_paths_with_spaces(self):
        with tempfile.TemporaryDirectory(prefix='update lit checks ') as temp:
            root = Path(temp)
            # Exercise %s, %S, and %t, with both quoted and unquoted RUN lines.
            for run in (
                'wasm-opt %s -S -o -',
                'wasm-opt "%s" -S -o -',
                'wasm-opt "%S/input file.wat" -S -o %t.wat && wasm-opt %t.wat -S -o -',
                'foreach %s %t wasm-opt -S -o -',
                'foreach "%s" "%t" wasm-opt -S -o -',
            ):
                with self.subTest(run=run):
                    test = root / 'input file.wat'
                    test.write_text(';; RUN: ' + run + ' | filecheck %s\n'
                                    '(module\n'
                                    ' (func $answer (result i32) (i32.const 42))\n'
                                    ')\n')
                    env = dict(os.environ, TMPDIR=temp, TEMP=temp, TMP=temp)
                    command = [sys.executable,
                               os.path.join(shared.options.binaryen_root, 'scripts', 'update_lit_checks.py'),
                               '--binaryen-bin', shared.options.binaryen_bin,
                               '--force', '--dry-run', str(test)]
                    result = subprocess.run(command, env=env, capture_output=True, text=True)
                    self.assertEqual(result.returncode, 0, result.stderr)
                    self.assertIn(';; CHECK:', result.stdout)
                    self.assertIn('(i32.const 42)', result.stdout)
