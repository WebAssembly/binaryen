
with open("src/wasm-interpreter.h") as f:
    content = f.read()

# Add debug prints to doAtomicLoad and doAtomicStore
load_hook = """  Literal doAtomicLoad(Address addr,
                       Index bytes,
                       Type type,
                       Name memoryName,
                       Address memorySize,
                       MemoryOrder order) {
    std::cerr << "doAtomicLoad addr=" << addr << " memoryName=" << memoryName << " instance=" << this << "\\n";"""

content = content.replace("""  Literal doAtomicLoad(Address addr,
                       Index bytes,
                       Type type,
                       Name memoryName,
                       Address memorySize,
                       MemoryOrder order) {""", load_hook)

store_hook = """  void doAtomicStore(Address addr,
                     Index bytes,
                     Literal toStore,
                     Name memoryName,
                     Address memorySize) {
    std::cerr << "doAtomicStore addr=" << addr << " val=" << toStore << " memoryName=" << memoryName << " instance=" << this << "\\n";"""

content = content.replace("""  void doAtomicStore(Address addr,
                     Index bytes,
                     Literal toStore,
                     Name memoryName,
                     Address memorySize) {""", store_hook)

with open("src/wasm-interpreter.h", "w") as f:
    f.write(content)
