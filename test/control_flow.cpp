#include <cmath>
#include <algorithm>
#include <emscripten.h>

extern "C" {

int EMSCRIPTEN_KEEPALIVE check_if(int x) {
  if (x < 10) x++;
  return x;
}

int EMSCRIPTEN_KEEPALIVE check_loop(int x) {
  while (x < 100) x *= 2;
  return x;
}

int EMSCRIPTEN_KEEPALIVE check_loop_break(int x) {
  while (x < 100) {
    x *= 2;
    if (x > 30) break;
    x++;
  }
  return x;
}

int EMSCRIPTEN_KEEPALIVE check_loop_continue(int x) {
  while (x < 100) {
    x *= 2;
    if (x > 30) continue;
    x++;
  }
  return x;
}

int EMSCRIPTEN_KEEPALIVE check_do_loop(int x) {
  do {
    x *= 2;
    if (x > 1000) break;
    x--;
    if (x > 30) continue;
    x++;
  } while (x < 100);
  return x;
}

int EMSCRIPTEN_KEEPALIVE check_do_once(int x) {
  do {
    x *= 2;
    if (x > 1000) break;
    x--;
    if (x > 30) continue;
    x++;
  } while (0);
  return x;
}

int EMSCRIPTEN_KEEPALIVE check_while_forever(int x) {
  while (1) {
    x *= 2;
    if (x > 1000) break;
    x--;
    if (x > 30) continue;
    x++;
  }
  return x;
}

int EMSCRIPTEN_KEEPALIVE check_switch(int x) {
  switch (x) {
    case 1: return 10;
    case 3: return 20;
    case 5: return 30;
    case 10: return 40;
    case 11: return 50;
    default: return 60;
  }
  return 70;
}

int EMSCRIPTEN_KEEPALIVE check_switch_nodefault(int x) {
  switch (x) {
    case 1: return 10;
    case 3: return 20;
    case 5: return 30;
    case 10: return 40;
    case 11: return 50;
  }
  return 70;
}

int EMSCRIPTEN_KEEPALIVE check_switch_rdefault(int x) {
  switch (x) {
    default: return -60;
    case 1: return 10;
    case 3: return 20;
    case 5: return 30;
    case 10: return 40;
    case 11: return 50;
  }
  return 70;
}

int EMSCRIPTEN_KEEPALIVE check_switch_fallthrough(int x) {
  switch (x) {
    case 1: return 10;
    case 2:
    case 3: x++;
    case 5: return x;
    case 10: return 40;
    case 11: return 50;
    default: return 60;
  }
  return 70;
}

}

