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
import sys
from support import run_command
import shared


def files_with_extensions(path, extensions):
  for file in sorted(os.listdir(path)):
    _, ext = os.path.splitext(file)
    if ext in extensions:
      yield file, ext


def generate_object_files(clang_bin):
  print '\n[ building object files from C sources... ]\n'

  lld_path = os.path.join(shared.options.binaryen_test, 'lld')
  for src_file, ext in files_with_extensions(lld_path, ['.c', '.cpp']):
    print '..', src_file
    obj_file = src_file.replace(ext, '.o')

    src_path = os.path.join(lld_path, src_file)
    obj_path = os.path.join(lld_path, obj_file)
    run_command([
        clang_bin, src_path, '-o', obj_path,
        '--target=wasm32-unknown-unknown-wasm',
        '-c',
        '-nostdinc',
        '-Xclang', '-nobuiltininc',
        '-Xclang', '-nostdsysteminc',
        '-Xclang', '-I/s/work/emscripten/system/include',
        '-O1',
    ])


def generate_wast_files(lld_bin):
  print '\n[ linking wasm files from object files... ]\n'

  lld_path = os.path.join(shared.options.binaryen_test, 'lld')
  for obj_file, ext in files_with_extensions(lld_path, ['.o']):
    print '..', obj_file
    wasm_file = obj_file.replace(ext, '.wasm')
    wast_file = obj_file.replace(ext, '.wast')

    obj_path = os.path.join(lld_path, obj_file)
    wasm_path = os.path.join(lld_path, wasm_file)
    wast_path = os.path.join(lld_path, wast_file)
    run_command([
        lld_bin, '-flavor', 'wasm',
        '-z', '-stack-size=1048576',
        obj_path, '-o', wasm_path,
        '--entry=main',
        '--allow-undefined',
    ])
    try:
      run_command(shared.WASM_DIS + [wasm_path, '-o', wast_path])
    finally:
      # Don't need the .wasm file, don't leave it around
      shared.delete_from_orbit(wasm_path)


if __name__ == '__main__':
  if len(sys.argv) != 3:
    print 'Usage: generate_lld_tests.py [path/to/clang] [path/to/lld]'
    sys.exit(1)
  generate_object_files(sys.argv[1])
  generate_wast_files(sys.argv[2])
