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
A bunch of hackish fixups for testing of SpiderMonkey support. We should
get rid of these ASAP.

This is meant to be run using BINARYEN_SCRIPTS in emcc, and not standalone.
'''

import math
import os
import shutil
import subprocess
import sys

import emscripten

binaryen_root = os.path.abspath(os.path.dirname(os.path.dirname(__file__)))

js_target = sys.argv[1]
wast_target = sys.argv[2]

wasm_target = wast_target[:-5] + '.wasm'

base_wast_target = os.path.basename(wast_target)
base_wasm_target = os.path.basename(wasm_target)


def fix(js, before, after):
  assert js.count(before) == 1
  return js.replace(before, after)

# fix up js
js = open(js_target).read()
# use the wasm, not wast
js = js.replace('"' + base_wast_target + '"', '"' + base_wasm_target + '"')
js = js.replace("'" + base_wast_target + "'", "'" + base_wasm_target + "'")
open(js_target, 'w').write(js)
shutil.copyfile(wast_target + '.mappedGlobals', wasm_target + '.mappedGlobals')

# fix up wast
wast = open(wast_target).read()
# memory
memory_start = wast.find('(memory') + 1
memory_end = wast.find(')', memory_start)
wast = (wast[:memory_end + 1] +
        ' (export "memory" memory) ' +
        wast[memory_end + 1:])
open(wast_target, 'w').write(wast)

# convert to binary using spidermonkey
subprocess.check_call(
    emscripten.shared.SPIDERMONKEY_ENGINE +
    ['-e', 'os.file.writeTypedArrayToFile("' + wasm_target +
     '", new Uint8Array(wasmTextToBinary(os.file.readFile("' +
     wast_target + '"))))'])
