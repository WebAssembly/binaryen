#!/usr/bin/env python

import argparse
import os
import re
import shlex
import subprocess
import sys


ROOT_DIR = os.path.dirname(os.path.abspath(__file__))
LLVM_TEST_DIR = os.path.join(ROOT_DIR, 'third_party', 'llvm', 'test', 'CodeGen',
                             'WebAssembly')
S_TEST_DIR = ROOT_DIR
LLVM_DIR = os.path.join(ROOT_DIR, 'third_party', 'llvm')
BIN_DIR = os.path.join(LLVM_DIR, 'build', 'bin')


def FindTestFiles(directory, ext):
    tests = []
    for root, dirs, files in os.walk(directory):
        for f in files:
            path = os.path.join(root, f)
            if os.path.splitext(f)[1] == ext:
                tests.append(path)
    tests.sort()
    return tests


def GetRunLine(test):
    run_line = ''
    with open(test) as test_file:
        for line in test_file.readlines():
            m = re.match(r'; RUN: (.*?)(\\?)$', line)
            if m:
                run_line += m.group(1)
                if not m.group(2):
                    break
    # Remove FileCheck
    run_line = re.sub(r'\|\s*FileCheck.*$', '', run_line)
    # Remove pipe input
    run_line = re.sub(r'<\s*%s', '', run_line)
    # Remove stderr > stdout redirect
    run_line = re.sub(r'2>&1', '', run_line)
    return run_line


def main(args):
    parser = argparse.ArgumentParser()
    options = parser.parse_args(args)

    tests = FindTestFiles(LLVM_TEST_DIR, '.ll')
    for ll_test in tests:
        name_noext = os.path.splitext(os.path.basename(ll_test))[0]
        s = os.path.join(S_TEST_DIR, name_noext + '.s')
        run_line = GetRunLine(ll_test)
        cmd = shlex.split(run_line)
        cmd.extend([ll_test, '-o', s])
        # Don't run if the command isn't llc. Some are opt and they don't
        # generate .s files.
        if cmd[0] != 'llc':
            continue
        cmd[0] = os.path.join(BIN_DIR, cmd[0])
        subprocess.check_call(cmd)


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
