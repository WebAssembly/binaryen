#include <stdio.h>
#include <stdlib.h>
#include <emscripten.h>

volatile int writeOnly;

int main() {
  EM_ASM({
    assert(HEAPU8.length === 16*1024*1024);
  });
  for (int i = 0; i < 20; i++) {
    printf("alloc 1MB: %d\n", i);
    writeOnly = (int)malloc(1024*1024);
  }
  EM_ASM({
    assert(HEAPU8.length > 16*1024*1024);
  });
  printf("ok.\n");
}

