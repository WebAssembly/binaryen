#include <stdint.h>
#include <stdio.h>

struct S1 { unsigned lo:32; unsigned mid:2; unsigned hi:30; };

static struct S1 g_68 = { -1, 0, 0xbbe }; // 0xbbe = 3006

extern "C" void emscripten_autodebug_i32(int32_t x, int32_t y);

int main() {
  emscripten_autodebug_i32(0, g_68.lo);
  emscripten_autodebug_i32(1, g_68.mid);
  emscripten_autodebug_i32(2, g_68.hi);
  return 0;
}
