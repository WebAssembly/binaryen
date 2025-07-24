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
    # next, we should see
    #
    #    if (flow.breaking()) {
    #      return flow;
    #    }
    #
    next = lines[i + 1]
    if '.breaking()) {' in next:
      next = lines[i + 2]
      if 'return ' in next:
        next = lines[i + 3]
        if '}' in next:
          # success! turn it all into a pop
          parts = line.split(' ')
          parts[-1] = 'pop();'
          line = ' '.join(parts) + '\n'
          i += 3

  new.append(line)
  i += 1

open('src/wasm-interpreter.h', 'w').write(''.join(new))
