import os
import platform
import tempfile
import unittest

from scripts.test import shared

from . import utils


def parse_stats(content):
    stats = {
        'modules': None,
        'functions': None,
        'patterns': {},
    }
    section = None
    for raw_line in content.strip().splitlines():
        line = raw_line.strip()
        if not line or line.startswith('#'):
            continue
        if line == 'Patterns:':
            section = 'patterns'
            continue
        if line == 'Events:':
            section = 'events'
            continue
        if section == 'patterns':
            parts = line.split()
            name = parts[0]
            stats['patterns'][name] = {
                'occurrences': int(parts[1]),
                'modules': int(parts[4]),
                'functions': int(parts[6]),
            }
            continue
        if line.startswith('Modules:'):
            stats['modules'] = int(line.split(':')[1].strip())
        elif line.startswith('Functions:'):
            stats['functions'] = int(line.split(':')[1].strip())
    return stats


class FuzzStatsTest(utils.BinaryenTestCase):
    def test_stats_file_created(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            stats_path = os.path.join(temp_dir, 'stats.txt')
            random_data = self.input_path('random_data.txt')
            env = dict(os.environ, BINARYEN_FUZZ_STATS=stats_path)

            shared.run_process(
                shared.WASM_OPT + [
                    '-ttf', random_data, '-q', '-o', os.devnull,
                ],
                env=env,
            )

            self.assertTrue(os.path.exists(stats_path))
            with open(stats_path) as f:
                content = f.read()

            self.assertIn('# Binaryen Fuzzing Statistics', content)
            stats = parse_stats(content)
            self.assertEqual(stats['modules'], 1)
            self.assertIsNotNone(stats['functions'])

    @unittest.skipIf(platform.system() == 'Windows',
                     'Windows line endings affect random data PRNG seed')
    def test_stats_file_updated_across_invocations(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            stats_path = os.path.join(temp_dir, 'stats.txt')
            wat_path = os.path.join(temp_dir, 'test.wat')
            with open(wat_path, 'w') as f:
                f.write(
                    """(module
  (func $foo (param $x (ref null any)) (result (ref null any))
    (drop (ref.test (ref null any) (local.get $x)))
    (drop (ref.cast (ref null any) (local.get $x)))
    (local.get $x)
  )
)""",
                )

            random_data = self.input_path('random_data.txt')
            env = dict(os.environ, BINARYEN_FUZZ_STATS=stats_path)
            cmd = shared.WASM_OPT + [
                '-ttf',
                random_data,
                f'--initial-fuzz={wat_path}',
                '--all-features',
                '-q',
                '-o',
                os.devnull,
            ]

            # First invocation
            shared.run_process(cmd, env=env)
            with open(stats_path) as f:
                stats1 = parse_stats(f.read())

            self.assertEqual(stats1['modules'], 1)
            self.assertEqual(stats1['functions'], 1)
            self.assertIn('ref_cast', stats1['patterns'])
            self.assertIn('ref_test', stats1['patterns'])
            self.assertEqual(stats1['patterns']['ref_cast']['occurrences'], 1)
            self.assertEqual(stats1['patterns']['ref_cast']['modules'], 1)
            self.assertEqual(stats1['patterns']['ref_test']['occurrences'], 1)
            self.assertEqual(stats1['patterns']['ref_test']['modules'], 1)

            # Second invocation
            shared.run_process(cmd, env=env)
            with open(stats_path) as f:
                stats2 = parse_stats(f.read())

            self.assertEqual(stats2['modules'], 2)
            self.assertEqual(stats2['functions'], 2)
            self.assertEqual(stats2['patterns']['ref_cast']['occurrences'], 2)
            self.assertEqual(stats2['patterns']['ref_cast']['modules'], 2)
            self.assertEqual(stats2['patterns']['ref_test']['occurrences'], 2)
            self.assertEqual(stats2['patterns']['ref_test']['modules'], 2)

            # Third invocation without initial-fuzz (empty function count)
            empty_cmd = shared.WASM_OPT + [
                '-ttf',
                random_data,
                '-q',
                '-o',
                os.devnull,
            ]
            shared.run_process(empty_cmd, env=env)
            with open(stats_path) as f:
                stats3 = parse_stats(f.read())

            self.assertEqual(stats3['modules'], 3)
            self.assertEqual(stats3['functions'], 2)
            # Pattern occurrences shouldn't change for module with no casts
            self.assertEqual(stats3['patterns']['ref_cast']['occurrences'], 2)
            self.assertEqual(stats3['patterns']['ref_cast']['modules'], 2)

    def test_stats_not_created_when_disabled(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            stats_path = os.path.join(temp_dir, 'stats.txt')
            random_data = self.input_path('random_data.txt')
            env = {
                k: v for k, v in os.environ.items()
                if k != 'BINARYEN_FUZZ_STATS'
            }

            shared.run_process(
                shared.WASM_OPT + [
                    '-ttf', random_data, '-q', '-o', os.devnull,
                ],
                env=env,
                cwd=temp_dir,
            )

            self.assertFalse(os.path.exists(stats_path))
            default_stats = os.path.join(temp_dir, 'fuzz-stats.txt')
            self.assertFalse(os.path.exists(default_stats))

    def test_default_filename(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            random_data = self.input_path('random_data.txt')
            env = dict(os.environ, BINARYEN_FUZZ_STATS='1')

            shared.run_process(
                shared.WASM_OPT + [
                    '-ttf', random_data, '-q', '-o', os.devnull,
                ],
                env=env,
                cwd=temp_dir,
            )

            default_stats = os.path.join(temp_dir, 'fuzz-stats.txt')
            self.assertTrue(os.path.exists(default_stats))
            with open(default_stats) as f:
                stats = parse_stats(f.read())
            self.assertEqual(stats['modules'], 1)
