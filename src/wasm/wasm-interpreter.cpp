#include "wasm-interpreter.h"

namespace wasm {

#ifdef WASM_INTERPRETER_DEBUG
int Indenter::indentLevel = 0;

Indenter::Indenter(const char* entry) : entryName(entry) {
  ++indentLevel;
}
Indenter::~Indenter() {
  print();
  std::cout << "exit " << entryName << '\n';
  --indentLevel;
}
void Indenter::print() {
  std::cout << indentLevel << ':';
  for (int i = 0; i <= indentLevel; ++i) {
    std::cout << ' ';
  }
}
#endif // WASM_INTERPRETER_DEBUG

} // namespace wasm
