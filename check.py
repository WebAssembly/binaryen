#!/usr/bin/env python2

# Copyright 2015 WebAssembly Community Group participants
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

import json
import os
import shutil
import subprocess
import sys

from scripts.test.support import run_command, split_wast
from scripts.test.shared import (
    ASM2WASM, BIN_DIR, EMCC, MOZJS, NATIVECC, NATIVEXX, NODEJS, S2WASM_EXE,
    WASM_AS, WASM_CTOR_EVAL, WASM_OPT, WASM_SHELL, WASM_MERGE, WASM_SHELL_EXE,
    WASM_DIS, binary_format_check, delete_from_orbit, fail, fail_with_error,
    fail_if_not_identical, fail_if_not_contained, has_vanilla_emcc,
    has_vanilla_llvm, minify_check, num_failures, options, tests,
    requested, warnings
)

import scripts.test.s2wasm as s2wasm

if options.interpreter:
  print '[ using wasm interpreter at "%s" ]' % options.interpreter
  assert os.path.exists(options.interpreter), 'interpreter not found'

# tests

print '[ checking --help is useful... ]\n'

not_executable_suffix = ['.txt', '.js', '.ilk', '.pdb', '.dll']
executables = sorted(filter(lambda x: not any(x.endswith(s) for s in
                                              not_executable_suffix) and os.path.isfile(x),
                            os.listdir(options.binaryen_bin)))
for e in executables:
  print '.. %s --help' % e
  out, err = subprocess.Popen([os.path.join(options.binaryen_bin, e), '--help'],
                              stdout=subprocess.PIPE,
                              stderr=subprocess.PIPE).communicate()
  assert len(out) == 0, 'Expected no stdout, got:\n%s' % out
  assert e.replace('.exe', '') in err, 'Expected help to contain program name, got:\n%s' % err
  assert len(err.split('\n')) > 8, 'Expected some help, got:\n%s' % err

print '\n[ checking wasm-opt -o notation... ]\n'

wast = os.path.join(options.binaryen_test, 'hello_world.wast')
delete_from_orbit('a.wast')
cmd = WASM_OPT + [wast, '-o', 'a.wast', '-S']
run_command(cmd)
fail_if_not_identical(open('a.wast').read(), open(wast).read())

print '\n[ checking wasm-opt binary reading/writing... ]\n'

shutil.copyfile(os.path.join(options.binaryen_test, 'hello_world.wast'), 'a.wast')
delete_from_orbit('a.wasm')
delete_from_orbit('b.wast')
run_command(WASM_OPT + ['a.wast', '-o', 'a.wasm'])
assert open('a.wasm', 'rb').read()[0] == '\0', 'we emit binary by default'
run_command(WASM_OPT + ['a.wasm', '-o', 'b.wast', '-S'])
assert open('b.wast', 'rb').read()[0] != '\0', 'we emit text with -S'

print '\n[ checking wasm-opt passes... ]\n'

for t in sorted(os.listdir(os.path.join(options.binaryen_test, 'passes'))):
  if t.endswith(('.wast', '.wasm')):
    print '..', t
    binary = '.wasm' in t
    passname = os.path.basename(t).replace('.wast', '').replace('.wasm', '')
    opts = ['-' + passname] if passname.startswith('O') else ['--' + p for p in passname.split('_')]
    t = os.path.join(options.binaryen_test, 'passes', t)
    actual = ''
    for module, asserts in split_wast(t):
      assert len(asserts) == 0
      with open('split.wast', 'w') as o: o.write(module)
      cmd = WASM_OPT + opts + ['split.wast', '--print']
      curr = run_command(cmd)
      actual += curr
      # also check debug mode output is valid
      debugged = run_command(cmd + ['--debug'], stderr=subprocess.PIPE)
      fail_if_not_contained(actual, debugged)
      # also check pass-debug mode
      old_pass_debug = os.environ.get('BINARYEN_PASS_DEBUG')
      try:
        os.environ['BINARYEN_PASS_DEBUG'] = '1'
        pass_debug = run_command(cmd)
        fail_if_not_identical(curr, pass_debug)
      finally:
        if old_pass_debug is not None:
          os.environ['BINARYEN_PASS_DEBUG'] = old_pass_debug
        else:
          if 'BINARYEN_PASS_DEBUG' in os.environ:
            del os.environ['BINARYEN_PASS_DEBUG']

    fail_if_not_identical(actual, open(os.path.join('test', 'passes', passname + ('.bin' if binary else '') + '.txt'), 'rb').read())

print '[ checking asm2wasm testcases... ]\n'

for asm in tests:
  if asm.endswith('.asm.js'):
    for precise in [0, 1, 2]:
      for opts in [1, 0]:
        cmd = ASM2WASM + [os.path.join(options.binaryen_test, asm)]
        wasm = asm.replace('.asm.js', '.fromasm')
        if not precise:
          cmd += ['--emit-potential-traps', '--ignore-implicit-traps']
          wasm += '.imprecise'
        elif precise == 2:
          cmd += ['--emit-clamped-potential-traps']
          wasm += '.clamp'
        if not opts:
          wasm += '.no-opts'
          if precise:
            cmd += ['-O0'] # test that -O0 does nothing
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
        if 'i64' in asm or 'wasm-only' in asm or 'noffi' in asm:
          cmd += ['--wasm-only']
        wasm = os.path.join(options.binaryen_test, wasm)
        print '..', asm, wasm

        def do_asm2wasm_test():
          actual = run_command(cmd)

          # verify output
          if not os.path.exists(wasm):
            fail_with_error('output .wast file %s does not exist' % wasm)
          expected = open(wasm, 'rb').read()
          if actual != expected:
            fail(actual, expected)

          binary_format_check(wasm, verify_final_result=False)

        # test both normally and with pass debug (so each inter-pass state is validated)
        old_pass_debug = os.environ.get('BINARYEN_PASS_DEBUG')
        try:
          os.environ['BINARYEN_PASS_DEBUG'] = '1'
          do_asm2wasm_test()
          del os.environ['BINARYEN_PASS_DEBUG']
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
          subprocess.check_call(WASM_OPT + ['--remove-imports', wasm], stdout=open('ztemp.wast', 'w'), stderr=subprocess.PIPE)
          proc = subprocess.Popen([options.interpreter, 'ztemp.wast'], stderr=subprocess.PIPE)
          out, err = proc.communicate()
          if proc.returncode != 0:
            try: # to parse the error
              reported = err.split(':')[1]
              start, end = reported.split('-')
              start_line, start_col = map(int, start.split('.'))
              lines = open('ztemp.wast').read().split('\n')
              print
              print '='*80
              print lines[start_line-1]
              print (' '*(start_col-1)) + '^'
              print (' '*(start_col-2)) + '/_\\'
              print '='*80
              print err
            except Exception, e:
              fail_with_error('wasm interpreter error: ' + err) # failed to pretty-print
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
          with open(wasm + '.map', 'rb') as expected:
            with open(jsmap, 'rb') as actual:
              fail_if_not_identical(actual.read(), expected.read())
          with open('a.wasm', 'rb') as binary:
            url_section_name = bytearray([16]) + bytearray('sourceMappingURL')
            payload = 'http://example.org/' + jsmap
            assert len(payload) < 256, 'name too long'
            url_section_contents = bytearray([len(payload)]) + bytearray(payload)
            print url_section_name
            binary_contents = bytearray(binary.read())
            if url_section_name not in binary_contents:
              fail_with_error('source map url section not found in binary')
            if url_section_contents not in binary_contents[binary_contents.index(url_section_name):]:
              fail_with_error('source map url not found in url section')


print '\n[ checking asm2wasm binary reading/writing... ]\n'

asmjs = os.path.join(options.binaryen_test, 'hello_world.asm.js')
delete_from_orbit('a.wasm')
delete_from_orbit('b.wast')
run_command(ASM2WASM + [asmjs, '-o', 'a.wasm'])
assert open('a.wasm', 'rb').read()[0] == '\0', 'we emit binary by default'
run_command(ASM2WASM + [asmjs, '-o', 'b.wast', '-S'])
assert open('b.wast', 'rb').read()[0] != '\0', 'we emit text with -S'

print '\n[ checking wasm-opt parsing & printing... ]\n'

for t in sorted(os.listdir(os.path.join(options.binaryen_test, 'print'))):
  if t.endswith('.wast'):
    print '..', t
    wasm = os.path.basename(t).replace('.wast', '')
    cmd = WASM_OPT + [os.path.join(options.binaryen_test, 'print', t), '--print']
    print '    ', ' '.join(cmd)
    actual, err = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
    fail_if_not_identical(actual, open(os.path.join(options.binaryen_test, 'print', wasm + '.txt')).read())
    cmd = WASM_OPT + [os.path.join(options.binaryen_test, 'print', t), '--print-minified']
    print '    ', ' '.join(cmd)
    actual, err = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
    fail_if_not_identical(actual.strip(), open(os.path.join(options.binaryen_test, 'print', wasm + '.minified.txt')).read().strip())

print '\n[ checking wasm-opt testcases... ]\n'

for t in tests:
  if t.endswith('.wast') and not t.startswith('spec'):
    print '..', t
    t = os.path.join(options.binaryen_test, t)
    f = t + '.from-wast'
    cmd = WASM_OPT + [t, '--print']
    actual = run_command(cmd)
    actual = actual.replace('printing before:\n', '')

    expected = open(f, 'rb').read()
    if actual != expected:
      fail(actual, expected)

    binary_format_check(t, wasm_as_args=['-g']) # test with debuginfo
    binary_format_check(t, wasm_as_args=[], binary_suffix='.fromBinary.noDebugInfo') # test without debuginfo

    minify_check(t)

print '\n[ checking wasm-dis on provided binaries... ]\n'

for t in tests:
  if t.endswith('.wasm') and not t.startswith('spec'):
    print '..', t
    t = os.path.join(options.binaryen_test, t)
    cmd = WASM_DIS + [t]
    if os.path.isfile(t + '.map'): cmd += ['--source-map', t + '.map']

    actual = run_command(cmd)

    with open(t + '.fromBinary') as f:
      expected = f.read()
      if actual != expected:
        fail(actual, expected)

print '\n[ checking wasm-merge... ]\n'

for t in os.listdir(os.path.join('test', 'merge')):
  if t.endswith(('.wast', '.wasm')):
    print '..', t
    t = os.path.join('test', 'merge', t)
    u = t + '.toMerge'
    for finalize in [0, 1]:
      for opt in [0, 1]:
        cmd = WASM_MERGE + [t, u, '-o', 'a.wast', '-S', '--verbose']
        if finalize: cmd += ['--finalize-memory-base=1024', '--finalize-table-base=8']
        if opt: cmd += ['-O']
        stdout = run_command(cmd)
        actual = open('a.wast').read()
        out = t + '.combined'
        if finalize: out += '.finalized'
        if opt: out += '.opt'
        with open(out) as f:
          fail_if_not_identical(f.read(), actual)
        with open(out + '.stdout') as f:
          fail_if_not_identical(f.read(), stdout)

print '\n[ checking wasm-ctor-eval... ]\n'

for t in os.listdir(os.path.join('test', 'ctor-eval')):
  if t.endswith(('.wast', '.wasm')):
    print '..', t
    t = os.path.join('test', 'ctor-eval', t)
    ctors = open(t + '.ctors').read().strip()
    cmd = WASM_CTOR_EVAL + [t, '-o', 'a.wast', '-S', '--ctors', ctors]
    stdout = run_command(cmd)
    actual = open('a.wast').read()
    out = t + '.out'
    with open(out) as f:
      fail_if_not_identical(f.read(), actual)

print '\n[ checking wasm-shell spec testcases... ]\n'

if len(requested) == 0:
  BLACKLIST = ['memory.wast', 'binary.wast'] # FIXME we support old and new memory formats, for now, until 0xc, and so can't pass this old-style test.
  # FIXME to update the spec to 0xd, we need to implement (register "name") for import.wast
  spec_tests = [os.path.join('spec', t) for t in sorted(os.listdir(os.path.join(options.binaryen_test, 'spec'))) if t not in BLACKLIST]
else:
  spec_tests = requested[:]

for t in spec_tests:
  if t.startswith('spec') and t.endswith('.wast'):
    print '..', t
    wast = os.path.join(options.binaryen_test, t)

    # skip checks for some tests
    if os.path.basename(wast) in ['linking.wast', 'nop.wast', 'stack.wast', 'typecheck.wast', 'unwind.wast']: # FIXME
      continue

    def run_spec_test(wast):
      cmd = WASM_SHELL + [wast]
      # we must skip the stack machine portions of spec tests or apply other extra args
      extra = {
      }
      cmd = cmd + (extra.get(os.path.basename(wast)) or [])
      return run_command(cmd, stderr=subprocess.PIPE)

    def run_opt_test(wast):
      # check optimization validation
      cmd = WASM_OPT + [wast, '-O']
      run_command(cmd)

    def check_expected(actual, expected):
      if expected and os.path.exists(expected):
        expected = open(expected).read()
        # fix it up, our pretty (i32.const 83) must become compared to a homely 83 : i32
        def fix(x):
          x = x.strip()
          if not x: return x
          v, t = x.split(' : ')
          if v.endswith('.'): v = v[:-1] # remove trailing '.'
          return '(' + t + '.const ' + v + ')'
        expected = '\n'.join(map(fix, expected.split('\n')))
        print '       (using expected output)'
        actual = actual.strip()
        expected = expected.strip()
        if actual != expected:
          fail(actual, expected)

    expected = os.path.join(options.binaryen_test, 'spec', 'expected-output', os.path.basename(wast) + '.log')

    # some spec tests should fail (actual process failure, not just assert_invalid)
    try:
      actual = run_spec_test(wast)
    except Exception, e:
      if ('wasm-validator error' in str(e) or 'parse exception' in str(e)) and '.fail.' in t:
        print '<< test failed as expected >>'
        continue # don't try all the binary format stuff TODO
      else:
        fail_with_error(str(e))

    check_expected(actual, expected)

    # skip binary checks for tests that reuse previous modules by name, as that's a wast-only feature
    if os.path.basename(wast) in ['exports.wast']: # FIXME
      continue

    # we must ignore some binary format splits
    splits_to_skip = {
        'func.wast': [2],
        'return.wast': [2]
    }

    # check binary format. here we can verify execution of the final result, no need for an output verification
    split_num = 0
    if os.path.basename(wast) not in []: # avoid some tests with things still being sorted out in the spec
      actual = ''
      for module, asserts in split_wast(wast):
        skip = splits_to_skip.get(os.path.basename(wast)) or []
        if split_num in skip:
          print '    skipping split module', split_num - 1
          split_num += 1
          continue
        print '    testing split module', split_num
        split_num += 1
        with open('split.wast', 'w') as o: o.write(module + '\n' + '\n'.join(asserts))
        run_spec_test('split.wast') # before binary stuff - just check it's still ok split out
        run_opt_test('split.wast') # also that our optimizer doesn't break on it
        result_wast = binary_format_check('split.wast', verify_final_result=False)
        # add the asserts, and verify that the test still passes
        open(result_wast, 'a').write('\n' + '\n'.join(asserts))
        actual += run_spec_test(result_wast)
      # compare all the outputs to the expected output
      check_expected(actual, os.path.join(options.binaryen_test, 'spec', 'expected-output', os.path.basename(wast) + '.log'))

if MOZJS:
  print '\n[ checking binaryen.js testcases... ]\n'

  for s in sorted(os.listdir(os.path.join(options.binaryen_test, 'binaryen.js'))):
    if not s.endswith('.js'): continue
    print s
    f = open('a.js', 'w')
    f.write(open(os.path.join(options.binaryen_bin, 'binaryen.js')).read())
    f.write(open(os.path.join(options.binaryen_test, 'binaryen.js', s)).read())
    f.close()
    cmd = [MOZJS, 'a.js']
    out = run_command(cmd, stderr=subprocess.STDOUT)
    expected = open(os.path.join(options.binaryen_test, 'binaryen.js', s + '.txt')).read()
    if expected not in out:
      fail(out, expected)

s2wasm.test_s2wasm()
s2wasm.test_linker()

print '\n[ running validation tests... ]\n'
# Ensure the tests validate by default
cmd = WASM_AS + [os.path.join(options.binaryen_test, 'validator', 'invalid_export.wast')]
run_command(cmd)
cmd = WASM_AS + [os.path.join(options.binaryen_test, 'validator', 'invalid_import.wast')]
run_command(cmd)
cmd = WASM_AS + ['--validate=web', os.path.join(options.binaryen_test, 'validator', 'invalid_export.wast')]
run_command(cmd, expected_status=1)
cmd = WASM_AS + ['--validate=web', os.path.join(options.binaryen_test, 'validator', 'invalid_import.wast')]
run_command(cmd, expected_status=1)
cmd = WASM_AS + ['--validate=none', os.path.join(options.binaryen_test, 'validator', 'invalid_return.wast')]
run_command(cmd)

if options.torture and options.test_waterfall:

  print '\n[ checking torture testcases... ]\n'

  unexpected_result_count = 0

  import test.waterfall.src.link_assembly_files as link_assembly_files
  s2wasm_torture_out = os.path.abspath(os.path.join(options.binaryen_test, 's2wasm-torture-out'))
  if os.path.isdir(s2wasm_torture_out):
    shutil.rmtree(s2wasm_torture_out)
  os.mkdir(s2wasm_torture_out)
  unexpected_result_count += link_assembly_files.run(
      linker=os.path.abspath(S2WASM_EXE),
      files=os.path.abspath(os.path.join(options.binaryen_test, 'torture-s', '*.s')),
      fails=os.path.abspath(os.path.join(options.binaryen_test, 's2wasm_known_gcc_test_failures.txt')),
      out=s2wasm_torture_out)
  assert os.path.isdir(s2wasm_torture_out), 'Expected output directory %s' % s2wasm_torture_out

  import test.waterfall.src.execute_files as execute_files
  unexpected_result_count += execute_files.run(
      runner=os.path.abspath(WASM_SHELL_EXE),
      files=os.path.abspath(os.path.join(s2wasm_torture_out, '*.wast')),
      fails=os.path.abspath(os.path.join(options.binaryen_test, 's2wasm_known_binaryen_shell_test_failures.txt')),
      out='',
      wasmjs='')

  shutil.rmtree(s2wasm_torture_out)
  if unexpected_result_count:
    fail('%s failures' % unexpected_result_count, '0 failures')

if has_vanilla_emcc and has_vanilla_llvm and 0:

  print '\n[ checking emcc WASM_BACKEND testcases...]\n'

  try:
    if has_vanilla_llvm:
      os.environ['LLVM'] = BIN_DIR # use the vanilla LLVM
    else:
      # if we did not set vanilla llvm, then we must set this env var to make emcc use the wasm backend.
      # (if we are using vanilla llvm, things should just work)
      print '(not using vanilla llvm, so setting env var to tell emcc to use wasm backend)'
      os.environ['EMCC_WASM_BACKEND'] = '1'
    VANILLA_EMCC = os.path.join(options.binaryen_test, 'emscripten', 'emcc')
    # run emcc to make sure it sets itself up properly, if it was never run before
    command = [VANILLA_EMCC, '-v']
    print '____' + ' '.join(command)
    subprocess.check_call(command)

    for c in sorted(os.listdir(os.path.join(options.binaryen_test, 'wasm_backend'))):
      if not c.endswith('cpp'): continue
      print '..', c
      base = c.replace('.cpp', '').replace('.c', '')
      expected = open(os.path.join(options.binaryen_test, 'wasm_backend', base + '.txt')).read()
      for opts in [[], ['-O1'], ['-O2']]:
        only = [] if opts != ['-O1'] or '_only' not in base else ['-s', 'ONLY_MY_CODE=1'] # only my code is a hack we used early in wasm backend dev, which somehow worked, but only with -O1
        command = [VANILLA_EMCC, '-o', 'a.wasm.js', os.path.join(options.binaryen_test, 'wasm_backend', c)] + opts + only
        print '....' + ' '.join(command)
        if os.path.exists('a.wasm.js'): os.unlink('a.wasm.js')
        subprocess.check_call(command)
        if NODEJS:
          print '  (check in node)'
          cmd = [NODEJS, 'a.wasm.js']
          out = run_command(cmd)
          if out.strip() != expected.strip():
            fail(out, expected)
  finally:
    if has_vanilla_llvm:
      del os.environ['LLVM']
    else:
      del os.environ['EMCC_WASM_BACKEND']

print '\n[ checking example testcases... ]\n'

if options.run_gcc_tests:
  print '\n[ checking native gcc testcases...]\n'  
  if not NATIVECC or not NATIVEXX:
    fail_with_error('Native compiler (e.g. gcc/g++) was not found in PATH!')
  else:
    for t in sorted(os.listdir(os.path.join(options.binaryen_test, 'example'))):
      output_file = os.path.join(options.binaryen_bin, 'example')
      cmd = ['-I' + os.path.join(options.binaryen_root, 'src'), '-g', '-lasmjs', '-lsupport', '-L' + os.path.join(options.binaryen_bin, '..', 'lib'), '-pthread', '-o', output_file]
      if t.endswith('.txt'):
        # check if there is a trace in the file, if so, we should build it
        out = subprocess.Popen([os.path.join('scripts', 'clean_c_api_trace.py'), os.path.join(options.binaryen_test, 'example', t)], stdout=subprocess.PIPE).communicate()[0]
        if len(out) == 0:
          print '  (no trace in ', t, ')'
          continue
        print '  (will check trace in ', t, ')'
        src = 'trace.cpp'
        with open(src, 'w') as o: o.write(out)
        expected = os.path.join(options.binaryen_test, 'example', t + '.txt')
      else:
        src = os.path.join(options.binaryen_test, 'example', t)
        expected = os.path.join(options.binaryen_test, 'example', '.'.join(t.split('.')[:-1]) + '.txt')
      if src.endswith(('.c', '.cpp')):
        # build the C file separately
        extra = [NATIVECC, src, '-c', '-o', 'example.o',
                 '-I' + os.path.join(options.binaryen_root, 'src'), '-g', '-L' + os.path.join(options.binaryen_bin, '..', 'lib'), '-pthread']
        print 'build: ', ' '.join(extra)
        subprocess.check_call(extra)
        # Link against the binaryen C library DSO, using an executable-relative rpath
        cmd = ['example.o', '-lbinaryen'] + cmd + ['-Wl,-rpath=$ORIGIN/../lib']
      else:
        continue
      print '  ', t, src, expected
      if os.environ.get('COMPILER_FLAGS'):
        for f in os.environ.get('COMPILER_FLAGS').split(' '):
          cmd.append(f)
      cmd = [NATIVEXX, '-std=c++11'] + cmd
      try:
        print 'link: ', ' '.join(cmd)
        subprocess.check_call(cmd)
        print 'run...', output_file
        proc = subprocess.Popen([output_file], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        actual, err = proc.communicate()
        assert proc.returncode == 0, [proc.returncode, actual, err]
      finally:
        os.remove(output_file)
        if sys.platform == 'darwin':
          # Also removes debug directory produced on Mac OS
          shutil.rmtree(output_file + '.dSYM')

      expected = open(expected).read()
      if actual != expected:
        fail(actual, expected)

if EMCC:

  if MOZJS and 0:

    print '\n[ checking native wasm support ]\n'

    command = [EMCC, '-o', 'a.wasm.js', '-s', 'BINARYEN=1', os.path.join(options.binaryen_test, 'hello_world.c'), '-s', 'BINARYEN_METHOD="native-wasm"', '-s', 'BINARYEN_SCRIPTS="spidermonkify.py"']
    print ' '.join(command)
    subprocess.check_call(command)

    cmd = [MOZJS, 'a.wasm.js']
    out = run_command(cmd)
    assert 'hello, world!' in out, out

    proc = subprocess.Popen([NODEJS, 'a.wasm.js'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out, err = proc.communicate()
    assert proc.returncode != 0, 'should fail on no wasm support'
    assert 'no native wasm support detected' in err, err

  print '\n[ checking wasm.js methods... ]\n'

  for method_init in ['interpret-asm2wasm', 'interpret-s-expr', 'asmjs', 'interpret-binary', 'asmjs,interpret-binary', 'interpret-binary,asmjs']:
    # check success and failure for simple modes, only success for combined/fallback ones
    for success in [1, 0] if ',' not in method_init else [1]:
      method = method_init
      command = [EMCC, '-o', 'a.wasm.js', '-s', 'BINARYEN=1', os.path.join(options.binaryen_test, 'hello_world.c') ]
      command += ['-s', 'BINARYEN_METHOD="' + method + '"']
      print method, ' : ', ' '.join(command), ' => ', success
      subprocess.check_call(command)

      see_polyfill =  'var WasmJS = ' in open('a.wasm.js').read()

      if method and 'interpret' not in method:
        assert not see_polyfill, 'verify polyfill was not added - we specified a method, and it does not need it'
      else:
        assert see_polyfill, 'we need the polyfill'

      def break_cashew():
        asm = open('a.wasm.asm.js').read()
        asm = asm.replace('"almost asm"', '"use asm"; var not_in_asm = [].length + (true || { x: 5 }.x);')
        asm = asm.replace("'almost asm'", '"use asm"; var not_in_asm = [].length + (true || { x: 5 }.x);')
        with open('a.wasm.asm.js', 'w') as o: o.write(asm)
      if method.startswith('interpret-asm2wasm'):
        delete_from_orbit('a.wasm.wast') # we should not need the .wast
        if not success:
          break_cashew() # we need cashew
      elif method.startswith('interpret-s-expr'):
        delete_from_orbit('a.wasm.asm.js') # we should not need the .asm.js
        if not success:
          delete_from_orbit('a.wasm.wast')
      elif method.startswith('asmjs'):
        delete_from_orbit('a.wasm.wast') # we should not need the .wast
        break_cashew() # we don't use cashew, so ok to break it
        if not success:
          delete_from_orbit('a.wasm.js')
      elif method.startswith('interpret-binary'):
        delete_from_orbit('a.wasm.wast') # we should not need the .wast
        delete_from_orbit('a.wasm.asm.js') # we should not need the .asm.js
        if not success:
          delete_from_orbit('a.wasm.wasm')
      else:
        1/0
      if NODEJS:
        proc = subprocess.Popen([NODEJS, 'a.wasm.js'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        out, err = proc.communicate()
        if success:
          assert proc.returncode == 0, err
          assert 'hello, world!' in out, out
        else:
          assert proc.returncode != 0, err
          assert 'hello, world!' not in out, out

  print '\n[ checking wasm.js testcases... ]\n'

  for c in tests:
    if c.endswith(('.c', '.cpp')):
      print '..', c
      base = c.replace('.cpp', '').replace('.c', '')
      post = base + '.post.js'
      try:
        post = open(os.path.join(options.binaryen_test, post)).read()
      except:
        post = None
      expected = open(os.path.join(options.binaryen_test, base + '.txt')).read()
      emcc = os.path.join(options.binaryen_test, base + '.emcc')
      extra = []
      if os.path.exists(emcc):
        extra = json.loads(open(emcc).read())
      if os.path.exists('a.normal.js'): os.unlink('a.normal.js')
      for opts in [[], ['-O1'], ['-O2'], ['-O3'], ['-Oz']]:
        for method in ['interpret-asm2wasm', 'interpret-s-expr', 'interpret-binary']:
          command = [EMCC, '-o', 'a.wasm.js', '-s', 'BINARYEN=1', os.path.join(options.binaryen_test, c)] + opts + extra
          command += ['-s', 'BINARYEN_METHOD="' + method + '"']
          command += ['-s', 'BINARYEN_TRAP_MODE="js"']
          print '....' + ' '.join(command)
          subprocess.check_call(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
          if post:
            open('a.wasm.js', 'a').write(post)
          else:
            print '     (no post)'
          for which in ['wasm']:
            print '......', which
            try:
              args = json.loads(open(os.path.join(options.binaryen_test, base + '.args')).read())
            except:
              args = []
              print '     (no args)'

            def execute():
              if NODEJS:
                cmd = [NODEJS, 'a.' + which + '.js'] + args
                out = run_command(cmd)
                if out.strip() != expected.strip():
                  fail(out, expected)

            execute()

            if method in ['interpret-s-expr']:
              # binary and back
              shutil.copyfile('a.wasm.wast', 'a.wasm.original.wast')
              recreated = binary_format_check('a.wasm.wast', verify_final_result=False)
              shutil.copyfile(recreated, 'a.wasm.wast')
              execute()

if num_failures == 0:
  print '\n[ success! ]'

if warnings:
  print '\n' + '\n'.join(warnings)

if num_failures > 0:
  print '\n[ ' + str(num_failures) + ' failures! ]'

sys.exit(num_failures)
