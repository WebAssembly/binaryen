#!/usr/bin/env python
#
# Copyright 2016 WebAssembly Community Group participants
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

'''
This fuzzes the relooper using the C API.
'''

import difflib
import os
import random
import subprocess

if os.environ.get('LD_LIBRARY_PATH'):
  os.environ['LD_LIBRARY_PATH'] += os.pathsep + 'lib'
else:
  os.environ['LD_LIBRARY_PATH'] = 'lib'

counter = 0

while True:
  # Random decisions
  num = random.randint(2, 250)
  density = random.random() * random.random()
  max_decision = num * 20
  decisions = [random.randint(1, max_decision) for x in range(num * 3)]
  branches = [0] * num
  defaults = [0] * num
  for i in range(num):
    b = set([])
    bs = random.randint(1, max(1,
                               round(density * random.random() * (num - 1))))
    for j in range(bs):
      b.add(random.randint(1, num - 1))
    b = list(b)
    defaults[i] = random.choice(b)
    b.remove(defaults[i])
    branches[i] = b
  optimize = random.random() < 0.5
  print counter, ':', num, density, optimize
  counter += 1

  for temp in ['fuzz.wasm', 'fuzz.wast', 'fast.txt', 'fuzz.slow.js',
               'fuzz.c']:
    try:
      os.unlink(temp)
    except OSError:
      pass

  # parts
  entry = '''
var label = 0;
var state;
var decisions = %s;
var index = 0;
function check() {
  if (index == decisions.length) throw 'HALT';
  console.log('(i32.const ' + (-decisions[index]) + ')');
  return decisions[index++];
}
''' % str(decisions)

  slow = entry + '\n'
  slow += 'label = 0;\n'

  slow += '''
while(1) switch(label) {
'''

  fast = '''

#include <assert.h>
#include <stdio.h>

#include "binaryen-c.h"

// globals: address 4 is index
// decisions are at address 8+

int main() {
  BinaryenModuleRef module = BinaryenModuleCreate();

  // check()

  // if the end, halt
  BinaryenExpressionRef halter = BinaryenIf(module,
    BinaryenBinary(module,
      BinaryenEqInt32(),
      BinaryenLoad(module, 4, 0, 0, 0, BinaryenInt32(),
                   BinaryenConst(module, BinaryenLiteralInt32(4))),
      BinaryenConst(module, BinaryenLiteralInt32(4 * %d)) // jumps of 4 bytes
    ),
    BinaryenUnreachable(module),
    NULL
  );
  // increment index
  BinaryenExpressionRef incer = BinaryenStore(module,
    4, 0, 0,
    BinaryenConst(module, BinaryenLiteralInt32(4)),
    BinaryenBinary(module,
      BinaryenAddInt32(),
      BinaryenLoad(module, 4, 0, 0, 0, BinaryenInt32(),
                   BinaryenConst(module, BinaryenLiteralInt32(4))),
      BinaryenConst(module, BinaryenLiteralInt32(4))
    ),
    BinaryenInt32()
  );

  // optionally, print the return value
  BinaryenExpressionRef args[] = {
    BinaryenBinary(module,
      BinaryenSubInt32(),
      BinaryenConst(module, BinaryenLiteralInt32(0)),
      BinaryenLoad(module,
        4, 0, 4, 0, BinaryenInt32(),
        BinaryenLoad(module, 4, 0, 0, 0, BinaryenInt32(),
                     BinaryenConst(module, BinaryenLiteralInt32(4)))
      )
    )
  };
  BinaryenExpressionRef debugger;
  if (1) debugger = BinaryenCall(module, "print", args, 1,
                                 BinaryenNone());
  else debugger = BinaryenNop(module);

  // return the decision. need to subtract 4 that we just added,
  // and add 8 since that's where we start, so overall offset 4
  BinaryenExpressionRef returner = BinaryenLoad(module,
    4, 0, 4, 0, BinaryenInt32(),
    BinaryenLoad(module, 4, 0, 0, 0, BinaryenInt32(),
    BinaryenConst(module, BinaryenLiteralInt32(4)))
  );
  BinaryenExpressionRef checkBodyList[] = { halter, incer, debugger,
                                            returner };
  BinaryenExpressionRef checkBody = BinaryenBlock(module,
    NULL, checkBodyList, sizeof(checkBodyList) / sizeof(BinaryenExpressionRef)
  );
  BinaryenFunctionTypeRef i = BinaryenAddFunctionType(module, "i",
                                                      BinaryenInt32(),
                                                      NULL, 0);
  BinaryenAddFunction(module, "check", i, NULL, 0, checkBody);

  // contents of main() begin here

  RelooperRef relooper = RelooperCreate();

''' % len(decisions)

  for i in range(0, num):
    slow += '  case %d: console.log("(i32.const %d)"); state = check(); \n' % (
            i, i)
    b = branches[i]
    for j in range(len(b)):
      slow += '    if (state %% %d == %d) { label = %d; break }\n' % (
              len(b) + 1, j, b[j])  # TODO: split range 1-n into these options
    slow += '    label = %d; break\n' % defaults[i]

  use_switch = [random.random() < 0.5 for i in range(num)]

  for i in range(num):
    fast += '''
  RelooperBlockRef b%d;
  {
    BinaryenExpressionRef args[] = {
      BinaryenConst(module, BinaryenLiteralInt32(%d))
    };
    BinaryenExpressionRef list[] = {
      BinaryenCall(module, "print", args, 1, BinaryenNone()),
      BinaryenSetLocal(module, 0, BinaryenCall(module, "check", NULL, 0,
                                               BinaryenInt32()))
    };
''' % (i, i)
    if use_switch[i]:
      fast += '''
    b%d = RelooperAddBlockWithSwitch(relooper,
      BinaryenBlock(module, NULL, list, 2),
      BinaryenBinary(module,
        BinaryenRemUInt32(),
        BinaryenGetLocal(module, 0, BinaryenInt32()),
        BinaryenConst(module, BinaryenLiteralInt32(%d))
      )
    );
''' % (i, len(branches[i]) + 1)
    else:  # non-switch
      fast += '''
    b%d = RelooperAddBlock(relooper, BinaryenBlock(module, NULL, list, 2));
''' % i
    fast += '''
  }
'''

  for i in range(num):
    b = branches[i]
    for j in range(len(b)):
      if use_switch[i]:
        total = len(b) + 1
        values = ','.join([str(x) for x in range(random.randint(len(b) + 1,
                           max_decision + 2)) if x % total == j])
        fast += '''
  {
    BinaryenIndex values[] = { %s };
    RelooperAddBranchForSwitch(b%d, b%d, values,
                               sizeof(values) / sizeof(BinaryenIndex), NULL);
  }
''' % (values, i, b[j])
      else:  # non-switch
        fast += '''
  RelooperAddBranch(b%d, b%d, BinaryenBinary(module,
    BinaryenEqInt32(),
    BinaryenBinary(module,
      BinaryenRemUInt32(),
      BinaryenGetLocal(module, 0, BinaryenInt32()),
      BinaryenConst(module, BinaryenLiteralInt32(%d))
    ),
    BinaryenConst(module, BinaryenLiteralInt32(%d))
  ), NULL);
''' % (i, b[j], len(b) + 1, j)
    # default branch
    if use_switch[i]:
      fast += '''
  RelooperAddBranchForSwitch(b%d, b%d, NULL, 0, NULL);
''' % (i, defaults[i])
    else:
      fast += '''
  RelooperAddBranch(b%d, b%d, NULL, NULL);
''' % (i, defaults[i])

  fast += '''
  BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, b0, 1,
                                                        module);

  int decisions[] = { %s };
  int numDecisions = sizeof(decisions)/sizeof(int);

  // write out all the decisions, then the body of the function
  BinaryenExpressionRef full[numDecisions + 1];

  {
    int i;
    for (i = 0; i < numDecisions; i++) {
      full[i] = BinaryenStore(module,
        4, 0, 0,
        BinaryenConst(module, BinaryenLiteralInt32(8 + 4 * i)),
        BinaryenConst(module, BinaryenLiteralInt32(decisions[i])),
        BinaryenInt32()
      );
    }
  }
  full[numDecisions] = body;
  BinaryenExpressionRef all = BinaryenBlock(module, NULL, full,
                                            numDecisions + 1);

  BinaryenFunctionTypeRef v = BinaryenAddFunctionType(module, "v",
                                                      BinaryenNone(),
                                                      NULL, 0);
  // locals: state, free-for-label
  BinaryenType localTypes[] = { BinaryenInt32(), BinaryenInt32() };
  BinaryenFunctionRef theMain = BinaryenAddFunction(module, "main", v,
                                                    localTypes, 2, all);
  BinaryenSetStart(module, theMain);

  // import

  BinaryenType iparams[] = { BinaryenInt32() };
  BinaryenFunctionTypeRef vi = BinaryenAddFunctionType(module, "vi",
                                                       BinaryenNone(),
                                                       iparams, 1);
  BinaryenAddImport(module, "print", "spectest", "print", vi);

  // memory
  BinaryenSetMemory(module, 1, 1, "mem", NULL, NULL, NULL, 0);

  // optionally, optimize
  if (%d) BinaryenModuleOptimize(module);

  assert(BinaryenModuleValidate(module));

  // write it out

  BinaryenModulePrint(module);

  BinaryenModuleDispose(module);

  return 0;
}
''' % (', '.join(map(str, decisions)), optimize)

  slow += '}'

  open('fuzz.slow.js', 'w').write(slow)
  open('fuzz.c', 'w').write(fast)

  print '.'
  cmd = [os.environ.get('CC') or 'gcc', 'fuzz.c', '-Isrc',
         '-lbinaryen', '-lasmjs',
         '-lsupport', '-Llib/.', '-pthread', '-o', 'fuzz']
  subprocess.check_call(cmd)
  print '^'
  subprocess.check_call(['./fuzz'], stdout=open('fuzz.wast', 'w'))
  print '*'
  fast_out = subprocess.Popen(['bin/wasm-shell', 'fuzz.wast'],
                              stdout=subprocess.PIPE,
                              stderr=subprocess.PIPE).communicate()[0]
  print '-'
  slow_out = subprocess.Popen(['nodejs', 'fuzz.slow.js'],
                              stdout=subprocess.PIPE,
                              stderr=subprocess.PIPE).communicate()[0]
  print '_'

  if slow_out != fast_out:
    print ''.join([a.rstrip() + '\n' for a in difflib.unified_diff(
          slow_out.split('\n'),
          fast_out.split('\n'),
          fromfile='slow',
          tofile='fast')])
    assert False
