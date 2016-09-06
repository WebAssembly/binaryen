#ifndef wasm_emscripten_h
#define wasm_emscripten_h

#include "wasm-traversal.h"

namespace wasm {

class Module;

void generateMemoryGrowthFunction(Module&);

struct AsmConstWalker : public PostWalker<AsmConstWalker, Visitor<AsmConstWalker>> {
  Module& wasm;
  std::unordered_map<Address, Address> segmentsByAddress; // address => segment index

  std::map<std::string, std::set<std::string>> sigsForCode;
  std::map<std::string, Address> ids;
  std::set<std::string> allSigs;

  AsmConstWalker(Module& _wasm, std::unordered_map<Address, Address> _segmentsByAddress) :
    wasm(_wasm), segmentsByAddress(_segmentsByAddress) { }

  void visitCallImport(CallImport* curr);

  std::string escape(const char *input);
};

} // namespace wasm

#endif // wasm_emscripten_h
