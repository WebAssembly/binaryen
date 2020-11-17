import lit.formats

config.name = "Binaryen lit tests"
config.test_format = lit.formats.ShTest(True)

config.suffixes = ['.wast']

config.test_source_root = os.path.dirname(__file__)
config.test_exec_root = os.path.join(config.binaryen_root, 'test')

# Replace all Binaryen tools with their absolute paths
bin_dir = os.path.join(config.binaryen_root, 'bin')
for tool in os.listdir(bin_dir):
    config.substitutions.append((tool, config.binaryen_root + '/bin/' + tool))

# Also make the `not` command available
config.substitutions.append(('not', config.src_root + '/scripts/not.py'))
