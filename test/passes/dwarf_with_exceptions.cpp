void foo();
void dwarf_with_exceptions() {
  try {
    foo();
  } catch (...) {
    foo();
  }
}
// How to generate dwarf_with_exceptions.wasm:
// $ clang++ -std=c++14 --target=wasm32-unknown-unknown -g -fwasm-exceptions \
//           -Xclang -disable-O0-optnone -c -S -emit-llvm
//           dwarf_with_exceptions.cpp -o temp.ll
// $ opt -S -mem2reg -simplifycfg temp.ll -o dwarf_with_exceptions.ll
// Remove some personal info from dwarf_with_exceptions.ll
// $ llc -exception-model=wasm -mattr=+exception-handling -filetype=obj \
//       dwarf_with_exceptions.ll -o dwarf_with_exceptions.o
// $ wasm-ld --no-entry --no-gc-sections --allow-undefined \
//           dwarf_with_exceptions.o -o dwarf_with_exceptions.wasm
