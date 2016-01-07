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

import filecmp
import glob
import os
import shutil
import subprocess
import sys
import tempfile
import urllib2


STORAGE_BASE = 'https://storage.googleapis.com/wasm-llvm/builds/git/'
BASE_DIR = os.path.abspath('test')
LKGR_PATH = os.path.join(BASE_DIR, 'lkgr')
TORTURE_TAR = 'wasm-torture-s-%s.tbz2'
TORTURE_DIR = os.path.join(BASE_DIR, 'torture-s')


def download_last_known_good_revision():
  return urllib2.urlopen(STORAGE_BASE + 'lkgr').read().strip()


def write_lkgr(lkgr):
  with open(LKGR_PATH, 'w') as f:
    f.write(lkgr)


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


def untar(tarfile, outdir):
  """Returns True if the untar dir differs from a pre-existing dir."""
  tmp_dir = tempfile.mkdtemp()
  try:
    with tempfile.TemporaryFile(mode='w+') as f:
      try:
        subprocess.check_call(['tar', '-xvf', tarfile], cwd=tmp_dir, stdout=f)
      except:
        f.seek(0)
        sys.stderr.write(f.read())
        raise
    untar_outdir = os.path.join(tmp_dir, os.path.basename(outdir))
    if os.path.exists(outdir):
      diff = filecmp.dircmp(untar_outdir, outdir)
      if not (diff.left_only + diff.right_only + diff.diff_files +
              diff.common_funny + diff.funny_files):
        # outdir already existed with exactly the same content.
        return False
      shutil.rmtree(outdir)
    # The untar files are different, or there was no previous outdir.
    print 'Updating', outdir
    shutil.move(untar_outdir, outdir)
    return True
  finally:
    if os.path.isdir(tmp_dir):
      shutil.rmtree(tmp_dir)


def main():
  subprocess.check_call(['git', 'submodule', 'sync', '--quiet'])
  subprocess.check_call(['git', 'submodule', 'init', '--quiet'])
  subprocess.check_call(['git', 'submodule', 'update', '--quiet'])
  subprocess.check_call(['git', 'submodule', 'foreach',
                         'git', 'pull', 'origin', 'master', '--quiet'])
  updates = 0
  lkgr = download_last_known_good_revision()
  updates += untar(download_tar_at_lkgr(TORTURE_TAR, lkgr), TORTURE_DIR)
  if updates:
    # Only update lkgr if the files it downloaded are different.
    print 'Updating lkgr to', lkgr
    write_lkgr(lkgr)


if __name__ == '__main__':
  sys.exit(main())
