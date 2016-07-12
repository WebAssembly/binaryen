#! /usr/bin/env python

'''
Cleans up output from the C api, makes a runnable C file
'''

import sys

trace = open(sys.argv[1]).read()

start = trace.find('// beginning a Binaryen API trace')
if start >= 0:
  trace = trace[start:]

  while 1:
    start = trace.find('\n(')
    if start < 0:
      break
    end = trace.find('\n)', start + 1)
    assert end > 0
    trace = trace[:start] + trace[end + 2:]

  print trace
