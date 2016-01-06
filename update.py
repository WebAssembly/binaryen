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

import glob
import os
import shutil
import subprocess
import sys
import tempfile
import urllib2


STORAGE_BASE = 'https://storage.googleapis.com/wasm-llvm/builds/git/'
BASE_DIR = 'test'
LKGR_PATH = os.path.join(BASE_DIR, 'lkgr')
TORTURE_TAR = 'wasm-torture-s-%s.tbz2'
TORTURE_FOLDER = os.path.join(BASE_DIR, 'torture-s')


def download_last_known_good_revision():
  with open(LKGR_PATH, 'w+') as f:
    lkgr = urllib2.urlopen(STORAGE_BASE + 'lkgr').read().strip()
    f.write(lkgr)
  return lkgr


def download_tar_at_lkgr(tar_pattern, lkgr):
  tar_path = os.path.join(BASE_DIR, tar_pattern)
  lkgr_tar_path = tar_path % lkgr
  if not os.path.isfile(lkgr_tar_path):
    with open(lkgr_tar_path, 'w+') as f:
      f.write(urllib2.urlopen(STORAGE_BASE + tar_pattern % lkgr).read())
  # Remove any previous tarfiles.
  for older_tar in glob.glob(tar_path):
    if older_tar != lkgr_tar_path:
      os.path.remove(older_tar)
  return lkgr_tar_path


def untar(tarfile, outfolder):
  if os.path.exists(outfolder):
    shutil.rmtree(outfolder)
  with tempfile.TemporaryFile(mode='w+') as f:
    try:
      base = os.path.basename(tarfile)
      subprocess.check_call(['tar', '-xvf', base], cwd=BASE_DIR, stdout=f)
    except:
      f.seek(0)
      sys.stderr.write(f.read())
      raise
  assert os.path.isdir(outfolder), 'Expected to untar into %s' % outfolder


def main():
  subprocess.check_call(['git', 'submodule', 'sync', '--quiet'])
  subprocess.check_call(['git', 'submodule', 'init', '--quiet'])
  subprocess.check_call(['git', 'submodule', 'update', '--quiet'])
  subprocess.check_call(['git', 'submodule', 'foreach',
                         'git', 'pull', 'origin', 'master', '--quiet'])
  lkgr = download_last_known_good_revision()
  untar(download_tar_at_lkgr(TORTURE_TAR, lkgr), TORTURE_FOLDER)


if __name__ == '__main__':
  sys.exit(main())
