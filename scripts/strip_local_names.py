
'''
Removes local names. When you don't care about local names but do want
to diff for structural changes, this can help.
'''

import sys

for line in open(sys.argv[1]).readlines():
  if '(tee_local ' in line or '(set_local ' in line or '(get_local ' in line:
    print line[:line.find('$')]
  else:
    print line,
