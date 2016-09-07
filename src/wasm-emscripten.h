#ifndef wasm_emscripten_h
#define wasm_emscripten_h

#include "wasm-traversal.h"

namespace wasm {

class Module;

void generateMemoryGrowthFunction(Module&);

// Create thunks for use with emscripten Runtime.dynCall. Creates one for each
// signature in the indirect function table.
std::vector<Function*> makeDynCallThunks(Module& wasm, std::vector<Name> const& tableSegmentData);

void generateEmscriptenMetadata(std::ostream& o,
                                Module& wasm,
                                std::unordered_map<Address, Address> segmentsByAddress,
                                Address staticBump,
                                std::vector<Name> const& initializerFunctions);

} // namespace wasm

#endif // wasm_emscripten_h
