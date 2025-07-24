import os, sys
import subprocess

diff = subprocess.check_output(['git', 'diff'])
if diff:
  print('cannot run since diff exists')
  sys.exit(1)

