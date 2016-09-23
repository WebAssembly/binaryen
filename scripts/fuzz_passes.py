#! /usr/bin/env python

#   Copyright 2016 WebAssembly Community Group participants
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

'''
This fuzzes passes, by starting with a working program, then running
random passes on the wast, and seeing if they break something

Usage: Provide a base filename for a runnable program, e.g. a.out.js.
       Then we will modify a.out.wast. Note that the program must
       be built to run using that wast (BINARYEN_METHOD=interpret-s-expr)
'''

import os
import random
import shutil
import subprocess
import sys

PASSES = [
    "duplicate-function-elimination",
    "dce",
    "remove-unused-brs",
    "remove-unused-names",
    "optimize-instructions",
    "precompute",
    "simplify-locals",
    "vacuum",
    "coalesce-locals",
    "reorder-locals",
    "merge-blocks",
]

# main

base = sys.argv[1]
wast = base[:-3] + '.wast'
print '>>> base program:', base, ', wast:', wast


def run():
  if os.path.exists(wast):
    print '>>> running using a wast of size', os.stat(wast).st_size
  cmd = ['nodejs', base]
  try:
    return subprocess.check_output(cmd, stderr=subprocess.STDOUT)
  except:
    return ''

original_wast = None

try:
  # get normal output

  normal = run()
  print '>>> normal output:\n', normal
  assert normal, 'must be output'

  # ensure we actually use the wast

  original_wast = wast + '.original.wast'
  shutil.move(wast, original_wast)
  assert run() != normal, 'running without the wast must fail'

  # ensure a bad pass makes it fail

  def apply_passes(passes):
    wasm_opt = os.path.join('bin', 'wasm-opt')
    subprocess.check_call([wasm_opt, original_wast] + passes + ['-o', wast])

  apply_passes(['--remove-imports'])
  assert run() != normal, 'running after a breaking pass must fail'

  # loop, looking for failures

  def simplify(passes):
    # passes is known to fail, try to simplify down by removing
    more = True
    while more:
      more = False
      print '>>> trying to reduce:', ' '.join(passes),
      print '  [' + str(len(passes)) + ']'
      for i in range(len(passes)):
        smaller = passes[:i] + passes[i + 1:]
        print '>>>>>> try to reduce to:', ' '.join(smaller),
        print '  [' + str(len(smaller)) + ']'
        try:
          apply_passes(smaller)
          assert run() == normal
        except:
          # this failed too, so it's a good reduction
          passes = smaller
          print '>>> reduction successful'
          more = True
          break
    print '>>> reduced to:', ' '.join(passes)

  tested = set()

  def pick_passes():
    ret = []
    while 1:
      str_ret = str(ret)
      if random.random() < 0.1 and str_ret not in tested:
        tested.add(str_ret)
        return ret
      ret.append('--' + random.choice(PASSES))

  counter = 0

  while 1:
    passes = pick_passes()
    print '>>> [' + str(counter) + '] testing:', ' '.join(passes)
    counter += 1
    try:
      apply_passes(passes)
    except Exception, e:
      print e
      simplify(passes)
      break
    seen = run()
    if seen != normal:
      print '>>> bad output:\n', seen
      simplify(passes)
      break

finally:
  if original_wast:
    shutil.move(original_wast, wast)
