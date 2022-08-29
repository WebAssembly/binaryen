#!/usr/bin/env python3
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


def generate_wat_files(llvm_bin, emscripten_sysroot):
    print('\n[ building wat files from C sources... ]\n')

    lld_path = os.path.join(shared.options.binaryen_test, 'lld')
    for src_file, ext in files_with_extensions(lld_path, ['.c', '.cpp', '.s']):
        print('..', src_file)
        obj_file = src_file.replace(ext, '.o')

        src_path = os.path.join(lld_path, src_file)
        obj_path = os.path.join(lld_path, obj_file)

        wasm_file = src_file.replace(ext, '.wasm')
        wat_file = src_file.replace(ext, '.wat')

        obj_path = os.path.join(lld_path, obj_file)
        wasm_path = os.path.join(lld_path, wasm_file)
        wat_path = os.path.join(lld_path, wat_file)
        is_shared = 'shared' in src_file
        is_64 = '64' in src_file

        compile_cmd = [
            os.path.join(llvm_bin, 'clang'), src_path, '-o', obj_path,
            '-mllvm', '-enable-emscripten-sjlj',
            '-c',
            '-nostdinc',
            '-Xclang', '-nobuiltininc',
            '-Xclang', '-nostdsysteminc',
            '-Xclang', '-I%s/include' % emscripten_sysroot,
            '-O1',
        ]

        link_cmd = [
            os.path.join(llvm_bin, 'wasm-ld'), '-flavor', 'wasm',
            obj_path, '-o', wasm_path,
            '--allow-undefined',
            '--export', '__wasm_call_ctors',
            '--export', '__start_em_asm',
            '--export', '__stop_em_asm',
            '--global-base=568',
        ]
        # We had a regression where this test only worked if debug names
        # were included.
        if 'longjmp' in src_file:
            link_cmd.append('--strip-debug')
        if is_shared:
            compile_cmd.append('-fPIC')
            compile_cmd.append('-fvisibility=default')
            link_cmd.append('-shared')
            link_cmd.append('--experimental-pic')
        else:
            if 'reserved_func_ptr' in src_file:
                link_cmd.append('--entry=__main_argc_argv')
            else:
                link_cmd.append('--entry=main')

        if is_64:
            compile_cmd.append('--target=wasm64-emscripten')
            link_cmd.append('-mwasm64')
        else:
            compile_cmd.append('--target=wasm32-emscripten')

        try:
            support.run_command(compile_cmd)
            support.run_command(link_cmd)
            support.run_command(shared.WASM_DIS + [wasm_path, '-o', wat_path])
        finally:
            # Don't need the .o or .wasm files, don't leave them around
            shared.delete_from_orbit(obj_path)
            shared.delete_from_orbit(wasm_path)


if __name__ == '__main__':
    if len(shared.options.positional_args) != 2:
        print('Usage: generate_lld_tests.py [llvm/bin/dir] [path/to/emscripten]')
        sys.exit(1)
    generate_wat_files(*shared.options.positional_args)
