#! /usr/bin/env python

#   Copyright 2015 WebAssembly Community Group participants
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

import os
import subprocess
import sys
import tempfile
import urllib2


STORAGE_BASE = 'https://storage.googleapis.com/wasm-llvm/builds/git/'


def update_torture():
  if not os.path.isdir('buildbot'):
    os.mkdir('buildbot')
  lkgr_path = os.path.join('buildbot', 'lkgr')
  with open(lkgr_path, 'w+') as f:
    lkgr = urllib2.urlopen(STORAGE_BASE + 'lkgr').read().strip()
    f.write(lkgr)
  torture = 'wasm-torture-s-%s.tbz2' % lkgr
  torture_path = os.path.join('buildbot', torture)
  if not os.path.isfile(torture_path):
    with open(torture_path, 'w+') as f:
      f.write(urllib2.urlopen(STORAGE_BASE + torture).read())
  with tempfile.TemporaryFile(mode='w') as untar:
    subprocess.check_call(['tar', '-xvf', torture], cwd='buildbot',
                          stdout=untar)


def main():
  subprocess.check_call(['git', 'submodule', 'sync', '--quiet'])
  subprocess.check_call(['git', 'submodule', 'init', '--quiet'])
  subprocess.check_call(['git', 'submodule', 'update', '--quiet'])
  subprocess.check_call(['git', 'submodule', 'foreach',
                         'git', 'pull', 'origin', 'master', '--quiet'])
  update_torture()


if __name__ == '__main__':
  sys.exit(main())
