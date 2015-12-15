#include <emscripten.h>

int main() {
  int *x = (int*)8;
  *x = 123;
  EM_ASM({
    Module.print("hello, world " + HEAP32[8>>2] + "!");
  });
}

