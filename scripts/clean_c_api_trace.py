#!/usr/bin/env python
#
# Copyright 2016 WebAssembly Community Group participants
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

'''
Cleans up output from the C api, makes a runnable C file
'''

import sys

trace = open(sys.argv[1]).read()

start = trace.find('// beginning a Binaryen API trace')
if start >= 0:
  trace = trace[start:]

  while 1:
    start = trace.find('\n(')
    if start < 0:
      break
    end = trace.find('\n)', start + 1)
    assert end > 0
    trace = trace[:start] + trace[end + 2:]

  print trace
