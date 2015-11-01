#include <emscripten.h>

int EMSCRIPTEN_KEEPALIVE add(int x, int y) {
  return x + y;
}

