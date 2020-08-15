#include <emscripten.h>

int main() {
  EM_ASM({ Module.print("Hello world"); });
  EM_ASM({ Module.print("Got " + $0); }, 42);
  return EM_ASM_INT({ return $0 + $1; }, 20, 30);
}
