#include <stdint.h>

/* Used to generate dyncall.s */

uint32_t i() {
  return 0;
}
uint32_t i_f(float f) {
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
  asm(" i32.const       $drop=, i@FUNCTION");
  asm(" i32.const       $drop=, i_f@FUNCTION");
  asm(" i32.const       $drop=, vd@FUNCTION");
  asm(" i32.const       $drop=, ffjjdi@FUNCTION");
  asm(" i32.const       $drop=, vd2@FUNCTION");
  return 0;
}
