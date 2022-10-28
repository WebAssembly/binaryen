from . import utils


class OnlyImportedMemoryTest(utils.BinaryenTestCase):
    def test_only_imported_memory(self):
        # We should not create a memories section for a file with only an
        # imported memory: such a module has no declared memories.
        self.roundtrip('only-imported-memory.wasm', debug=False)
