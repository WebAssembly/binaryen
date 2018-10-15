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

from support import run_command
from shared import (
    ASM2WASM, WASM_OPT, binary_format_check, delete_from_orbit,
    fail_with_error, options, tests, fail_if_not_identical_to_file
)


def test_asm2wasm():
  print '[ checking asm2wasm testcases... ]\n'

  for asm in tests:
    if not asm.endswith('.asm.js'):
      continue
    for precise in [0, 1, 2]:
      for opts in [1, 0]:
        cmd = ASM2WASM + [os.path.join(options.binaryen_test, asm)]
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
        if 'debugInfo' in asm:
          cmd += ['-g']
        if 'noffi' in asm:
          cmd += ['--no-legalize-javascript-ffi']
        if precise and opts:
          # test mem init importing
          open('a.mem', 'wb').write(asm)
          cmd += ['--mem-init=a.mem']
          if asm[0] == 'e':
            cmd += ['--mem-base=1024']
        if '4GB' in asm:
          cmd += ['--mem-max=4294967296']
        if 'i64' in asm or 'wasm-only' in asm or 'noffi' in asm:
          cmd += ['--wasm-only']
        wasm = os.path.join(options.binaryen_test, wasm)
        print '..', asm, wasm

        def do_asm2wasm_test():
          actual = run_command(cmd)

          # verify output
          if not os.path.exists(wasm):
            fail_with_error('output .wast file %s does not exist' % wasm)
          fail_if_not_identical_to_file(actual, wasm)

          binary_format_check(wasm, verify_final_result=False)

        # test both normally and with pass debug (so each inter-pass state
        # is validated)
        old_pass_debug = os.environ.get('BINARYEN_PASS_DEBUG')
        try:
          os.environ['BINARYEN_PASS_DEBUG'] = '1'
          print "With BINARYEN_PASS_DEBUG=1:"
          do_asm2wasm_test()
          del os.environ['BINARYEN_PASS_DEBUG']
          print "With BINARYEN_PASS_DEBUG disabled:"
          do_asm2wasm_test()
        finally:
          if old_pass_debug is not None:
            os.environ['BINARYEN_PASS_DEBUG'] = old_pass_debug
          else:
            if 'BINARYEN_PASS_DEBUG' in os.environ:
              del os.environ['BINARYEN_PASS_DEBUG']

        # verify in wasm
        if options.interpreter:
          # remove imports, spec interpreter doesn't know what to do with them
          subprocess.check_call(WASM_OPT + ['--remove-imports', wasm],
                                stdout=open('ztemp.wast', 'w'),
                                stderr=subprocess.PIPE)
          proc = subprocess.Popen([options.interpreter, 'ztemp.wast'],
                                  stderr=subprocess.PIPE)
          out, err = proc.communicate()
          if proc.returncode != 0:
            try:  # to parse the error
              reported = err.split(':')[1]
              start, end = reported.split('-')
              start_line, start_col = map(int, start.split('.'))
              lines = open('ztemp.wast').read().split('\n')
              print
              print '=' * 80
              print lines[start_line - 1]
              print (' ' * (start_col - 1)) + '^'
              print (' ' * (start_col - 2)) + '/_\\'
              print '=' * 80
              print err
            except Exception:
              # failed to pretty-print
              fail_with_error('wasm interpreter error: ' + err)
            fail_with_error('wasm interpreter error')

        # verify debug info
        if 'debugInfo' in asm:
          jsmap = 'a.wasm.map'
          cmd += ['--source-map', jsmap,
                  '--source-map-url', 'http://example.org/' + jsmap,
                  '-o', 'a.wasm']
          run_command(cmd)
          if not os.path.isfile(jsmap):
            fail_with_error('Debug info map not created: %s' % jsmap)
          with open(jsmap, 'rb') as actual:
            fail_if_not_identical_to_file(actual.read(), wasm + '.map')
          with open('a.wasm', 'rb') as binary:
            url_section_name = bytearray([16]) + bytearray('sourceMappingURL')
            url = 'http://example.org/' + jsmap
            assert len(url) < 256, 'name too long'
            url_section_contents = bytearray([len(url)]) + bytearray(url)
            print url_section_name
            binary_contents = bytearray(binary.read())
            if url_section_name not in binary_contents:
              fail_with_error('source map url section not found in binary')
            url_section_index = binary_contents.index(url_section_name)
            if url_section_contents not in binary_contents[url_section_index:]:
              fail_with_error('source map url not found in url section')


def test_asm2wasm_binary():
  print '\n[ checking asm2wasm binary reading/writing... ]\n'

  asmjs = os.path.join(options.binaryen_test, 'hello_world.asm.js')
  delete_from_orbit('a.wasm')
  delete_from_orbit('b.wast')
  run_command(ASM2WASM + [asmjs, '-o', 'a.wasm'])
  assert open('a.wasm', 'rb').read()[0] == '\0', 'we emit binary by default'
  run_command(ASM2WASM + [asmjs, '-o', 'b.wast', '-S'])
  assert open('b.wast', 'rb').read()[0] != '\0', 'we emit text with -S'


if __name__ == '__main__':
  test_asm2wasm()
  test_asm2wasm_binary()
