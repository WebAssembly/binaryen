import subprocess

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
        # out of date). Instead, test randomly, in a way that the chance of a
        # flake is unrealistic.
        size = 10 * 1024
        iters = 1000
        temp_dat = tempfile.NamedTemporaryFile(suffix='.dat')
        initial = self.input_path('fuzz.wat')

        # The set of all params we see, for the import that is refinable. Ditto
        # for export results.
        import_params = Set()
        export_results = Set()

        for _ in range(iters):
            # Generate raw random data
            with open(temp_dat.name, 'wb') as f:
                f.write(bytes([random.randint(0, 255) for x in range(size)]))

            # Generate the fuzz testcase from the random data + the initial
            # contents.
            args = ['-ttf', temp_dat.name, '--initial-fuzz=' + initial]
            args += ['--fuzz-preserve-imports-exports', '--fuzz-against-js']
            args += ['--print']
            wat = shared.run_process(shared.WASM_OPT + args,
                                   stdout=subprocess.PIPE).stdout

            # Find the params/results that might be refined.
            for line in wat.splitlines():
                if line.startswith(' (import "module" "base" (func $import '):
                    params, results = parse_params_results(line)
                    import_params.insert(params)
                    assert results == 'eqref', 'cannot refine import result'
                elif line.startswith(' (import "module" "base" (func $import-reffed '):
                    params, results = parse_params_results(line)
                    assert params == 'i32 anyref', 'cannot refine reffed stuff'
                    assert results == 'eqref', 'cannot refine import result'
                if line.startswith(' (func $export '):
                    params, results = parse_params_results(line)
                    assert params == '(param $0 i32) (param $1 anyref)', 'cannot refine export params'
                    export_results.insert(results)
                if line.startswith(' (func $export-reffed '):
                    params, results = parse_params_results(line)
                    assert params == '(param $0 i32) (param $1 anyref)', 'cannot refine export params'
                    assert results == 'eqref', 'cannot refine reffed stuff'

        # We looked at 1000 cases, and we should be refining half the time, so
        # we must see more than one refinement, unless we are so lucky we'd win
        # the lottery a thousand times and more.
        print(f'import_params: {import_params}')
        assert len(import_params) >= 2
        print(f'export_results: {export_results}')
        assert len(export_results) >= 2

    def parse_params_results(self, line):
        # Given a line with wat params and results, parse and return them.


