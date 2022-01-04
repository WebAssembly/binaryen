import os
import tempfile
from scripts.test import shared
from . import utils


class EmptyDataFuzzTest(utils.BinaryenTestCase):
    def test_empty_data(self):
        try:
            temp = tempfile.NamedTemporaryFile(delete=False).name
            shared.run_process(shared.WASM_OPT + ['-ttf', temp],
                               capture_output=True)
        finally:
            os.unlink(temp)
