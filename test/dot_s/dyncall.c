#include <stdint.h>

/* Used to generate dyncall.s */

uint32_t i() {
  return 0;
}
uint64_t jf(float f) {
  return 0;
}
void vd(double d) {
  return;
}
float ffjjdi(float f, uint64_t j, uint64_t j2, double d, uint32_t i) {
  return 0.0;
}

/* Duplicates sig vd */
void vd2(double d) {
  return;
}

int main() {
  asm(" i32.const       $discard=, i@FUNCTION");
  asm(" i32.const       $discard=, jf@FUNCTION");
  asm(" i32.const       $discard=, vd@FUNCTION");
  asm(" i32.const       $discard=, ffjjdi@FUNCTION");
  asm(" i32.const       $discard=, vd2@FUNCTION");
  return 0;
}
