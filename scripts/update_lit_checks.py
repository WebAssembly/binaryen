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

"""A test case update script.

This script is a utility to update wasm-opt based lit tests with new FileCheck
patterns. It is based on LLVM's update_llc_test_checks.py script.
"""

import argparse
import glob
import os
import re
import subprocess
import sys
import tempfile

script_dir = os.path.dirname(__file__)
script_name = os.path.basename(__file__)

NOTICE = (';; NOTE: Assertions have been generated by {script} and should not' +
          ' be edited.')

RUN_LINE_RE = re.compile(r'^\s*;;\s*RUN:\s*(.*)$')
CHECK_PREFIX_RE = re.compile(r'.*--check-prefix[= ](\S+).*')
MODULE_RE = re.compile(r'^\(module.*$', re.MULTILINE)

items = ['type', 'import', 'global', 'memory', 'data', 'table', 'elem', 'tag',
         'export', 'start', 'func']
ITEM_RE = re.compile(r'(^\s*)\((' + '|'.join(items) + r')\s+(\$?[^\s()]*).*$',
                     re.MULTILINE)


def warn(msg):
    print(f'warning: {msg}', file=sys.stderr)


def itertests(args):
    """
    Yield (filename, lines) for each test specified in the command line args
    """
    for pattern in args.tests:
        tests = glob.glob(pattern, recursive=True)
        if not tests:
            warn(f'No tests matched {pattern}. Ignoring it.')
            continue
        for test in tests:
            with open(test) as f:
                lines = [line.rstrip() for line in f]
            first_line = lines[0] if lines else ''
            if script_name not in first_line and not args.force:
                warn(f'Skipping test {test} which was not generated by '
                     f'{script_name}. Use -f to override.')
                continue
            yield test, lines


def find_run_lines(test, lines):
    line_matches = [RUN_LINE_RE.match(l) for l in lines]
    matches = [match.group(1) for match in line_matches if match]
    if not matches:
        warn(f'No RUN lines found in {test}. Ignoring.')
        return []
    run_lines = [matches[0]]
    for line in matches[1:]:
        if run_lines[-1].endswith('\\'):
            run_lines[-1] = run_lines[-1].rstrip('\\') + ' ' + line
        else:
            run_lines.append(line)
    return run_lines


def run_command(args, test, tmp, command):
    env = dict(os.environ)
    env['PATH'] = args.binaryen_bin + os.pathsep + env['PATH']
    command = command.replace('%s', test)
    command = command.replace('%t', tmp)
    command = command.replace('foreach', os.path.join(script_dir, 'foreach.py'))
    return subprocess.check_output(command, shell=True, env=env).decode('utf-8')


def find_end(module, start):
    # Find the index one past the closing parenthesis corresponding to the first
    # open parenthesis at `start`.
    assert module[start] == '('
    depth = 1
    for end in range(start + 1, len(module)):
        if depth == 0:
            break
        elif module[end] == '(':
            depth += 1
        elif module[end] == ')':
            depth -= 1
    return end


def split_modules(text):
    # Return a list of strings; one for each module
    module_starts = [match.start() for match in MODULE_RE.finditer(text)]
    if len(module_starts) < 2:
        return [text]
    first_module = text[:module_starts[1]]
    modules = [first_module]
    for i in range(1, len(module_starts) - 1):
        module = text[module_starts[i]:module_starts[i + 1]]
        modules.append(module)
    last_module = text[module_starts[-1]:]
    modules.append(last_module)
    return modules


def parse_output(text):
    # Return a list containing, for each module in the text, a list of
    # (name, [line]) for module items.
    modules = []
    for module in split_modules(text):
        items = []
        for match in ITEM_RE.finditer(module):
            kind, name = match[2], match[3]
            end = find_end(module, match.end(1))
            lines = module[match.start():end].split('\n')
            items.append(((kind, name), lines))
        modules.append(items)
    return modules


def get_command_output(args, test, lines, tmp):
    # Return list of maps from prefixes to lists of module items of the form
    # ((kind, name), [line]). The outer list has an entry for each module.
    command_output = []
    for line in find_run_lines(test, lines):
        commands = [cmd.strip() for cmd in line.rsplit('|', 1)]
        filecheck_cmd = ''
        if len(commands) > 1 and commands[1].startswith('filecheck '):
            filecheck_cmd = commands[1]
            commands = commands[:1]
        elif len(commands) > 1 and commands[1].startswith('FileCheck '):
            warn('`FileCheck` is not a known command. '
                 'Did you mean to use `filecheck` instead?')

        prefix = ''
        if filecheck_cmd.startswith('filecheck '):
            prefix_match = CHECK_PREFIX_RE.match(filecheck_cmd)
            if prefix_match:
                prefix = prefix_match.group(1)
            else:
                prefix = 'CHECK'

        output = run_command(args, test, tmp, commands[0])
        if prefix:
            module_outputs = parse_output(output)
            for i in range(len(module_outputs)):
                if len(command_output) == i:
                    command_output.append({})
                command_output[i][prefix] = module_outputs[i]

    return command_output


def update_test(args, test, lines, tmp):
    all_items = args.all_items
    if lines and script_name in lines[0]:
        # Apply previously used options for this file
        if '--all-items' in lines[0]:
            all_items = True
        # Skip the notice if it is already in the output
        lines = lines[1:]

    command_output = get_command_output(args, test, lines, tmp)

    prefixes = set(prefix
                   for module_output in command_output
                   for prefix in module_output.keys())
    check_line_re = re.compile(r'^\s*;;\s*(' + '|'.join(prefixes) +
                               r')(?:-NEXT|-LABEL|-NOT)?:.*$')

    # Filter out whitespace between check blocks
    if lines:
        filtered = [lines[0]]
        for i in range(1, len(lines) - 1):
            if lines[i] or not check_line_re.match(lines[i - 1]) or \
               not check_line_re.match(lines[i + 1]):
                filtered.append(lines[i])
        filtered.append(lines[-1])
        lines = filtered

    named_items = []
    for line in lines:
        match = ITEM_RE.match(line)
        if match:
            kind, name = match[2], match[3]
            named_items.append((kind, name))

    script = script_name
    if all_items:
        script += ' --all-items'
    output_lines = [NOTICE.format(script=script)]

    def emit_checks(indent, prefix, lines):
        output_lines.append(f'{indent};; {prefix}:     {lines[0]}')
        for line in lines[1:]:
            output_lines.append(f'{indent};; {prefix}-NEXT:{line}')

    input_modules = [m.split('\n') for m in split_modules('\n'.join(lines))]
    if len(input_modules) > len(command_output):
        warn('Fewer output modules than input modules:'
             'not all modules will get checks.')

    # Remove extra newlines at the end of modules
    input_modules = [m[:-1] for m in input_modules[:-1]] + [input_modules[-1]]

    for module_idx in range(len(input_modules)):
        output = command_output[module_idx] \
            if module_idx < len(command_output) else {}

        for line in input_modules[module_idx]:
            # Skip pre-existing check lines; we will regenerate them.
            if check_line_re.match(line):
                continue

            match = ITEM_RE.match(line)
            if not match:
                output_lines.append(line)
                continue

            indent, kind, name = match.groups()

            for prefix, items in output.items():
                # If the output for this prefix contains an item with this
                # name, emit all the items up to and including the matching
                # item
                has_item = False
                for kind_name, lines in items:
                    if name and (kind, name) == kind_name:
                        has_item = True
                        break
                if has_item:
                    first = True
                    while True:
                        kind_name, lines = items.pop(0)
                        if all_items or kind_name in named_items:
                            if not first:
                                output_lines.append('')
                            first = False
                            emit_checks(indent, prefix, lines)
                        if name and (kind, name) == kind_name:
                            break
            output_lines.append(line)

        # Output any remaining checks for each prefix
        first = True
        for prefix, items in output.items():
            for kind_name, lines in items:
                if all_items or kind_name in named_items:
                    if not first:
                        output_lines.append('')
                    first = False
                    emit_checks('', prefix, lines)

    if args.dry_run:
        print('\n'.join(output_lines))
    else:
        with open(test, 'w') as f:
            for line in output_lines:
                f.write(line + '\n')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        '--binaryen-bin', dest='binaryen_bin', default='bin',
        help=('Specifies the path to the Binaryen executables in the CMake build'
              ' directory. Default: bin/ of current directory (i.e. assume an'
              ' in-tree build).'))
    parser.add_argument(
        '--all-items', action='store_true',
        help=('Emit checks for all module items, even those that do not appear'
              ' in the input.'))
    parser.add_argument(
        '-f', '--force', action='store_true',
        help=('Generate FileCheck patterns even for test files whose existing '
              'patterns were not generated by this script.'))
    parser.add_argument(
        '--dry-run', action='store_true',
        help=('Print the updated test file contents instead of changing the '
              'test files'))
    parser.add_argument('tests', nargs='+', help='The test files to update')
    args = parser.parse_args()
    args.binaryen_bin = os.path.abspath(args.binaryen_bin)

    tmp = tempfile.mktemp()

    for test, lines in itertests(args):
        update_test(args, test, lines, tmp)


if __name__ == '__main__':
    main()
