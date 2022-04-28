#!/usr/bin/env python3

# Copyright 2021 WebAssembly Community Group participants
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

import os
import sys
import subprocess

from test import support


# Usage: foreach infile tempfile cmd...
#
# Split 'infile', which contains multiple text modules, into separate temp files
# containing one text module each and named `tempfile`.0, `tempfile`.1, etc. Run
# `cmd` with the current temp file appended to it on all the temp files in
# sequence. Exit with code 0 only if all of the subprocesses exited with code 0.
def main():
    infile = sys.argv[1]
    tempfile = sys.argv[2]
    cmd = sys.argv[3:]
    returncode = 0
    all_modules = open(infile).read()
    for i, (module, asserts) in enumerate(support.split_wast(infile)):
        tempname = tempfile + '.' + str(i)
        with open(tempname, 'w') as temp:
            print(module, file=temp)
        new_cmd = cmd + [tempname]
        result = subprocess.run(new_cmd)
        if result.returncode != 0:
            returncode = result.returncode
            module_char_start = all_modules.find(module)
            module_line_start = all_modules[:module_char_start].count(os.linesep)
            print(f'[Failing module at line {module_line_start}]', file=sys.stderr)
    sys.exit(returncode)


if __name__ == '__main__':
    main()
