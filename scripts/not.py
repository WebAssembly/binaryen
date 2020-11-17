#!/usr/bin/env python3

# Copyright 2020 WebAssembly Community Group participants
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

import sys
import subprocess


# Emulate the `not` tool from LLVM's test infrastructure for use with lit and
# FileCheck. It succeeds if the given subcommand fails and vice versa.
def main():
    cmd = sys.argv[1:]
    result = subprocess.run(cmd)
    sys.exit(0 if result.returncode != 0 else 1)


if __name__ == '__main__':
    main()
