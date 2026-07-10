#include <emscripten/em_asm.h>

int main() {
  EM_ASM({ Module.print("Hello world"); });
  int x = EM_ASM_INT({ return $0 + $1; }, 13, 27);
  EM_ASM_({ Module.print("Got " + $0); }, x);
  return 0;
}
