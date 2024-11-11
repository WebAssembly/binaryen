#
# Copyright 2024 WebAssembly Community Group participants
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

'''
ClusterFuzz run.py script: when run by ClusterFuzz, it uses wasm-opt to generate
a fixed number of testcases.

This should be bundled up together with the other files it needs:

run.py                [this script]
bin/wasm-opt          [static build of the binaryen executable]
scripts/fuzz_shell.js [copy of that testcase runner shell script]
'''

import os
import getopt
import random
import subprocess
import sys

# The V8 flags we put in the "fuzzer flags" files, which tell ClusterFuzz how to
# run V8.
FUZZER_FLAGS_FILE_CONTENTS = '--wasm-staging'

# Maximum size of the random data that we feed into wasm-opt -ttf. This is
# smaller than fuzz_opt.py's INPUT_SIZE_MAX because that script is tuned for
# fuzzing large wasm files (to reduce the overhead we have of launching many
# processes per file), which is less of an issue on ClusterFuzz.
MAX_DATA_FILE_SIZE = 10 * 1024

# The prefix for fuzz files.
FUZZ_FILENAME_PREFIX = 'fuzz-'

# The prefix for flags files.
FLAGS_FILENAME_PREFIX = 'flags-'

# The name of the fuzzer (appears after FUZZ_FILENAME_PREFIX /
# FLAGS_FILENAME_PREFIX).
FUZZER_NAME_PREFIX = 'binaryen-'

# File extensions.
JS_FILE_EXTENSION = '.js'
WASM_FILE_EXTENSION = '.wasm'

# The root directory of the bundle this will be in, which is the directory of
# this very file.
ROOT_DIR = os.path.dirname(os.path.abspath(__file__))

# The path to the wasm-opt binary that we run to generate testcases.
FUZZER_BINARY_PATH = os.path.join(ROOT_DIR, 'bin', 'wasm-opt')

# The path to the fuzz_shell.js script that will execute the wasm in each
# testcase.
JS_SHELL_PATH = os.path.join(ROOT_DIR, 'scripts', 'fuzz_shell.js')


# Returns the file name for fuzz or flags files.
def get_file_name(prefix, index):
    return '%s%s%d%s' % (prefix, FUZZER_NAME_PREFIX, index, JS_FILE_EXTENSION)


# Returns the contents of a .js fuzz file, given particular wasm contents that
# we want to be executed.
def get_js_file_contents(wasm_contents):
    # Start with the standard JS shell.
    with open(JS_SHELL_PATH) as file:
        js = file.read()

    # Prepend the wasm contents, so they are used (rather than the normal
    # mechanism where the wasm file's name is provided in argv).
    js = f'var binary = {wasm_contents};\n\n' + js
    return js


def main(argv):
  """Process arguments and start the fuzzer."""
  output_directory = '.'
  tests_count = 100

  expected_flags = ['input_dir=', 'output_dir=', 'no_of_files=']
  optlist, _ = getopt.getopt(argv[1:], '', expected_flags)
  for option, value in optlist:
    if option == '--output_dir':
      output_directory = value
    elif option == '--no_of_files':
      tests_count = int(value)

  fuzzer_binary_path = FUZZER_BINARY_PATH

  for i in range(1, tests_count + 1):
    input_data_file_path = os.path.join(output_directory, '%d.input' % i)
    wasm_file_path = os.path.join(output_directory, '%d.wasm' % i)

    data_file_size = random.SystemRandom().randint(1, MAX_DATA_FILE_SIZE)
    with open(input_data_file_path, 'wb') as file:
      file.write(os.urandom(data_file_size))

    # enable all but shared-mem?
    subprocess.call([
        fuzzer_binary_path, '--translate-to-fuzz', '--fuzz-passes', '--output',
        wasm_file_path, input_data_file_path
    ])

    with open(wasm_file_path, 'rb') as file:
      wasm_contents = file.read()

    testcase_file_path = os.path.join(output_directory,
                                      get_file_name(FUZZ_FILENAME_PREFIX, i))
    wasm_contents = ','.join([str(c) for c in wasm_contents])
    js_file_contents = get_js_file_contents(wasm_contents)
    with open(testcase_file_path, 'w') as file:
      file.write(js_file_contents)

    flags_file_path = os.path.join(output_directory,
                                   get_file_name(FLAGS_FILENAME_PREFIX, i))
    with open(flags_file_path, 'w') as file:
      file.write(FUZZER_FLAGS_FILE_CONTENTS)

    print('Created testcase: {}'.format(testcase_file_path))

    # Remove temporary files.
    os.remove(input_data_file_path)
    os.remove(wasm_file_path)

  print('Created {} testcases.'.format(tests_count))


if __name__ == '__main__':
  main(sys.argv)

