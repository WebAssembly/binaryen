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

import scripts.storage
import scripts.support


BASE_DIR = os.path.abspath('test')
REVISION_PATH = os.path.join(BASE_DIR, 'revision')
TORTURE_TAR = 'wasm-torture-s-%s.tbz2'


def write_revision(revision):
  with open(REVISION_PATH, 'w') as f:
    f.write(revision)


def run(force_latest, override_build):
  subprocess.check_call(['git', 'submodule', 'sync', '--quiet'])
  subprocess.check_call(['git', 'submodule', 'init', '--quiet'])
  subprocess.check_call(['git', 'submodule', 'update', '--quiet'])
  subprocess.check_call(['git', 'submodule', 'foreach',
                         'git', 'pull', 'origin', 'master', '--quiet'])
  updates = 0
  revision = (override_build if override_build else
              scripts.storage.download_revision(force_latest=force_latest))
  downloaded = scripts.storage.download_tar(TORTURE_TAR, BASE_DIR, revision)
  updates += scripts.support.untar(downloaded, BASE_DIR)
  if updates or override_build:
    # Only update revision if the files it downloaded are different, or if
    # overriding the build ID.
    print 'Updating revision to', revision
    write_revision(revision)


def getargs():
  import argparse
  parser = argparse.ArgumentParser(
      description='Update the repository dependencies.')
  parser.add_argument('--force-latest', action='store_true',
                      help='Sync to latest waterfall build, not lkgr')
  parser.add_argument('--override-build', type=str, default=None,
                      help='Sync to specific build ID from  waterfall build')
  return parser.parse_args()


if __name__ == '__main__':
  args = getargs()
  sys.exit(run(force_latest=args.force_latest,
               override_build=args.override_build))
