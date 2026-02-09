#include "wasm-interpreter.h"

namespace wasm {

std::ostream& operator<<(std::ostream& o, const WasmException& exn) {
  auto exnData = exn.exn.getExnData();
  return o << exnData->tag.definition->name << " " << exnData->payload;
}

} // namespace wasm
