#ifndef wasm_qualified_name_h
#define wasm_qualified_name_h

#include "support/name.h"
#include <ostream>

namespace wasm {

struct QualifiedName {
  Name module;
  Name name;

  friend std::ostream& operator<<(std::ostream& o, const QualifiedName& qname) {
    return o << qname.module << "." << qname.name;
  }
};

} // namespace wasm

#endif // wasm_qualified_name_h
