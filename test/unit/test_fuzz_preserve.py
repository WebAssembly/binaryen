import random
import subprocess
import tempfile
import time

from scripts.test import shared

from . import utils


class PreserveFuzzTest(utils.BinaryenTestCase):
    def test_against_js(self):
        # When --fuzz-against-js is used, the wasm is only going to be fuzzed
        # against JS, so the fuzzer mutates the boundary in valid ways, even if
        # --fuzz-preserve-imports-exports is set.
        #
        # Testing this deterministically is too hard (as the fuzzer evolves, it
        # will handle random data differently, and the test would constantly get
        # out of date). Instead, test randomly, but in a way that the chance of
        # a flake is unrealistic.
        max_size = 1024
        temp_dat = tempfile.NamedTemporaryFile(suffix='.dat')
        initial = self.input_path('fuzz.wat')

        # The set of all params we see, for the import that is refinable. Ditto
        # for export results.
        import_params = set()
        export_results = set()

        # Run until we find what we want. Stop only if we reached a max number
        # of iterations and a timeout.
        min_iters = 200
        start_time = time.time()
        # Locally this succeeds in less than 1 second. Give it a very wide
        # margin of error to avoid flakes.
        max_time = start_time + 60

        i = 0
        while True:
            i += 1

            if self.found_expected(import_params) and self.found_expected(export_results):
                print(f"{i} iterations {round(time.time() - start_time, 2)} seconds)")
                print(f'proper import_params : {import_params}')
                print(f'proper export_results: {export_results}')
                return

            if i > min_iters and time.time() > max_time:
                raise Exception('looked too long and still failed')

            # Generate raw random data
            size = random.randint(1, max_size)
            with open(temp_dat.name, 'wb') as f:
                f.write(bytes([random.randint(0, 255) for x in range(size)]))

            # Generate the fuzz testcase from the random data + the initial
            # contents.
            args = ['-ttf', temp_dat.name, '--initial-fuzz=' + initial, '-all']
            args += ['--fuzz-preserve-imports-exports', '--fuzz-against-js']
            args += ['--print']
            wat = shared.run_process(shared.WASM_OPT + args,
                                   stdout=subprocess.PIPE).stdout

            # The things that begin reffed might end up not reffed, if mutation
            # removes the refs. Check for that.
            import_reffed_is_reffed = '(ref.func $import-reffed)' in wat
            export_reffed_is_reffed = '(ref.func $export-reffed)' in wat

            # Find the params/results that might be refined.
            for line in wat.splitlines():
                if line.startswith(' (import "module" "base" (func $import '):
                    params, results = self.parse_params_results(line)
                    import_params.add(params)
                    assert results == '(result eqref)', 'cannot refine import result'
                elif line.startswith(' (import "module" "base" (func $import-reffed '):
                    params, results = self.parse_params_results(line)
                    if import_reffed_is_reffed:
                        assert params == '(param i32 anyref)', 'cannot refine reffed stuff'
                    assert results == '(result eqref)', 'cannot refine import result'
                if line.startswith(' (func $export '):
                    params, results = self.parse_params_results(line)
                    assert params == '(param $0 i32) (param $1 anyref)', 'cannot refine export params'
                    export_results.add(results)
                if line.startswith(' (func $export-reffed '):
                    params, results = self.parse_params_results(line)
                    assert params == '(param $0 i32) (param $1 anyref)', 'cannot refine export params'
                    if export_reffed_is_reffed:
                        assert results == '(result eqref)', 'cannot refine reffed stuff'

    # Given the types we saw for params or results, look in detail for the
    # things we expect to see.
    def found_expected(self, data):
        # Look for significant variety.
        if len(data) < 5:
            return False

        string = str(data)

        # Each of the following has a 50% chance to get emitted each time, so
        # over many iterations, the chance of failing to find them goes
        # exponentially to nothing.

        # There must be nullable types.
        if '(ref null' not in string:
            return False

        # There must be non-nullable types.
        if '(ref (' not in string and '(ref $' not in string:
            return False

        string = string.replace('null ', '')

        # There must be defined types.
        if ' $' not in string:
            return False

        # There must be exact types.
        if '(exact ' not in string:
            return False

        # There must be inexact types.
        if '(ref $' not in string:
            return False

        return True

    # Given a line with wat params and results, parse and return them.
    def parse_params_results(self, line):
        # Find either params or results.
        def get(what, line):
            ret = ''
            pos = 0

            while True:
                # Find the thing we are looking for.
                start = line.find(what, pos)
                if start < 0:
                    break

                # Find the end paren.
                parens = 1
                end = start + 1
                while parens > 0:
                    if line[end] == '(':
                        parens += 1
                    elif line[end] == ')':
                        parens -= 1
                    end += 1

                # Add (separated by a space).
                if ret:
                    ret += ' '
                ret += line[start:end]

                # Keep looking.
                pos = end

            return ret

        return get('(param', line), get('(result', line)
