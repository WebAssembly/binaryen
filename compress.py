#!/usr/bin/env python

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

import os, shutil, sys, subprocess, difflib, json, time, urllib2, itertools
import plotly
import plotly.graph_objs as go
import pprint

import scripts.storage
import scripts.support

warnings = []


files = [
  'test/emcc_O2_hello_world.wast.fromBinary'
]

kindNames = []
origSizes = []
lzmaSizes = []
gzipSizes = []

for file in files:
  print '\n[ processing file ' + file + ' ]\n'

  args = [os.path.join('bin', 'wasm-as'), file]
  opts = ['--use-op-table']

  for k in range(0, len(opts) + 1):
    for opt in itertools.combinations(opts, k):
      argz = args + list(opt)

      kindNames.append(" ".join(opt))

      # print args + list(opt)
      print "Assemble file."
      proc = subprocess.Popen(argz, stdout=open('out.bin', 'w'), stderr=subprocess.PIPE)
      out, err = proc.communicate()
      assert proc.returncode == 0, err
      origSize = os.stat('out.bin').st_size
      origSizes.append(origSize);

      print "Lzma"
      proc = subprocess.Popen(['lzma', '-k', '-f', '-9', 'out.bin'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
      out, err = proc.communicate()
      assert proc.returncode == 0, err
      lzmaSize = os.stat('out.bin.lzma').st_size
      lzmaSizes.append(lzmaSize)

      print "Gzip"
      proc = subprocess.Popen(['gzip', '-k', '-f', '-9', 'out.bin'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
      out, err = proc.communicate()
      assert proc.returncode == 0, err
      gzSize = os.stat('out.bin.gz').st_size
      gzipSizes.append(gzSize)

trace0 = go.Bar(
    x=kindNames,
    y=origSizes,
    name='orig'
)
trace1 = go.Bar(
    x=kindNames,
    y=lzmaSizes,
    name='lzma'
)
trace2 = go.Bar(
    x=kindNames,
    y=gzipSizes,
    name='gzip'
)
data = [trace0, trace1, trace2]
pprint.pprint(data)
# layout = go.Layout(
#     barmode='group'
# )
# fig = go.Figure(data=data, layout=layout)
# plot_url = plotly.offline.plot(fig, filename='grouped-bar')


# print plotly.__version__  # version >1.9.4 required
# from plotly.graph_objs import Scatter, Layout
# plotly.offline.plot({
# "data": [
#     Scatter(x=[1, 2, 3, 4], y=[4, 1, 3, 7])
# ],
# "layout": Layout(
#     title="hello world"
# )
# })




if warnings:
  print '\n' + '\n'.join(warnings)
