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
    print(f'{prefix} \t\t -{a[item]}')
  elif item not in a and item in b:
    print(f'{prefix} \t\t +{b[item]}')
  else:
    # print the diff and ensure a + or - prefix
    diff = b[item] - a[item]
    print(f'{prefix} \t\t {"+" if diff > 0 else ""}{diff}')

