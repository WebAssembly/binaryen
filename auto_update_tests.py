#!/usr/bin/env python

import os, sys, subprocess, difflib

from scripts.test.support import run_command, split_wast
from scripts.test.shared import (
    ASM2WASM, MOZJS, S2WASM, WASM_SHELL, WASM_OPT, WASM_AS, WASM_DIS,
    WASM_CTOR_EVAL, WASM_MERGE, WASM_REDUCE, WASM2ASM, WASM_METADCE,
    BINARYEN_INSTALL_DIR, has_shell_timeout)
from scripts.test.wasm2asm import tests, spec_tests, extra_tests, assert_tests


if MOZJS:
  print '\n[ checking binaryen.js testcases... ]\n'

  for s in sorted(os.listdir(os.path.join('test', 'binaryen.js'))):
    if not s.endswith('.js'): continue
    if 'kitch' not in s: continue
    print s
    f = open('a.js', 'w')
    f.write(open(os.path.join('bin', 'binaryen.js')).read())
    # node/shell test support
    f.write(open(os.path.join('test', 'binaryen.js', s)).read())
    f.close()
    cmd = [MOZJS, 'a.js']
    out = run_command(cmd, stderr=subprocess.STDOUT)
    with open(os.path.join('test', 'binaryen.js', s + '.txt'), 'w') as o: o.write(out)

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
    with open(out, 'w') as o: o.write(actual)

print '\n[ checking wasm2asm ]\n'

for wasm in tests + spec_tests + extra_tests:
  if not wasm.endswith('.wast'):
    continue

  asm = os.path.basename(wasm).replace('.wast', '.2asm.js')
  expected_file = os.path.join('test', asm)

  if not os.path.exists(expected_file):
    continue

  print '..', wasm

  cmd = WASM2ASM + [os.path.join('test', wasm)]
  out = run_command(cmd)
  with open(expected_file, 'w') as o: o.write(out)

for wasm in assert_tests:
  print '..', wasm

  asserts = os.path.basename(wasm).replace('.wast.asserts', '.asserts.js')
  traps = os.path.basename(wasm).replace('.wast.asserts', '.traps.js')
  asserts_expected_file = os.path.join('test', asserts)
  traps_expected_file = os.path.join('test', traps)

  cmd = WASM2ASM + [os.path.join('test', wasm), '--allow-asserts']
  out = run_command(cmd)
  with open(asserts_expected_file, 'w') as o: o.write(out)

  cmd += ['--pedantic']
  out = run_command(cmd)
  with open(traps_expected_file, 'w') as o: o.write(out)

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
    with open(out, 'w') as o: o.write(actual)
    with open(out + '.stdout', 'w') as o: o.write(stdout)

if has_shell_timeout():
  print '\n[ checking wasm-reduce ]\n'

  for t in os.listdir(os.path.join('test', 'reduce')):
    if t.endswith('.wast'):
      print '..', t
      t = os.path.join('test', 'reduce', t)
      # convert to wasm
      run_command(WASM_AS + [t, '-o', 'a.wasm'])
      print run_command(WASM_REDUCE + ['a.wasm', '--command=bin/wasm-opt b.wasm --fuzz-exec', '-t', 'b.wasm', '-w', 'c.wasm'])
      expected = t + '.txt'
      run_command(WASM_DIS + ['c.wasm', '-o', expected])

print '\n[ success! ]'  
