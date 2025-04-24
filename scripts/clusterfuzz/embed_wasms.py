#
# Copyright 2025 WebAssembly Community Group participants
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

'''
Reverse script for extract_wasms.py: That one extracts wasm files from a
JavaScript testcase (which has wasm files embedded as arrays of numbers), and
this one re-embeds them back. To do so, we use the magic comments that the
extractor uses: it replaces each wasm array with

  'undefined /* extracted wasm */'

We simply replace those with the given wasm files, in JS format.

For example, assume INFILE.js contains two wasm files. Then

  extract_wasms.py INFILE.js OUTFILE

will emit

  OUTFILE.js, OUTFILE.0.wasm, OUTFILE.1.wasm

We now have a JS file without the wasm (which includes the magic comments
mentioned before) and one binary wasm file for each wasm. We can now re-embed
them, creating a merged JS file containing JS + wasm, using

  embed_wasms.py OUTFILE.js OUTFILE.0.wasm OUTFILE.1.wasm MERGED.js

The first argument is the input JS, then the wasm files, then the last argument
is the output JS.
'''

import re
import sys

in_js = sys.argv[1]
in_wasms = sys.argv[2:-1]
out_js = sys.argv[-1]

with open(in_js) as f:
    js = f.read()

wasm_index = 0


def replace_wasm(text):
    global wasm_index
    wasm_file = in_wasms[wasm_index]
    wasm_index += 1

    with open(wasm_file, 'rb') as f:
        wasm = f.read()

    bytes = [str(int(x)) for x in wasm]
    bytes = ', '.join(bytes)

    return f'new Uint8Array([{bytes}])'


js = re.sub(r'undefined [/][*] extracted wasm [*][/]', replace_wasm, js)

# Write out the new JS.
with open(out_js, 'w') as f:
    f.write(js)
