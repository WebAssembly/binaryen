'''
Given two files that are the output of --metrics, show a nice diff of them
'''

import os, sys

def parse(filename):
  ret = {}
  for line in open(filename).readlines():
    if ' : ' in line:
      item, count = line.split(' : ')
      ret[item.strip()] = int(count)
  return ret

a = parse(sys.argv[1])
b = parse(sys.argv[2])

items = set(list(a.keys()) + list(a.keys()))

longest_name = max([len(item) for item in items])

for item in sorted(list(items)):
  prefix = item + (' ' * (longest_name - len(item))) + ': '

  if item in a and item not in b:
    value = f'-{a[item]}'
  elif item not in a and item in b:
    value = f'+{a[item]}'
  else:
    diff = b[item] - a[item]
    # ensure a + or - prefix
    value = str(diff)
    if diff > 0:
      value = '+' + value

  # left-justify
  value = '{:>8}'.format(value)
  print(f'{prefix} {value}')

