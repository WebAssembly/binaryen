import os, sys
import subprocess

diff = subprocess.check_output(['git', 'diff', 'src/'])
if diff:
  print('cannot run since diff exists')
  sys.exit(1)

for line in open('src/wasm-interpreter.h').readlines():
  print(line)
  # look for
  #           Flow flow = visit(expression);
  # or
  #           Flow flow = self()->visit(expression);
  if ' = visit(' in line or ' = self()->visit(' in line:
      Flow flow = self()->visit(expression);

