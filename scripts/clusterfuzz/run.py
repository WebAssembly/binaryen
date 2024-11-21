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
a fixed number of testcases. This is a "blackbox fuzzer", see

https://google.github.io/clusterfuzz/setting-up-fuzzing/blackbox-fuzzing/

This file should be bundled up together with the other files it needs, see
bundle_clusterfuzz.py.
'''

import os
import getopt
import math
import random
import subprocess
import sys


# The V8 flags we put in the "fuzzer flags" files, which tell ClusterFuzz how to
# run V8. By default we apply all staging flags.
FUZZER_FLAGS_FILE_CONTENTS = '--wasm-staging'

# Maximum size of the random data that we feed into wasm-opt -ttf. This is
# smaller than fuzz_opt.py's INPUT_SIZE_MAX because that script is tuned for
# fuzzing large wasm files (to reduce the overhead we have of launching many
# processes per file), which is less of an issue on ClusterFuzz.
MAX_RANDOM_SIZE = 15 * 1024

# Max and mean amount of extra JS operations we append, like extra compiles or
# runs of the wasm. We allow a high max here, but the mean is far lower, so that
# typical testcases are not long-running.
MAX_EXTRA_JS_OPERATIONS = 40
MEAN_EXTRA_JS_OPERATIONS = 2

# The prefix for fuzz files.
FUZZ_FILENAME_PREFIX = 'fuzz-'

# The prefix for flags files.
FLAGS_FILENAME_PREFIX = 'flags-'

# The name of the fuzzer (appears after FUZZ_FILENAME_PREFIX /
# FLAGS_FILENAME_PREFIX).
FUZZER_NAME_PREFIX = 'binaryen-'

# The root directory of the bundle this will be in, which is the directory of
# this very file.
ROOT_DIR = os.path.dirname(os.path.abspath(__file__))

# The path to the wasm-opt binary that we run to generate testcases.
FUZZER_BINARY_PATH = os.path.join(ROOT_DIR, 'bin', 'wasm-opt')

# The path to the fuzz_shell.js script that will execute the wasm in each
# testcase.
JS_SHELL_PATH = os.path.join(ROOT_DIR, 'scripts', 'fuzz_shell.js')

# The arguments we provide to wasm-opt to generate wasm files.
FUZZER_ARGS = [
    # Generate a wasm from random data.
    '--translate-to-fuzz',
    # Run some random passes, to further shape the random wasm we emit.
    '--fuzz-passes',
    # Enable all features but disable ones not yet ready for fuzzing. This may
    # be a smaller set than fuzz_opt.py, as that enables a few experimental
    # flags, while here we just fuzz with d8's --wasm-staging.
    '-all',
    '--disable-shared-everything',
    '--disable-fp16',
]


# Returns the file name for fuzz or flags files.
def get_file_name(prefix, index):
    return f'{prefix}{FUZZER_NAME_PREFIX}{index}.js'


# We should only use the system's random number generation, which is the best.
# (We also use urandom below, which uses this under the hood.)
system_random = random.SystemRandom()


# Returns the contents of a .js fuzz file, given particular wasm contents that
# we want to be executed.
def get_js_file_contents(wasm_contents):
    # Start with the standard JS shell.
    with open(JS_SHELL_PATH) as file:
        js = file.read()

    # Prepend the wasm contents, so they are used (rather than the normal
    # mechanism where the wasm file's name is provided in argv).
    wasm_contents = ','.join([str(c) for c in wasm_contents])
    js = f'var binary = new Uint8Array([{wasm_contents}]);\n\n' + js

    # The default JS builds and runs the wasm. Append some random additional
    # operations as well, as more compiles and executions can find things. To
    # approximate a number in the range [0, MAX_EXTRA_JS_OPERATIONS) but with a
    # mean of MEAN_EXTRA_JS_OPERATIONS, start with a number in [0, 1) and then
    # raise it to the proper power, as multiplying by itself keeps the range
    # unchanged, but lowers the mean. Specifically, the mean begins at 0.5, so
    #
    #   0.5^power = MEAN_EXTRA_JS_OPERATIONS / MAX_EXTRA_JS_OPERATIONS
    #
    # is what we want, and if we take log2 of each side, gives us
    #
    #   power =  log2(MEAN_EXTRA_JS_OPERATIONS / MAX_EXTRA_JS_OPERATIONS) / log2(0.5)
    #         = -log2(MEAN_EXTRA_JS_OPERATIONS / MAX_EXTRA_JS_OPERATIONS)
    power = -math.log2(float(MEAN_EXTRA_JS_OPERATIONS) / MAX_EXTRA_JS_OPERATIONS)
    x = system_random.random()
    x = math.pow(x, power)
    num = math.floor(x * MAX_EXTRA_JS_OPERATIONS)
    assert num >= 0 and num <= MAX_EXTRA_JS_OPERATIONS
    for i in range(num):
        js += system_random.choice([
            # Compile and link the wasm again. Each link adds more to the total
            # exports that we can call.
            'build(binary);\n',
            # Run all the exports we've accumulated.
            'callExports();\n',
        ])

    return js


def main(argv):
    # Parse the options. See
    # https://google.github.io/clusterfuzz/setting-up-fuzzing/blackbox-fuzzing/#uploading-a-fuzzer
    output_dir = '.'
    num = 100
    expected_flags = ['input_dir=', 'output_dir=', 'no_of_files=']
    optlist, _ = getopt.getopt(argv[1:], '', expected_flags)
    for option, value in optlist:
        if option == '--output_dir':
            output_dir = value
        elif option == '--no_of_files':
            num = int(value)

    for i in range(1, num + 1):
        input_data_file_path = os.path.join(output_dir, f'{i}.input')
        wasm_file_path = os.path.join(output_dir, f'{i}.wasm')

        # wasm-opt may fail to run in rare cases (when the fuzzer emits code it
        # detects as invalid). Just try again in such a case.
        for attempt in range(0, 100):
            # Generate random data.
            random_size = system_random.randint(1, MAX_RANDOM_SIZE)
            with open(input_data_file_path, 'wb') as file:
                file.write(os.urandom(random_size))

            # Generate wasm from the random data.
            cmd = [FUZZER_BINARY_PATH] + FUZZER_ARGS
            cmd += ['-o', wasm_file_path, input_data_file_path]
            try:
                subprocess.check_call(cmd)
            except subprocess.CalledProcessError:
                # Try again.
                print('(oops, retrying wasm-opt)')
                attempt += 1
                if attempt == 99:
                    # Something is very wrong!
                    raise
                continue
            # Success, leave the loop.
            break

        # Generate a testcase from the wasm
        with open(wasm_file_path, 'rb') as file:
            wasm_contents = file.read()
        testcase_file_path = os.path.join(output_dir,
                                          get_file_name(FUZZ_FILENAME_PREFIX, i))
        js_file_contents = get_js_file_contents(wasm_contents)
        with open(testcase_file_path, 'w') as file:
            file.write(js_file_contents)

        # Emit a corresponding flags file.
        flags_file_path = os.path.join(output_dir,
                                       get_file_name(FLAGS_FILENAME_PREFIX, i))
        with open(flags_file_path, 'w') as file:
            file.write(FUZZER_FLAGS_FILE_CONTENTS)

        print(f'Created testcase: {testcase_file_path}, {len(wasm_contents)} bytes')

        # Remove temporary files.
        os.remove(input_data_file_path)
        os.remove(wasm_file_path)

    print(f'Created {num} testcases.')


if __name__ == '__main__':
    main(sys.argv)
