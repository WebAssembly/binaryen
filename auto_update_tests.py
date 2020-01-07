#!/usr/bin/env python3
#
# Copyright 2015 WebAssembly Community Group participants
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
import shutil
import subprocess
import sys
from collections import OrderedDict

from scripts.test import lld
from scripts.test import shared
from scripts.test import support
from scripts.test import wasm2js


def update_asm_js_tests():
    print('[ processing and updating testcases... ]\n')
    for asm in shared.get_tests(shared.options.binaryen_test, ['.asm.js']):
        basename = os.path.basename(asm)
        for precise in [0, 1, 2]:
            for opts in [1, 0]:
                cmd = shared.ASM2WASM + [asm]
                if 'threads' in basename:
                    cmd += ['--enable-threads']
                wasm = asm.replace('.asm.js', '.fromasm')
                if not precise:
                    cmd += ['--trap-mode=allow', '--ignore-implicit-traps']
                    wasm += '.imprecise'
                elif precise == 2:
                    cmd += ['--trap-mode=clamp']
                    wasm += '.clamp'
                if not opts:
                    wasm += '.no-opts'
                    if precise:
                        cmd += ['-O0']  # test that -O0 does nothing
                else:
                    cmd += ['-O']
                if 'debugInfo' in basename:
                    cmd += ['-g']
                if 'noffi' in basename:
                    cmd += ['--no-legalize-javascript-ffi']
                if precise and opts:
                    # test mem init importing
                    open('a.mem', 'wb').write(bytes(basename, 'utf-8'))
                    cmd += ['--mem-init=a.mem']
                    if basename[0] == 'e':
                        cmd += ['--mem-base=1024']
                if '4GB' in basename:
                    cmd += ['--mem-max=4294967296']
                if 'i64' in basename or 'wasm-only' in basename or 'noffi' in basename:
                    cmd += ['--wasm-only']
                print(' '.join(cmd))
                actual = support.run_command(cmd)
                with open(os.path.join(shared.options.binaryen_test, wasm), 'w') as o:
                    o.write(actual)
                if 'debugInfo' in basename:
                    cmd += ['--source-map', os.path.join(shared.options.binaryen_test, wasm + '.map'), '-o', 'a.wasm']
                    support.run_command(cmd)


def update_wasm_opt_tests():
    print('\n[ checking wasm-opt -o notation... ]\n')
    wast = os.path.join(shared.options.binaryen_test, 'hello_world.wat')
    cmd = shared.WASM_OPT + [wast, '-o', 'a.wast', '-S']
    support.run_command(cmd)
    open(wast, 'w').write(open('a.wast').read())

    print('\n[ checking wasm-opt parsing & printing... ]\n')
    for t in shared.get_tests(shared.get_test_dir('print'), ['.wast']):
        print('..', os.path.basename(t))
        wasm = t.replace('.wast', '')
        cmd = shared.WASM_OPT + [t, '--print', '-all']
        print('    ', ' '.join(cmd))
        actual = subprocess.check_output(cmd)
        print(cmd, actual)
        with open(wasm + '.txt', 'wb') as o:
            o.write(actual)
        cmd = shared.WASM_OPT + [t, '--print-minified', '-all']
        print('    ', ' '.join(cmd))
        actual = subprocess.check_output(cmd)
        with open(wasm + '.minified.txt', 'wb') as o:
            o.write(actual)

    print('\n[ checking wasm-opt passes... ]\n')
    for t in shared.get_tests(shared.get_test_dir('passes'), ['.wast', '.wasm']):
        print('..', os.path.basename(t))
        binary = t.endswith('.wasm')
        base = os.path.basename(t).replace('.wast', '').replace('.wasm', '')
        passname = base
        passes_file = os.path.join(shared.get_test_dir('passes'), passname + '.passes')
        if os.path.exists(passes_file):
            passname = open(passes_file).read().strip()
        opts = [('--' + p if not p.startswith('O') and p != 'g' else '-' + p) for p in passname.split('_')]
        actual = ''
        for module, asserts in support.split_wast(t):
            assert len(asserts) == 0
            support.write_wast('split.wast', module)
            cmd = shared.WASM_OPT + opts + ['split.wast', '--print']
            actual += support.run_command(cmd)
        with open(os.path.join(shared.options.binaryen_test, 'passes', base + ('.bin' if binary else '') + '.txt'), 'w') as o:
            o.write(actual)
        if 'emit-js-wrapper' in t:
            with open('a.js') as i:
                with open(t + '.js', 'w') as o:
                    o.write(i.read())
        if 'emit-spec-wrapper' in t:
            with open('a.wat') as i:
                with open(t + '.wat', 'w') as o:
                    o.write(i.read())

    print('\n[ checking wasm-opt testcases... ]\n')
    for t in shared.get_tests(shared.options.binaryen_test, ['.wast']):
        print('..', os.path.basename(t))
        f = t + '.from-wast'
        cmd = shared.WASM_OPT + [t, '--print', '-all']
        actual = support.run_command(cmd)
        actual = actual.replace('printing before:\n', '')
        open(f, 'w').write(actual)

    print('\n[ checking wasm-opt debugInfo read-write... ]\n')
    for t in shared.get_tests(shared.options.binaryen_test, ['.fromasm']):
        if 'debugInfo' not in t:
            continue
        print('..', os.path.basename(t))
        f = t + '.read-written'
        support.run_command(shared.WASM_AS + [t, '--source-map=a.map', '-o', 'a.wasm', '-g'])
        support.run_command(shared.WASM_OPT + ['a.wasm', '--input-source-map=a.map', '-o', 'b.wasm', '--output-source-map=b.map', '-g'])
        actual = support.run_command(shared.WASM_DIS + ['b.wasm', '--source-map=b.map'])
        open(f, 'w').write(actual)


def update_bin_fmt_tests():
    print('\n[ checking binary format testcases... ]\n')
    for wast in shared.get_tests(shared.options.binaryen_test, ['.wast']):
        for debug_info in [0, 1]:
            cmd = shared.WASM_AS + [wast, '-o', 'a.wasm', '-all']
            if debug_info:
                cmd += ['-g']
            print(' '.join(cmd))
            if os.path.exists('a.wasm'):
                os.unlink('a.wasm')
            subprocess.check_call(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            assert os.path.exists('a.wasm')

            cmd = shared.WASM_DIS + ['a.wasm', '-o', 'a.wast']
            print(' '.join(cmd))
            if os.path.exists('a.wast'):
                os.unlink('a.wast')
            subprocess.check_call(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            assert os.path.exists('a.wast')
            actual = open('a.wast').read()
            binary_file = wast + '.fromBinary'
            if not debug_info:
                binary_file += '.noDebugInfo'
            with open(binary_file, 'w') as o:
                o.write(actual)


def update_example_tests():
    print('\n[ checking example testcases... ]\n')
    for t in shared.get_tests(shared.get_test_dir('example')):
        basename = os.path.basename(t)
        output_file = os.path.join(shared.options.binaryen_bin, 'example')
        libdir = os.path.join(shared.BINARYEN_INSTALL_DIR, 'lib')
        cmd = ['-I' + os.path.join(shared.options.binaryen_root, 'src'), '-g', '-pthread', '-o', output_file]
        if t.endswith('.txt'):
            # check if there is a trace in the file, if so, we should build it
            out = subprocess.Popen([os.path.join(shared.options.binaryen_root, 'scripts', 'clean_c_api_trace.py'), t], stdout=subprocess.PIPE).communicate()[0]
            if len(out) == 0:
                print('  (no trace in ', basename, ')')
                continue
            print('  (will check trace in ', basename, ')')
            src = 'trace.cpp'
            with open(src, 'wb') as o:
                o.write(out)
            expected = t + '.txt'
        else:
            src = t
            expected = os.path.splitext(t)[0] + '.txt'
        if not src.endswith(('.c', '.cpp')):
            continue
        # build the C file separately
        extra = [os.environ.get('CC') or 'gcc',
                 src, '-c', '-o', 'example.o',
                 '-I' + os.path.join(shared.options.binaryen_root, 'src'), '-g', '-L' + libdir, '-pthread']
        print('build: ', ' '.join(extra))
        if src.endswith('.cpp'):
            extra += ['-std=c++14']
        print(os.getcwd())
        subprocess.check_call(extra)
        # Link against the binaryen C library DSO, using rpath
        cmd = ['example.o', '-L' + libdir, '-lbinaryen', '-Wl,-rpath,' + os.path.abspath(libdir)] + cmd
        print('    ', basename, src, expected)
        if os.environ.get('COMPILER_FLAGS'):
            for f in os.environ.get('COMPILER_FLAGS').split(' '):
                cmd.append(f)
        cmd = [os.environ.get('CXX') or 'g++', '-std=c++14'] + cmd
        try:
            print('link: ', ' '.join(cmd))
            subprocess.check_call(cmd)
            print('run...', output_file)
            proc = subprocess.Popen([output_file], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            actual, err = proc.communicate()
            assert proc.returncode == 0, [proc.returncode, actual, err]
            with open(expected, 'wb') as o:
                o.write(actual)
        finally:
            os.remove(output_file)
            if sys.platform == 'darwin':
                # Also removes debug directory produced on Mac OS
                shutil.rmtree(output_file + '.dSYM')


def update_wasm_dis_tests():
    print('\n[ checking wasm-dis on provided binaries... ]\n')
    for t in shared.get_tests(shared.options.binaryen_test, ['.wasm']):
        print('..', os.path.basename(t))
        cmd = shared.WASM_DIS + [t]
        if os.path.isfile(t + '.map'):
            cmd += ['--source-map', t + '.map']
        actual = support.run_command(cmd)

        open(t + '.fromBinary', 'w').write(actual)


def update_binaryen_js_tests():
    if not (shared.MOZJS or shared.NODEJS):
        print('no vm to run binaryen.js tests')
        return

    if not os.path.exists(shared.BINARYEN_JS):
        print('no binaryen.js build to test')
        return

    print('\n[ checking binaryen.js testcases... ]\n')
    node_has_wasm = shared.NODEJS and support.node_has_webassembly(shared.NODEJS)
    for s in shared.get_tests(shared.get_test_dir('binaryen.js'), ['.js']):
        basename = os.path.basename(s)
        print(basename)
        f = open('a.js', 'w')
        f.write(open(shared.BINARYEN_JS).read())
        if shared.NODEJS:
            f.write(support.node_test_glue())
        test_src = open(s).read()
        f.write(test_src)
        f.close()
        if shared.MOZJS or node_has_wasm or 'WebAssembly.' not in test_src:
            cmd = [shared.MOZJS or shared.NODEJS, 'a.js']
            if 'fatal' not in basename:
                out = support.run_command(cmd, stderr=subprocess.STDOUT)
            else:
                # expect an error - the specific error code will depend on the vm
                out = support.run_command(cmd, stderr=subprocess.STDOUT, expected_status=None)
            with open(s + '.txt', 'w') as o:
                o.write(out)
        else:
            print('Skipping ' + basename + ' because WebAssembly might not be supported')


def update_ctor_eval_tests():
    print('\n[ checking wasm-ctor-eval... ]\n')
    for t in shared.get_tests(shared.get_test_dir('ctor-eval'), ['.wast', '.wasm']):
        print('..', os.path.basename(t))
        ctors = open(t + '.ctors').read().strip()
        cmd = shared.WASM_CTOR_EVAL + [t, '-o', 'a.wast', '-S', '--ctors', ctors]
        support.run_command(cmd)
        actual = open('a.wast').read()
        out = t + '.out'
        with open(out, 'w') as o:
            o.write(actual)


def update_metadce_tests():
    print('\n[ checking wasm-metadce... ]\n')
    for t in shared.get_tests(shared.get_test_dir('metadce'), ['.wast', '.wasm']):
        print('..', os.path.basename(t))
        graph = t + '.graph.txt'
        cmd = shared.WASM_METADCE + [t, '--graph-file=' + graph, '-o', 'a.wast', '-S', '-all']
        stdout = support.run_command(cmd)
        actual = open('a.wast').read()
        out = t + '.dced'
        with open(out, 'w') as o:
            o.write(actual)
        with open(out + '.stdout', 'w') as o:
            o.write(stdout)


def update_reduce_tests():
    if not shared.has_shell_timeout():
        return
    print('\n[ checking wasm-reduce ]\n')
    for t in shared.get_tests(shared.get_test_dir('reduce'), ['.wast']):
        print('..', os.path.basename(t))
        # convert to wasm
        support.run_command(shared.WASM_AS + [t, '-o', 'a.wasm'])
        print(support.run_command(shared.WASM_REDUCE + ['a.wasm', '--command=%s b.wasm --fuzz-exec' % shared.WASM_OPT[0], '-t', 'b.wasm', '-w', 'c.wasm']))
        expected = t + '.txt'
        support.run_command(shared.WASM_DIS + ['c.wasm', '-o', expected])


def update_spec_tests():
    print('\n[ updating wasm-shell spec testcases... ]\n')

    for t in shared.options.spec_tests:
        print('..', os.path.basename(t))

        cmd = shared.WASM_SHELL + [t]
        expected = os.path.join(shared.get_test_dir('spec'), 'expected-output', os.path.basename(t) + '.log')
        if os.path.isfile(expected):
            stdout = support.run_command(cmd, stderr=subprocess.PIPE)
            with open(expected, 'w') as o:
                o.write(stdout)


TEST_SUITES = OrderedDict([
    ('wasm-opt', update_wasm_opt_tests),
    ('asm2wasm', update_asm_js_tests),
    ('wasm-dis', update_wasm_dis_tests),
    ('example', update_example_tests),
    ('ctor-eval', update_ctor_eval_tests),
    ('wasm-metadce', update_metadce_tests),
    ('wasm-reduce', update_reduce_tests),
    ('spec', update_spec_tests),
    ('binaryenjs', update_binaryen_js_tests),
    ('lld', lld.update_lld_tests),
    ('wasm2js', wasm2js.update_wasm2js_tests),
    ('binfmt', update_bin_fmt_tests),
])


def main():
    if shared.options.list_suites:
        for suite in TEST_SUITES.keys():
            print(suite)
        return 0

    for test in shared.requested or TEST_SUITES.keys():
        TEST_SUITES[test]()

    print('\n[ success! ]')


if __name__ == '__main__':
    sys.exit(main())
