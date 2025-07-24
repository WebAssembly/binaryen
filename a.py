import os, sys
import subprocess

diff = subprocess.check_output(['git', 'diff', 'src/'])
if diff:
  print('cannot run since diff exists')
  sys.exit(1)

new = []

for line in open('src/wasm-interpreter.h').readlines():
  # look for
  #           Flow flow = visit(expression);
  # or
  #           Flow flow = self()->visit(expression);
  if ' = visit(' in line or ' = self()->visit(' in line:
    print(line.rstrip())
    parts = line.split(' ')
    eq_index = parts.index('=')

  new.append(line)

open('src/wasm-interpreter.h', 'w').write(''.join(new))
