#include <emscripten.h>

char c = 10;
short s = 20;
int i = 55;

void print(int v) {
  int *x = (int*)8;
  *x = v;
  EM_ASM({
    Module.print("print: " + HEAP32[8>>2]);
  });
}

int main() {
  print(1);
  print(c);
  print(s);
  print(i);
}

