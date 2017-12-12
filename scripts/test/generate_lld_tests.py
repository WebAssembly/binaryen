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
from shared import options


def generate_lld_tests(clang_bin):
  print '\n[ building object files from C sources... ]\n'

  lld_path = os.path.join(options.binaryen_test, 'lld')
  for src_file in sorted(os.listdir(lld_path)):
    if not src_file.endswith('.c'):
      continue
    print '..', src_file
    obj_file = src_file.replace('.c', '.o')

    src_path = os.path.join(lld_path, src_file)
    obj_path = os.path.join(lld_path, obj_file)
    cmd = [
      clang_bin, src_path, '-o', obj_path,
      '--target=wasm32-unknown-unknown-wasm',
      '-c',
      '-nostdinc',
      '-Xclang', '-nobuiltininc',
      '-Xclang', '-nostdsysteminc',
    ]
    run_command(cmd)


if __name__ == '__main__':
  if len(sys.argv) != 2:
    print 'Usage: generate_lld_tests.py [path/to/clang]'
    sys.exit(1)
  generate_lld_tests(sys.argv[1])
