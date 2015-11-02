#include <emscripten.h>

extern "C" {

int inner(int x) {
  return x*x + 2;
}

int EMSCRIPTEN_KEEPALIVE simple(int x) {
  return inner(x);
}

int EMSCRIPTEN_KEEPALIVE fibo(int x) {
  if (x == 0 || x == 1) return 1;
  return fibo(x-1) + fibo(x-2);
}

int EMSCRIPTEN_KEEPALIVE run_script() {
  emscripten_run_script("Module.print('hello from called script')");
  return emscripten_run_script_int("1+2+3+4-1");
}

}

