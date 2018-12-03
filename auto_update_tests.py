#!/usr/bin/env python
#
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

import os
import shutil
import subprocess
import sys

from scripts.test.support import run_command, split_wast, node_test_glue, node_has_webassembly
from scripts.test.shared import (
    ASM2WASM, MOZJS, NODEJS, WASM_OPT, WASM_AS, WASM_DIS,
    WASM_CTOR_EVAL, WASM_MERGE, WASM_REDUCE, WASM2JS, WASM_METADCE,
    WASM_EMSCRIPTEN_FINALIZE, BINARYEN_INSTALL_DIR, BINARYEN_JS,
    files_with_pattern, has_shell_timeout, options)
from scripts.test.wasm2js import tests, spec_tests, extra_wasm2js_tests, assert_tests, wasm2js_dir, wasm2js_blacklist


def update_asm_js_tests():
  print '[ processing and updating testcases... ]\n'
  for asm in sorted(os.listdir('test')):
    if asm.endswith('.asm.js'):
      for precise in [0, 1, 2]:
        for opts in [1, 0]:
          cmd = ASM2WASM + [os.path.join('test', asm), '--enable-threads']
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
          print ' '.join(cmd)
          actual = run_command(cmd)
          with open(os.path.join('test', wasm), 'w') as o:
            o.write(actual)
          if 'debugInfo' in asm:
            cmd += ['--source-map', os.path.join('test', wasm + '.map'), '-o', 'a.wasm']
            run_command(cmd)


def update_lld_tests():
  print '\n[ checking wasm-emscripten-finalize testcases... ]\n'

  extension_arg_map = {
    '.out': [],
    '.jscall.out': ['--emscripten-reserved-function-pointers=3'],
  }
  for wast_path in files_with_pattern('test', 'lld', '*.wast'):
    print '..', wast_path
    for ext, ext_args in extension_arg_map.items():
      out_path = wast_path + ext
      if ext != '.out' and not os.path.exists(out_path):
        continue
      cmd = (WASM_EMSCRIPTEN_FINALIZE +
             [wast_path, '-S', '--global-base=568'] + ext_args)
      actual = run_command(cmd)
      with open(out_path, 'w') as o:
        o.write(actual)


def update_wasm_opt_tests():
  print '\n[ checking wasm-opt -o notation... ]\n'
  wast = os.path.join('test', 'hello_world.wast')
  cmd = WASM_OPT + [wast, '-o', 'a.wast', '-S']
  run_command(cmd)
  open(wast, 'w').write(open('a.wast').read())

  print '\n[ checking wasm-opt binary reading/writing... ]\n'
  for t in sorted(os.listdir(os.path.join('test', 'print'))):
    if t.endswith('.wast'):
      print '..', t
      wasm = os.path.basename(t).replace('.wast', '')
      cmd = WASM_OPT + [os.path.join('test', 'print', t), '--print']
      print '    ', ' '.join(cmd)
      actual = subprocess.check_output(cmd)
      print cmd, actual
      with open(os.path.join('test', 'print', wasm + '.txt'), 'w') as o:
        o.write(actual)
      cmd = WASM_OPT + [os.path.join('test', 'print', t), '--print-minified']
      print '    ', ' '.join(cmd)
      actual = subprocess.check_output(cmd)
      with open(os.path.join('test', 'print', wasm + '.minified.txt'), 'w') as o:
        o.write(actual)

  print '\n[ checking wasm-opt passes... ]\n'
  for t in sorted(os.listdir(os.path.join('test', 'passes'))):
    if t.endswith(('.wast', '.wasm')):
      print '..', t
      binary = '.wasm' in t
      base = os.path.basename(t).replace('.wast', '').replace('.wasm', '')
      passname = base
      if passname.isdigit():
        passname = open(os.path.join('test', 'passes', passname + '.passes')).read().strip()
      opts = [('--' + p if not p.startswith('O') else '-' + p) for p in passname.split('_')]
      t = os.path.join('test', 'passes', t)
      actual = ''
      for module, asserts in split_wast(t):
        assert len(asserts) == 0
        with open('split.wast', 'w') as o:
          o.write(module)
        cmd = WASM_OPT + opts + ['split.wast', '--print']
        actual += run_command(cmd)
      with open(os.path.join('test', 'passes', base + ('.bin' if binary else '') + '.txt'), 'w') as o:
        o.write(actual)
      if 'emit-js-wrapper' in t:
        with open('a.js') as i:
          with open(t + '.js', 'w') as o:
            o.write(i.read())
      if 'emit-spec-wrapper' in t:
        with open('a.wat') as i:
          with open(t + '.wat', 'w') as o:
            o.write(i.read())

  print '\n[ checking wasm-opt testcases... ]\n'
  for t in os.listdir('test'):
    if t.endswith('.wast') and not t.startswith('spec'):
      print '..', t
      t = os.path.join('test', t)
      f = t + '.from-wast'
      cmd = WASM_OPT + [t, '--print']
      actual = run_command(cmd)
      actual = actual.replace('printing before:\n', '')
      open(f, 'w').write(actual)

  print '\n[ checking wasm-opt debugInfo read-write... ]\n'
  for t in os.listdir('test'):
    if t.endswith('.fromasm') and 'debugInfo' in t:
      print '..', t
      t = os.path.join('test', t)
      f = t + '.read-written'
      run_command(WASM_AS + [t, '--source-map=a.map', '-o', 'a.wasm', '-g'])
      run_command(WASM_OPT + ['a.wasm', '--input-source-map=a.map', '-o', 'b.wasm', '--output-source-map=b.map', '-g'])
      actual = run_command(WASM_DIS + ['b.wasm', '--source-map=b.map'])
      open(f, 'w').write(actual)


def update_bin_fmt_tests():
  print '\n[ checking binary format testcases... ]\n'
  for wast in sorted(os.listdir('test')):
    if wast.endswith('.wast') and wast not in []:  # blacklist some known failures
      for debug_info in [0, 1]:
        cmd = WASM_AS + [os.path.join('test', wast), '-o', 'a.wasm']
        if debug_info:
          cmd += ['-g']
        print ' '.join(cmd)
        if os.path.exists('a.wasm'):
          os.unlink('a.wasm')
        subprocess.check_call(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        assert os.path.exists('a.wasm')

        cmd = WASM_DIS + ['a.wasm', '-o', 'a.wast']
        print ' '.join(cmd)
        if os.path.exists('a.wast'):
          os.unlink('a.wast')
        subprocess.check_call(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        assert os.path.exists('a.wast')
        actual = open('a.wast').read()
        binary_name = wast + '.fromBinary'
        if not debug_info:
          binary_name += '.noDebugInfo'
        with open(os.path.join('test', binary_name), 'w') as o:
          o.write(actual)


def update_example_tests():
  print '\n[ checking example testcases... ]\n'
  for t in sorted(os.listdir(os.path.join('test', 'example'))):
    output_file = os.path.join(options.binaryen_bin, 'example')
    libdir = os.path.join(BINARYEN_INSTALL_DIR, 'lib')
    cmd = ['-Isrc', '-g', '-pthread', '-o', output_file]
    if t.endswith('.txt'):
      # check if there is a trace in the file, if so, we should build it
      out = subprocess.Popen([os.path.join('scripts', 'clean_c_api_trace.py'), os.path.join('test', 'example', t)], stdout=subprocess.PIPE).communicate()[0]
      if len(out) == 0:
        print '  (no trace in ', t, ')'
        continue
      print '  (will check trace in ', t, ')'
      src = 'trace.cpp'
      with open(src, 'w') as o:
        o.write(out)
      expected = os.path.join('test', 'example', t + '.txt')
    else:
      src = os.path.join('test', 'example', t)
      expected = os.path.join('test', 'example', '.'.join(t.split('.')[:-1]) + '.txt')
    if not src.endswith(('.c', '.cpp')):
      continue
    # build the C file separately
    extra = [os.environ.get('CC') or 'gcc',
             src, '-c', '-o', 'example.o',
             '-Isrc', '-g', '-L' + libdir, '-pthread']
    print 'build: ', ' '.join(extra)
    if src.endswith('.cpp'):
      extra += ['-std=c++11']
    print os.getcwd()
    subprocess.check_call(extra)
    # Link against the binaryen C library DSO, using rpath
    cmd = ['example.o', '-L' + libdir, '-lbinaryen', '-Wl,-rpath,' + os.path.abspath(libdir)] + cmd
    print '  ', t, src, expected
    if os.environ.get('COMPILER_FLAGS'):
      for f in os.environ.get('COMPILER_FLAGS').split(' '):
        cmd.append(f)
    cmd = [os.environ.get('CXX') or 'g++', '-std=c++11'] + cmd
    try:
      print 'link: ', ' '.join(cmd)
      subprocess.check_call(cmd)
      print 'run...', output_file
      proc = subprocess.Popen([output_file], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
      actual, err = proc.communicate()
      assert proc.returncode == 0, [proc.returncode, actual, err]
      with open(expected, 'w') as o:
        o.write(actual)
    finally:
      os.remove(output_file)
      if sys.platform == 'darwin':
        # Also removes debug directory produced on Mac OS
        shutil.rmtree(output_file + '.dSYM')


def update_wasm_dis_tests():
  print '\n[ checking wasm-dis on provided binaries... ]\n'
  for t in os.listdir('test'):
    if t.endswith('.wasm') and not t.startswith('spec'):
      print '..', t
      t = os.path.join('test', t)
      cmd = WASM_DIS + [t]
      if os.path.isfile(t + '.map'):
        cmd += ['--source-map', t + '.map']
      actual = run_command(cmd)

      open(t + '.fromBinary', 'w').write(actual)


def update_wasm_merge_tests():
  print '\n[ checking wasm-merge... ]\n'
  for t in os.listdir(os.path.join('test', 'merge')):
    if t.endswith(('.wast', '.wasm')):
      print '..', t
      t = os.path.join('test', 'merge', t)
      u = t + '.toMerge'
      for finalize in [0, 1]:
        for opt in [0, 1]:
          cmd = WASM_MERGE + [t, u, '-o', 'a.wast', '-S', '--verbose']
          if finalize:
            cmd += ['--finalize-memory-base=1024', '--finalize-table-base=8']
          if opt:
            cmd += ['-O']
          stdout = run_command(cmd)
          actual = open('a.wast').read()
          out = t + '.combined'
          if finalize:
            out += '.finalized'
          if opt:
            out += '.opt'
          with open(out, 'w') as o:
            o.write(actual)
          with open(out + '.stdout', 'w') as o:
            o.write(stdout)


def update_binaryen_js_tests():
  if not (MOZJS or NODEJS):
    print 'no vm to run binaryen.js tests'
    return

  if not os.path.exists(BINARYEN_JS):
    print 'no binaryen.js build to test'
    return

  print '\n[ checking binaryen.js testcases... ]\n'
  node_has_wasm = NODEJS and node_has_webassembly(NODEJS)
  for s in sorted(os.listdir(os.path.join('test', 'binaryen.js'))):
    if not s.endswith('.js'):
      continue
    print s
    f = open('a.js', 'w')
    f.write(open(BINARYEN_JS).read())
    if NODEJS:
      f.write(node_test_glue())
    test_path = os.path.join('test', 'binaryen.js', s)
    test_src = open(test_path).read()
    f.write(test_src)
    f.close()
    if MOZJS or node_has_wasm or 'WebAssembly.' not in test_src:
      cmd = [MOZJS or NODEJS, 'a.js']
      if 'fatal' not in s:
        out = run_command(cmd, stderr=subprocess.STDOUT)
      else:
        # expect an error - the specific error code will depend on the vm
        out = run_command(cmd, stderr=subprocess.STDOUT, expected_status=None)
      with open(os.path.join('test', 'binaryen.js', s + '.txt'), 'w') as o:
        o.write(out)
    else:
      print 'Skipping ' + test_path + ' because WebAssembly might not be supported'


def update_ctor_eval_tests():
  print '\n[ checking wasm-ctor-eval... ]\n'
  for t in os.listdir(os.path.join('test', 'ctor-eval')):
    if t.endswith(('.wast', '.wasm')):
      print '..', t
      t = os.path.join('test', 'ctor-eval', t)
      ctors = open(t + '.ctors').read().strip()
      cmd = WASM_CTOR_EVAL + [t, '-o', 'a.wast', '-S', '--ctors', ctors]
      run_command(cmd)
      actual = open('a.wast').read()
      out = t + '.out'
      with open(out, 'w') as o:
        o.write(actual)


def update_wasm2js_tests():
  print '\n[ checking wasm2js ]\n'
  for wasm in tests + spec_tests + extra_wasm2js_tests:
    if not wasm.endswith('.wast'):
      continue

    if os.path.basename(wasm) in wasm2js_blacklist:
      continue

    asm = os.path.basename(wasm).replace('.wast', '.2asm.js')
    expected_file = os.path.join(wasm2js_dir, asm)

    # we run wasm2js on tests and spec tests only if the output
    # exists - only some work so far. the tests in extra are in
    # the test/wasm2js dir and so are specific to wasm2js, and
    # we run all of those.
    if wasm not in extra_wasm2js_tests and not os.path.exists(expected_file):
      continue

    print '..', wasm

    cmd = WASM2JS + [os.path.join('test', wasm)]
    out = run_command(cmd)
    with open(expected_file, 'w') as o:
      o.write(out)

  for wasm in assert_tests:
    print '..', wasm

    asserts = os.path.basename(wasm).replace('.wast.asserts', '.asserts.js')
    traps = os.path.basename(wasm).replace('.wast.asserts', '.traps.js')
    asserts_expected_file = os.path.join('test', asserts)
    traps_expected_file = os.path.join('test', traps)

    cmd = WASM2JS + [os.path.join(wasm2js_dir, wasm), '--allow-asserts']
    out = run_command(cmd)
    with open(asserts_expected_file, 'w') as o:
      o.write(out)

    cmd += ['--pedantic']
    out = run_command(cmd)
    with open(traps_expected_file, 'w') as o:
      o.write(out)


def update_metadce_tests():
  print '\n[ checking wasm-metadce... ]\n'
  for t in os.listdir(os.path.join('test', 'metadce')):
    if t.endswith(('.wast', '.wasm')):
      print '..', t
      t = os.path.join('test', 'metadce', t)
      graph = t + '.graph.txt'
      cmd = WASM_METADCE + [t, '--graph-file=' + graph, '-o', 'a.wast', '-S']
      stdout = run_command(cmd)
      actual = open('a.wast').read()
      out = t + '.dced'
      with open(out, 'w') as o:
        o.write(actual)
      with open(out + '.stdout', 'w') as o:
        o.write(stdout)


def update_reduce_tests():
  if not has_shell_timeout():
    return
  print '\n[ checking wasm-reduce ]\n'
  for t in os.listdir(os.path.join('test', 'reduce')):
    if t.endswith('.wast'):
      print '..', t
      t = os.path.join('test', 'reduce', t)
      # convert to wasm
      run_command(WASM_AS + [t, '-o', 'a.wasm'])
      print run_command(WASM_REDUCE + ['a.wasm', '--command=%s b.wasm --fuzz-exec' % WASM_OPT[0], '-t', 'b.wasm', '-w', 'c.wasm'])
      expected = t + '.txt'
      run_command(WASM_DIS + ['c.wasm', '-o', expected])


def main():
  update_asm_js_tests()
  update_lld_tests()
  update_wasm_opt_tests()
  update_bin_fmt_tests()
  update_example_tests()
  update_wasm_dis_tests()
  update_wasm_merge_tests()
  update_binaryen_js_tests()
  update_ctor_eval_tests()
  update_wasm2js_tests()
  update_metadce_tests()
  update_reduce_tests()

  print '\n[ success! ]'


if __name__ == '__main__':
  sys.exit(main())
