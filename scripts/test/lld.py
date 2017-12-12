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
    fail, fail_with_error, fail_if_not_contained,
    options, LLD_METADATA, LLD_EMSCRIPTEN
)


def test_lld_metadata():
  print '\n[ checking lld-metadata testcases... ]\n'

  lld_path = os.path.join(options.binaryen_test, 'lld')
  for obj_file in sorted(os.listdir(lld_path)):
    if not obj_file.endswith('.o'):
      continue
    print '..', obj_file
    json_file = obj_file.replace('.o', '.json')
    expected_file = os.path.join(lld_path, json_file)

    obj_path = os.path.join(lld_path, obj_file)
    cmd = LLD_METADATA + [obj_path]
    actual = run_command(cmd)

    if not os.path.exists(expected_file):
      print actual
      fail_with_error('output ' + expected_file + ' does not exist')
    expected = open(expected_file, 'rb').read()
    if actual != expected:
      fail(actual, expected)


if __name__ == '__main__':
  test_lld_metadata()
