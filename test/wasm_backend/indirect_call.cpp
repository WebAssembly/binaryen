#include <emscripten.h>

void print(const char *prefix, int v) {
  int *x = (int*)8; // XXX this order is wrong!
  *x = (int)prefix;
  int *y = (int*)16;
  *y = v;
  EM_ASM({
    Module.print("print: " + Pointer_stringify(HEAP32[8>>2]) + " : " + HEAP32[16>>2]);
  });
}

void something() {
  print("something", 12);
}

void more() {
  print("more", -1);
}

void other(int x) {
  print("other", x + 40);
}

void yet(int x) {
  print("yet", x + 99);
}

typedef void (*v)();
typedef void (*vi)(int);

int main(int argc, char **argv) {
  print("argc", argc);
  v f1[4] = { something, more, something, more };
  print("addr of something", (int)&something);
  print("addr of more", (int)&more);
  for (int i = 0; i < 4 && i < argc*4; i++) {
    print("i", i);
    v curr = f1[i];
    //print("curr address to call", (int)curr);
    curr();
  }
  vi f2[4] = { other, yet, other, yet };
  for (int i = 0; i < 4 && i < argc*4; i++) {
    vi curr = f2[i];
    //print("curr", (int)curr);
    curr(i);
  }
}

