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
from support import run_command
from shared import (
    fail_with_error, files_with_pattern, options,
    WASM_EMSCRIPTEN_FINALIZE, fail_if_not_identical_to_file
)


def test_wasm_emscripten_finalize():
  print '\n[ checking wasm-emscripten-finalize testcases... ]\n'

  for wast_path in files_with_pattern(options.binaryen_test, 'lld', '*.wast'):
    print '..', wast_path
    mem_file = wast_path + '.mem'
    extension_arg_map = {
      '.out': [],
      '.jscall.out': ['--emscripten-reserved-function-pointers=3'],
      '.mem.out': ['--separate-data-segments', mem_file],
    }
    for ext, ext_args in extension_arg_map.items():
      expected_file = wast_path + ext
      if ext != '.out' and not os.path.exists(expected_file):
        continue

      cmd = (WASM_EMSCRIPTEN_FINALIZE +
             [wast_path, '-S', '--global-base=568'] + ext_args)
      actual = run_command(cmd)

      if not os.path.exists(expected_file):
        print actual
        fail_with_error('output ' + expected_file + ' does not exist')
      fail_if_not_identical_to_file(actual, expected_file)
      if ext == '.mem.out':
        with open(mem_file) as mf:
          mem = mf.read()
          fail_if_not_identical_to_file(mem, wast_path + '.mem.mem')
        os.remove(mem_file)


if __name__ == '__main__':
  test_wasm_emscripten_finalize()
