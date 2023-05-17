#!/usr/bin/env python3
# Copyright 2022 WebAssembly Community Group participants
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

"""A test case update script for lit help checks.
"""

import os
import subprocess

import test.shared as shared

script_dir = os.path.dirname(__file__)
root_dir = os.path.dirname(script_dir)
test_dir = os.path.join(root_dir, 'test', 'lit', 'help')

TOOLS = ['wasm-opt', 'wasm-as', 'wasm-dis', 'wasm2js', 'wasm-ctor-eval',
         'wasm-shell', 'wasm-reduce', 'wasm-metadce', 'wasm-split',
         'wasm-fuzz-types', 'wasm-emscripten-finalize', 'wasm-merge']


def main():
    for tool in TOOLS:
        tool_path = os.path.join(shared.options.binaryen_bin, tool)
        command = [tool_path, '--help']
        print(command)
        output = subprocess.check_output(command).decode('utf-8')
        with open(os.path.join(test_dir, tool + '.test'), 'w') as out:
            out.write(f';; RUN: {tool} --help | filecheck %s' + os.linesep)
            first = True
            for line in output.splitlines():
                if first:
                    out.write(f';; CHECK: {line}'.strip() + os.linesep)
                    first = False
                else:
                    out.write(f';; CHECK-NEXT: {line}'.strip() + os.linesep)


if __name__ == '__main__':
    main()
