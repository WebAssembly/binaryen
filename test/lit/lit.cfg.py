import lit.formats

config.name = "Binaryen lit tests"
config.test_format = lit.formats.ShTest()

config.suffixes = ['.wat', '.wast', '.test']

config.test_source_root = os.path.dirname(__file__)
config.test_exec_root = os.path.join(config.binaryen_build_root, 'test')

# Replace all Binaryen tools with their absolute paths
bin_dir = os.path.join(config.binaryen_build_root, 'bin')
assert(os.path.isdir(bin_dir))

for tool_file in os.listdir(bin_dir):
    tool_path = config.binaryen_build_root + '/bin/' + tool_file
    tool = tool_file[:-4] if tool_file.endswith('.exe') else tool_file
    config.substitutions.append((tool, tool_path))

# Also make the `not` and `foreach` commands available
for tool in ('not', 'foreach'):
    tool_file = config.binaryen_src_root + '/scripts/' + tool + '.py'
    python = sys.executable.replace('\\', '/')
    config.substitutions.append((tool, python + ' ' + tool_file))
