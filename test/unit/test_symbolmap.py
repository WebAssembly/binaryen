from scripts.test import shared
from . import utils


class SymbolMapTest(utils.BinaryenTestCase):
    def test_symbolmap(self):
        input_wasm = self.input_path('hello_world.wat')
        # write the symbol map to a file
        args = [input_wasm, '--symbolmap=out.symbols']
        shared.run_process(shared.WASM_OPT + args)
        with open('out.symbols') as f:
            file_output = f.read()
        # write the symbol map to stdout
        args = [input_wasm, '--symbolmap']
        stdout_output = shared.run_process(shared.WASM_OPT + args,
                                           capture_output=True).stdout
        # ignore whitespace in the comparison as on windows stdout gets an \r
        self.assertEqual(file_output.strip(), stdout_output.strip())
        # the wat contains a single function "add"
        self.assertIn('0:add', file_output)
