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
FUZZER_FLAGS = '--wasm-staging --experimental-wasm-custom-descriptors'

# Optional V8 flags to add to FUZZER_FLAGS, some of the time.
OPTIONAL_FUZZER_FLAGS = [
    '--experimental-wasm-revectorize',
]

# Maximum size of the random data that we feed into wasm-opt -ttf. This is
# smaller than fuzz_opt.py's INPUT_SIZE_MAX because that script is tuned for
# fuzzing large wasm files (to reduce the overhead we have of launching many
# processes per file), which is less of an issue on ClusterFuzz.
MAX_RANDOM_SIZE = 15 * 1024

# Max and median amount of extra JS operations we append, like extra compiles or
# runs of the wasm. We allow a high max, but the median is far lower, so that
# typical testcases are not long-running.
MAX_EXTRA_JS_OPERATIONS = 40
MEDIAN_EXTRA_JS_OPERATIONS = 2

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

# The path to the directory with initial contents.
INITIAL_CONTENT_PATH = os.path.join(ROOT_DIR, 'initial')

# The file that contains the number of initial contents
INITIAL_CONTENT_NUM_PATH = os.path.join(ROOT_DIR, 'initial', 'num.txt')

# The arguments we provide to wasm-opt to generate wasm files.
FUZZER_ARGS = [
    # Generate a wasm from random data.
    '--translate-to-fuzz',
    # Run some random passes, to further shape the random wasm we emit.
    '--fuzz-passes',
    # Enable all features but disable ones not yet ready for fuzzing. This may
    # be a smaller set than fuzz_opt.py, as that enables a few experimental
    # flags, while here we just fuzz with d8's --wasm-staging. This should be
    # synchonized with bundle_clusterfuzz.
    '-all',
    '--disable-shared-everything',
    '--disable-fp16',
    '--disable-strings',
    '--disable-stack-switching',
]


# Returns the file name for fuzz or flags files.
def get_file_name(prefix, index):
    return f'{prefix}{FUZZER_NAME_PREFIX}{index}.js'


# We should only use the system's random number generation, which is the best.
# (We also use urandom below, which uses this under the hood.)
system_random = random.SystemRandom()

# The number of initial content testcases that were bundled for us, in the
# "initial/" subdir.
with open(INITIAL_CONTENT_NUM_PATH) as f:
    num_initial_contents = int(f.read())


def get_random_initial_content():
    index = system_random.randint(0, num_initial_contents - 1)
    return os.path.join(INITIAL_CONTENT_PATH, f'{index}.wasm')


# In production ClusterFuzz we retry whenever we see a wasm-opt error. We are
# not looking for wasm-opt issues there, and just use it to generate testcases
# for VMs. For local testing, however, we may want to disable retrying, which
# allows us to debug any such failures that we run into.
retry = True


# Generate a random wasm file, and return a string that creates a typed array of
# those bytes, suitable for use in a JS file, in the form
#
#   new Uint8Array([..wasm_contents..])
#
# Receives the testcase index and the output dir.
def get_wasm_contents(i, output_dir):
    input_data_file_path = os.path.join(output_dir, f'{i}.input')
    wasm_file_path = os.path.join(output_dir, f'{i}.wasm')

    # wasm-opt may fail to run in rare cases (when the fuzzer emits code it
    # detects as invalid). Just try again in such a case.
    for attempt in range(0, 100):
        # Generate random data.
        random_size = system_random.randint(1, MAX_RANDOM_SIZE)
        with open(input_data_file_path, 'wb') as file:
            file.write(os.urandom(random_size))

        # Generate a command to use wasm-opt with the proper args to generate
        # wasm content from the input data.
        cmd = [FUZZER_BINARY_PATH] + FUZZER_ARGS
        cmd += ['-o', wasm_file_path, input_data_file_path]

        # Sometimes use a file from the initial content testcases.
        if system_random.random() < 0.5:
            initial_content = get_random_initial_content()
            cmd += ['--initial-fuzz=' + initial_content]
        else:
            initial_content = None

        # Generate wasm from the random data.
        try:
            subprocess.check_call(cmd)
        except subprocess.CalledProcessError:
            if not retry:
                print('error in running wasm-opt')
                print(' '.join(cmd))
                raise

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

    # Clean up temp files.
    os.remove(wasm_file_path)
    os.remove(input_data_file_path)

    # Convert to a string, and wrap into a typed array.
    wasm_contents = ','.join([str(c) for c in wasm_contents])
    js = f'new Uint8Array([{wasm_contents}])'
    if initial_content:
        js = f'{js} /* using initial content {os.path.basename(initial_content)} */'
    return js


# Returns the contents of a .js fuzz file, given the index of the testcase and
# the output dir.
def get_js_file_contents(i, output_dir):
    # Start with the standard JS shell.
    with open(JS_SHELL_PATH) as file:
        js = file.read()

    # Prepend the wasm contents, so they are used (rather than the normal
    # mechanism where the wasm file's name is provided in argv).
    wasm_contents = get_wasm_contents(i, output_dir)
    pre = f'var binary = {wasm_contents};\n'
    bytes = wasm_contents.count(',')

    # Sometimes add a second wasm file as well.
    has_second = False
    if system_random.random() < 0.333:
        has_second = True
        wasm_contents = get_wasm_contents(i, output_dir)
        pre += f'var secondBinary = {wasm_contents};\n'
        bytes += wasm_contents.count(',')

    js = pre + '\n' + js

    # The default JS builds and runs the wasm. Append some random additional
    # operations as well, as more compiles and executions can find things. To
    # approximate a number in the range [0, MAX_EXTRA_JS_OPERATIONS) but with a
    # median of MEDIAN_EXTRA_JS_OPERATIONS, start in the range [0, 1) and then
    # raise it to the proper power, as multiplying by itself keeps the range
    # unchanged, but lowers the median. Specifically, the median begins at 0.5,
    # so
    #
    #   0.5^power = MEDIAN_EXTRA_JS_OPERATIONS / MAX_EXTRA_JS_OPERATIONS
    #
    # is what we want, and if we take log2 of each side, gives us
    #
    #   power =  log2(MEDIAN_EXTRA_JS_OPERATIONS / MAX_EXTRA_JS_OPERATIONS) / log2(0.5)
    #         = -log2(MEDIAN_EXTRA_JS_OPERATIONS / MAX_EXTRA_JS_OPERATIONS)
    power = -math.log2(float(MEDIAN_EXTRA_JS_OPERATIONS) / MAX_EXTRA_JS_OPERATIONS)
    x = system_random.random()
    x = math.pow(x, power)
    num = math.floor(x * MAX_EXTRA_JS_OPERATIONS)
    assert num >= 0 and num <= MAX_EXTRA_JS_OPERATIONS

    extra_js_operations = [
        # Compile and link the wasm again. Each link adds more to the total
        # exports that we can call.
        'build(binary)',
        # Run all the exports we've accumulated. This is a placeholder, as we
        # must pick a random seed for each (the placeholder would cause a JS
        # error at runtime if we had a bug and did not replace it properly).
        'CALL_EXPORTS',
    ]
    if has_second:
        extra_js_operations += [
            'build(secondBinary)',
        ]

    for i in range(num):
        choice = system_random.choice(extra_js_operations)
        if choice == 'CALL_EXPORTS':
            # The random seed can be any unsigned 32-bit number.
            seed = system_random.randint(0, 0xffffffff)
            choice = f'callExports({seed})'
        js += choice + ';\n'

    print(f'Created {bytes} wasm bytes')

    # Some of the time, fuzz JSPI (similar to fuzz_opt.py, see details there).
    if system_random.random() < 0.25:
        # Prepend the flag to enable JSPI.
        js = 'var JSPI = 1;\n\n' + js

        # Un-comment the async and await keywords.
        js = js.replace('/* async */', 'async')
        js = js.replace('/* await */', 'await')

    return js


def main(argv):
    # Parse the options. See
    # https://google.github.io/clusterfuzz/setting-up-fuzzing/blackbox-fuzzing/#uploading-a-fuzzer
    output_dir = '.'
    num = 100
    expected_flags = ['input_dir=', 'output_dir=', 'no_of_files=', 'no_retry']
    optlist, _ = getopt.getopt(argv[1:], '', expected_flags)
    for option, value in optlist:
        if option == '--output_dir':
            output_dir = value
        elif option == '--no_of_files':
            num = int(value)
        elif option == '--no_retry':
            global retry
            retry = False

    for i in range(1, num + 1):
        testcase_file_path = os.path.join(output_dir,
                                          get_file_name(FUZZ_FILENAME_PREFIX, i))

        # Emit the JS file.
        js_file_contents = get_js_file_contents(i, output_dir)
        with open(testcase_file_path, 'w') as file:
            file.write(js_file_contents)

        # Emit a corresponding flags file.
        flags_file_path = os.path.join(output_dir,
                                       get_file_name(FLAGS_FILENAME_PREFIX, i))
        with open(flags_file_path, 'w') as file:
            flags = FUZZER_FLAGS
            # Some of the time add an additional flag for V8.
            if OPTIONAL_FUZZER_FLAGS and system_random.random() < 0.5:
                flags += ' ' + system_random.choice(OPTIONAL_FUZZER_FLAGS)
            file.write(flags)

        print(f'Created testcase: {testcase_file_path}')

    print(f'Created {num} testcases.')


if __name__ == '__main__':
    main(sys.argv)
