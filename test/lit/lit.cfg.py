import lit.formats

config.name = "Binaryen lit tests"
config.test_format = lit.formats.ShTest(True)

config.suffixes = ['.wat', '.wast']

config.test_source_root = os.path.dirname(__file__)
config.test_exec_root = os.path.join(config.binaryen_build_root, 'test')

# Replace all Binaryen tools with their absolute paths
bin_dir = os.path.join(config.binaryen_build_root, 'bin')
for tool_file in os.listdir(bin_dir):
    tool_path = config.binaryen_build_root + '/bin/' + tool_file
    tool = tool_file[:-4] if tool_file.endswith('.exe') else tool_file
    config.substitutions.append((tool, tool_path))

# Also make the `not` command available
not_file = config.binaryen_src_root + '/scripts/not.py'
python = sys.executable.replace('\\', '/')
config.substitutions.append(('not', python + ' ' + not_file))
