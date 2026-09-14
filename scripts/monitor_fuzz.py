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
                        self.lines_written += 1
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


class FuzzerWorker:
    """Manages a single fuzzer subprocess and its monitor."""

    def __init__(
        self,
        worker_id,
        work_dir,
        cmd,
        env,
        max_lines,
        keep_lines,
        truncate_interval,
    ):
        self.id = worker_id
        self.work_dir = work_dir
        os.makedirs(work_dir, exist_ok=True)
        self.log_path = os.path.join(work_dir, 'fuzz.log')
        self.monitor = FuzzMonitor(
            log_path=self.log_path,
            max_lines=max_lines,
            keep_lines=keep_lines,
            truncate_interval=truncate_interval,
        )
        worker_env = env.copy()
        worker_env['BINARYEN_OUT_DIR'] = work_dir
        self.proc = subprocess.Popen(
            cmd,
            cwd=work_dir,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            bufsize=1,
            env=worker_env,
            errors='replace',
            start_new_session=True,
        )
        self.reader_thread = threading.Thread(
            target=self.monitor.run,
            args=(self.proc.stdout,),
            daemon=True,
        )
        self.reader_thread.start()


def parse_args():
    # N.B. We could alternatively `import shared from test`, which has the side
    # effect of changing the current directory to <binaryen_root>/out/test, but
    # this is less magical.
    binaryen_root = os.path.dirname(
        os.path.dirname(os.path.abspath(__file__)))
    default_log_dir = os.path.join(binaryen_root, 'out', 'test')
    cores = os.cpu_count() or 1
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        '-j',
        '--jobs',
        type=int,
        nargs='?',
        const=cores,
        default=int(os.environ.get('JOBS', '1')),
        help=(
            f'Number of parallel fuzzers to run (default: $JOBS or 1; '
            f'defaults to {cores} if passed without an argument)'
        ),
    )
    parser.add_argument(
        '--log-dir',
        default=os.environ.get('LOG_DIR', default_log_dir),
        help='Directory to save fuzz logs (default: $LOG_DIR or out/test)',
    )
    parser.add_argument(
        '--max-iters',
        type=int,
        default=int(os.environ.get('MAX_ITERS', '0')),
        help='Stop after N total iterations across all fuzzers (0 for infinite, default: $MAX_ITERS or 0)',
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
    args = parser.parse_args()
    if args.jobs < 1:
        parser.error('--jobs must be at least 1')
    return args


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
    else:
        cmd = [
            os.path.abspath(arg) if os.path.exists(arg) else arg for arg in cmd
        ]

    env = os.environ.copy()
    env['PYTHONUNBUFFERED'] = '1'

    workers = []
    for i in range(args.jobs):
        work_dir = os.path.join(args.log_dir, str(i))
        workers.append(
            FuzzerWorker(
                worker_id=i,
                work_dir=work_dir,
                cmd=cmd,
                env=env,
                max_lines=args.max_lines,
                keep_lines=args.keep_lines,
                truncate_interval=args.truncate_interval,
            ),
        )

    if len(workers) == 1:
        print(
            f'Fuzzer started with PID {workers[0].proc.pid}. Monitoring...',
            flush=True,
        )
    else:
        pids = ', '.join(str(w.proc.pid) for w in workers)
        print(
            f'Started {len(workers)} fuzzers with PIDs {pids}. Monitoring...',
            flush=True,
        )

    def stop_children():
        for w in workers:
            if w.proc.poll() is None:
                try:
                    os.killpg(w.proc.pid, signal.SIGTERM)
                except ProcessLookupError:
                    pass
        deadline = time.time() + 5.0
        for w in workers:
            if w.proc.poll() is None:
                remaining = max(0.0, deadline - time.time())
                try:
                    w.proc.wait(timeout=remaining)
                except subprocess.TimeoutExpired:
                    try:
                        os.killpg(w.proc.pid, signal.SIGKILL)
                    except ProcessLookupError:
                        pass
                    w.proc.wait()

    def signal_handler(signum, _frame):
        stop_children()
        for w in workers:
            w.reader_thread.join(timeout=2.0)
        sys.exit(128 + signum)

    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)

    start_time = time.time()
    last_report = 0
    limit_reached = False
    stopped_worker = None

    try:
        while any(
            w.reader_thread.is_alive() or w.proc.poll() is None for w in workers
        ):
            time.sleep(0.2)
            now = time.time()
            elapsed = int(now - start_time)

            minute = elapsed // 60
            total_iters = sum(w.monitor.get_progress() for w in workers)

            if minute > last_report:
                last_report = minute
                timestamp = time.strftime('%H:%M:%S')
                print(
                    f'[{timestamp}] Runtime: {last_report} min,'
                    f' Iterations: {total_iters}',
                    flush=True,
                )

            if args.max_iters > 0 and total_iters >= args.max_iters:
                fuzzer_str = 'fuzzer' if len(workers) == 1 else 'fuzzers'
                print(
                    f'Reached max iterations ({args.max_iters}). Stopping'
                    f' {fuzzer_str}...',
                    flush=True,
                )
                limit_reached = True
                stop_children()
                break

            should_stop = False
            for w in workers:
                if w.monitor.get_status()[0]:
                    try:
                        w.proc.wait(timeout=2.0)
                    except subprocess.TimeoutExpired:
                        pass
                    w.reader_thread.join(timeout=2.0)
                    stopped_worker = w
                    should_stop = True
                    break
                if w.proc.poll() is not None:
                    w.reader_thread.join(timeout=2.0)
                    stopped_worker = w
                    should_stop = True
                    break

            if should_stop:
                stop_children()
                break
    finally:
        stop_children()
        for w in workers:
            w.reader_thread.join(timeout=5.0)

    for w in workers:
        bug_found, iteration, seed, _ = w.monitor.get_status()
        if bug_found:
            print('SUCCESS: Bug found!')
            if len(workers) > 1:
                print(f'Fuzzer: {w.id}')
            print(f'Directory: {w.work_dir}')
            print(f'Iteration: {iteration}')
            print(f'Seed: {seed}')
            print(f'Exit code: {w.proc.returncode}')
            return 0

    if limit_reached:
        print(
            f'SUCCESS: Reached max iterations ({args.max_iters}) without finding'
            ' a bug.',
        )
        return 0

    failed_worker = stopped_worker or workers[0]
    _, _, _, recent_lines = failed_worker.monitor.get_status()

    print('FAILURE: Fuzzer stopped unexpectedly without finding a bug.')
    if len(workers) > 1:
        print(f'Fuzzer: {failed_worker.id}')
    print(f'Directory: {failed_worker.work_dir}')
    print(f'Exit code: {failed_worker.proc.returncode}')
    if recent_lines:
        print('Last 20 lines of log:')
        for line in recent_lines:
            print(line.rstrip('\r\n'))
    return 1


if __name__ == '__main__':
    sys.exit(main())
