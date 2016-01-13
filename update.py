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
import json
import os
import shutil
import subprocess
import sys
import tempfile
import urllib2


STORAGE_BASE = 'https://storage.googleapis.com/wasm-llvm/builds/git/'
BASE_DIR = os.path.abspath('test')
REVISION_PATH = os.path.join(BASE_DIR, 'revision')
TORTURE_TAR = 'wasm-torture-s-%s.tbz2'
TORTURE_DIR = os.path.join(BASE_DIR, 'torture-s')


def download_revision(force_latest):
  name = 'latest' if force_latest else 'lkgr'
  downloaded = urllib2.urlopen(STORAGE_BASE + name).read().strip()
  # TODO: for now try opening as JSON, if that doesn't work then the content is
  #       just a hash. The waterfall is in the process of migrating to JSON.
  info = None
  try:
    info = json.loads(downloaded)
  except:
    pass
  return info['build'] if type(info) == dict else downloaded


def write_revision(revision):
  with open(REVISION_PATH, 'w') as f:
    f.write(revision)


def download_tar(tar_pattern, revision):
  tar_path = os.path.join(BASE_DIR, tar_pattern)
  revision_tar_path = tar_path % revision
  if not os.path.isfile(revision_tar_path):
    with open(revision_tar_path, 'w+') as f:
      f.write(urllib2.urlopen(STORAGE_BASE + tar_pattern % revision).read())
  # Remove any previous tarfiles.
  for older_tar in glob.glob(tar_path):
    if older_tar != revision_tar_path:
      os.path.remove(older_tar)
  return revision_tar_path


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


def run(force_latest, override_hash):
  subprocess.check_call(['git', 'submodule', 'sync', '--quiet'])
  subprocess.check_call(['git', 'submodule', 'init', '--quiet'])
  subprocess.check_call(['git', 'submodule', 'update', '--quiet'])
  subprocess.check_call(['git', 'submodule', 'foreach',
                         'git', 'pull', 'origin', 'master', '--quiet'])
  updates = 0
  revision = (override_hash if override_hash else
              download_revision(force_latest=force_latest))
  updates += untar(download_tar(TORTURE_TAR, revision), TORTURE_DIR)
  if updates:
    # Only update revision if the files it downloaded are different.
    print 'Updating revision to', revision
    write_revision(revision)


def getargs():
  import argparse
  parser = argparse.ArgumentParser(
      description='Update the repository dependencies.')
  parser.add_argument('--force-latest', action='store_true',
                      help='Sync to latest waterfall build, not lkgr')
  parser.add_argument('--override-hash', type=str, default=None,
                      help='Sync to specific hash from  waterfall build')
  return parser.parse_args()


if __name__ == '__main__':
  args = getargs()
  sys.exit(run(force_latest=args.force_latest,
               override_hash=args.override_hash))
