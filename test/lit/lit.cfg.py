import lit.formats

config.name = "Binaryen lit tests"
config.test_format = lit.formats.ShTest(True)

config.suffixes = ['.wast']

config.test_source_root = os.path.dirname(__file__)
config.test_exec_root = os.path.join(config.binaryen_root, 'test')

config.substitutions.extend([
  ('%wasm-opt', config.binaryen_root + '/bin/wasm-opt'),
  ('%wasm-dis', config.binaryen_root + '/bin/wasm-dis'),
])
