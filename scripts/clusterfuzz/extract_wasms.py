#
# Copyright 2024 WebAssembly Community Group participants
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
Wasm extractor for testcases generated by the ClusterFuzz run.py script. Usage:

extract_wasms.py INFILE.js OUTFILE

That will find embedded wasm files in INFILE.js, of the form

  new Uint8Array([..wasm_contents..]);

and extract them into OUTFILE.0.wasm, OUTFILE.1.wasm, etc. It also emits
OUTFILE.js which will no longer contain the embedded contents, after which the
script can be run as

  d8 OUTFILE.js -- OUTFILE.0.wasm

That is, the embedded file can now be provided as a filename argument.
'''

import re
import sys

file_counter = 0


def get_wasm_filename():
    global file_counter
    file_counter += 1
    return f'{out}.{file_counter - 1}.wasm'


in_js = sys.argv[1]
out = sys.argv[2]

with open(in_js) as f:
    js = f.read()


def repl(match):
    text = match.group(0)
    print('text', text)

    # We found something of the form
    #
    #   new Uint8Array([..binary data as numbers..]);
    #
    # See if the numbers are the beginnings of a wasm file, "\0asm". If so, we
    # assume it is wasm.
    numbers = match.groups()[0]
    numbers = numbers.split(',')
    print('numbers', numbers)

    # Handle both base 10 and 16.
    try:
        parsed = [int(n, 0) for n in numbers]
        print('parsed', parsed)
        binary = bytes(parsed)
        print('binary', binary)
    except ValueError:
        # Not wasm; return the existing text.
        return text

    if binary[:4] != b'\0asm':
        print('sad')
        return text

    # It is wasm. Parse out the numbers into a binary wasm file.
    with open(get_wasm_filename(), 'wb') as f:
        f.write(binary)

    # Replace the Uint8Array with undefined + a comment.
    return 'undefined /* extracted wasm */'


# Replace the wasm files and write them out. We investigate any new Uint8Array
# on an array of values like [100, 200] or [0x61, 0x6D, 0x6a] etc.
js = re.sub(r'new Uint8Array\(\[([\d,x a-fA-F]+)\]\)', repl, js)

# Write out the new JS.
with open(f'{out}.js', 'w') as f:
    f.write(js)
