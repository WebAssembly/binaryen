#ifndef wasm_emscripten_h
#define wasm_emscripten_h

namespace wasm {

class Module;

void generateMemoryGrowthFunction(Module&);

} // namespace wasm

#endif // wasm_emscripten_h
