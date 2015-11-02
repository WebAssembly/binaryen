#include <stdint.h>
#include <emscripten.h>

extern "C" {

int EMSCRIPTEN_KEEPALIVE loadi8(size_t addr) { return ((int8_t*)addr)[0]; }
int EMSCRIPTEN_KEEPALIVE loadi16(size_t addr) { return ((int16_t*)addr)[0]; }
int EMSCRIPTEN_KEEPALIVE loadi32(size_t addr) { return ((int32_t*)addr)[0]; }

int EMSCRIPTEN_KEEPALIVE loadu8(size_t addr) { return ((uint8_t*)addr)[0]; }
int EMSCRIPTEN_KEEPALIVE loadu16(size_t addr) { return ((uint16_t*)addr)[0]; }
int EMSCRIPTEN_KEEPALIVE loadu32(size_t addr) { return ((uint32_t*)addr)[0]; }

double EMSCRIPTEN_KEEPALIVE loadf32(size_t addr) { return ((float*)addr)[0]; }
double EMSCRIPTEN_KEEPALIVE loadf64(size_t addr) { return ((double*)addr)[0]; }

void EMSCRIPTEN_KEEPALIVE storei8(size_t addr, int8_t v) { ((int8_t*)addr)[0] = v; }
void EMSCRIPTEN_KEEPALIVE storei16(size_t addr, int16_t v) { ((int16_t*)addr)[0] = v; }
void EMSCRIPTEN_KEEPALIVE storei32(size_t addr, int32_t v) { ((int32_t*)addr)[0] = v; }

void EMSCRIPTEN_KEEPALIVE storeu8(size_t addr, uint8_t v) { ((uint8_t*)addr)[0] = v; }
void EMSCRIPTEN_KEEPALIVE storeu16(size_t addr, uint16_t v) { ((uint16_t*)addr)[0] = v; }
void EMSCRIPTEN_KEEPALIVE storeu32(size_t addr, uint32_t v) { ((uint32_t*)addr)[0] = v; }

void EMSCRIPTEN_KEEPALIVE storef32(size_t addr, float v) { ((float*)addr)[0] = v; }
void EMSCRIPTEN_KEEPALIVE storef64(size_t addr, double v) { ((double*)addr)[0] = v; }

int* EMSCRIPTEN_KEEPALIVE get_stack() {
  int t;
  return &t;
}

}

