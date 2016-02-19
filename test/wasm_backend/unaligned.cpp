#include <stdint.h>
#include <emscripten.h>

void print(int v) {
  int *x = (int*)8;
  *x = v;
  EM_ASM({
    Module.print("print: " + HEAP32[8>>2]);
  });
}

char buffer[8];

int main() {
  {
    volatile int16_t* x;
    x = (int16_t*)&buffer[0];
    *x = 0x1234;
    print(*x);
    x = (int16_t*)&buffer[1];
    *x = 0x2345;
    print(*x);
  }
  {
    volatile int32_t* x;
    x = (int32_t*)&buffer[0];
    *x = 0x12345678;
    print(*x);
    x = (int32_t*)&buffer[1];
    *x = 0x23456789;
    print(*x);
    x = (int32_t*)&buffer[2];
    *x = 0x3456789a;
    print(*x);
    x = (int32_t*)&buffer[3];
    *x = 0x456789ab;
    print(*x);
  }
  {
    volatile float* x;
    x = (float*)&buffer[0];
    *x = -0x12345678;
    print(*x);
    x = (float*)&buffer[1];
    *x = -0x12345678;
    print(*x);
    x = (float*)&buffer[2];
    *x = -0x12345678;
    print(*x);
    x = (float*)&buffer[3];
    *x = -0x12345678;
    print(*x);
  }
  {
    volatile double* x;
    x = (double*)&buffer[0];
    *x = -1;
    print(*x);
    x = (double*)&buffer[1];
    *x = -2;
    print(*x);
    x = (double*)&buffer[2];
    *x = -3;
    print(*x);
    x = (double*)&buffer[3];
    *x = -4;
    print(*x);
  }
}

