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

import os
import subprocess
import sys

import emscripten

binaryen_root = os.path.abspath(os.path.dirname(os.path.dirname(__file__)))

js_target = sys.argv[1]
wast_target = sys.argv[2]

wasm_target = wast_target[:-5] + '.wasm'

# convert to binary using spidermonkey
'''
using something like
mozjs -e 'os.file.writeTypedArrayToFile("moz.wasm",
new Uint8Array(wasmTextToBinary(os.file.readFile("a.out.wast"))))'
investigate with
>>> map(chr, map(ord, open('moz.wasm').read()))
or
python -c "print str(map(chr,map(ord,
 open('a.out.wasm').read()))).replace(',', '\n')"
'''
subprocess.check_call(
    emscripten.shared.SPIDERMONKEY_ENGINE +
    ['-e', 'os.file.writeTypedArrayToFile("' + wasm_target +
     '", new Uint8Array(wasmTextToBinary(os.file.readFile("' +
     wast_target + '"))))'])
