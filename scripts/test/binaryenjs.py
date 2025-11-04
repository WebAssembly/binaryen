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


def make_js_test_header(binaryen_js):
    # common wrapper code for JS tests, waiting for binaryen.js to become ready
    # and providing common utility used by all tests:
    return '''
import Binaryen from "%s";
var binaryen = await Binaryen()

// avoid stdout/stderr ordering issues in some js shells - use just stdout
console.warn = console.error = console.log;

function assert(x) {
    if (!x) throw Error('Test assertion failed');
}
''' % binaryen_js


def make_js_test(input_js_file, binaryen_js):
    basename = os.path.basename(input_js_file)
    outname = os.path.splitext(basename)[0] + '.mjs'
    with open(outname, 'w') as f:
        f.write(make_js_test_header(binaryen_js))
        test_src = open(input_js_file).read()
        f.write(test_src)
    return outname


def do_test_binaryen_js_with(which):
    if not (shared.MOZJS or shared.NODEJS):
        shared.fail_with_error('no vm to run binaryen.js tests')

    node_has_wasm = shared.NODEJS and support.node_has_webassembly(shared.NODEJS)
    if not os.path.exists(which):
        shared.fail_with_error('no ' + which + ' build to test')

    print('\n[ checking binaryen.js testcases (' + which + ')... ]\n')

    for s in shared.get_tests(shared.get_test_dir('binaryen.js'), ['.js']):
        outname = make_js_test(s, which)

        def test(cmd):
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
            test([shared.MOZJS, '-m', outname])
        if shared.NODEJS:
            test_src = open(s).read()
            if node_has_wasm or 'WebAssembly.' not in test_src:
                test([shared.NODEJS, outname])
            else:
                print('Skipping ' + s + ' because WebAssembly might not be supported')


def update_binaryen_js_tests():
    if not (shared.MOZJS or shared.NODEJS):
        print('no vm to run binaryen.js tests')
        return

    if not os.path.exists(shared.BINARYEN_JS):
        print('no binaryen.js build to test')
        return

    print('\n[ checking binaryen.js testcases... ]\n')
    node_has_wasm = shared.NODEJS and support.node_has_webassembly(shared.NODEJS)
    for s in shared.get_tests(shared.get_test_dir('binaryen.js'), ['.js']):
        outname = make_js_test(s, shared.BINARYEN_JS)

        def update(cmd):
            if 'fatal' not in outname:
                out = support.run_command(cmd, stderr=subprocess.STDOUT)
            else:
                # expect an error - the specific error code will depend on the vm
                out = support.run_command(cmd, stderr=subprocess.STDOUT, expected_status=None)
            with open(s + '.txt', 'w') as o:
                o.write(out)

        # run in available shell
        test_src = open(s).read()
        if shared.MOZJS:
            update([shared.MOZJS, '-m', outname])
        elif node_has_wasm or 'WebAssembly.' not in test_src:
            update([shared.NODEJS, outname])
        else:
            print('Skipping ' + s + ' because WebAssembly might not be supported')


def test_binaryen_js():
    do_test_binaryen_js_with(shared.BINARYEN_JS)


def test_binaryen_wasm():
    do_test_binaryen_js_with(shared.BINARYEN_WASM)
