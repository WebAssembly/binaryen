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

import io
import re
import subprocess

QUOTED = re.compile(r'\(module\s*(\$\S*)?\s+(quote|binary)')

MODULE_DEFINITION_OR_INSTANCE = re.compile(r'(?m)\(module\s+(instance|definition)')


def split_wast(wastFile):
    '''
    Returns a list of pairs of module definitions and assertions.
    Module invalidity tests, as well as (module definition ...) and (module instance ...) are skipped.
    '''
    # if it's a binary, leave it as is, we can't split it
    wast = None
    if not wastFile.endswith('.wasm'):
        try:
            wast = open(wastFile).read()
        except Exception:
            pass

    if not wast:
        return ((open(wastFile, 'rb').read(), []),)

    # .wast files can contain multiple modules, and assertions for each one.
    # this splits out a wast into [(module, assertions), ..]
    # we ignore module invalidity tests here.
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
    ignoring_assertions = False
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
        if QUOTED.match(chunk) or MODULE_DEFINITION_OR_INSTANCE.match(chunk):
            # There may be assertions after this quoted module, but we aren't
            # returning the module, so we need to skip the assertions as well.
            ignoring_assertions = True
            continue
        if chunk.startswith('(module'):
            ignoring_assertions = False
            ret += [(chunk, [])]
        elif chunk.startswith('(assert_invalid'):
            continue
        elif chunk.startswith(('(assert', '(invoke', '(register')) and not ignoring_assertions:
            # ret may be empty if there are some asserts before the first
            # module. in that case these are asserts *without* a module, which
            # are valid (they may check something that doesn't refer to a module
            # in any way).
            if not ret:
                ret += [(None, [])]
            ret[-1][1].append(chunk)
    return ret


# write a split wast from split_wast. the wast may be binary if the original
# file was binary
def write_wast(filename, wast, asserts=[]):
    if type(wast) is bytes:
        assert not asserts
        with open(filename, 'wb') as o:
            o.write(wast)
    else:
        with open(filename, 'w') as o:
            o.write(wast + '\n'.join(asserts))


# Hack to allow subprocess with stdout/stderr to StringIO, which doesn't have a fileno and doesn't work otherwise
def _subprocess_run(*args, **kwargs):
    overwrite_stderr = "stderr" in kwargs and isinstance(kwargs["stderr"], io.StringIO)
    overwrite_stdout = "stdout" in kwargs and isinstance(kwargs["stdout"], io.StringIO)

    if overwrite_stdout:
        stdout_fd = kwargs["stdout"]
        kwargs["stdout"] = subprocess.PIPE
    if overwrite_stderr:
        stderr_fd = kwargs["stderr"]
        kwargs["stderr"] = subprocess.PIPE

    proc = subprocess.run(*args, **kwargs)

    if overwrite_stdout:
        stdout_fd.write(proc.stdout)
    if overwrite_stderr:
        stderr_fd.write(proc.stderr)

    return proc.stdout, proc.stderr, proc.returncode


def run_command(cmd, expected_status=0, stdout=None, stderr=None,
                expected_err=None, err_contains=False, err_ignore=None):
    '''
    stderr - None, subprocess.PIPE, subprocess.STDOUT or a file handle / io.StringIO to write stdout to
    stdout - File handle to print debug messages to
    returns the process's stdout
    '''
    if expected_err is not None:
        assert stderr == subprocess.PIPE or stderr is None, \
            "Can't redirect stderr if using expected_err"
        stderr = subprocess.PIPE
    print('executing: ', ' '.join(cmd), file=stdout)

    out, err, code = _subprocess_run(cmd, stdout=subprocess.PIPE, stderr=stderr, encoding='UTF-8')

    if expected_status is not None and code != expected_status:
        raise Exception(f"run_command `{' '.join(cmd)}` failed ({code}) {err or ''}")
    if expected_err is not None:
        if err_ignore is not None:
            err = "\n".join([line for line in err.split('\n') if err_ignore not in line])
        err_correct = expected_err in err if err_contains else expected_err == err
        if not err_correct:
            raise Exception(f"run_command unexpected stderr. Expected '{expected_err}', actual '{err}'")
    return out


def node_has_webassembly(cmd):
    cmd = [cmd, '-e', 'process.stdout.write(typeof WebAssembly)']
    return run_command(cmd) == 'object'
