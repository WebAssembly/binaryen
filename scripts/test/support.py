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

import filecmp
import os
import shutil
import subprocess
import sys
import tempfile


def _open_archive(tarfile, tmp_dir):
  with tempfile.TemporaryFile(mode='w+') as f:
    try:
      subprocess.check_call(['tar', '-xvf', tarfile], cwd=tmp_dir, stdout=f)
    except Exception:
      f.seek(0)
      sys.stderr.write(f.read())
      raise
  return os.listdir(tmp_dir)


def _files_same(dir1, dir2, basenames):
  diff = filecmp.cmpfiles(dir1, dir2, basenames)
  return 0 == len(diff[1] + diff[2])


def _dirs_same(dir1, dir2, basenames):
  for d in basenames:
    left = os.path.join(dir1, d)
    right = os.path.join(dir2, d)
    if not (os.path.isdir(left) and os.path.isdir(right)):
      return False
    diff = filecmp.dircmp(right, right)
    if 0 != len(diff.left_only + diff.right_only + diff.diff_files +
                diff.common_funny + diff.funny_files):
      return False
  return True


def _move_files(dirfrom, dirto, basenames):
  for f in basenames:
    from_file = os.path.join(dirfrom, f)
    to_file = os.path.join(dirto, f)
    if os.path.isfile(to_file):
      os.path.remove(to_file)
    shutil.move(from_file, to_file)


def _move_dirs(dirfrom, dirto, basenames):
    for d in basenames:
      from_dir = os.path.join(dirfrom, d)
      to_dir = os.path.join(dirto, d)
      if os.path.isdir(to_dir):
        shutil.rmtree(to_dir)
      shutil.move(from_dir, to_dir)


def untar(tarfile, outdir):
  """Returns True if untar content differs from pre-existing outdir content."""
  tmpdir = tempfile.mkdtemp()
  try:
    untared = _open_archive(tarfile, tmpdir)
    files = [f for f in untared if os.path.isfile(os.path.join(tmpdir, f))]
    dirs = [d for d in untared if os.path.isdir(os.path.join(tmpdir, d))]
    assert len(files) + len(dirs) == len(untared), 'Only files and directories'
    if _files_same(tmpdir, outdir, files) and _dirs_same(tmpdir, outdir, dirs):
      # Nothing new or different in the tarfile.
      return False
    # Some or all of the files / directories are new.
    _move_files(tmpdir, outdir, files)
    _move_dirs(tmpdir, outdir, dirs)
    return True
  finally:
    if os.path.isdir(tmpdir):
      shutil.rmtree(tmpdir)


def split_wast(wastFile):
  # .wast files can contain multiple modules, and assertions for each one.
  # this splits out a wast into [(module, assertions), ..]
  # we ignore module invalidity tests here.
  wast = open(wastFile, 'rb').read()

  # if it's a binary, leave it as is
  if wast[0] == '\0':
    return [[wast, '']]

  wast = open(wastFile, 'r').read()
  ret = []

  def to_end(j):
    depth = 1
    while depth > 0 and j < len(wast):
      if wast[j] == '"':
        while 1:
          j = wast.find('"', j + 1)
          if wast[j - 1] == '\\':
            continue
          break
        assert j > 0
      elif wast[j] == '(':
        depth += 1
      elif wast[j] == ')':
        depth -= 1
      elif wast[j] == ';' and wast[j + 1] == ';':
        j = wast.find('\n', j)
      j += 1
    return j

  i = 0
  while i >= 0:
    start = wast.find('(', i)
    if start >= 0 and wast[start + 1] == ';':
      # block comment
      i = wast.find(';)', start + 2)
      assert i > 0, wast[start:]
      i += 2
      continue
    skip = wast.find(';', i)
    if skip >= 0 and skip < start and skip + 1 < len(wast):
      if wast[skip + 1] == ';':
        i = wast.find('\n', i) + 1
        continue
    if start < 0:
      break
    i = to_end(start + 1)
    chunk = wast[start:i]
    if chunk.startswith('(module'):
      ret += [(chunk, [])]
    elif chunk.startswith('(assert_invalid'):
      continue
    elif chunk.startswith(('(assert', '(invoke')):
      ret[-1][1].append(chunk)
  return ret


def run_command(cmd, expected_status=0, stderr=None,
                expected_err=None, err_contains=False, err_ignore=None):
  if expected_err is not None:
    assert stderr == subprocess.PIPE or stderr is None,\
        "Can't redirect stderr if using expected_err"
    stderr = subprocess.PIPE
  print 'executing: ', ' '.join(cmd)
  proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=stderr, universal_newlines=True)
  out, err = proc.communicate()
  code = proc.returncode
  if expected_status is not None and code != expected_status:
    raise Exception(('run_command failed (%s)' % code, out + str(err or '')))
  if expected_err is not None:
    if err_ignore is not None:
      err = "\n".join([line for line in err.split('\n') if err_ignore not in line])
    err_correct = expected_err in err if err_contains else expected_err == err
    if not err_correct:
      raise Exception(('run_command unexpected stderr',
                       "expected '%s', actual '%s'" % (expected_err, err)))
  return out


def node_has_webassembly(cmd):
  cmd = [cmd, '-e', 'process.stdout.write(typeof WebAssembly)']
  return run_command(cmd) == 'object'


def node_test_glue():
  # running concatenated files (a.js) in node interferes with module loading
  # because the concatenated file expects a 'var Binaryen' but binaryen.js
  # assigned to module.exports. this is correct behavior but tests then need
  # a workaround:
  return ('if (typeof module === "object" && typeof exports === "object")\n'
          '  Binaryen = module.exports;\n')
