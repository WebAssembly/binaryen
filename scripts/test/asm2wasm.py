#!/usr/bin/env python
#
# Copyright 2017 WebAssembly Community Group participants
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

from scripts.test import shared
from scripts.test import support


def test_asm2wasm():
    print('[ checking asm2wasm testcases... ]\n')

    for asm in shared.get_tests(shared.options.binaryen_test, ['.asm.js']):
        basename = os.path.basename(asm)
        for precise in [0, 1, 2]:
            for opts in [1, 0]:
                cmd = shared.ASM2WASM + [asm]
                if 'threads' in asm:
                    cmd += ['--enable-threads']
                wasm = asm.replace('.asm.js', '.fromasm')
                if not precise:
                    cmd += ['--trap-mode=allow', '--ignore-implicit-traps']
                    wasm += '.imprecise'
                elif precise == 2:
                    cmd += ['--trap-mode=clamp']
                    wasm += '.clamp'
                if not opts:
                    wasm += '.no-opts'
                    if precise:
                        cmd += ['-O0']  # test that -O0 does nothing
                else:
                    cmd += ['-O']
                if 'debugInfo' in basename:
                    cmd += ['-g']
                if 'noffi' in basename:
                    cmd += ['--no-legalize-javascript-ffi']
                if precise and opts:
                    # test mem init importing
                    open('a.mem', 'w').write(basename)
                    cmd += ['--mem-init=a.mem']
                    if basename[0] == 'e':
                        cmd += ['--mem-base=1024']
                if '4GB' in basename:
                    cmd += ['--mem-max=4294967296']
                if 'i64' in basename or 'wasm-only' in basename or 'noffi' in basename:
                    cmd += ['--wasm-only']
                print('..', basename, os.path.basename(wasm))

                def do_asm2wasm_test():
                    actual = support.run_command(cmd)

                    # verify output
                    if not os.path.exists(wasm):
                        shared.fail_with_error('output .wast file %s does not exist' % wasm)
                    shared.fail_if_not_identical_to_file(actual, wasm)

                    shared.binary_format_check(wasm, verify_final_result=False)

                # test both normally and with pass debug (so each inter-pass state
                # is validated)
                old_pass_debug = os.environ.get('BINARYEN_PASS_DEBUG')
                try:
                    os.environ['BINARYEN_PASS_DEBUG'] = '1'
                    print("With BINARYEN_PASS_DEBUG=1:")
                    do_asm2wasm_test()
                    del os.environ['BINARYEN_PASS_DEBUG']
                    print("With BINARYEN_PASS_DEBUG disabled:")
                    do_asm2wasm_test()
                finally:
                    if old_pass_debug is not None:
                        os.environ['BINARYEN_PASS_DEBUG'] = old_pass_debug
                    else:
                        if 'BINARYEN_PASS_DEBUG' in os.environ:
                            del os.environ['BINARYEN_PASS_DEBUG']

                # verify in wasm
                if shared.options.interpreter:
                    # remove imports, spec interpreter doesn't know what to do with them
                    subprocess.check_call(shared.WASM_OPT + ['--remove-imports', wasm],
                                          stdout=open('ztemp.wast', 'w'),
                                          stderr=subprocess.PIPE)
                    proc = subprocess.Popen([shared.options.interpreter, 'ztemp.wast'],
                                            stderr=subprocess.PIPE)
                    out, err = proc.communicate()
                    if proc.returncode != 0:
                        try:  # to parse the error
                            reported = err.split(':')[1]
                            start, end = reported.split('-')
                            start_line, start_col = map(int, start.split('.'))
                            lines = open('ztemp.wast').read().split('\n')
                            print()
                            print('=' * 80)
                            print(lines[start_line - 1])
                            print((' ' * (start_col - 1)) + '^')
                            print((' ' * (start_col - 2)) + '/_\\')
                            print('=' * 80)
                            print(err)
                        except Exception:
                            # failed to pretty-print
                            shared.fail_with_error('wasm interpreter error: ' + err)
                        shared.fail_with_error('wasm interpreter error')

                # verify debug info
                if 'debugInfo' in asm:
                    jsmap = 'a.wasm.map'
                    cmd += ['--source-map', jsmap,
                            '--source-map-url', 'http://example.org/' + jsmap,
                            '-o', 'a.wasm']
                    support.run_command(cmd)
                    if not os.path.isfile(jsmap):
                        shared.fail_with_error('Debug info map not created: %s' % jsmap)
                    with open(jsmap, 'rb') as actual:
                        shared.fail_if_not_identical_to_file(actual.read(), wasm + '.map')
                    with open('a.wasm', 'rb') as binary:
                        url_section_name = bytes([16]) + bytes('sourceMappingURL', 'utf-8')
                        url = 'http://example.org/' + jsmap
                        assert len(url) < 256, 'name too long'
                        url_section_contents = bytes([len(url)]) + bytes(url, 'utf-8')
                        print(url_section_name)
                        binary_contents = binary.read()
                        if url_section_name not in binary_contents:
                            shared.fail_with_error('source map url section not found in binary')
                        url_section_index = binary_contents.index(url_section_name)
                        if url_section_contents not in binary_contents[url_section_index:]:
                            shared.fail_with_error('source map url not found in url section')


def test_asm2wasm_binary():
    print('\n[ checking asm2wasm binary reading/writing... ]\n')

    asmjs = os.path.join(shared.options.binaryen_test, 'hello_world.asm.js')
    shared.delete_from_orbit('a.wasm')
    shared.delete_from_orbit('b.wast')
    support.run_command(shared.ASM2WASM + [asmjs, '-o', 'a.wasm'])
    assert open('a.wasm', 'rb').read()[0] == 0, 'we emit binary by default'
    support.run_command(shared.ASM2WASM + [asmjs, '-o', 'b.wast', '-S'])
    assert open('b.wast', 'rb').read()[0] != 0, 'we emit text with -S'


if __name__ == '__main__':
    test_asm2wasm()
    test_asm2wasm_binary()
