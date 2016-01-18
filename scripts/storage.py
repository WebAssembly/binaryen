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

import glob
import json
import os
import urllib2


STORAGE_BASE = 'https://storage.googleapis.com/wasm-llvm/builds/git/'


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


def download_tar(tar_pattern, directory, revision):
  tar_path = os.path.join(directory, tar_pattern)
  revision_tar_path = tar_path % revision
  if os.path.isfile(revision_tar_path):
    print 'Already have `%s`' % revision_tar_path
  else:
    print 'Downloading `%s`' % revision_tar_path
    with open(revision_tar_path, 'w+') as f:
      f.write(urllib2.urlopen(STORAGE_BASE + tar_pattern % revision).read())
  # Remove any previous tarfiles.
  for older_tar in glob.glob(tar_path % '*'):
    if older_tar != revision_tar_path:
      print 'Removing older tar file `%s`' % older_tar
      os.remove(older_tar)
  return revision_tar_path
