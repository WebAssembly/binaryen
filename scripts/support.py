#! /usr/bin/env python

#   Copyright 2016 WebAssembly Community Group participants
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
import os
import shutil
import subprocess
import sys
import tempfile


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
