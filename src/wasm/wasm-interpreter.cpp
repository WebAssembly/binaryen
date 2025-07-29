#include "wasm-interpreter.h"

namespace wasm {

std::ostream& operator<<(std::ostream& o, const WasmException& exn) {
  auto exnData = exn.exn.getExnData();
  return o << exnData->tag << " " << exnData->payload;
}

} // namespace wasm
