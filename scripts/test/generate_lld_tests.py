#!/usr/bin/env python
#
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

from __future__ import print_function

import os
import sys

import shared
import support


def files_with_extensions(path, extensions):
    for file in sorted(os.listdir(path)):
        ext = os.path.splitext(file)[1]
        if ext in extensions:
            yield file, ext


def generate_wast_files(llvm_bin, emscripten_root):
    print('\n[ building wast files from C sources... ]\n')

    lld_path = os.path.join(shared.options.binaryen_test, 'lld')
    for src_file, ext in files_with_extensions(lld_path, ['.c', '.cpp']):
        print('..', src_file)
        obj_file = src_file.replace(ext, '.o')

        src_path = os.path.join(lld_path, src_file)
        obj_path = os.path.join(lld_path, obj_file)

        wasm_file = src_file.replace(ext, '.wasm')
        wast_file = src_file.replace(ext, '.wast')

        obj_path = os.path.join(lld_path, obj_file)
        wasm_path = os.path.join(lld_path, wasm_file)
        wast_path = os.path.join(lld_path, wast_file)
        is_shared = 'shared' in src_file

        compile_cmd = [
            os.path.join(llvm_bin, 'clang'), src_path, '-o', obj_path,
            '--target=wasm32-emscripten',
            '-mllvm', '-enable-emscripten-sjlj',
            '-c',
            '-nostdinc',
            '-Xclang', '-nobuiltininc',
            '-Xclang', '-nostdsysteminc',
            '-Xclang', '-I%s/system/include' % emscripten_root,
            '-O1',
        ]

        link_cmd = [
            os.path.join(llvm_bin, 'wasm-ld'), '-flavor', 'wasm',
            '-z', '-stack-size=1048576',
            obj_path, '-o', wasm_path,
            '--allow-undefined',
            '--export', '__wasm_call_ctors',
            '--export', '__data_end',
            '--global-base=568',
        ]
        if is_shared:
            compile_cmd.append('-fPIC')
            compile_cmd.append('-fvisibility=default')
            link_cmd.append('-shared')
        else:
            link_cmd.append('--entry=main')

        try:
            support.run_command(compile_cmd)
            support.run_command(link_cmd)
            support.run_command(shared.WASM_DIS + [wasm_path, '-o', wast_path])
        finally:
            # Don't need the .o or .wasm files, don't leave them around
            shared.delete_from_orbit(obj_path)
            shared.delete_from_orbit(wasm_path)


if __name__ == '__main__':
    if len(shared.options.positional_args) != 2:
        print('Usage: generate_lld_tests.py [llvm/bin/dir] [path/to/emscripten]')
        sys.exit(1)
    generate_wast_files(*shared.options.positional_args)
