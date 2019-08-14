
"""Removes local names. When you don't care about local names but do want
to diff for structural changes, this can help.
"""

import sys

for line in open(sys.argv[1]).readlines():
    if '(local.tee ' in line or '(local.set ' in line or '(local.get ' in line:
        print(line[:line.find('$')])
    else:
        print(line.rstrip())
