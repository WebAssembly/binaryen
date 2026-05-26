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

import pathlib
import subprocess
import tempfile

from . import shared, support
from .shared import print_heading

spec_tests = [
]

def test_wasm2c_spec_output():
    for t in shared.options.spec_tests:
        test_path = pathlib.Path(t)
        if test_path.name not in spec_tests:
            continue

        print('..', test_path.name)

        is_fail_test = '.fail' in test_path.name

        test_subdir = f'wasm2c_spec_{test_path.stem}'
        test_subdir_path = pathlib.Path(test_subdir)
        test_subdir_path.mkdir(exist_ok=True)

        wasm2c_cmd = [shared.WASM2C[0], t, '-o', f'{test_subdir}/{test_path.stem}.c', '--allow-asserts']
        support.run_command(wasm2c_cmd, expected_status = (1 if is_fail_test else 0))

        c_sources = sorted(test_subdir_path.glob('*.c'))

        wasm_rt_dir = pathlib.Path(shared.options.binaryen_root) / 'src' / 'tools' / 'wasm2c' / 'wasm-rt'
        c_sources.append(wasm_rt_dir / 'wasm-rt-impl.c')
        c_sources.append(wasm_rt_dir / 'wasm-rt-mem-impl.c')
        c_sources.append(wasm_rt_dir / 'wasm-rt-exceptions-impl.c')

        compile_cmd = [shared.NATIVECC, '-O2', '-std=c11', '-D_GNU_SOURCE', '-D_DEFAULT_SOURCE', '-I.', f"-I{wasm_rt_dir}"] + [str(s) for s in c_sources] + ['-o', f'{test_subdir}/spec_test_runner']

        compile_cmd += ['-fno-optimize-sibling-calls', '-frounding-math']
        if 'gcc' in shared.NATIVECC.lower():
            compile_cmd.append('-fsignaling-nans')

        compile_cmd.append('-lm')
        compile_cmd.append('-lpthread')

        support.run_command(compile_cmd)

        # Run spec test runner binary and assert success
        support.run_command([f'{test_subdir}/spec_test_runner'])

def test_wasm2c_spec():
    print_heading('checking wasm2c spec testcases...')
    if shared.skip_if_on_windows('wasm2c-spec'):
        return
    test_wasm2c_spec_output()
