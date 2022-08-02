#include <emscripten.h>

int main() {
  EM_ASM({ Module.print("Hello world"); });
  int ret = EM_ASM_INT({ return $0 + $1; }, 20, 30);
  EM_ASM({ Module.print("Got " + $0); }, 42);
  return ret;
}
