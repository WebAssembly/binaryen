#!/usr/bin/env python
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
    if 'safe_stack' in filename:
        return ['--check-stack-overflow', '--global-base=568']
    elif 'shared' in filename:
        return ['--side-module']
    elif 'standalone-wasm' in filename:
        return ['--standalone-wasm', '--global-base=568']
    else:
        return ['--global-base=568']


def test_wasm_emscripten_finalize():
    print('\n[ checking wasm-emscripten-finalize testcases... ]\n')

    for wat_path in shared.get_tests(shared.get_test_dir('lld'), ['.wat']):
        print('..', wat_path)
        is_passive = '.passive.' in wat_path
        mem_file = wat_path + '.mem'
        extension_arg_map = {
            '.out': [],
        }
        if not is_passive:
            extension_arg_map.update({
                '.mem.out': ['--separate-data-segments', mem_file],
            })
        for ext, ext_args in extension_arg_map.items():
            expected_file = wat_path + ext
            if ext != '.out' and not os.path.exists(expected_file):
                continue

            cmd = shared.WASM_EMSCRIPTEN_FINALIZE + [wat_path, '-S'] + \
                ext_args
            cmd += args_for_finalize(os.path.basename(wat_path))
            actual = support.run_command(cmd)

            if not os.path.exists(expected_file):
                print(actual)
                shared.fail_with_error('output ' + expected_file +
                                       ' does not exist')
            shared.fail_if_not_identical_to_file(actual, expected_file)
            if ext == '.mem.out':
                with open(mem_file) as mf:
                    mem = mf.read()
                    shared.fail_if_not_identical_to_file(mem, wat_path +
                                                         '.mem.mem')
                os.remove(mem_file)


def update_lld_tests():
    print('\n[ updating wasm-emscripten-finalize testcases... ]\n')

    for wat_path in shared.get_tests(shared.get_test_dir('lld'), ['.wat']):
        print('..', wat_path)
        is_passive = '.passive.' in wat_path
        mem_file = wat_path + '.mem'
        extension_arg_map = {
            '.out': [],
        }
        if not is_passive:
            extension_arg_map.update({
                '.mem.out': ['--separate-data-segments', mem_file + '.mem'],
            })
        for ext, ext_args in extension_arg_map.items():
            out_path = wat_path + ext
            if ext != '.out' and not os.path.exists(out_path):
                continue
            cmd = shared.WASM_EMSCRIPTEN_FINALIZE + [wat_path, '-S'] + \
                ext_args
            cmd += args_for_finalize(os.path.basename(wat_path))
            actual = support.run_command(cmd)
            with open(out_path, 'w') as o:
                o.write(actual)


if __name__ == '__main__':
    test_wasm_emscripten_finalize()
