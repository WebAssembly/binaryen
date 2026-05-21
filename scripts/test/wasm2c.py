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

import os
import re
import tempfile
import subprocess
from . import shared, support
from .shared import print_heading

SPEC_LIST = [
    'unreachable.wast',
]

def run_in_sandbox(cmd, temp_dir, expected_status=0):
    print("executing: ", " ".join(cmd))
    proc = subprocess.run(cmd, cwd=temp_dir, capture_output=True, text=True)
    if expected_status is not None and proc.returncode != expected_status:
        raise Exception(f"Command `{' '.join(cmd)}` failed with exit code {proc.returncode}. Stderr:\n{proc.stderr}")
    return proc.stdout, proc.stderr

def test_wasm2c_spec_execute(spec_wast_path):
    basename = os.path.basename(spec_wast_path)
    if basename not in SPEC_LIST:
        print('..', basename, '(skipped)')
        return

    print('..', basename)

    is_fail_test = '.fail.' in basename or basename.endswith('.fail.wast')

    try:
        splits = support.split_wast(spec_wast_path)
    except Exception as e:
        shared.fail_with_error(f"Failed to split wast {basename}: {e}")
        return

    with tempfile.TemporaryDirectory(delete=False, prefix=f"wasm2c_spec_{basename.replace('.wast', '').replace('.', '_')}_") as temp_dir:
        # Combine module definitions and assertions into a single combined wast file
        split_wast_path = os.path.join(temp_dir, 'split.wast')
        with open(split_wast_path, 'w') as sf:
            for module_wat, assertions in splits:
                if not module_wat:
                    continue
                if isinstance(module_wat, bytes):
                    sf.write(module_wat.decode('utf-8', errors='ignore'))
                else:
                    sf.write(module_wat)
                sf.write("\n\n")
                for a in assertions:
                    sf.write(a)
                    sf.write("\n")
                sf.write("\n\n")

        split_c = 'split.c'
        split_h = 'split.h'
        wasm2c_cmd = [shared.WASM2C[0], 'split.wast', '-o', split_c, '--allow-asserts']

        if is_fail_test:
            # Compile-failure test: expect validation to fail
            try:
                run_in_sandbox(wasm2c_cmd, temp_dir, expected_status=0)
                shared.fail_with_error(f"Expected wasm2c validation to fail for {basename}, but it succeeded!")
            except Exception as e:
                if "failed with exit code 1" in str(e):
                    print(f"Spec fail-test {basename} passed (failed validation as expected).")
                    return
                else:
                    raise e
            return
        else:
            run_in_sandbox(wasm2c_cmd, temp_dir)

        # Compile C source portably using NATIVECC
        c_sources = [os.path.join(temp_dir, 'split.c')]
        wasm2c_dir = os.path.join(shared.options.binaryen_root, 'wasm2c')
        c_sources.append(os.path.join(wasm2c_dir, 'wasm-rt-impl.c'))
        c_sources.append(os.path.join(wasm2c_dir, 'wasm-rt-mem-impl.c'))

        cmd = [shared.NATIVECC, '-O2', '-std=c11', '-D_GNU_SOURCE', '-D_DEFAULT_SOURCE', '-I.', f"-I{wasm2c_dir}", f"-I{temp_dir}"] + c_sources + ['-o', 'spec_test_runner']

        cmd += ['-fno-optimize-sibling-calls', '-frounding-math']
        if 'gcc' in shared.NATIVECC.lower():
            cmd.append('-fsignaling-nans')

        cmd.append('-lm')
        cmd.append('-lpthread')

        run_in_sandbox(cmd, temp_dir)

        # Run spec test runner binary and assert success
        actual_stdout, _ = run_in_sandbox(['./spec_test_runner'], temp_dir)

        if "assertions passed" not in actual_stdout:
            shared.fail_with_error(f"Spec runner failed to run correctly. Stdout:\n{actual_stdout}")
        else:
            match = re.search(r'(\d+)/(\d+) assertions passed', actual_stdout)
            if match:
                passed = int(match.group(1))
                total = int(match.group(2))
                if passed != total:
                    shared.fail_with_error(f"Spec test {basename} FAILED: {passed}/{total} passed.")
                else:
                    print(f"Spec test {basename} passed: {passed}/{total} assertions.")

def test_wasm2c_spec():
    print_heading('checking wasm2c compiled spec testcases...')
    if shared.skip_if_on_windows('wasm2c-spec'):
        return
    spec_tests = shared.options.spec_tests
    for t in spec_tests:
        test_wasm2c_spec_execute(t)
