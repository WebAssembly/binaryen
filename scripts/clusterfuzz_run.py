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
ClusterFuzz helper script. To update us in ClusterFuzz:

0. Test this script locally on latest v8, using "./test_clusterfuzz_run.py".
1. Create a .tgz archive.
2. Put this at the root of the archive, renamed to "run.py".
3. Put a static build (no dynamic libraries) of wasm-opt in "bin/wasm-opt"
4. Upload the archive.

TODO: Automate 0-3, once we verify all this works smoothly.
'''

import os
import getopt
import random
import subprocess
import sys

FUZZER_BINARY_NAME = 'wasm-opt'
FUZZER_FLAGS_FILE_CONTENTS = '--experimental-wasm-threads' # staging? copy our flags
MAX_DATA_FILE_SIZE = 10000

FUZZER_NAME_PREFIX = 'binaryen-'
FUZZ_FILENAME_PREFIX = 'fuzz-'
FLAGS_FILENAME_PREFIX = 'flags-'

JS_FILE_EXTENSION = '.js'
WASM_FILE_EXTENSION = '.wasm'

# update this
JS_FILE_CONTENT = """
const module = new WebAssembly.Module(new Uint8Array([BYTES]));
const instance = new WebAssembly.Instance(module);

if (instance.exports.hangLimitInitializer)
  instance.exports.hangLimitInitializer();
try {
  console.log('calling: func_0');
  console.log('result: ' + instance.exports.func_0());
} catch (e) {
  console.log('exception: ' + e);
}
if (instance.exports.hangLimitInitializer)
  instance.exports.hangLimitInitializer();
try {
  console.log('calling: hangLimitInitializer');
  instance.exports.hangLimitInitializer();
} catch (e) {
  console.log('exception: ' + e);
}
"""


def get_fuzzer_binary_path():
  """Return fuzzer binary path for wasm-opt."""
  bin_directory = os.path.join(
      os.path.dirname(os.path.abspath(__file__)), 'bin')
  return os.path.join(bin_directory, FUZZER_BINARY_NAME)


def get_file_name(prefix, index):
  """Return file name for fuzz, flags files."""
  return '%s%s%d%s' % (prefix, FUZZER_NAME_PREFIX, index, JS_FILE_EXTENSION)


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

  fuzzer_binary_path = get_fuzzer_binary_path()

  for i in range(1, tests_count + 1):
    input_data_file_path = os.path.join(output_directory, '%d.input' % i)
    wasm_file_path = os.path.join(output_directory, '%d.wasm' % i)

    data_file_size = random.SystemRandom().randint(1, MAX_DATA_FILE_SIZE)
    with open(input_data_file_path, 'wb') as file_handle:
      file_handle.write(os.urandom(data_file_size))

    # enable all but shared-mem?
    subprocess.call([
        fuzzer_binary_path, '--translate-to-fuzz', '--fuzz-passes', '--output',
        wasm_file_path, input_data_file_path
    ])

    with open(wasm_file_path, 'rb') as file_handle:
      wasm_contents = file_handle.read()

    testcase_file_path = os.path.join(output_directory,
                                      get_file_name(FUZZ_FILENAME_PREFIX, i))
    wasm_contents = ','.join([str(c) for c in wasm_contents])
    js_file_contents = JS_FILE_CONTENT.replace('BYTES', wasm_contents)
    with open(testcase_file_path, 'w') as file_handle:
      file_handle.write(js_file_contents)

    flags_file_path = os.path.join(output_directory,
                                   get_file_name(FLAGS_FILENAME_PREFIX, i))
    with open(flags_file_path, 'w') as file_handle:
      file_handle.write(FUZZER_FLAGS_FILE_CONTENTS)

    print('Created testcase: {}'.format(testcase_file_path))

    # Remove temporary files.
    os.remove(input_data_file_path)
    os.remove(wasm_file_path)

  print('Created {} testcases.'.format(tests_count))


if __name__ == '__main__':
  main(sys.argv)

