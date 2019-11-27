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

import os
import subprocess

from . import shared
from . import support


def test_binaryen_js():
    if not (shared.MOZJS or shared.NODEJS):
        print('no vm to run binaryen.js tests')
        return

    node_has_wasm = shared.NODEJS and support.node_has_webassembly(shared.NODEJS)

    if not os.path.exists(shared.BINARYEN_JS):
        print('no binaryen.js build to test')
        return

    print('\n[ checking binaryen.js testcases... ]\n')

    for s in sorted(os.listdir(os.path.join(shared.options.binaryen_test, 'binaryen.js'))):
        if not s.endswith('.js'):
            continue
        print(s)
        f = open('a.js', 'w')
        # avoid stdout/stderr ordering issues in some js shells - use just stdout
        f.write('''
            console.warn = function(x) { console.log(x) };
        ''')
        binaryen_js = open(shared.BINARYEN_JS).read()
        f.write(binaryen_js)
        if shared.NODEJS:
            f.write(support.node_test_glue())
        test_path = os.path.join(shared.options.binaryen_test, 'binaryen.js', s)
        test_src = open(test_path).read()
        f.write(test_src)
        f.close()

        def test(engine):
            cmd = [engine, 'a.js']
            if 'fatal' not in s:
                out = support.run_command(cmd, stderr=subprocess.STDOUT)
            else:
                # expect an error - the specific error code will depend on the vm
                out = support.run_command(cmd, stderr=subprocess.STDOUT, expected_status=None)
            expected = open(os.path.join(shared.options.binaryen_test, 'binaryen.js', s + '.txt')).read()
            if expected not in out:
                shared.fail(out, expected)

        # run in all possible shells
        if shared.MOZJS:
            test(shared.MOZJS)
        if shared.NODEJS:
            if node_has_wasm or 'WebAssembly.' not in test_src:
                test(shared.NODEJS)
            else:
                print('Skipping ' + test_path + ' because WebAssembly might not be supported')


if __name__ == "__main__":
    test_binaryen_js()
