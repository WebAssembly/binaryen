#!/usr/bin/env python3
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
This fuzzes passes, by starting with a wast, then running
random passes on the wast, and seeing if they break optimization
or validation

Usage: Provide the filename of the wast.
'''

from __future__ import print_function

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
    "remove-unused-functions",
]

# main

wast = sys.argv[1]
print('>>> wast:', wast)

args = sys.argv[2:]


def run():
    try:
        cmd = ['bin/wasm-opt', wast]
        print('run', cmd)
        subprocess.check_call(cmd, stderr=open('/dev/null'))
    except Exception as e:
        return ">>> !!! ", e, " !!!"
    return 'ok'


original_wast = None

try:
    # get normal output

    normal = run()
    print('>>> normal output:\n', normal)
    assert normal, 'must be output'

    # ensure we actually use the wast

    original_wast = wast + '.original.wast'
    shutil.move(wast, original_wast)

    def apply_passes(passes):
        wasm_opt = os.path.join('bin', 'wasm-opt')
        subprocess.check_call([wasm_opt, original_wast] + passes + ['-o', wast],
                              stderr=open('/dev/null'))

    # loop, looking for failures

    def simplify(passes):
        # passes is known to fail, try to simplify down by removing
        more = True
        while more:
            more = False
            print('>>> trying to reduce:', ' '.join(passes), '  [' + str(len(passes)) + ']')
            for i in range(len(passes)):
                smaller = passes[:i] + passes[i + 1:]
                print('>>>>>> try to reduce to:', ' '.join(smaller), '  [' + str(len(smaller)) + ']')
                try:
                    apply_passes(smaller)
                    assert run() == normal
                except Exception:
                    # this failed too, so it's a good reduction
                    passes = smaller
                    print('>>> reduction successful')
                    more = True
                    break
        print('>>> reduced to:', ' '.join(passes))

    tested = set()

    def pick_passes():
        # return '--waka'.split(' ')
        ret = []
        while 1:
            str_ret = str(ret)
            if random.random() < 0.5 and str_ret not in tested:
                tested.add(str_ret)
                return ret
            ret.append('--' + random.choice(PASSES))

    counter = 0

    while 1:
        passes = pick_passes()
        print('>>> [' + str(counter) + '] testing:', ' '.join(passes))
        counter += 1
        try:
            apply_passes(passes)
        except Exception as e:
            print(e)
            simplify(passes)
            break
        seen = run()
        if seen != normal:
            print('>>> bad output:\n', seen)
            simplify(passes)
            break

finally:
    if original_wast:
        shutil.move(original_wast, wast)
