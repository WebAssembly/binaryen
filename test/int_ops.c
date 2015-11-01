#include <emscripten.h>

// unary
int EMSCRIPTEN_KEEPALIVE clz(int x) { return __builtin_clz(x); }

// binary
int EMSCRIPTEN_KEEPALIVE add(int x, int y) { return x + y; }
int EMSCRIPTEN_KEEPALIVE sub(int x, int y) { return x - y; }
int EMSCRIPTEN_KEEPALIVE mul(int x, int y) { return x * y; }
int EMSCRIPTEN_KEEPALIVE sdiv(int x, int y) { return x / y; }
unsigned EMSCRIPTEN_KEEPALIVE udiv(unsigned x, unsigned y) { return x / y; }
int EMSCRIPTEN_KEEPALIVE srem(int x, int y) { return x % y; }
unsigned EMSCRIPTEN_KEEPALIVE urem(unsigned x, unsigned y) { return x % y; }
int EMSCRIPTEN_KEEPALIVE and(int x, int y) { return x & y; }
int EMSCRIPTEN_KEEPALIVE or(int x, int y) { return x | y; }
int EMSCRIPTEN_KEEPALIVE xor(int x, int y) { return x ^ y; }
int EMSCRIPTEN_KEEPALIVE shl(int x, int y) { return x << y; }
int EMSCRIPTEN_KEEPALIVE sshr(int x, int y) { return x >> y; }
unsigned EMSCRIPTEN_KEEPALIVE ushr(unsigned x, unsigned y) { return x >> y; }

// comparisons
int EMSCRIPTEN_KEEPALIVE eq(int x, int y) { return x == y; }
int EMSCRIPTEN_KEEPALIVE ne(int x, int y) { return x != y; }
int EMSCRIPTEN_KEEPALIVE lts(int x, int y) { return x < y; }
int EMSCRIPTEN_KEEPALIVE ltu(unsigned x, unsigned y) { return x < y; }
int EMSCRIPTEN_KEEPALIVE les(int x, int y) { return x <= y; }
int EMSCRIPTEN_KEEPALIVE leu(unsigned x, unsigned y) { return x <= y; }
int EMSCRIPTEN_KEEPALIVE gts(int x, int y) { return x > y; }
int EMSCRIPTEN_KEEPALIVE gtu(unsigned x, unsigned y) { return x > y; }
int EMSCRIPTEN_KEEPALIVE ges(int x, int y) { return x >= y; }
int EMSCRIPTEN_KEEPALIVE geu(unsigned x, unsigned y) { return x >= y; }

