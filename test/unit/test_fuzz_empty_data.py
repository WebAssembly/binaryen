import os
import subprocess
import tempfile
from scripts.test import shared
from . import utils


class EmptyDataFuzzTest(utils.BinaryenTestCase):
    def test_empty_data(self):
        with tempfile.NamedTemporaryFile() as f:
            shared.run_process(shared.WASM_OPT + ['-ttf', f.name],
                               capture_output=True)
