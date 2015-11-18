#include <cmath>
#include <algorithm>
#include <emscripten.h>

extern "C" {

// unary
double EMSCRIPTEN_KEEPALIVE dneg(double x) { return -x; }
double EMSCRIPTEN_KEEPALIVE dfloor(double x) { return floor(x); }

// binary
double EMSCRIPTEN_KEEPALIVE dadd(double x, double y) { return x + y; }
double EMSCRIPTEN_KEEPALIVE dsub(double x, double y) { return x - y; }
double EMSCRIPTEN_KEEPALIVE dmul(double x, double y) { return x * y; }
double EMSCRIPTEN_KEEPALIVE ddiv(double x, double y) { return x / y; }
double EMSCRIPTEN_KEEPALIVE dcopysign(double x, double y) { return std::copysign(x, y); }
double EMSCRIPTEN_KEEPALIVE dmin(double x, double y) { return std::min(x, y); }
double EMSCRIPTEN_KEEPALIVE dmax(double x, double y) { return std::max(x, y); }

// comparisons
int EMSCRIPTEN_KEEPALIVE deq(double x, double y) { return x == y; }
int EMSCRIPTEN_KEEPALIVE dne(double x, double y) { return x != y; }
int EMSCRIPTEN_KEEPALIVE dlt(double x, double y) { return x < y; }
int EMSCRIPTEN_KEEPALIVE dle(double x, double y) { return x <= y; }
int EMSCRIPTEN_KEEPALIVE dgt(double x, double y) { return x > y; }
int EMSCRIPTEN_KEEPALIVE dge(double x, double y) { return x >= y; }

double EMSCRIPTEN_KEEPALIVE int_to_double(int x) {
  double d = x;
  return d + 1.23;
}

double EMSCRIPTEN_KEEPALIVE uint_to_double(unsigned x) {
  double d = x;
  return d + 1.23;
}

int EMSCRIPTEN_KEEPALIVE double_to_int(double d) {
  d += 1.23;
  int x = d;
  return x;
}

}

