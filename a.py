import os, sys
import subprocess

diff = subprocess.check_output(['git', 'diff', 'src/'])
if diff:
  print('cannot run since diff exists')
  sys.exit(1)

new = []
lines = open('src/wasm-interpreter.h').readlines()
i = 0
while i < len(lines):
  line = lines[i]
  # look for
  #           Flow flow = visit(expression);
  # or
  #           Flow flow = self()->visit(expression);
  if ' = visit(' in line or ' = self()->visit(' in line:
    print(line.rstrip())
    parts = line.split(' ')
    parts[-1] = 'pop();'
    line = ' '.join(parts) + '\n'

  new.append(line)
  i += 1

open('src/wasm-interpreter.h', 'w').write(''.join(new))
