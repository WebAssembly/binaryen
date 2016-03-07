'''
A bunch of hackish fixups for testing of SpiderMonkey support. We should
get rid of these ASAP.
'''

import os
import sys
import math
import shutil
import subprocess

import emscripten

binaryen_root = os.path.abspath(os.path.dirname(os.path.dirname(__file__)))

js_target = sys.argv[1]
wast_target = sys.argv[2]

wasm_target = wast_target[:-5] + '.wasm'

base_wast_target = os.path.basename(wast_target)
base_wasm_target = os.path.basename(wasm_target)


def fix(js, before, after):
  assert js.count(before) == 1
  return js.replace(before, after)

# fix up js
js = open(js_target).read()
# use the wasm, not wast
js = js.replace('"' + base_wast_target + '"', '"' + base_wasm_target + '"')
js = js.replace("'" + base_wast_target + "'", "'" + base_wasm_target + "'")
open(js_target, 'w').write(js)
shutil.copyfile(wast_target + '.mappedGlobals', wasm_target + '.mappedGlobals')

# lower cases, spidermonkey has no support for them
temp = wast_target + '.temp'
subprocess.check_call([os.path.join(binaryen_root, 'bin', 'binaryen-shell'),
                       wast_target, '--lower-case', '--print'],
                      stdout=open(temp, 'w'))
shutil.copyfile(temp, wast_target)
os.remove(temp)

# fix up wast
wast = open(wast_target).read()
# tableswitch => br_table
wast = wast.replace('(tableswitch', '(br_table')
# memory to page sizes
PAGE_SIZE = 64 * 1024
memory_start = wast.find('(memory') + 1
memory_end = wast.find(')', memory_start)
memory = wast[memory_start:memory_end]
parts = memory.split(' ')
parts[1] = str(int(math.ceil(float(parts[1]) / PAGE_SIZE)))
if len(parts) == 3:
  parts[2] = str(int(math.ceil(float(parts[2]) / PAGE_SIZE)))
wast = wast[:memory_start] + ' '.join(parts) + \
  wast[memory_end:memory_end + 1] + \
  ' (export "memory" memory) ' + wast[memory_end + 1:]
open(wast_target, 'w').write(wast)

# convert to binary using spidermonkey
subprocess.check_call(emscripten.shared.SPIDERMONKEY_ENGINE +
  ['-e', 'os.file.writeTypedArrayToFile("' + wasm_target + \
  '", new Uint8Array(wasmTextToBinary(os.file.readFile("' + \
  wast_target + '"))))'])
