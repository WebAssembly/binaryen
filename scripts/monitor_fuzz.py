#!/usr/bin/env python3

# Copyright 2026 WebAssembly Community Group participants
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Run and monitor the Binaryen fuzzer (fuzz_opt.py).

Monitors progress, manages log file truncation, stops at iteration limits,
and reports bugs found.
"""

import argparse
import collections
import os
import re
import signal
import subprocess
import sys
import threading
import time


class FuzzMonitor:
    """Monitors fuzzer output stream, manages log files, and tracks state."""

    def __init__(self, log_path, max_lines, keep_lines, truncate_interval):
        self.log_path = log_path
        self.max_lines = max_lines
        self.keep_lines = keep_lines
        self.truncate_interval = truncate_interval

        self.lock = threading.Lock()
        self.latest_iteration = 0
        self.latest_seed = 'unknown'
        self.bug_found = False
        self.recent_lines = collections.deque(maxlen=20)

        self.deque = collections.deque(maxlen=keep_lines)
        self.lines_written = 0

        if os.path.isfile(log_path):
            try:
                with open(log_path, encoding='utf-8', errors='replace') as f:
                    for line in f:
                        self.deque.append(line)
                        self.recent_lines.append(line)
                        self.lines_written += 1
                        self._parse_line(line)
            except Exception:
                pass

    def _parse_line(self, line):
        iter_match = re.search(r'ITERATION:\s*(\d+)', line)
        if iter_match:
            self.latest_iteration = int(iter_match.group(1))

        seed_match = re.search(r'seed:\s*(\d+)', line)
        if seed_match:
            self.latest_seed = seed_match.group(1)

        if re.search(r'You found a bug', line, re.IGNORECASE):
            self.bug_found = True

    def run(self, stdout_stream):
        last_truncate = time.time()
        try:
            with open(self.log_path, 'a', encoding='utf-8') as f:
                for line in stdout_stream:
                    with self.lock:
                        self._parse_line(line)
                        self.deque.append(line)
                        self.recent_lines.append(line)
                        self.lines_written += 1

                    f.write(line)
                    f.flush()

                    now = time.time()
                    if (
                        self.lines_written >= self.max_lines
                        and (now - last_truncate) >= self.truncate_interval
                    ):
                        f.close()
                        with open(self.log_path, 'w', encoding='utf-8') as wf:
                            with self.lock:
                                wf.writelines(self.deque)
                                self.lines_written = len(self.deque)
                        f = open(self.log_path, 'a', encoding='utf-8')
                        last_truncate = now
        except Exception as e:
            print(f'Error writing to log file: {e}', file=sys.stderr)

    def get_progress(self):
        with self.lock:
            return self.latest_iteration

    def get_status(self):
        with self.lock:
            return (
                self.bug_found,
                self.latest_iteration,
                self.latest_seed,
                list(self.recent_lines),
            )


def parse_args():
    default_log_dir = os.path.join(
        os.path.dirname(os.path.abspath(__file__)), 'out', 'test')
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        '--log-dir',
        default=os.environ.get('LOG_DIR', default_log_dir),
        help='Directory to save fuzz.log (default: $LOG_DIR or ./out/test)',
    )
    parser.add_argument(
        '--max-iters',
        type=int,
        default=int(os.environ.get('MAX_ITERS', '0')),
        help='Stop after N iterations (0 for infinite, default: $MAX_ITERS or 0)',
    )
    parser.add_argument(
        '--truncate-interval',
        type=float,
        default=30.0,
        help='Seconds between log truncation checks (default: 30)',
    )
    parser.add_argument(
        '--max-lines',
        type=int,
        default=10000,
        help='Maximum lines in log before truncation (default: 10000)',
    )
    parser.add_argument(
        '--keep-lines',
        type=int,
        default=5000,
        help='Lines to keep when truncating (default: 5000)',
    )
    parser.add_argument(
        'cmd',
        nargs=argparse.REMAINDER,
        help='Fuzzer command to run (default: ./scripts/fuzz_opt.py)',
    )
    return parser.parse_args()


def main():
    args = parse_args()

    cmd = list(args.cmd)
    if cmd and cmd[0] == '--':
        cmd.pop(0)
    if not cmd:
        default_fuzzer = os.path.join(
            os.path.dirname(os.path.abspath(__file__)), 'fuzz_opt.py',
        )
        cmd = [sys.executable, default_fuzzer]

    os.makedirs(args.log_dir, exist_ok=True)
    log_file_path = os.path.join(args.log_dir, 'fuzz.log')

    monitor = FuzzMonitor(
        log_path=log_file_path,
        max_lines=args.max_lines,
        keep_lines=args.keep_lines,
        truncate_interval=args.truncate_interval,
    )

    env = os.environ.copy()
    env['PYTHONUNBUFFERED'] = '1'

    proc = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        bufsize=1,
        env=env,
        errors='replace',
        start_new_session=True,
    )

    print(f'Fuzzer started with PID {proc.pid}. Monitoring...', flush=True)

    reader_thread = threading.Thread(
        target=monitor.run,
        args=(proc.stdout,),
        daemon=True,
    )
    reader_thread.start()

    def stop_child():
        if proc.poll() is None:
            try:
                os.killpg(proc.pid, signal.SIGTERM)
            except ProcessLookupError:
                pass
            try:
                proc.wait(timeout=5)
            except subprocess.TimeoutExpired:
                try:
                    os.killpg(proc.pid, signal.SIGKILL)
                except ProcessLookupError:
                    pass
                proc.wait()

    def signal_handler(signum, _frame):
        stop_child()
        reader_thread.join(timeout=2.0)
        sys.exit(128 + signum)

    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)

    start_time = time.time()
    last_report = 0
    limit_reached = False

    try:
        while reader_thread.is_alive() or proc.poll() is None:
            reader_thread.join(timeout=1.0)
            now = time.time()
            elapsed = int(now - start_time)

            minute = elapsed // 60
            latest_iter = monitor.get_progress()

            if minute > last_report:
                last_report = minute
                timestamp = time.strftime('%H:%M:%S')
                print(
                    f'[{timestamp}] Runtime: {last_report} min, Latest'
                    f' Iteration: {latest_iter}',
                    flush=True,
                )

            if args.max_iters > 0 and latest_iter >= args.max_iters:
                print(
                    f'Reached max iterations ({args.max_iters}). Stopping'
                    ' fuzzer...',
                    flush=True,
                )
                limit_reached = True
                stop_child()
                break
    finally:
        stop_child()
        reader_thread.join(timeout=5.0)

    exit_code = proc.returncode

    if limit_reached:
        print(
            f'SUCCESS: Reached max iterations ({args.max_iters}) without finding'
            ' a bug.',
        )
        return 0

    bug_found, iteration, seed, recent_lines = monitor.get_status()

    if bug_found:
        print('SUCCESS: Bug found!')
        print(f'Iteration: {iteration}')
        print(f'Seed: {seed}')
        print(f'Exit code: {exit_code}')
        return 0

    print('FAILURE: Fuzzer stopped unexpectedly without finding a bug.')
    print(f'Exit code: {exit_code}')
    if recent_lines:
        print('Last 20 lines of log:')
        for line in recent_lines:
            print(line.rstrip('\r\n'))
    return 1


if __name__ == '__main__':
    sys.exit(main())
