from scripts.test import shared
from . import utils


class DataCountTest(utils.BinaryenTestCase):
    def test_datacount(self):
        # We should not create a memories section for a file with only an
        # imported memory: such a module has no declared memories.
        self.roundtrip('only-imported-memory.wasm')
