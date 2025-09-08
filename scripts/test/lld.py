# Copyright 2017 WebAssembly Community Group participants
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
from . import shared
from . import support


def args_for_finalize(filename):
    ret = []
    if 'safe_stack' in filename:
        ret += ['--check-stack-overflow']
    if 'shared' in filename:
        ret += ['--side-module']
    if 'standalone-wasm' in filename:
        ret += ['--standalone-wasm']
    return ret


def run_test(input_path):
    print('..', input_path)
    expected_file = input_path + '.out'
    if not os.path.exists(expected_file):
        shared.fail_with_error('output ' + expected_file +
                               ' does not exist')

    cmd = list(shared.WASM_EMSCRIPTEN_FINALIZE)
    if '64' in input_path:
        cmd += ['--enable-memory64', '--bigint']
    cmd += [input_path, '-S']
    cmd += args_for_finalize(os.path.basename(input_path))
    actual = support.run_command(cmd)

    shared.fail_if_not_identical_to_file(actual, expected_file)


def test_wasm_emscripten_finalize():
    print('\n[ checking wasm-emscripten-finalize testcases... ]\n')

    for input_path in shared.get_tests(shared.get_test_dir('lld'), ['.wat', '.wasm']):
        run_test(input_path)


def update_lld_tests():
    print('\n[ updating wasm-emscripten-finalize testcases... ]\n')

    for input_path in shared.get_tests(shared.get_test_dir('lld'), ['.wat', '.wasm']):
        print('..', input_path)
        extension_arg_map = {
            '.out': [],
        }
        for ext, ext_args in extension_arg_map.items():
            out_path = input_path + ext
            if ext != '.out' and not os.path.exists(out_path):
                continue
            cmd = shared.WASM_EMSCRIPTEN_FINALIZE + ext_args
            if '64' in input_path:
                cmd += ['--enable-memory64', '--bigint']
            cmd += [input_path, '-S']
            cmd += args_for_finalize(os.path.basename(input_path))
            actual = support.run_command(cmd)

            with open(out_path, 'w') as o:
                o.write(actual)
