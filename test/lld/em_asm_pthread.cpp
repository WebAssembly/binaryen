// Build with
//
// emcc a.cpp -pthread -s WASM_BIGINT
//

#include <emscripten.h>

EM_JS(void, world, (), { console.log("World."); });

int main() {
  EM_ASM({ console.log("Hello."); });
  world();
}
